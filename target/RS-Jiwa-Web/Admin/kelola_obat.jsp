<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Obat & Psikotropika - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="obat" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Master Obat & Stok" />
            <jsp:param name="subtitle" value="Manajemen Data Obat Keras, Antipsikotik, dan Psikotropika (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-pills me-2 text-primary"></i> Master Data Obat Jiwa</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahObat">
                    <i class="fa-solid fa-plus me-1"></i> Tambah Obat Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Kode</th>
                                <th>Nama Obat & Dosis</th>
                                <th>Golongan</th>
                                <th>Stok Fisik</th>
                                <th>Harga Satuan</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM obat ORDER BY id_obat ASC -->
                            <tr>
                                <td><code>OB-001</code></td>
                                <td><strong>Haloperidol 5 mg</strong> (Tablet)</td>
                                <td>Obat Keras</td>
                                <td><span class="badge bg-success">380 Tablet</span></td>
                                <td>Rp 1.500</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editObat('1', 'OB-001', 'Haloperidol 5 mg', 'Obat Keras', '380', '1500')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/ObatServlet?action=delete&id=1" class="btn btn-sm btn-danger" onclick="return confirm('Hapus obat ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td><code>OB-002</code></td>
                                <td><strong>Risperidone 2 mg</strong> (Tablet)</td>
                                <td>Obat Keras</td>
                                <td><span class="badge bg-success">240 Tablet</span></td>
                                <td>Rp 3.500</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editObat('2', 'OB-002', 'Risperidone 2 mg', 'Obat Keras', '240', '3500')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/ObatServlet?action=delete&id=2" class="btn btn-sm btn-danger" onclick="return confirm('Hapus obat ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td><code>OB-004</code></td>
                                <td><strong>Diazepam 10 mg / 2ml</strong> (Injeksi)</td>
                                <td>Psikotropika Gol. IV</td>
                                <td><span class="badge bg-danger">8 Ampul (Kritis)</span></td>
                                <td>Rp 18.000</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editObat('4', 'OB-004', 'Diazepam 10 mg Injeksi', 'Psikotropika Gol. IV', '8', '18000')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/ObatServlet?action=delete&id=4" class="btn btn-sm btn-danger" onclick="return confirm('Hapus obat ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH OBAT -->
<div class="modal fade" id="modalTambahObat" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Obat Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/ObatServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Kode Obat *</label>
                        <input type="text" name="kode_obat" class="form-control" placeholder="Contoh: OB-007" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Obat & Kekuatan *</label>
                        <input type="text" name="nama_obat" class="form-control" placeholder="Contoh: Clozapine 25 mg" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Golongan *</label>
                        <select name="golongan" class="form-select" required>
                            <option value="Obat Keras">Obat Keras</option>
                            <option value="Psikotropika Gol. IV">Psikotropika Golongan IV</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Stok Awal *</label>
                        <input type="number" name="stok" class="form-control" min="0" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Harga Satuan (Rp) *</label>
                        <input type="number" name="harga" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Obat</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT OBAT -->
<div class="modal fade" id="modalEditObat" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Data Obat</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/ObatServlet?action=update" method="POST">
                <input type="hidden" name="id_obat" id="edit_id_obat">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Kode Obat</label>
                        <input type="text" name="kode_obat" id="edit_kode_obat" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Obat *</label>
                        <input type="text" name="nama_obat" id="edit_nama_obat" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Golongan *</label>
                        <select name="golongan" id="edit_golongan" class="form-select" required>
                            <option value="Obat Keras">Obat Keras</option>
                            <option value="Psikotropika Gol. IV">Psikotropika Golongan IV</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Stok Fisik *</label>
                        <input type="number" name="stok" id="edit_stok" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Harga Satuan (Rp) *</label>
                        <input type="number" name="harga" id="edit_harga" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Obat</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editObat(id, kode, nama, golongan, stok, harga) {
        document.getElementById('edit_id_obat').value = id;
        document.getElementById('edit_kode_obat').value = kode;
        document.getElementById('edit_nama_obat').value = nama;
        document.getElementById('edit_golongan').value = golongan;
        document.getElementById('edit_stok').value = stok;
        document.getElementById('edit_harga').value = harga;
        var modal = new bootstrap.Modal(document.getElementById('modalEditObat'));
        modal.show();
    }
</script>
</body>
</html>


