<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Antrean Resep - Farmasi RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="antrian" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Daftar Antrean Resep Obat" />
            <jsp:param name="subtitle" value="Verifikasi dan Penyiapan Resep Elektronik Pasien" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-list-check me-2 text-primary"></i> Tabel Antrean Resep</h6>
                <div style="width: 250px;">
                    <input type="text" class="form-control form-control-sm" placeholder="Cari No. Resep...">
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. Resep</th>
                                <th>Nama Pasien</th>
                                <th>Dokter Peresep</th>
                                <th>Nama Obat & Dosis</th>
                                <th>Status</th>
                                <th class="text-center" style="width: 200px;">Aksi Farmasi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM resep_obat JOIN pasien ... -->
                            <tr>
                                <td><strong>#RX-2026-089</strong></td>
                                <td>Agus Prasetyo (Isolasi A-02)</td>
                                <td>dr. Citra Dewi, Sp.KJ</td>
                                <td>Diazepam 10 mg Injeksi (2 Ampul)</td>
                                <td><span class="badge bg-danger">CITO / Menunggu</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-primary" onclick="alert('Resep #RX-2026-089 mulai diracik!')">Proses Racik</button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#RX-2026-088</strong></td>
                                <td>Bambang Wicaksono (Isolasi A-01)</td>
                                <td>dr. Hendra Pratama, Sp.KJ</td>
                                <td>Haloperidol 5 mg (30 tab) + THP 2 mg</td>
                                <td><span class="badge bg-warning text-dark">Sedang Diracik</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-success" onclick="alert('Resep #RX-2026-088 siap diserahkan ke perawat!')">Siap Diambil</button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#RX-2026-087</strong></td>
                                <td>Siti Aminah (Bangsal 01)</td>
                                <td>dr. Citra Dewi, Sp.KJ</td>
                                <td>Risperidone 2 mg (20 tab)</td>
                                <td><span class="badge bg-success">Siap Diambil</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-secondary" onclick="alert('Obat telah diserahkan kepada perawat!')">Serahkan</button>
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

