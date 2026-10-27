<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Perawat - RS Khusus ODGJ</title>
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
            <jsp:param name="title" value="Dashboard Perawat" />
            <jsp:param name="subtitle" value="Monitoring Harian Asuhan Keperawatan Pasien Jiwa" />
        </jsp:include>

        <div class="alert alert-primary mb-4">
            <h5 class="alert-heading fw-bold mb-1"><i class="fa-solid fa-user-nurse me-2"></i> Selamat Bertugas, Ners</h5>
            <p class="mb-0">Gunakan menu di samping untuk mencatat tanda-tanda vital (TTV), observasi perilaku harian, serta memperbarui kamar rawat pasien.</p>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-danger bg-opacity-10 text-danger rounded-3 me-3"><i class="fa-solid fa-lock fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">PASIEN ISOLASI</small>
                            <h3 class="fw-bold mb-0">3 Pasien</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-3 me-3"><i class="fa-solid fa-bed fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">BANGSAL REGULER</small>
                            <h3 class="fw-bold mb-0">11 Pasien</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-success bg-opacity-10 text-success rounded-3 me-3"><i class="fa-solid fa-heart-pulse fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">CATATAN TTV HARI INI</small>
                            <h3 class="fw-bold mb-0">8 Tercatat</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-list me-2 text-primary"></i> Pasien Perlu Observasi Perilaku</h6>
                <a href="pantau_kondisi_harian.jsp" class="btn btn-sm btn-primary"><i class="fa-solid fa-plus me-1"></i> Catat TTV Baru</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. RM</th>
                                <th>Nama Pasien</th>
                                <th>Kamar</th>
                                <th>Perilaku Terakhir</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>RM-2026-0001</strong></td>
                                <td>Bambang Wicaksono</td>
                                <td><span class="badge bg-danger">Isolasi A-01</span></td>
                                <td>Gaduh gelisah berkurang, tidur nyenyak</td>
                                <td><a href="pantau_kondisi_harian.jsp?id=1" class="btn btn-sm btn-outline-primary">Input TTV</a></td>
                            </tr>
                            <tr>
                                <td><strong>RM-2026-0004</strong></td>
                                <td>Agus Prasetyo</td>
                                <td><span class="badge bg-danger">Isolasi A-02</span></td>
                                <td>Mendengar bisikan, kontak mata minim</td>
                                <td><a href="pantau_kondisi_harian.jsp?id=4" class="btn btn-sm btn-outline-primary">Input TTV</a></td>
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

