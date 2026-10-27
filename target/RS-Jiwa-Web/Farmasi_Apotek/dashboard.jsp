<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Farmasi - RS Khusus ODGJ</title>
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
            <jsp:param name="title" value="Dashboard Farmasi & Apotek" />
            <jsp:param name="subtitle" value="Pengawasan Antrean Resep dan Pengelolaan Stok Obat Jiwa" />
        </jsp:include>

        <div class="alert alert-primary mb-4">
            <h5 class="alert-heading fw-bold mb-1"><i class="fa-solid fa-mortar-pestle me-2"></i> Selamat Bertugas, Petugas Apotek</h5>
            <p class="mb-0">Halaman ini digunakan untuk memproses resep dari dokter spesialis jiwa dan mengelola sisa stok fisik obat di instalasi farmasi.</p>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 me-3"><i class="fa-solid fa-clock-rotate-left fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">ANTREAN RESEP MENUNGGU</small>
                            <h3 class="fw-bold mb-0">3 Resep</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-success bg-opacity-10 text-success rounded-3 me-3"><i class="fa-solid fa-check-double fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">RESEP SELESAI HARI INI</small>
                            <h3 class="fw-bold mb-0">18 Resep</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-danger bg-opacity-10 text-danger rounded-3 me-3"><i class="fa-solid fa-boxes-stacked fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">STOK OBAT KRITIS</small>
                            <h3 class="fw-bold mb-0">1 Item</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-receipt me-2 text-primary"></i> Resep Masuk Perlu Diracik</h6>
                <a href="antrian_resep.jsp" class="btn btn-sm btn-primary">Lihat Semua Antrean</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. Resep</th>
                                <th>Nama Pasien</th>
                                <th>Rincian Obat</th>
                                <th>Status</th>
                                <th class="text-center">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>#RX-2026-089</strong></td>
                                <td>Agus Prasetyo (Isolasi A-02)</td>
                                <td>Diazepam 10 mg Injeksi (2 Ampul)</td>
                                <td><span class="badge bg-danger">CITO / Darurat</span></td>
                                <td class="text-center"><a href="antrian_resep.jsp" class="btn btn-sm btn-success">Proses</a></td>
                            </tr>
                            <tr>
                                <td><strong>#RX-2026-088</strong></td>
                                <td>Bambang Wicaksono (Isolasi A-01)</td>
                                <td>Haloperidol 5 mg (30 tab) + THP 2 mg</td>
                                <td><span class="badge bg-warning text-dark">Menunggu</span></td>
                                <td class="text-center"><a href="antrian_resep.jsp" class="btn btn-sm btn-success">Proses</a></td>
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

