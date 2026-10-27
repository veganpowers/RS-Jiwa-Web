<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Data Pasien - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="pasien" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Data Pasien ODGJ" />
            <jsp:param name="subtitle" value="Data Master Pasien, Pendaftaran Pasien Baru, dan Rekam Identitas (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-bed-pulse me-2 text-primary"></i> Master Data Pasien</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahPasien">
                    <i class="fa-solid fa-user-plus me-1"></i> Pendaftaran Pasien Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. RM</th>
                                <th>Nama Lengkap</th>
                                <th>NIK</th>
                                <th>JK / Usia</th>
                                <th>Status Rawat</th>
                                <th>Kamar</th>
                                <th>Kontak Keluarga</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM pasien ORDER BY id_pasien ASC -->
                            <tr>
                                <td><strong>RM-2026-0001</strong></td>
                                <td>Bambang Wicaksono</td>
                                <td>3374011205920001</td>
                                <td>L / 34 Thn</td>
                                <td><span class="badge bg-danger">Rawat Inap</span></td>
                                <td>Isolasi A-01</td>
                                <td>0812-9988-7766</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editPasien('1', 'RM-2026-0001', 'Bambang Wicaksono', '3374011205920001', 'L', 'Rawat Inap', 'Isolasi A-01', '0812-9988-7766')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/PasienServlet?action=delete&id=1" class="btn btn-sm btn-danger" onclick="return confirm('Hapus pasien ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>RM-2026-0002</strong></td>
                                <td>Siti Aminah</td>
                                <td>3374025508980003</td>
                                <td>P / 28 Thn</td>
                                <td><span class="badge bg-danger">Rawat Inap</span></td>
                                <td>Bangsal Melati 01</td>
                                <td>0857-1122-3344</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editPasien('2', 'RM-2026-0002', 'Siti Aminah', '3374025508980003', 'P', 'Rawat Inap', 'Bangsal Melati 01', '0857-1122-3344')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/PasienServlet?action=delete&id=2" class="btn btn-sm btn-danger" onclick="return confirm('Hapus pasien ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>RM-2026-0003</strong></td>
                                <td>Dewi Lestari</td>
                                <td>3374034401940002</td>
                                <td>P / 32 Thn</td>
                                <td><span class="badge bg-success">Rawat Jalan</span></td>
                                <td>-</td>
                                <td>0821-3344-5566</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editPasien('3', 'RM-2026-0003', 'Dewi Lestari', '3374034401940002', 'P', 'Rawat Jalan', '-', '0821-3344-5566')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/PasienServlet?action=delete&id=3" class="btn btn-sm btn-danger" onclick="return confirm('Hapus pasien ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH PASIEN -->
<div class="modal fade" id="modalTambahPasien" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Pendaftaran Pasien Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/PasienServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">No. Rekam Medis (RM) *</label>
                            <input type="text" name="no_rm" class="form-control" value="RM-2026-0005" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NIK Pasien (16 Digit) *</label>
                            <input type="text" name="nik" class="form-control" placeholder="3374xxxxxxxxxxxx" required>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Nama Lengkap Pasien *</label>
                            <input type="text" name="nama_pasien" class="form-control" placeholder="Nama lengkap sesuai KTP" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Jenis Kelamin *</label>
                            <select name="jenis_kelamin" class="form-select" required>
                                <option value="L">Laki-laki</option>
                                <option value="P">Perempuan</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Status Rawat *</label>
                            <select name="status_rawat" class="form-select" required>
                                <option value="Rawat Inap">Rawat Inap</option>
                                <option value="Rawat Jalan">Rawat Jalan</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Kamar Rawat</label>
                            <input type="text" name="nomor_kamar" class="form-control" placeholder="Contoh: Isolasi A-03 / Bangsal 02">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Kontak Wali / Keluarga *</label>
                            <input type="text" name="kontak_wali" class="form-control" placeholder="08123456789 (Nama Wali)" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Pasien</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT PASIEN -->
<div class="modal fade" id="modalEditPasien" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Data Pasien</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/PasienServlet?action=update" method="POST">
                <input type="hidden" name="id_pasien" id="edit_id_pasien">
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">No. RM</label>
                            <input type="text" name="no_rm" id="edit_no_rm" class="form-control" readonly>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">NIK Pasien *</label>
                            <input type="text" name="nik" id="edit_nik" class="form-control" required>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label fw-semibold">Nama Pasien *</label>
                            <input type="text" name="nama_pasien" id="edit_nama_pasien" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Jenis Kelamin *</label>
                            <select name="jenis_kelamin" id="edit_jenis_kelamin" class="form-select" required>
                                <option value="L">Laki-laki</option>
                                <option value="P">Perempuan</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Status Rawat *</label>
                            <select name="status_rawat" id="edit_status_rawat" class="form-select" required>
                                <option value="Rawat Inap">Rawat Inap</option>
                                <option value="Rawat Jalan">Rawat Jalan</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-semibold">Kamar Rawat</label>
                            <input type="text" name="nomor_kamar" id="edit_nomor_kamar" class="form-control">
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-semibold">Kontak Wali / Keluarga *</label>
                            <input type="text" name="kontak_wali" id="edit_kontak_wali" class="form-control" required>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Pasien</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editPasien(id, noRm, nama, nik, jk, statusRawat, kamar, kontakWali) {
        document.getElementById('edit_id_pasien').value = id;
        document.getElementById('edit_no_rm').value = noRm;
        document.getElementById('edit_nama_pasien').value = nama;
        document.getElementById('edit_nik').value = nik;
        document.getElementById('edit_jenis_kelamin').value = jk;
        document.getElementById('edit_status_rawat').value = statusRawat;
        document.getElementById('edit_nomor_kamar').value = kamar;
        document.getElementById('edit_kontak_wali').value = kontakWali;
        var modal = new bootstrap.Modal(document.getElementById('modalEditPasien'));
        modal.show();
    }
</script>
</body>
</html>

