<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Dokter - RS Khusus ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="dashboard" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Dashboard Dokter" />
            <jsp:param name="subtitle" value="Ringkasan Antrean Pasien dan Tugas Medis Psikiatri" />
        </jsp:include>

        <div class="alert alert-primary mb-4">
            <h5 class="alert-heading fw-bold mb-1"><i class="fa-solid fa-user-doctor me-2"></i> Selamat Bertugas, Dokter</h5>
            <p class="mb-0">Halaman ini digunakan untuk mengelola rekam medis pemeriksaan pasien, diagnosis kejiwaan, dan peresepan obat harian.</p>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-3 me-3"><i class="fa-solid fa-bed-pulse fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">PASIEN RAWAT INAP</small>
                            <!-- INTEGRASI: SELECT COUNT(*) FROM pasien WHERE status_rawat='Rawat Inap' -->
                            <h3 class="fw-bold mb-0">14 Pasien</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-success bg-opacity-10 text-success rounded-3 me-3"><i class="fa-solid fa-notes-medical fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">DIAGNOSA HARI INI</small>
                            <!-- INTEGRASI: SELECT COUNT(*) FROM rekam_medis WHERE DATE(tanggal)=CURDATE() -->
                            <h3 class="fw-bold mb-0">6 Rekam Medis</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 me-3"><i class="fa-solid fa-pills fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">RESEP DITERBITKAN</small>
                            <!-- INTEGRASI: SELECT COUNT(*) FROM resep_obat -->
                            <h3 class="fw-bold mb-0">9 Resep</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-list me-2 text-primary"></i> Pasien Perlu Pemeriksaan Hari Ini</h6>
                <a href="input_diagnosa.jsp" class="btn btn-sm btn-primary"><i class="fa-solid fa-plus me-1"></i> Input Diagnosa Baru</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. RM</th>
                                <th>Nama Pasien</th>
                                <th>Ruangan</th>
                                <th>Diagnosa Terakhir</th>
                                <th>Status</th>
                                <th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM pasien LIMIT 4 -->
                            <tr>
                                <td><strong>RM-2026-0001</strong></td>
                                <td>Bambang Wicaksono</td>
                                <td>Isolasi A-01</td>
                                <td>F20.0 Skizofrenia Paranoid</td>
                                <td><span class="badge bg-danger">Observasi Ketat</span></td>
                                <td class="text-center">
                                    <a href="input_diagnosa.jsp?id=1" class="btn btn-sm btn-outline-primary">Periksa</a>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>RM-2026-0002</strong></td>
                                <td>Siti Aminah</td>
                                <td>Bangsal Melati 01</td>
                                <td>F20.0 Halusinasi Dengar</td>
                                <td><span class="badge bg-success">Stabil</span></td>
                                <td class="text-center">
                                    <a href="input_diagnosa.jsp?id=2" class="btn btn-sm btn-outline-primary">Periksa</a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

