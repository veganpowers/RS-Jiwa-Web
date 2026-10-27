<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catatan Harian Pasien (TTV) - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="pantau" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Catatan Harian & Tanda Vital (TTV)" />
            <jsp:param name="subtitle" value="Input Tensi, Suhu Tubuh, dan Observasi Perilaku Pasien ODGJ" />
        </jsp:include>

        <div class="row g-4">
            <!-- FORM INPUT TTV DASAR -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-file-medical me-2 text-primary"></i> Formulir Observasi Pasien</h6>
                    </div>
                    <div class="card-body">
                        <!-- INTEGRASI: Form action ke PerawatServlet?action=simpan_ttv POST -->
                        <form action="<%= request.getContextPath() %>/PerawatServlet?action=simpan_ttv" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien Rawat --</option>
                                    <option value="1">RM-2026-0001 - Bambang Wicaksono (Isolasi A-01)</option>
                                    <option value="2">RM-2026-0002 - Siti Aminah (Bangsal Melati 01)</option>
                                    <option value="4">RM-2026-0004 - Agus Prasetyo (Isolasi A-02)</option>
                                </select>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Tekanan Darah *</label>
                                    <input type="text" name="tensi" class="form-control" placeholder="Contoh: 120/80" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Suhu Tubuh (&deg;C) *</label>
                                    <input type="text" name="suhu" class="form-control" placeholder="Contoh: 36.5" required>
                                </div>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Nadi (bpm)</label>
                                    <input type="number" name="nadi" class="form-control" placeholder="Contoh: 80">
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Pernapasan (x/mnt)</label>
                                    <input type="number" name="respirasi" class="form-control" placeholder="Contoh: 18">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Keterangan Observasi Perilaku Pasien *</label>
                                <textarea name="catatan_perilaku" class="form-control" rows="3" placeholder="Contoh: Pasien tampak tenang, mau diajak makan siang, tidak ada tanda-tanda mengamuk..." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary w-100"><i class="fa-solid fa-save me-1"></i> Simpan Catatan Harian</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL CATATAN HARIAN TERBARU -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-list me-2 text-primary"></i> Data Observasi Harian Pasien</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Waktu</th>
                                        <th>Pasien</th>
                                        <th>TTV (TD/Suhu)</th>
                                        <th>Catatan Perilaku</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- INTEGRASI: SELECT * FROM pantau_kondisi ORDER BY tanggal DESC LIMIT 5 -->
                                    <tr>
                                        <td>26/10 08:00</td>
                                        <td><strong>Bambang W.</strong><br><small class="text-muted">Isolasi A-01</small></td>
                                        <td>130/85 mmHg<br><small class="text-muted">36.7 &deg;C</small></td>
                                        <td>Mulai kooperatif, sudah bersedia minum obat oral</td>
                                    </tr>
                                    <tr>
                                        <td>26/10 08:30</td>
                                        <td><strong>Siti Aminah</strong><br><small class="text-muted">Bangsal 01</small></td>
                                        <td>115/75 mmHg<br><small class="text-muted">36.4 &deg;C</small></td>
                                        <td>Mampu berkomunikasi dengan perawat, kontak mata baik</td>
                                    </tr>
                                    <tr>
                                        <td>26/10 07:15</td>
                                        <td><strong>Agus Prasetyo</strong><br><small class="text-muted">Isolasi A-02</small></td>
                                        <td>140/90 mmHg<br><small class="text-muted">37.1 &deg;C</small></td>
                                        <td>Tidur pulas pasca injeksi sedasi Diazepam</td>
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

