<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jadwal Terapi Kelompok - Dokter RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="terapi" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Jadwal Terapi Aktivitas Kelompok (TAK)" />
            <jsp:param name="subtitle" value="Manajemen Jadwal dan Peserta Sesi Rehabilitasi Jiwa" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-people-group me-2 text-primary"></i> Tabel Jadwal Terapi Pasien</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahTerapi">
                    <i class="fa-solid fa-plus me-1"></i> Tambah Jadwal Terapi
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Tanggal & Waktu</th>
                                <th>Topik Terapi / TAK</th>
                                <th>Ruangan</th>
                                <th>Instruktur / Terapis</th>
                                <th>Peserta Terdaftar</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM jadwal_terapi_grup ORDER BY tanggal ASC -->
                            <tr>
                                <td>27 Okt 2026<br><small class="text-muted">09:00 - 10:30 WIB</small></td>
                                <td><strong>TAK Sosialisasi (Berkenalan & Komunikasi)</strong></td>
                                <td>Aula Terapi Jiwa</td>
                                <td>dr. Hendra Pratama & Ns. Siti</td>
                                <td>Siti Aminah, Dewi Lestari (Total 6 Pasien)</td>
                                <td><span class="badge bg-primary">Terjadwal</span></td>
                            </tr>
                            <tr>
                                <td>28 Okt 2026<br><small class="text-muted">10:00 - 11:30 WIB</small></td>
                                <td><strong>Terapi Okupasi & Kerajinan Tangan</strong></td>
                                <td>Ruang Kesenian Bangsal</td>
                                <td>dr. Citra Dewi & Tim Rehab</td>
                                <td>Dewi Lestari, Agus Prasetyo (Total 8 Pasien)</td>
                                <td><span class="badge bg-secondary">Akan Datang</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH TERAPI -->
<div class="modal fade" id="modalTambahTerapi" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Jadwal Terapi Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/TerapiServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama / Topik Terapi *</label>
                        <input type="text" name="nama_terapi" class="form-control" placeholder="Contoh: TAK Stimulasi Persepsi Halusinasi" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tanggal & Waktu *</label>
                        <input type="datetime-local" name="waktu" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ruangan *</label>
                        <input type="text" name="ruangan" class="form-control" placeholder="Contoh: Aula Terapi Jiwa" required>
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

