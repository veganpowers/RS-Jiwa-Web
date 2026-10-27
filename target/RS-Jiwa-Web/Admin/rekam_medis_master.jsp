<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rekam Medis Master - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="rekam" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Rekam Medis Pasien (Master)" />
            <jsp:param name="subtitle" value="Pusat Pencarian dan Pengelolaan Riwayat Medis Pasien ODGJ (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-notes-medical me-2 text-primary"></i> Seluruh Arsip Rekam Medis</h6>
                <div style="width: 250px;">
                    <input type="text" class="form-control form-control-sm" placeholder="Cari No. RM / Nama Pasien...">
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Tanggal</th>
                                <th>No. RM</th>
                                <th>Nama Pasien</th>
                                <th>Dokter Pemeriksa</th>
                                <th>Diagnosa (ICD-10)</th>
                                <th>Keluhan & Catatan</th>
                                <th class="text-center" style="width: 100px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM rekam_medis JOIN pasien ... -->
                            <tr>
                                <td>26/10/2026</td>
                                <td><strong>RM-2026-0004</strong></td>
                                <td>Agus Prasetyo</td>
                                <td>dr. Citra Dewi, Sp.KJ</td>
                                <td><span class="badge bg-danger">F20.0 Skizofrenia</span></td>
                                <td>Gaduh gelisah, berupaya kabur dari selasar belakang</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-danger" onclick="if(confirm('Hapus rekam medis ini?')) alert('Rekam medis dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>24/10/2026</td>
                                <td><strong>RM-2026-0002</strong></td>
                                <td>Siti Aminah</td>
                                <td>dr. Citra Dewi, Sp.KJ</td>
                                <td><span class="badge bg-primary">F20.0 Paranoid</span></td>
                                <td>Halusinasi dengar teratasi, latihan bersosialisasi</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-danger" onclick="if(confirm('Hapus rekam medis ini?')) alert('Rekam medis dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>22/10/2026</td>
                                <td><strong>RM-2026-0001</strong></td>
                                <td>Bambang Wicaksono</td>
                                <td>dr. Hendra Pratama, Sp.KJ</td>
                                <td><span class="badge bg-danger">F20.0 Gaduh Gelisah</span></td>
                                <td>Agresif merusak properti, fiksasi bantalan lembut</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-danger" onclick="if(confirm('Hapus rekam medis ini?')) alert('Rekam medis dihapus!')"><i class="fa-solid fa-trash"></i></button>
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

