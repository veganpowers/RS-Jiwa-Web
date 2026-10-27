<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pendaftaran Pasien Baru - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="pendaftaran" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Penerimaan & Pendaftaran Pasien Baru" />
            <jsp:param name="subtitle" value="Registrasi Pasien Masuk IGD / Bangsal Jiwa dan Alokasi Kamar Perawatan" />
        </jsp:include>

        <% if ("sukses".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Pasien baru berhasil didaftarkan dan dialokasikan ke ruangan!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- FORMULIR REGISTRASI PASIEN BARU -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-user-plus me-2 text-primary"></i> Formulir Pasien Masuk</h6>
                    </div>
                    <div class="card-body">
                        <!-- INTEGRASI: Form action ke PasienServlet?action=insert POST -->
                        <form action="<%= request.getContextPath() %>/PasienServlet?action=insert" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">No. Rekam Medis (Auto/Manual) *</label>
                                <input type="text" name="no_rm" class="form-control" value="RM-2026-0005" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">NIK KTP Pasien (16 Digit) *</label>
                                <input type="text" name="nik" class="form-control" placeholder="Contoh: 3374011205920005" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nama Lengkap Pasien *</label>
                                <input type="text" name="nama_pasien" class="form-control" placeholder="Nama pasien sesuai KTP" required>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Jenis Kelamin *</label>
                                    <select name="jenis_kelamin" class="form-select" required>
                                        <option value="L">Laki-laki</option>
                                        <option value="P">Perempuan</option>
                                    </select>
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Status Rawat *</label>
                                    <select name="status_rawat" class="form-select" required>
                                        <option value="Rawat Inap">Rawat Inap</option>
                                        <option value="Rawat Jalan">Rawat Jalan</option>
                                    </select>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Alokasi Kamar (Jika Rawat Inap) *</label>
                                <select name="nomor_kamar" class="form-select" required>
                                    <option value="">-- Pilih Kamar Tersedia --</option>
                                    <option value="Isolasi A-03">Isolasi A-03 (Kamar Isolasi Khusus - Kosong)</option>
                                    <option value="Bangsal Melati 02">Bangsal Melati 02 (Bangsal Reguler - Kosong)</option>
                                    <option value="Bangsal Melati 03">Bangsal Melati 03 (Bangsal Reguler - Kosong)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Kontak Wali / Keluarga Penanggung Jawab *</label>
                                <input type="text" name="kontak_wali" class="form-control" placeholder="08123456789 (Nama Wali / Hubungan)" required>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2"><i class="fa-solid fa-save me-1"></i> Daftarkan Pasien Masuk</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL DAFTAR PASIEN YANG TERDAFTAR -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-users me-2 text-primary"></i> Pasien Terdaftar Terakhir</h6>
                        <div style="width: 220px;">
                            <input type="text" class="form-control form-control-sm" placeholder="Cari No. RM / Nama...">
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>No. RM</th>
                                        <th>Nama Pasien</th>
                                        <th>Status Rawat</th>
                                        <th>Kamar</th>
                                        <th>Kontak Wali</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <!-- INTEGRASI: SELECT * FROM pasien ORDER BY id_pasien DESC LIMIT 6 -->
                                    <tr>
                                        <td><strong>RM-2026-0001</strong></td>
                                        <td>Bambang Wicaksono (34 Thn / L)</td>
                                        <td><span class="badge bg-danger">Rawat Inap</span></td>
                                        <td>Isolasi A-01</td>
                                        <td>0812-9988-7766</td>
                                    </tr>
                                    <tr>
                                        <td><strong>RM-2026-0002</strong></td>
                                        <td>Siti Aminah (28 Thn / P)</td>
                                        <td><span class="badge bg-danger">Rawat Inap</span></td>
                                        <td>Bangsal Melati 01</td>
                                        <td>0857-1122-3344</td>
                                    </tr>
                                    <tr>
                                        <td><strong>RM-2026-0004</strong></td>
                                        <td>Agus Prasetyo (41 Thn / L)</td>
                                        <td><span class="badge bg-danger">Rawat Inap</span></td>
                                        <td>Isolasi A-02</td>
                                        <td>0813-2233-4455</td>
                                    </tr>
                                    <tr>
                                        <td><strong>RM-2026-0003</strong></td>
                                        <td>Dewi Lestari (32 Thn / P)</td>
                                        <td><span class="badge bg-success">Rawat Jalan</span></td>
                                        <td>-</td>
                                        <td>0821-3344-5566</td>
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
