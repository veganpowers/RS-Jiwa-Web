<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jadwal Besuk Keluarga - RS Khusus ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="besuk" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Pendaftaran Izin Besuk" />
            <jsp:param name="subtitle" value="Pengajuan Izin Kunjungan Tatap Muka untuk Pasien Siti Aminah" />
        </jsp:include>

        <div class="row g-4">
            <!-- FORM DAFTAR BESUK -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-calendar-plus me-2 text-primary"></i> Formulir Kunjungan</h6>
                    </div>
                    <div class="card-body">
                        <!-- INTEGRASI: Form action ke KeluargaServlet?action=daftar_besuk POST -->
                        <form action="<%= request.getContextPath() %>/KeluargaServlet?action=daftar_besuk" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Tanggal Rencana Besuk *</label>
                                <input type="date" name="tanggal" class="form-control" min="2026-10-27" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Sesi Waktu Kunjungan *</label>
                                <select name="sesi" class="form-select" required>
                                    <option value="Sesi Siang (10:00 - 11:30 WIB)">Sesi Siang (10:00 - 11:30 WIB)</option>
                                    <option value="Sesi Sore (14:30 - 16:00 WIB)">Sesi Sore (14:30 - 16:00 WIB)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nama Pengunjung & Hubungan *</label>
                                <input type="text" name="nama_pengunjung" class="form-control" value="Ratna Susanti (Ibu Kandung)" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Jumlah Keluarga Hadir (Maksimal 2) *</label>
                                <select name="jumlah" class="form-select" required>
                                    <option value="1">1 Orang</option>
                                    <option value="2">2 Orang</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary w-100"><i class="fa-solid fa-paper-plane me-1"></i> Ajukan Izin Kunjungan</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL RIWAYAT KUNJUNGAN -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-history me-2 text-primary"></i> Riwayat Pengajuan Izin Besuk</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tanggal</th>
                                        <th>Sesi Waktu</th>
                                        <th>Pengunjung</th>
                                        <th>Status Izin</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- INTEGRASI: SELECT * FROM jadwal_besuk WHERE id_pasien = ... -->
                                    <tr>
                                        <td>Sabtu, 24 Okt 2026</td>
                                        <td>Sesi Sore (14:30 - 16:00 WIB)</td>
                                        <td>Ratna & Suami (2 orang)</td>
                                        <td><span class="badge bg-success">Terlaksana</span></td>
                                    </tr>
                                    <tr>
                                        <td>Selasa, 20 Okt 2026</td>
                                        <td>Sesi Siang (10:00 - 11:30 WIB)</td>
                                        <td>Ratna Susanti (1 orang)</td>
                                        <td><span class="badge bg-success">Terlaksana</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

