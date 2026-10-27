<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Riwayat Konsultasi Pasien - Dokter RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="riwayat" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Riwayat Konsultasi & Rekam Medis" />
            <jsp:param name="subtitle" value="Pencarian Arsip Hasil Pemeriksaan Medis Pasien Jiwa" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Arsip Konsultasi Psikiatri</h6>
                <div style="width: 250px;">
                    <input type="text" class="form-control form-control-sm" placeholder="Cari No. RM / Nama Pasien...">
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Tanggal Periksa</th>
                                <th>No. RM</th>
                                <th>Nama Pasien</th>
                                <th>Keluhan yang Dilaporkan</th>
                                <th>Hasil Diagnosa</th>
                                <th>Rekomendasi / Resep</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM rekam_medis ORDER BY tanggal DESC -->
                            <tr>
                                <td>26/10/2026</td>
                                <td><strong>RM-2026-0004</strong></td>
                                <td>Agus Prasetyo</td>
                                <td>Gaduh gelisah, berupaya kabur dari selasar belakang</td>
                                <td><span class="badge bg-danger">F20.0 Skizofrenia</span></td>
                                <td>Injeksi Diazepam 10 mg & Pengawasan Isolasi</td>
                            </tr>
                            <tr>
                                <td>24/10/2026</td>
                                <td><strong>RM-2026-0002</strong></td>
                                <td>Siti Aminah</td>
                                <td>Mendengar bisikan asing saat malam hari</td>
                                <td><span class="badge bg-primary">F20.0 Paranoid</span></td>
                                <td>Risperidone 2 mg (2x1) & Latihan Menghardik</td>
                            </tr>
                            <tr>
                                <td>22/10/2026</td>
                                <td><strong>RM-2026-0001</strong></td>
                                <td>Bambang Wicaksono</td>
                                <td>Agresif verbal dan merusak properti bangsal</td>
                                <td><span class="badge bg-danger">F20.0 Gaduh Gelisah</span></td>
                                <td>Haloperidol 5 mg + THP 2 mg & Restraint Lembut</td>
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

