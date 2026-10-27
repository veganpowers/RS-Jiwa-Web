<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - RS Khusus ODGJ</title>
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
            <jsp:param name="title" value="Dashboard Administrator" />
            <jsp:param name="subtitle" value="Pusat Kontrol dan Akses Seluruh Data Master Rumah Sakit" />
        </jsp:include>

        <div class="alert alert-primary mb-4" role="alert">
            <h5 class="alert-heading fw-bold mb-1"><i class="fa-solid fa-hospital-user me-2"></i> Selamat Datang di Panel Utama Administrator</h5>
            <p class="mb-0">Sebagai Administrator, Anda memiliki hak akses penuh untuk melakukan operasi <strong>CRUD (Create, Read, Update, Delete)</strong> terhadap seluruh data master, medis, operasional obat, tagihan, dan akun sistem.</p>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-3 me-3"><i class="fa-solid fa-user-doctor fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL DOKTER</small>
                            <h3 class="fw-bold mb-0">5</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-success bg-opacity-10 text-success rounded-3 me-3"><i class="fa-solid fa-user-nurse fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL PERAWAT</small>
                            <h3 class="fw-bold mb-0">12</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-danger bg-opacity-10 text-danger rounded-3 me-3"><i class="fa-solid fa-bed-pulse fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL PASIEN</small>
                            <h3 class="fw-bold mb-0">28</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 me-3"><i class="fa-solid fa-door-closed fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL KAMAR</small>
                            <h3 class="fw-bold mb-0">16</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Data Pasien ODGJ Masuk Terbaru</h6>
                <a href="data_pasien.jsp" class="btn btn-sm btn-primary">Kelola Seluruh Pasien &rarr;</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. RM</th>
                                <th>Nama Pasien</th>
                                <th>Jenis Kelamin</th>
                                <th>Status Rawat</th>
                                <th>Kamar Rawat</th>
                                <th>Kontak Keluarga</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>RM-2026-0001</strong></td>
                                <td>Bambang Wicaksono</td>
                                <td>Laki-laki</td>
                                <td><span class="badge bg-danger">Rawat Inap</span></td>
                                <td>Isolasi A-01</td>
                                <td>0812-9988-7766</td>
                            </tr>
                            <tr>
                                <td><strong>RM-2026-0002</strong></td>
                                <td>Siti Aminah</td>
                                <td>Perempuan</td>
                                <td><span class="badge bg-danger">Rawat Inap</span></td>
                                <td>Bangsal Melati 01</td>
                                <td>0857-1122-3344</td>
                            </tr>
                            <tr>
                                <td><strong>RM-2026-0003</strong></td>
                                <td>Dewi Lestari</td>
                                <td>Perempuan</td>
                                <td><span class="badge bg-success">Rawat Jalan</span></td>
                                <td>-</td>
                                <td>0821-3344-5566</td>
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

