<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resep Obat Pasien - Dokter RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="resep" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Pemberian Resep Obat" />
            <jsp:param name="subtitle" value="Form Input E-Resep Terapi Obat Jiwa Sederhana" />
        </jsp:include>

        <div class="row g-4">
            <!-- FORM INPUT RESEP -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-file-prescription me-2 text-primary"></i> Buat Resep Baru</h6>
                    </div>
                    <div class="card-body">
                        <!-- INTEGRASI: Form action ke ResepServlet POST -->
                        <form action="<%= request.getContextPath() %>/ResepServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien Penerima --</option>
                                    <option value="1" <%= "RM-2026-0001".equals(request.getParameter("rm")) ? "selected" : "" %>>RM-2026-0001 - Bambang Wicaksono</option>
                                    <option value="2" <%= "RM-2026-0002".equals(request.getParameter("rm")) ? "selected" : "" %>>RM-2026-0002 - Siti Aminah</option>
                                    <option value="4" <%= "RM-2026-0004".equals(request.getParameter("rm")) ? "selected" : "" %>>RM-2026-0004 - Agus Prasetyo</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nama Obat Jiwa *</label>
                                <select name="id_obat" class="form-select" required>
                                    <option value="">-- Pilih Obat dari Master Stok --</option>
                                    <option value="1">Haloperidol 5 mg (Tablet)</option>
                                    <option value="2">Risperidone 2 mg (Tablet)</option>
                                    <option value="3">Trihexyphenidyl 2 mg (Tablet)</option>
                                    <option value="4">Diazepam 10 mg (Injeksi Ampul)</option>
                                    <option value="5">Chlorpromazine 100 mg (Tablet)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Jumlah (Qty) *</label>
                                <input type="number" name="jumlah" class="form-control" placeholder="Contoh: 10" min="1" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Dosis & Aturan Minum *</label>
                                <input type="text" name="aturan_pakai" class="form-control" placeholder="Contoh: 3 x 1 tablet sesudah makan" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Catatan Khusus Apotek</label>
                                <textarea name="catatan" class="form-control" rows="2" placeholder="Contoh: CITO / segera kirim ke ruang isolasi"></textarea>
                            </div>

                            <button type="submit" class="btn btn-success w-100"><i class="fa-solid fa-paper-plane me-1"></i> Kirim Resep ke Farmasi</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL DAFTAR RESEP TERKIRIM -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-list me-2 text-primary"></i> Daftar Resep Terbaru</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>No. Resep</th>
                                        <th>Pasien</th>
                                        <th>Obat & Dosis</th>
                                        <th>Status Apotek</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- INTEGRASI: SELECT * FROM resep_obat ORDER BY id_resep DESC LIMIT 4 -->
                                    <tr>
                                        <td><strong>#RX-2026-089</strong></td>
                                        <td>Agus Prasetyo</td>
                                        <td>Diazepam 10 mg (2 ampul)<br><small class="text-muted">Injeksi IM CITO</small></td>
                                        <td><span class="badge bg-warning text-dark">Menunggu Diracik</span></td>
                                    </tr>
                                    <tr>
                                        <td><strong>#RX-2026-088</strong></td>
                                        <td>Bambang Wicaksono</td>
                                        <td>Haloperidol 5mg + THP 2mg<br><small class="text-muted">3 x 1 tablet</small></td>
                                        <td><span class="badge bg-primary">Sedang Diracik</span></td>
                                    </tr>
                                    <tr>
                                        <td><strong>#RX-2026-087</strong></td>
                                        <td>Siti Aminah</td>
                                        <td>Risperidone 2 mg (20 tab)<br><small class="text-muted">2 x 1 tablet</small></td>
                                        <td><span class="badge bg-success">Siap Diambil</span></td>
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

