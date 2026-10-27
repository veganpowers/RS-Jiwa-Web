<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pemberian Obat Pasien - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="log" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Log Pemberian Obat Pasien" />
            <jsp:param name="subtitle" value="Checklist Verifikasi Minum Obat Pasien Rawat Inap & Isolasi" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-pills me-2 text-primary"></i> Jadwal Minum Obat Pasien Hari Ini</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Jam</th>
                                <th>No. RM & Nama Pasien</th>
                                <th>Kamar</th>
                                <th>Nama Obat & Dosis</th>
                                <th>Status Minum</th>
                                <th class="text-center" style="width: 160px;">Aksi Verifikasi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM resep_obat JOIN pasien ... -->
                            <tr>
                                <td><strong>08:00 WIB</strong></td>
                                <td>Bambang Wicaksono<br><small class="text-muted">RM-2026-0001</small></td>
                                <td><span class="badge bg-danger">Isolasi A-01</span></td>
                                <td>Haloperidol 5 mg (1 tab) + THP 2 mg</td>
                                <td><span class="badge bg-success"><i class="fa-solid fa-check"></i> Sudah Diminum</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-secondary" disabled>Selesai</button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>12:00 WIB</strong></td>
                                <td>Siti Aminah<br><small class="text-muted">RM-2026-0002</small></td>
                                <td><span class="badge bg-info text-dark">Bangsal Melati 01</span></td>
                                <td>Risperidone 2 mg (1 tab)</td>
                                <td><span class="badge bg-warning text-dark"><i class="fa-solid fa-clock"></i> Belum Diberikan</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-success" onclick="if(confirm('Konfirmasi bahwa pasien Siti Aminah sudah menelan obat?')) alert('Status berhasil diperbarui!')">
                                        <i class="fa-solid fa-check me-1"></i> Berikan
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>CITO / Darurat</strong></td>
                                <td>Agus Prasetyo<br><small class="text-muted">RM-2026-0004</small></td>
                                <td><span class="badge bg-danger">Isolasi A-02</span></td>
                                <td>Diazepam 10 mg Injeksi IM</td>
                                <td><span class="badge bg-success"><i class="fa-solid fa-check"></i> Terinjeksi</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-secondary" disabled>Selesai</button>
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

