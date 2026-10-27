<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal Keluarga Pasien - RS Khusus ODGJ</title>
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
            <jsp:param name="title" value="Beranda Informasi Pasien" />
            <jsp:param name="subtitle" value="Monitoring Kondisi dan Informasi Perawatan Anggota Keluarga" />
        </jsp:include>

        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body p-4 bg-white">
                <div class="d-flex align-items-center mb-3">
                    <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-circle me-3"><i class="fa-solid fa-user fa-2x"></i></div>
                    <div>
                        <h4 class="fw-bold mb-1">Siti Aminah (28 Tahun)</h4>
                        <p class="text-muted mb-0">No. Rekam Medis: <strong>RM-2026-0002</strong> &bull; Ruang: <strong>Bangsal Melati 01</strong></p>
                    </div>
                </div>
                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded border">
                            <small class="text-muted d-block">DOKTER PENANGGUNG JAWAB</small>
                            <strong>dr. Citra Dewi, Sp.KJ</strong>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded border">
                            <small class="text-muted d-block">STATUS PERAWATAN</small>
                            <span class="badge bg-success">Stabil & Kooperatif</span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="p-3 bg-light rounded border">
                            <small class="text-muted d-block">TANGGAL MASUK RAWAT</small>
                            <strong>18 Oktober 2026</strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-notes-medical me-2 text-primary"></i> Catatan Dokter Jiwa Terbaru</h6>
                    </div>
                    <div class="card-body">
                        <p class="mb-2"><strong>Evaluasi Mingguan (26 Okt 2026):</strong></p>
                        <p class="text-muted">Pasien sudah tidak mengalami halusinasi pendengaran. Bersedia minum obat oral dengan rutin dan mulai berinteraksi baik dengan rekan sekamar di Bangsal Melati.</p>
                        <a href="info_perkembangan.jsp" class="btn btn-sm btn-outline-primary">Lihat Seluruh Catatan</a>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-calendar-check me-2 text-primary"></i> Jadwal Besuk Keluarga</h6>
                    </div>
                    <div class="card-body">
                        <p class="text-muted mb-3">Kunjungan tatap muka diperbolehkan pada hari <strong>Selasa & Sabtu</strong> pukul 14:00 - 16:00 WIB.</p>
                        <a href="jadwal_besuk.jsp" class="btn btn-primary"><i class="fa-solid fa-calendar-plus me-1"></i> Ajukan Izin Besuk</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

