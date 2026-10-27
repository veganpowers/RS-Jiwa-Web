<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Rumah Sakit - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="laporan" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Laporan Rekapitulasi Pelayanan" />
            <jsp:param name="subtitle" value="Cetak dan Filter Data Kunjungan Pasien dan Pendapatan Rumah Sakit" />
        </jsp:include>

        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <form class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Pilih Bulan *</label>
                        <select class="form-select">
                            <option value="10" selected>Oktober 2026</option>
                            <option value="9">September 2026</option>
                            <option value="8">Agustus 2026</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Jenis Laporan *</label>
                        <select class="form-select">
                            <option value="kunjungan">Laporan Kunjungan Pasien ODGJ</option>
                            <option value="kamar">Laporan Penggunaan Kamar & Isolasi</option>
                            <option value="keuangan">Laporan Penerimaan Kas & BPJS</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <button type="button" class="btn btn-primary me-2"><i class="fa-solid fa-filter me-1"></i> Tampilkan</button>
                        <button type="button" class="btn btn-outline-secondary" onclick="window.print()"><i class="fa-solid fa-print me-1"></i> Cetak PDF</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-table me-2 text-primary"></i> Rekapitulasi Kunjungan Pasien Periode Oktober 2026</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Kategori Layanan</th>
                                <th>Jumlah Pasien Terdaftar</th>
                                <th>Pasien Selesai Pulang (KRS)</th>
                                <th>Masih Dalam Rawat</th>
                                <th>Keterangan</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Ruang Isolasi Khusus (Krisis)</strong></td>
                                <td>6 Pasien</td>
                                <td>3 Pasien</td>
                                <td>3 Pasien Aktif</td>
                                <td>Tingkat keterisian 75%</td>
                            </tr>
                            <tr>
                                <td><strong>Bangsal Reguler (Melati)</strong></td>
                                <td>18 Pasien</td>
                                <td>7 Pasien</td>
                                <td>11 Pasien Aktif</td>
                                <td>Tingkat keterisian 68%</td>
                            </tr>
                            <tr>
                                <td><strong>Poliklinik Rawat Jalan</strong></td>
                                <td>34 Pasien</td>
                                <td>34 Pasien</td>
                                <td>-</td>
                                <td>Konsultasi rutin rawat jalan</td>
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

