<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Akun Pengguna - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="user" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Akun Pengguna Sistem" />
            <jsp:param name="subtitle" value="Manajemen Hak Akses Login untuk Dokter, Perawat, Farmasi, Kasir, dan Keluarga (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-users-gear me-2 text-primary"></i> Master Data Akun Pengguna (Users)</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahUser">
                    <i class="fa-solid fa-user-plus me-1"></i> Tambah Akun Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No</th>
                                <th>Username</th>
                                <th>Nama Lengkap</th>
                                <th>Role / Hak Akses</th>
                                <th>Status Akun</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM users ORDER BY id_user ASC -->
                            <tr>
                                <td>1</td>
                                <td><strong>admin</strong></td>
                                <td>Administrator Utama</td>
                                <td><span class="badge bg-dark">admin</span></td>
                                <td><span class="badge bg-success">Aktif</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="alert('Ubah password untuk admin')"><i class="fa-solid fa-key"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td><strong>dokter1</strong></td>
                                <td>dr. Hendra Pratama, Sp.KJ</td>
                                <td><span class="badge bg-primary">dokter</span></td>
                                <td><span class="badge bg-success">Aktif</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="alert('Ubah password untuk dokter1')"><i class="fa-solid fa-key"></i></button>
                                    <button class="btn btn-sm btn-danger" onclick="if(confirm('Hapus akun ini?')) alert('Akun dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td><strong>perawat1</strong></td>
                                <td>Ns. Siti Rahma, S.Kep</td>
                                <td><span class="badge bg-info text-dark">perawat</span></td>
                                <td><span class="badge bg-success">Aktif</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="alert('Ubah password untuk perawat1')"><i class="fa-solid fa-key"></i></button>
                                    <button class="btn btn-sm btn-danger" onclick="if(confirm('Hapus akun ini?')) alert('Akun dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td><strong>farmasi1</strong></td>
                                <td>Apt. Faisal Anwar, S.Farm</td>
                                <td><span class="badge bg-success">farmasi</span></td>
                                <td><span class="badge bg-success">Aktif</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="alert('Ubah password untuk farmasi1')"><i class="fa-solid fa-key"></i></button>
                                    <button class="btn btn-sm btn-danger" onclick="if(confirm('Hapus akun ini?')) alert('Akun dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td><strong>kasir1</strong></td>
                                <td>Budi Prasetyo, S.E.</td>
                                <td><span class="badge bg-secondary">kasir</span></td>
                                <td><span class="badge bg-success">Aktif</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="alert('Ubah password untuk kasir1')"><i class="fa-solid fa-key"></i></button>
                                    <button class="btn btn-sm btn-danger" onclick="if(confirm('Hapus akun ini?')) alert('Akun dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>6</td>
                                <td><strong>keluarga1</strong></td>
                                <td>Ibu Ratna Susanti</td>
                                <td><span class="badge bg-warning text-dark">keluarga</span></td>
                                <td><span class="badge bg-success">Aktif</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="alert('Ubah password untuk keluarga1')"><i class="fa-solid fa-key"></i></button>
                                    <button class="btn btn-sm btn-danger" onclick="if(confirm('Hapus akun ini?')) alert('Akun dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH USER -->
<div class="modal fade" id="modalTambahUser" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Akun Pengguna Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/UserServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Username Login *</label>
                        <input type="text" name="username" class="form-control" placeholder="Contoh: dokter_ahmad" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Password Default *</label>
                        <input type="password" name="password" class="form-control" placeholder="Minimal 6 karakter" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Lengkap Pemilik Akun *</label>
                        <input type="text" name="nama_lengkap" class="form-control" placeholder="Nama pengguna" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Role / Hak Akses *</label>
                        <select name="role" class="form-select" required>
                            <option value="dokter">Dokter Spesialis Jiwa</option>
                            <option value="perawat">Perawat / Ners</option>
                            <option value="farmasi">Petugas Farmasi / Apotek</option>
                            <option value="kasir">Petugas Kasir / Pembayaran</option>
                            <option value="keluarga">Keluarga Pasien</option>
                            <option value="admin">Administrator</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Akun</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>


