<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Kamar Pasien - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="kamar" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Update Status Kamar Pasien" />
            <jsp:param name="subtitle" value="Pemindahan dan Penyesuaian Ruang Rawat Pasien (Isolasi / Bangsal)" />
        </jsp:include>

        <div class="row g-4">
            <!-- FORM PINDAH / UPDATE KAMAR -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-door-open me-2 text-primary"></i> Formulir Pindah Kamar</h6>
                    </div>
                    <div class="card-body">
                        <!-- INTEGRASI: Form action ke PerawatServlet?action=pindah_kamar POST -->
                        <form action="<%= request.getContextPath() %>/PerawatServlet?action=pindah_kamar" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien --</option>
                                    <option value="1">Bambang Wicaksono (Saat ini: Isolasi A-01)</option>
                                    <option value="2">Siti Aminah (Saat ini: Bangsal Melati 01)</option>
                                    <option value="4">Agus Prasetyo (Saat ini: Isolasi A-02)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pindah ke Kamar Tujuan *</label>
                                <select name="nomor_kamar_baru" class="form-select" required>
                                    <option value="">-- Pilih Kamar Kosong --</option>
                                    <option value="Isolasi A-03">Isolasi A-03 (Kosong)</option>
                                    <option value="Bangsal Melati 02">Bangsal Melati 02 (Kosong)</option>
                                    <option value="Bangsal Melati 03">Bangsal Melati 03 (Kosong)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Alasan Pemindahan *</label>
                                <select name="alasan" class="form-select" required>
                                    <option value="Kondisi Tenang">Kondisi Tenang / Stabil (Turun ke Bangsal)</option>
                                    <option value="Gaduh Gelisah">Gaduh Gelisah / Agresif (Pindah ke Isolasi)</option>
                                    <option value="Kebutuhan Khusus">Kebutuhan Medis Khusus</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Catatan Perawat</label>
                                <textarea name="catatan" class="form-control" rows="2" placeholder="Catatan kondisi saat perpindahan fisik pasien..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-warning text-dark w-100 fw-bold"><i class="fa-solid fa-shuffle me-1"></i> Update Kamar Pasien</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL STATUS KETERSEDIAAN KAMAR SAAT INI -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-bed me-2 text-primary"></i> Daftar Kamar & Pasien Penghuni</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Nama Kamar</th>
                                        <th>Tipe</th>
                                        <th>Status</th>
                                        <th>Nama Pasien</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- INTEGRASI: SELECT * FROM kamar -->
                                    <tr>
                                        <td><strong>Isolasi A-01</strong></td>
                                        <td>Isolasi Khusus</td>
                                        <td><span class="badge bg-danger">Terisi</span></td>
                                        <td>Bambang Wicaksono</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Isolasi A-02</strong></td>
                                        <td>Isolasi Khusus</td>
                                        <td><span class="badge bg-danger">Terisi</span></td>
                                        <td>Agus Prasetyo</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Isolasi A-03</strong></td>
                                        <td>Isolasi Khusus</td>
                                        <td><span class="badge bg-success">Kosong (Tersedia)</span></td>
                                        <td><em>- Belum Ada -</em></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Bangsal Melati 01</strong></td>
                                        <td>Bangsal Reguler</td>
                                        <td><span class="badge bg-danger">Terisi</span></td>
                                        <td>Siti Aminah</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Bangsal Melati 02</strong></td>
                                        <td>Bangsal Reguler</td>
                                        <td><span class="badge bg-success">Kosong (Tersedia)</span></td>
                                        <td><em>- Belum Ada -</em></td>
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

