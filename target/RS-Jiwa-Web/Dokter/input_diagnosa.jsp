<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pemeriksaan & Input Diagnosa - Dokter RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="diagnosa" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Input Hasil Diagnosa Medis" />
            <jsp:param name="subtitle" value="Pencatatan Anamnesis dan Rekam Medis Pasien (Operasi CRUD)" />
        </jsp:include>

        <% if ("sukses".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                Hasil diagnosa rekam medis berhasil disimpan!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- FORM INPUT DIAGNOSA DASAR -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-file-circle-plus me-2 text-primary"></i> Formulir Rekam Medis</h6>
                    </div>
                    <div class="card-body">
                        <!-- INTEGRASI: Form action ke DiagnosaServlet POST -->
                        <form action="<%= request.getContextPath() %>/DiagnosaServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien ODGJ *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien --</option>
                                    <option value="1" <%= "RM-2026-0001".equals(request.getParameter("rm")) ? "selected" : "" %>>RM-2026-0001 - Bambang Wicaksono</option>
                                    <option value="2" <%= "RM-2026-0002".equals(request.getParameter("rm")) ? "selected" : "" %>>RM-2026-0002 - Siti Aminah</option>
                                    <option value="4" <%= "RM-2026-0004".equals(request.getParameter("rm")) ? "selected" : "" %>>RM-2026-0004 - Agus Prasetyo</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tanggal Pemeriksaan *</label>
                                <input type="date" name="tanggal" class="form-control" value="2026-10-26" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Keluhan Utama & Gejala *</label>
                                <textarea name="keluhan" class="form-control" rows="3" placeholder="Contoh: Pasien berteriak gelisah, mengaku mendengar suara bisikan tak kasat mata..." required></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Kode & Nama Diagnosa (ICD-10) *</label>
                                <select name="diagnosa" class="form-select" required>
                                    <option value="F20.0 Skizofrenia Paranoid">F20.0 Skizofrenia Paranoid</option>
                                    <option value="F31.0 Gangguan Afektif Bipolar">F31.0 Gangguan Afektif Bipolar</option>
                                    <option value="F32.0 Episode Depresi Berat">F32.0 Episode Depresi Berat</option>
                                    <option value="F10.0 Gangguan Mental Terkait Zat">F10.0 Gangguan Mental Terkait Zat/Adiksi</option>
                                    <option value="F41.0 Gangguan Cemas & Panik">F41.0 Gangguan Cemas & Panik</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tindakan / Rencana Terapi *</label>
                                <textarea name="tindakan" class="form-control" rows="2" placeholder="Contoh: Isolasi pengawasan 24 jam, terapi obat antipsikotik oral, evaluasi respon 3 hari." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary w-100"><i class="fa-solid fa-save me-1"></i> Simpan Hasil Diagnosa</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL RIWAYAT REKAM MEDIS TERBARU -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-history me-2 text-primary"></i> Riwayat Diagnosa Terkini</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-striped align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Tgl</th>
                                        <th>Pasien</th>
                                        <th>Diagnosa ICD-10</th>
                                        <th>Rencana Medis</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- INTEGRASI: SELECT * FROM rekam_medis ORDER BY id_rekam_medis DESC LIMIT 5 -->
                                    <tr>
                                        <td>26/10</td>
                                        <td><strong>Agus Prasetyo</strong><br><small class="text-muted">RM-2026-0004</small></td>
                                        <td><span class="badge bg-danger">F20.0 Skizofrenia</span></td>
                                        <td>Injeksi Diazepam CITO & Isolasi</td>
                                    </tr>
                                    <tr>
                                        <td>24/10</td>
                                        <td><strong>Siti Aminah</strong><br><small class="text-muted">RM-2026-0002</small></td>
                                        <td><span class="badge bg-primary">F20.0 Paranoid</span></td>
                                        <td>Latihan menghardik halusinasi & TAK</td>
                                    </tr>
                                    <tr>
                                        <td>22/10</td>
                                        <td><strong>Bambang W.</strong><br><small class="text-muted">RM-2026-0001</small></td>
                                        <td><span class="badge bg-danger">F20.0 Gaduh Gelisah</span></td>
                                        <td>Fiksasi mekanik 4 titik & Haloperidol</td>
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

