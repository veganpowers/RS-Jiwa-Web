<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Perkembangan Pasien - Portal Keluarga RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="perkembangan" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Riwayat Perkembangan Pasien" />
            <jsp:param name="subtitle" value="Catatan Evaluasi Dokter dan Perawat Mengenai Pasien Siti Aminah" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-list me-2 text-primary"></i> Catatan Observasi Tim Medis</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Tanggal</th>
                                <th>Petugas Medis</th>
                                <th>Catatan Evaluasi Pasien</th>
                                <th>Status Progres</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM pantau_kondisi WHERE id_pasien = ... -->
                            <tr>
                                <td>26 Okt 2026</td>
                                <td>dr. Citra Dewi, Sp.KJ</td>
                                <td>Afek mulai terbuka, respon emosional stabil, halusinasi dengar sudah teratasi sepenuhnya.</td>
                                <td><span class="badge bg-success">Membaik</span></td>
                            </tr>
                            <tr>
                                <td>24 Okt 2026</td>
                                <td>Ns. Siti Rahma, S.Kep</td>
                                <td>Mengikuti sesi Terapi Aktivitas Kelompok (TAK) dengan baik dan tersenyum ramah kepada teman kelompok.</td>
                                <td><span class="badge bg-primary">Aktif</span></td>
                            </tr>
                            <tr>
                                <td>21 Okt 2026</td>
                                <td>dr. Citra Dewi, Sp.KJ</td>
                                <td>Penurunan dosis antipsikotik, pasien dialihkan dari ruang isolasi ke Bangsal Melati.</td>
                                <td><span class="badge bg-info text-dark">Stabilisasi</span></td>
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

