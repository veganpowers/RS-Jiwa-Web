<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jadwal Dokter - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="jadwal" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Jadwal Praktik Dokter" />
            <jsp:param name="subtitle" value="Atur Shift Praktik dan Poliklinik Dokter Spesialis Jiwa (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-calendar-days me-2 text-primary"></i> Jadwal Praktik Mingguan Dokter</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahJadwal">
                    <i class="fa-solid fa-plus me-1"></i> Tambah Jadwal Praktik
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Hari</th>
                                <th>Nama Dokter</th>
                                <th>Spesialisasi</th>
                                <th>Jam Praktik</th>
                                <th>Ruang Poliklinik</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM jadwal_dokter JOIN dokter ... -->
                            <tr>
                                <td><strong>Senin & Rabu</strong></td>
                                <td>dr. Hendra Pratama, Sp.KJ</td>
                                <td>Psikiatri Klinis & Dewasa</td>
                                <td>08:00 - 13:00 WIB</td>
                                <td>Poli Jiwa Dewasa 1</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-danger" onclick="if(confirm('Hapus jadwal ini?')) alert('Jadwal dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>Selasa & Kamis</strong></td>
                                <td>dr. Citra Dewi, Sp.KJ</td>
                                <td>Psikiatri Forensik & Adiksi</td>
                                <td>09:00 - 14:00 WIB</td>
                                <td>Poli Adiksi & Konseling</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-danger" onclick="if(confirm('Hapus jadwal ini?')) alert('Jadwal dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH JADWAL -->
<div class="modal fade" id="modalTambahJadwal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Jadwal Praktik</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/JadwalServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Pilih Dokter *</label>
                        <select name="id_dokter" class="form-select" required>
                            <option value="">-- Pilih Dokter Spesialis --</option>
                            <option value="1">dr. Hendra Pratama, Sp.KJ</option>
                            <option value="2">dr. Citra Dewi, Sp.KJ</option>
                            <option value="3">dr. Bambang Soedjarwo, Sp.KJ</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Hari Praktik *</label>
                        <input type="text" name="hari" class="form-control" placeholder="Contoh: Senin s/d Rabu" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Jam Praktik *</label>
                        <input type="text" name="jam" class="form-control" placeholder="Contoh: 08:00 - 13:00 WIB" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ruangan Poli *</label>
                        <input type="text" name="ruangan" class="form-control" placeholder="Contoh: Poli Jiwa 1" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Jadwal</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

