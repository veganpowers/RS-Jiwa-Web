-- ====================================================================
-- SISTEM INFORMASI RUMAH SAKIT KHUSUS JIWA (RS ODGJ)
-- NAMA DATABASE: db_rsodgj
-- STRUKTUR TABEL LENGKAP, TERKORELASI (NORMALISASI) & CONSTRAINTS
-- ====================================================================

CREATE DATABASE IF NOT EXISTS db_rsodgj;
USE db_rsodgj;

-- Matikan foreign key check sementara untuk kelancaran reset tabel
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS peserta_terapi_grup;
DROP TABLE IF EXISTS jadwal_terapi_grup;
DROP TABLE IF EXISTS resep_obat;
DROP TABLE IF EXISTS obat;
DROP TABLE IF EXISTS tagihan_pembayaran;
DROP TABLE IF EXISTS insiden_darurat;
DROP TABLE IF EXISTS rekam_medis;
DROP TABLE IF EXISTS keluarga_pasien;
DROP TABLE IF EXISTS jadwal_dokter;
DROP TABLE IF EXISTS pasien;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS perawat;
DROP TABLE IF EXISTS dokter;
DROP TABLE IF EXISTS kamar;

SET FOREIGN_KEY_CHECKS = 1;

-- ====================================================================
-- 1. TABEL MASTER: DOKTER (Spesialis Kedokteran Jiwa / Psikiater)
-- ====================================================================
CREATE TABLE dokter (
    id_dokter INT AUTO_INCREMENT PRIMARY KEY,
    nama_dokter VARCHAR(100) NOT NULL,
    no_str VARCHAR(50) NOT NULL UNIQUE,
    spesialisasi VARCHAR(100) NOT NULL DEFAULT 'Spesialis Kedokteran Jiwa (Sp.KJ)',
    subspesialisasi VARCHAR(100) DEFAULT 'Psikiatri Umum',
    no_telp VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    status ENUM('Aktif', 'Cuti', 'Non-Aktif') DEFAULT 'Aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 2. TABEL MASTER: PERAWAT (Tenaga Keperawatan Jiwa & Ners)
-- ====================================================================
CREATE TABLE perawat (
    id_perawat INT AUTO_INCREMENT PRIMARY KEY,
    nama_perawat VARCHAR(100) NOT NULL,
    no_str VARCHAR(50) NOT NULL UNIQUE,
    kualifikasi VARCHAR(100) NOT NULL,
    shift_default ENUM('Pagi', 'Siang', 'Malam', 'Lepas Piket') DEFAULT 'Pagi',
    ruang_jaga VARCHAR(100) NOT NULL,
    no_telp VARCHAR(20) NOT NULL,
    status ENUM('Aktif', 'Cuti', 'Non-Aktif') DEFAULT 'Aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 3. TABEL MASTER: KAMAR & RUANG ISOLASI KHUSUS ODGJ
-- ====================================================================
CREATE TABLE kamar (
    id_kamar INT AUTO_INCREMENT PRIMARY KEY,
    nama_kamar VARCHAR(50) NOT NULL,
    jenis ENUM('isolasi', 'reguler', 'vip_jiwa') NOT NULL,
    kapasitas INT NOT NULL DEFAULT 1,
    terisi INT NOT NULL DEFAULT 0,
    tarif_per_hari DECIMAL(12,2) DEFAULT 150000.00,
    id_perawat_pj INT NULL,
    fasilitas_khusus TEXT,
    CONSTRAINT fk_kamar_perawat FOREIGN KEY (id_perawat_pj) 
        REFERENCES perawat(id_perawat) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 4. TABEL AUTENTIKASI: USERS (Akun Login Seluruh Role)
-- Berelasi langsung dengan id_dokter atau id_perawat
-- ====================================================================
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'dokter', 'perawat', 'keluarga', 'farmasi', 'kasir') NOT NULL,
    id_dokter INT NULL UNIQUE,
    id_perawat INT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_dokter FOREIGN KEY (id_dokter) 
        REFERENCES dokter(id_dokter) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_users_perawat FOREIGN KEY (id_perawat) 
        REFERENCES perawat(id_perawat) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 5. TABEL MASTER: PASIEN ODGJ
-- Memiliki relasi ke Kamar Inap & Dokter Penanggung Jawab (DPJP)
-- ====================================================================
CREATE TABLE pasien (
    id_pasien INT AUTO_INCREMENT PRIMARY KEY,
    no_rekam_medis VARCHAR(20) NOT NULL UNIQUE,
    nama VARCHAR(100) NOT NULL,
    nik VARCHAR(20) NOT NULL UNIQUE,
    jenis_kelamin ENUM('Laki-laki', 'Perempuan') NOT NULL,
    tgl_lahir DATE NOT NULL,
    alamat TEXT,
    status_perawatan ENUM('Rawat Inap', 'Rawat Jalan', 'Isolasi Khusus', 'Selesai') DEFAULT 'Rawat Inap',
    tingkat_agitasi ENUM('Tenang', 'Gelisah Ringan', 'Agitasi Berat / Gaduh Gelisah') DEFAULT 'Tenang',
    id_kamar INT NULL,
    id_dokter_dpjp INT NULL,
    tgl_masuk DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pasien_kamar FOREIGN KEY (id_kamar) 
        REFERENCES kamar(id_kamar) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_pasien_dokter FOREIGN KEY (id_dokter_dpjp) 
        REFERENCES dokter(id_dokter) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 6. TABEL MASTER MEDIS: KELUARGA / WALI PASIEN
-- Penting untuk informed consent tindakan medis, isolasi, dan pengekangan
-- ====================================================================
CREATE TABLE keluarga_pasien (
    id_keluarga INT AUTO_INCREMENT PRIMARY KEY,
    id_pasien INT NOT NULL,
    id_user INT NULL UNIQUE,
    nama_wali VARCHAR(100) NOT NULL,
    hubungan VARCHAR(50) NOT NULL,
    nik_wali VARCHAR(20),
    no_telp VARCHAR(20) NOT NULL,
    alamat TEXT,
    persetujuan_tindakan ENUM('Setuju', 'Menolak', 'Menunggu Persetujuan') DEFAULT 'Setuju',
    catatan_wali TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_keluarga_pasien FOREIGN KEY (id_pasien) 
        REFERENCES pasien(id_pasien) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_keluarga_user FOREIGN KEY (id_user) 
        REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 7. TABEL MASTER MEDIS: OBAT PSIKOFARMAKA & MEDIS JIWA
-- ====================================================================
CREATE TABLE obat (
    id_obat INT AUTO_INCREMENT PRIMARY KEY,
    kode_obat VARCHAR(20) NOT NULL UNIQUE,
    nama_obat VARCHAR(100) NOT NULL,
    kategori ENUM('Antipsikotik Tipikal', 'Antipsikotik Atipikal', 'Antidepresan', 'Mood Stabilizer', 'Antiansietas / Sedatif', 'Injeksi Emergensi', 'Lain-lain') NOT NULL,
    bentuk_sediaan ENUM('Tablet', 'Kapsul', 'Ampul / Injeksi', 'Sirup / Tetes') DEFAULT 'Tablet',
    stok INT NOT NULL DEFAULT 0,
    satuan VARCHAR(20) NOT NULL DEFAULT 'Tablet',
    harga DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    deskripsi TEXT,
    efek_samping TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 8. TABEL OPERASIONAL: JADWAL PRAKTIK DOKTER PSIKIATER
-- ====================================================================
CREATE TABLE jadwal_dokter (
    id_jadwal INT AUTO_INCREMENT PRIMARY KEY,
    id_dokter INT NOT NULL,
    hari ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu') NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    ruang_praktik VARCHAR(50) NOT NULL DEFAULT 'Poli Psikiatri 1',
    kuota_pasien INT DEFAULT 15,
    status ENUM('Aktif', 'Cuti', 'Pengganti') DEFAULT 'Aktif',
    CONSTRAINT fk_jadwal_dokter FOREIGN KEY (id_dokter) 
        REFERENCES dokter(id_dokter) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 9. TABEL MEDIS: REKAM MEDIS & EVALUASI PSIKIATRI MASTER
-- ====================================================================
CREATE TABLE rekam_medis (
    id_rm INT AUTO_INCREMENT PRIMARY KEY,
    id_pasien INT NOT NULL,
    id_dokter INT NOT NULL,
    tgl_periksa DATETIME DEFAULT CURRENT_TIMESTAMP,
    keluhan_utama TEXT NOT NULL,
    pemeriksaan_status_mental TEXT,
    diagnosa_utama VARCHAR(255) NOT NULL,
    diagnosa_sekunder VARCHAR(255) NULL,
    rencana_terapi TEXT NOT NULL,
    catatan_keamanan TEXT,
    CONSTRAINT fk_rm_pasien FOREIGN KEY (id_pasien) 
        REFERENCES pasien(id_pasien) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_rm_dokter FOREIGN KEY (id_dokter) 
        REFERENCES dokter(id_dokter) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 10. TABEL TRANSAKSI: RESEP OBAT
-- Relasi antara Rekam Medis / Pasien, Dokter, dan Obat
-- ====================================================================
CREATE TABLE resep_obat (
    id_resep INT AUTO_INCREMENT PRIMARY KEY,
    id_rm INT NULL,
    id_pasien INT NOT NULL,
    id_dokter INT NOT NULL,
    id_obat INT NOT NULL,
    tgl_resep DATETIME DEFAULT CURRENT_TIMESTAMP,
    jumlah INT NOT NULL DEFAULT 1,
    aturan_pakai VARCHAR(100) NOT NULL,
    status_tebus ENUM('Menunggu', 'Diproses Farmasi', 'Sudah Diambil', 'Dibatalkan') DEFAULT 'Menunggu',
    catatan_resep TEXT,
    CONSTRAINT fk_resep_rm FOREIGN KEY (id_rm) 
        REFERENCES rekam_medis(id_rm) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_resep_pasien FOREIGN KEY (id_pasien) 
        REFERENCES pasien(id_pasien) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_resep_dokter FOREIGN KEY (id_dokter) 
        REFERENCES dokter(id_dokter) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_resep_obat FOREIGN KEY (id_obat) 
        REFERENCES obat(id_obat) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 11. TABEL OPERASIONAL: JADWAL TERAPI AKTIVITAS KELOMPOK (TAK)
-- ====================================================================
CREATE TABLE jadwal_terapi_grup (
    id_terapi INT AUTO_INCREMENT PRIMARY KEY,
    nama_terapi VARCHAR(100) NOT NULL,
    jenis_terapi ENUM('TAK Sosialisasi', 'TAK Stimulasi Sensori', 'TAK Orientasi Realitas', 'Terapi Okupasi & Prakarya', 'Terapi Musik & Relaksasi') NOT NULL,
    id_dokter_pj INT NOT NULL,
    id_perawat_fasilitator INT NOT NULL,
    hari ENUM('Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu') NOT NULL,
    jam_mulai TIME NOT NULL,
    jam_selesai TIME NOT NULL,
    lokasi_ruangan VARCHAR(50) NOT NULL DEFAULT 'Aula Rehabilitasi Jiwa',
    kapasitas_maksimal INT DEFAULT 10,
    tujuan_terapi TEXT,
    status ENUM('Terjadwal', 'Berjalan', 'Selesai', 'Dibatalkan') DEFAULT 'Terjadwal',
    CONSTRAINT fk_terapi_dokter FOREIGN KEY (id_dokter_pj) 
        REFERENCES dokter(id_dokter) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_terapi_perawat FOREIGN KEY (id_perawat_fasilitator) 
        REFERENCES perawat(id_perawat) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 12. TABEL RELASI: PESERTA TERAPI AKTIVITAS KELOMPOK
-- ====================================================================
CREATE TABLE peserta_terapi_grup (
    id_peserta INT AUTO_INCREMENT PRIMARY KEY,
    id_terapi INT NOT NULL,
    id_pasien INT NOT NULL,
    catatan_perkembangan TEXT,
    kehadiran ENUM('Hadir', 'Izin', 'Tidak Kooperatif / Agitasi') DEFAULT 'Hadir',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_peserta_terapi FOREIGN KEY (id_terapi) 
        REFERENCES jadwal_terapi_grup(id_terapi) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_peserta_pasien FOREIGN KEY (id_pasien) 
        REFERENCES pasien(id_pasien) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 13. TABEL KEPERAWATAN: INSIDEN DARURAT & LOG DEESKALASI
-- ====================================================================
CREATE TABLE insiden_darurat (
    id_insiden INT AUTO_INCREMENT PRIMARY KEY,
    id_pasien INT NOT NULL,
    id_perawat INT NOT NULL,
    id_dokter_penangan INT NULL,
    jenis_insiden VARCHAR(100) NOT NULL,
    tingkat_keparahan ENUM('Ringan', 'Sedang', 'Berat / Kritis') DEFAULT 'Sedang',
    tindakan_deeskalasi TEXT NOT NULL,
    deskripsi TEXT NOT NULL,
    waktu_kejadian DATETIME DEFAULT CURRENT_TIMESTAMP,
    status_penanganan ENUM('Dalam Penanganan', 'Observasi Ketat', 'Terkendali / Selesai') DEFAULT 'Observasi Ketat',
    CONSTRAINT fk_insiden_pasien FOREIGN KEY (id_pasien) 
        REFERENCES pasien(id_pasien) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_insiden_perawat FOREIGN KEY (id_perawat) 
        REFERENCES perawat(id_perawat) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_insiden_dokter FOREIGN KEY (id_dokter_penangan) 
        REFERENCES dokter(id_dokter) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ====================================================================
-- 14. TABEL KEUANGAN: TAGIHAN PERAWATAN & KASIR
-- ====================================================================
CREATE TABLE tagihan_pembayaran (
    id_tagihan INT AUTO_INCREMENT PRIMARY KEY,
    kode_tagihan VARCHAR(30) NOT NULL UNIQUE,
    id_pasien INT NOT NULL,
    total_biaya_kamar DECIMAL(12,2) DEFAULT 0.00,
    total_biaya_obat DECIMAL(12,2) DEFAULT 0.00,
    total_biaya_tindakan DECIMAL(12,2) DEFAULT 0.00,
    total_akhir DECIMAL(12,2) NOT NULL,
    status_pembayaran ENUM('Belum Lunas', 'Lunas', 'Jaminan BPJS / Dinsos') DEFAULT 'Belum Lunas',
    tgl_pembayaran DATETIME NULL,
    keterangan TEXT,
    CONSTRAINT fk_tagihan_pasien FOREIGN KEY (id_pasien) 
        REFERENCES pasien(id_pasien) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- ====================================================================
-- DUMMY DATA SEEDING (DATA AWAL SIAP UJI SISTEM)
-- ====================================================================

-- 1. Seeding Dokter Spesialis
INSERT INTO dokter (id_dokter, nama_dokter, no_str, spesialisasi, subspesialisasi, no_telp, email, status) VALUES
(1, 'dr. Budi Santoso, Sp.KJ', 'STR-3201/DSKJ/2019', 'Spesialis Kedokteran Jiwa (Sp.KJ)', 'Psikiatri Umum & Agitasi Akut', '081234567890', 'budi.santoso@rsodgj.go.id', 'Aktif'),
(2, 'dr. Siti Rahmawati, Sp.KJ (K)', 'STR-3201/DSKJ/2021', 'Spesialis Kedokteran Jiwa (Sp.KJ)', 'Psikiatri Anak & Bipolar', '081398765432', 'siti.rahma@rsodgj.go.id', 'Aktif'),
(3, 'dr. Hendra Wijaya, Sp.KJ', 'STR-3201/DSKJ/2023', 'Spesialis Kedokteran Jiwa (Sp.KJ)', 'Psikiatri Adiksi & Napza', '085711223344', 'hendra.w@rsodgj.go.id', 'Cuti');

-- 2. Seeding Tenaga Perawat
INSERT INTO perawat (id_perawat, nama_perawat, no_str, kualifikasi, shift_default, ruang_jaga, no_telp, status) VALUES
(1, 'Ners Eka Pratama, S.Kep., Ns.', 'STR-PERAWAT-1904221', 'Deeskalasi Gaduh Gelisah & BTCLS', 'Pagi', 'Ruang Isolasi Lavender', '081244556677', 'Aktif'),
(2, 'Ners Dodi Firmansyah, A.Md.Kep', 'STR-PERAWAT-2015339', 'Asuhan Keperawatan Jiwa Madya', 'Siang', 'Bangsal Cempaka (Reguler)', '081322334455', 'Aktif'),
(3, 'Ners Rina Wulandari, S.Kep., Ns.', 'STR-PERAWAT-2187642', 'Terapi Aktivitas Kelompok (TAK)', 'Malam', 'IGD Jiwa & Ruang Observasi', '085677889900', 'Aktif');

-- 3. Seeding Kamar & Ruang Isolasi
INSERT INTO kamar (id_kamar, nama_kamar, jenis, kapasitas, terisi, tarif_per_hari, id_perawat_pj, fasilitas_khusus) VALUES
(1, 'Ruang Lavender 01', 'isolasi', 1, 1, 350000.00, 1, 'Peredam suara, dinding pengaman berbusa, CCTV pantau 24 jam, pintu kunci ganda tanpa pegangan dalam'),
(2, 'Ruang Lavender 02', 'isolasi', 1, 0, 350000.00, 1, 'Peredam suara, kasur fiksasi antitedeng, CCTV pantau 24 jam'),
(3, 'Bangsal Cempaka A (Pria)', 'reguler', 6, 2, 120000.00, 2, 'Kamar mandi tanpa gantungan tajam, jendela teralis khusus, ruang makan komunal'),
(4, 'Bangsal Cempaka B (Wanita)', 'reguler', 6, 0, 120000.00, 2, 'Kamar mandi ramah psikiatri, taman terapi internal');

-- 4. Seeding Akun Users (Password: '123')
INSERT INTO users (id, username, password, role, id_dokter, id_perawat) VALUES
(1, 'admin', '123', 'admin', NULL, NULL),
(2, 'dr_budi', '123', 'dokter', 1, NULL),
(3, 'dr_siti', '123', 'dokter', 2, NULL),
(4, 'ners_eka', '123', 'perawat', NULL, 1),
(5, 'ners_dodi', '123', 'perawat', NULL, 2),
(6, 'kel_santoso', '123', 'keluarga', NULL, NULL),
(7, 'farmasi1', '123', 'farmasi', NULL, NULL),
(8, 'kasir1', '123', 'kasir', NULL, NULL);

-- 5. Seeding Data Pasien ODGJ
INSERT INTO pasien (id_pasien, no_rekam_medis, nama, nik, jenis_kelamin, tgl_lahir, alamat, status_perawatan, tingkat_agitasi, id_kamar, id_dokter_dpjp) VALUES
(1, 'RM-2026-0001', 'Ahmad Fauzi', '3201011205900001', 'Laki-laki', '1990-05-12', 'Jl. Kenanga No. 12, Bandung', 'Isolasi Khusus', 'Agitasi Berat / Gaduh Gelisah', 1, 1),
(2, 'RM-2026-0002', 'Ratna Sari', '3201024508950002', 'Perempuan', '1995-08-15', 'Jl. Anggrek No. 4, Sukabumi', 'Rawat Inap', 'Gelisah Ringan', 3, 2),
(3, 'RM-2026-0003', 'Joko Widodo', '3201032103880003', 'Laki-laki', '1988-03-21', 'Jl. Melati No. 8, Cimahi', 'Rawat Inap', 'Tenang', 3, 1);

-- 6. Seeding Keluarga Pasien (Wali / Penanggung Jawab)
INSERT INTO keluarga_pasien (id_keluarga, id_pasien, id_user, nama_wali, hubungan, nik_wali, no_telp, alamat, persetujuan_tindakan, catatan_wali) VALUES
(1, 1, 6, 'Bapak Santoso Fauzi', 'Orang Tua (Ayah)', '3201010101650001', '081299887766', 'Jl. Kenanga No. 12, Bandung', 'Setuju', 'Menyetujui tindakan isolasi sementara dan injeksi penenang jika terjadi gaduh gelisah hebat'),
(2, 2, NULL, 'Ibu Dewi Sartika', 'Ibu Kandung', '3201020202700002', '081388776655', 'Jl. Anggrek No. 4, Sukabumi', 'Setuju', 'Mohon dikabari jika ada perkembangan jadwal besuk');

-- 7. Seeding Master Obat Psikofarmaka
INSERT INTO obat (id_obat, kode_obat, nama_obat, kategori, bentuk_sediaan, stok, satuan, harga, deskripsi, efek_samping) VALUES
(1, 'OBT-HAL-01', 'Haloperidol 5mg', 'Antipsikotik Tipikal', 'Tablet', 250, 'Tablet', 4500.00, 'Antipsikotik poten untuk meredakan agitasi psikomotorik dan halusinasi skizofrenia.', 'Gejala ekstrapiramidal (EPS), kekakuan otot.'),
(2, 'OBT-RIS-02', 'Risperidone 2mg', 'Antipsikotik Atipikal', 'Tablet', 300, 'Tablet', 7000.00, 'Antipsikotik lini pertama skizofrenia dan episode manik bipolar.', 'Peningkatan nafsu makan, sedasi ringan.'),
(3, 'OBT-CLO-03', 'Chlorpromazine 100mg', 'Antipsikotik Tipikal', 'Tablet', 180, 'Tablet', 3800.00, 'Sedasi kuat untuk pasien dengan gaduh gelisah ekstrem malam hari.', 'Hipotensi ortostatik, mengantuk berat.'),
(4, 'OBT-DIA-04', 'Diazepam 5mg/ml Injeksi', 'Injeksi Emergensi', 'Ampul / Injeksi', 50, 'Ampul', 18000.00, 'Injeksi penenang darurat untuk deeskalasi cepat pasien agresif.', 'Depresi pernapasan jika overdosis, ataksia.'),
(5, 'OBT-LIT-05', 'Lithium Carbonate 300mg', 'Mood Stabilizer', 'Tablet', 120, 'Tablet', 8500.00, 'Stabilisator suasana hati lini utama untuk gangguan afektif bipolar.', 'Tremor halus tangan, sering haus/urin.');

-- 8. Seeding Jadwal Dokter Psikiater
INSERT INTO jadwal_dokter (id_jadwal, id_dokter, hari, jam_mulai, jam_selesai, ruang_praktik, kuota_pasien, status) VALUES
(1, 1, 'Senin', '08:00:00', '14:00:00', 'Poli Psikiatri 1 (Agitasi & Umum)', 15, 'Aktif'),
(2, 1, 'Rabu', '08:00:00', '14:00:00', 'Poli Psikiatri 1 (Agitasi & Umum)', 15, 'Aktif'),
(3, 2, 'Selasa', '09:00:00', '15:00:00', 'Poli Psikiatri 2 (Bipolar & Anak)', 12, 'Aktif'),
(4, 2, 'Kamis', '09:00:00', '15:00:00', 'Poli Psikiatri 2 (Bipolar & Anak)', 12, 'Aktif');

-- 9. Seeding Rekam Medis Master
INSERT INTO rekam_medis (id_rm, id_pasien, id_dokter, tgl_periksa, keluhan_utama, pemeriksaan_status_mental, diagnosa_utama, diagnosa_sekunder, rencana_terapi, catatan_keamanan) VALUES
(1, 1, 1, NOW() - INTERVAL 1 DAY, 'Pasien berteriak-teriak mendengar bisikan ancaman, mondar-mandir agresif.', 'Afek tidak serasi, halusinasi auditorik imperatif, waham kejar, insight derajat 1 (menolak sakit).', 'F20.0 Skizofrenia Paranoid', 'F05 Delirium Superimposed', 'Isolasi sementara di Ruang Lavender 01, injeksi Haloperidol 5mg IM, pengawasan 24 jam.', 'Jauhkan dari benda berbahan kaca atau kawat tajam.'),
(2, 2, 2, NOW() - INTERVAL 2 DAY, 'Bicara sangat cepat, euforia berlebihan, tidak tidur 3 hari.', 'Mood elasi, logorrhea, flight of ideas, waham kebesaran ringan.', 'F31.1 Gangguan Afektif Bipolar Episode Kini Manik Tanpa Gejala Psikotik', NULL, 'Pemberian Risperidone 2x2mg dan Lithium Carbonate 300mg, rawat inap Bangsal Cempaka B.', 'Pasien kooperatif namun memiliki dorongan keluyuran tinggi.');

-- 10. Seeding Resep Obat
INSERT INTO resep_obat (id_resep, id_rm, id_pasien, id_dokter, id_obat, tgl_resep, jumlah, aturan_pakai, status_tebus, catatan_resep) VALUES
(1, 1, 1, 1, 1, NOW() - INTERVAL 1 DAY, 30, '2x sehari 1 tablet (5mg)', 'Sudah Diambil', 'Awasi kepatuhan minum obat di hadapan perawat'),
(2, 1, 1, 1, 4, NOW() - INTERVAL 1 DAY, 2, 'Injeksi 1 ampul IM jika gaduh gelisah hebat', 'Sudah Diambil', 'Hanya boleh disuntikkan oleh ners bersertifikasi BTCLS'),
(3, 2, 2, 2, 2, NOW() - INTERVAL 2 DAY, 60, '2x sehari 1 tablet (2mg)', 'Sudah Diambil', 'Diberikan sesudah makan pagi dan malam');

-- 11. Seeding Jadwal Terapi Aktivitas Kelompok (TAK)
INSERT INTO jadwal_terapi_grup (id_terapi, nama_terapi, jenis_terapi, id_dokter_pj, id_perawat_fasilitator, hari, jam_mulai, jam_selesai, lokasi_ruangan, kapasitas_maksimal, tujuan_terapi, status) VALUES
(1, 'TAK Sosialisasi Sesi 1: Perkenalan Diri', 'TAK Sosialisasi', 2, 3, 'Senin', '09:00:00', '10:30:00', 'Aula Rehabilitasi Jiwa', 8, 'Meningkatkan kemampuan pasien memperkenalkan diri dan berinteraksi dengan orang lain.', 'Terjadwal'),
(2, 'Terapi Okupasi: Menggambar & Mewarnai Ekspresif', 'Terapi Okupasi & Prakarya', 1, 2, 'Rabu', '10:00:00', '11:30:00', 'Gazebo Terapi Terbuka', 10, 'Menyalurkan emosi dan energi melalui aktivitas motorik halus seni grafis.', 'Terjadwal');

-- 12. Seeding Peserta Terapi Grup
INSERT INTO peserta_terapi_grup (id_peserta, id_terapi, id_pasien, catatan_perkembangan, kehadiran) VALUES
(1, 1, 2, 'Pasien sangat antusias menceritakan hobi dan merespon teman kelompok dengan ramah.', 'Hadir'),
(2, 1, 3, 'Pasien masih agak pasif namun mau menyebutkan nama dan asal kota.', 'Hadir');

-- 13. Seeding Insiden Darurat & Deeskalasi
INSERT INTO insiden_darurat (id_insiden, id_pasien, id_perawat, id_dokter_penangan, jenis_insiden, tingkat_keparahan, tindakan_deeskalasi, deskripsi, waktu_kejadian, status_penanganan) VALUES
(1, 1, 1, 1, 'Agitasi Psikomotorik & Gaduh Gelisah', 'Berat / Kritis', 'Deeskalasi verbal tenang, isolasi di Ruang Lavender 01, pemberian injeksi penenang atas persetujuan dr. Budi.', 'Pasien membenturkan bantal dan berteriak ketakutan karena halusinasi auditori kejaran orang jahat.', NOW() - INTERVAL 5 HOUR, 'Observasi Ketat'),
(2, 2, 2, 2, 'Percobaan Melarikan Diri', 'Sedang', 'Pendekatan persuasif tanpa kekerasan fisik, diajak berbicara di ruang perawat sambil minum teh hangat.', 'Pasien mencoba melewati pintu pagar taman terapi olahraga pagi karena rindu keluarga.', NOW() - INTERVAL 1 DAY, 'Terkendali / Selesai');

-- 14. Seeding Tagihan Pembayaran
INSERT INTO tagihan_pembayaran (id_tagihan, kode_tagihan, id_pasien, total_biaya_kamar, total_biaya_obat, total_biaya_tindakan, total_akhir, status_pembayaran, tgl_pembayaran, keterangan) VALUES
(1, 'INV-202610-001', 1, 1050000.00, 171000.00, 250000.00, 1471000.00, 'Belum Lunas', NULL, 'Perawatan isolasi 3 hari + obat antipsikotik');
