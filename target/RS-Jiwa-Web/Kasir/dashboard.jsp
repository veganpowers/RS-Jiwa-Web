<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Kasir - RS Khusus ODGJ</title>
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
            <jsp:param name="title" value="Dashboard Kasir & Pembayaran" />
            <jsp:param name="subtitle" value="Penerimaan Kas Rawat Inap & Jalan RS ODGJ" />
        </jsp:include>

        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-success bg-opacity-10 text-success rounded-3 me-3"><i class="fa-solid fa-money-bill-wave fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL PENERIMAAN HARI INI</small>
                            <h3 class="fw-bold mb-0">Rp 12.500.000</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 me-3"><i class="fa-solid fa-file-invoice fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TAGIHAN MENUNGGU BAYAR</small>
                            <h3 class="fw-bold mb-0">4 Invoice</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-receipt me-2 text-primary"></i> Transaksi Terakhir</h6>
                <a href="tagihan_perawatan.jsp" class="btn btn-sm btn-primary">Kelola Semua Tagihan</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. Invoice</th>
                                <th>Nama Pasien</th>
                                <th>Penjamin</th>
                                <th>Total Biaya</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>#INV-2026-042</strong></td>
                                <td>Siti Aminah</td>
                                <td>BPJS PBI Jiwa</td>
                                <td>Rp 4.250.000</td>
                                <td><span class="badge bg-success">Lunas</span></td>
                            </tr>
                            <tr>
                                <td><strong>#INV-2026-043</strong></td>
                                <td>Bambang Wicaksono</td>
                                <td>Umum / Tunai</td>
                                <td>Rp 3.800.000</td>
                                <td><span class="badge bg-warning text-dark">Belum Bayar</span></td>
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

