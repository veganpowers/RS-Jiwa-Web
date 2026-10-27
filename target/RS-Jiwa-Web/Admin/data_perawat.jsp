<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Data Perawat - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="perawat" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Data Perawat / Ners" />
            <jsp:param name="subtitle" value="Manajemen Data Master Tim Keperawatan Jiwa (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-user-nurse me-2 text-primary"></i> Daftar Perawat / Ners Bangsal</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahPerawat">
                    <i class="fa-solid fa-plus me-1"></i> Tambah Perawat Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No</th>
                                <th>Nama Lengkap</th>
                                <th>NIRA / SIP</th>
                                <th>Ruangan Penempatan</th>
                                <th>No. Handphone</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM perawat ORDER BY id_perawat ASC -->
                            <tr>
                                <td>1</td>
                                <td><strong>Ns. Siti Rahma, S.Kep</strong></td>
                                <td>NIRA-3374-00129</td>
                                <td>Ruang Isolasi Krisis & IGD Jiwa</td>
                                <td>0852-3344-5566</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editPerawat('1', 'Ns. Siti Rahma, S.Kep', 'NIRA-3374-00129', 'Ruang Isolasi Krisis & IGD Jiwa', '0852-3344-5566')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/PerawatAdminServlet?action=delete&id=1" class="btn btn-sm btn-danger" onclick="return confirm('Hapus perawat ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td><strong>Ns. Doni Pratama, S.Kep</strong></td>
                                <td>NIRA-3374-00135</td>
                                <td>Bangsal Melati (Reguler)</td>
                                <td>0819-8877-6655</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editPerawat('2', 'Ns. Doni Pratama, S.Kep', 'NIRA-3374-00135', 'Bangsal Melati (Reguler)', '0819-8877-6655')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/PerawatAdminServlet?action=delete&id=2" class="btn btn-sm btn-danger" onclick="return confirm('Hapus perawat ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH PERAWAT -->
<div class="modal fade" id="modalTambahPerawat" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Perawat Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/PerawatAdminServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Lengkap & Gelar *</label>
                        <input type="text" name="nama_perawat" class="form-control" placeholder="Ns. Nama, S.Kep" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">NIRA / Nomor Registrasi *</label>
                        <input type="text" name="nira" class="form-control" placeholder="NIRA-3374-xxxxx" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ruangan Penempatan *</label>
                        <select name="ruangan" class="form-select" required>
                            <option value="Bangsal Melati (Reguler)">Bangsal Melati (Reguler)</option>
                            <option value="Ruang Isolasi Krisis & IGD Jiwa">Ruang Isolasi Krisis & IGD Jiwa</option>
                            <option value="Poli Rawat Jalan Jiwa">Poli Rawat Jalan Jiwa</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">No. Handphone / WA *</label>
                        <input type="text" name="no_telp" class="form-control" placeholder="08123456789" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Perawat</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT PERAWAT -->
<div class="modal fade" id="modalEditPerawat" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Data Perawat</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/PerawatAdminServlet?action=update" method="POST">
                <input type="hidden" name="id_perawat" id="edit_id_perawat">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Lengkap & Gelar *</label>
                        <input type="text" name="nama_perawat" id="edit_nama_perawat" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">NIRA / Nomor Registrasi *</label>
                        <input type="text" name="nira" id="edit_nira" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ruangan Penempatan *</label>
                        <select name="ruangan" id="edit_ruangan" class="form-select" required>
                            <option value="Bangsal Melati (Reguler)">Bangsal Melati (Reguler)</option>
                            <option value="Ruang Isolasi Krisis & IGD Jiwa">Ruang Isolasi Krisis & IGD Jiwa</option>
                            <option value="Poli Rawat Jalan Jiwa">Poli Rawat Jalan Jiwa</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">No. Handphone / WA *</label>
                        <input type="text" name="no_telp" id="edit_no_telp" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Perawat</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editPerawat(id, nama, nira, ruangan, noTelp) {
        document.getElementById('edit_id_perawat').value = id;
        document.getElementById('edit_nama_perawat').value = nama;
        document.getElementById('edit_nira').value = nira;
        document.getElementById('edit_ruangan').value = ruangan;
        document.getElementById('edit_no_telp').value = noTelp;
        var modal = new bootstrap.Modal(document.getElementById('modalEditPerawat'));
        modal.show();
    }
</script>
</body>
</html>

