<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Pasien Ditangani - Dokter RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="pasien" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Daftar Pasien Ditangani" />
            <jsp:param name="subtitle" value="Data Pasien Rawat Inap & Jalan di Bawah Tanggung Jawab DPJP" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-bed-pulse me-2 text-primary"></i> Tabel Pasien Rawat</h6>
                <div style="width: 250px;">
                    <input type="text" class="form-control form-control-sm" placeholder="Cari nama / No. RM...">
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. RM</th>
                                <th>Nama Lengkap</th>
                                <th>Umur / JK</th>
                                <th>Kamar / Ruangan</th>
                                <th>Kondisi Terkini</th>
                                <th>Tanggal Masuk</th>
                                <th class="text-center" style="width: 180px;">Aksi Medis</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM pasien WHERE id_dokter = session.id_dokter -->
                            <tr>
                                <td><strong>RM-2026-0001</strong></td>
                                <td>Bambang Wicaksono</td>
                                <td>34 Thn / L</td>
                                <td><span class="badge bg-danger">Isolasi A-01</span></td>
                                <td>Gaduh Gelisah Berat (Fiksasi)</td>
                                <td>22 Okt 2026</td>
                                <td class="text-center">
                                    <a href="input_diagnosa.jsp?rm=RM-2026-0001" class="btn btn-sm btn-primary"><i class="fa-solid fa-stethoscope"></i> Diagnosa</a>
                                    <a href="resep_obat.jsp?rm=RM-2026-0001" class="btn btn-sm btn-success"><i class="fa-solid fa-pills"></i> Resep</a>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>RM-2026-0002</strong></td>
                                <td>Siti Aminah</td>
                                <td>28 Thn / P</td>
                                <td><span class="badge bg-info text-dark">Bangsal Melati 01</span></td>
                                <td>Tenang, Afek Terbuka</td>
                                <td>18 Okt 2026</td>
                                <td class="text-center">
                                    <a href="input_diagnosa.jsp?rm=RM-2026-0002" class="btn btn-sm btn-primary"><i class="fa-solid fa-stethoscope"></i> Diagnosa</a>
                                    <a href="resep_obat.jsp?rm=RM-2026-0002" class="btn btn-sm btn-success"><i class="fa-solid fa-pills"></i> Resep</a>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>RM-2026-0004</strong></td>
                                <td>Agus Prasetyo</td>
                                <td>41 Thn / L</td>
                                <td><span class="badge bg-danger">Isolasi A-02</span></td>
                                <td>Halusinasi Auditori Akut</td>
                                <td>24 Okt 2026</td>
                                <td class="text-center">
                                    <a href="input_diagnosa.jsp?rm=RM-2026-0004" class="btn btn-sm btn-primary"><i class="fa-solid fa-stethoscope"></i> Diagnosa</a>
                                    <a href="resep_obat.jsp?rm=RM-2026-0004" class="btn btn-sm btn-success"><i class="fa-solid fa-pills"></i> Resep</a>
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

