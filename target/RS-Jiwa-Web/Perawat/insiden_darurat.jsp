<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Insiden Pasien - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="insiden" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Laporan Insiden Pasien" />
            <jsp:param name="subtitle" value="Pencatatan Kejadian Khusus (Pasien Mengamuk, Kabur, Gaduh Gelisah)" />
        </jsp:include>

        <div class="row g-4">
            <!-- FORM INPUT INSIDEN DASAR -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-triangle-exclamation me-2 text-danger"></i> Form Laporan Insiden</h6>
                    </div>
                    <div class="card-body">
                        <!-- INTEGRASI: Form action ke PerawatServlet?action=simpan_insiden POST -->
                        <form action="<%= request.getContextPath() %>/PerawatServlet?action=simpan_insiden" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien Terkait *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien --</option>
                                    <option value="1">RM-2026-0001 - Bambang Wicaksono</option>
                                    <option value="4">RM-2026-0004 - Agus Prasetyo</option>
                                    <option value="2">RM-2026-0002 - Siti Aminah</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Waktu Kejadian *</label>
                                <input type="datetime-local" name="waktu" class="form-control" required value="2026-10-26T10:00">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Jenis Kejadian / Insiden *</label>
                                <select name="jenis_insiden" class="form-select" required>
                                    <option value="Gaduh Gelisah & Mengamuk">Gaduh Gelisah & Mengamuk</option>
                                    <option value="Percobaan Melarikan Diri">Percobaan Melarikan Diri (Kabur)</option>
                                    <option value="Menolak Minum Obat">Menolak Minum Obat & Melawan</option>
                                    <option value="Merusak Fasilitas">Merusak Fasilitas Bangsal</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Kronologi Singkat *</label>
                                <textarea name="kronologi" class="form-control" rows="2" placeholder="Ceritakan bagaimana insiden terjadi..." required></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tindakan Penanganan Awal *</label>
                                <textarea name="penanganan" class="form-control" rows="2" placeholder="Contoh: Ditenangkan secara verbal, dipindahkan ke isolasi..." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-danger w-100"><i class="fa-solid fa-paper-plane me-1"></i> Kirim Laporan Insiden</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL DAFTAR INSIDEN -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-history me-2 text-danger"></i> Riwayat Insiden Terakhir</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Waktu</th>
                                        <th>Pasien</th>
                                        <th>Jenis Insiden</th>
                                        <th>Penanganan</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- INTEGRASI: SELECT * FROM insiden_darurat ORDER BY id_insiden DESC -->
                                    <tr>
                                        <td>26/10 06:30</td>
                                        <td>Agus Prasetyo</td>
                                        <td><span class="badge bg-danger">Percobaan Kabur</span></td>
                                        <td>Diamankan sekuriti, pindah ke Isolasi A-02</td>
                                    </tr>
                                    <tr>
                                        <td>25/10 21:15</td>
                                        <td>Bambang W.</td>
                                        <td><span class="badge bg-warning text-dark">Mengamuk</span></td>
                                        <td>Fiksasi bantalan lembut, injeksi Haloperidol</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

