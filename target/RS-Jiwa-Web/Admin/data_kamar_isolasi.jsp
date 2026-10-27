<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Kamar Perawatan - Admin RS ODGJ</title>
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
            <jsp:param name="title" value="Kelola Kamar Perawatan" />
            <jsp:param name="subtitle" value="Manajemen Status Ketersediaan Kamar Rawat Inap & Isolasi (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-door-closed me-2 text-primary"></i> Data Master Kamar & Status Ketersediaan</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahKamar">
                    <i class="fa-solid fa-plus me-1"></i> Tambah Kamar Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width: 50px;">No</th>
                                <th>Nomor / Nama Kamar</th>
                                <th>Jenis / Tipe Kamar</th>
                                <th>Status Kamar</th>
                                <th>Pasien yang Menempati</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM kamar ORDER BY id_kamar ASC -->
                            <tr>
                                <td>1</td>
                                <td><strong>Isolasi A-01</strong></td>
                                <td>Kamar Isolasi Khusus</td>
                                <td><span class="badge bg-danger">Terisi</span></td>
                                <td>Bambang Wicaksono (RM-2026-0001)</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editKamar('1', 'Isolasi A-01', 'Kamar Isolasi Khusus', 'Terisi')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/KamarServlet?action=delete&id=1" class="btn btn-sm btn-danger" onclick="return confirm('Hapus kamar ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td><strong>Isolasi A-02</strong></td>
                                <td>Kamar Isolasi Khusus</td>
                                <td><span class="badge bg-danger">Terisi</span></td>
                                <td>Agus Prasetyo (RM-2026-0004)</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editKamar('2', 'Isolasi A-02', 'Kamar Isolasi Khusus', 'Terisi')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/KamarServlet?action=delete&id=2" class="btn btn-sm btn-danger" onclick="return confirm('Hapus kamar ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td><strong>Isolasi A-03</strong></td>
                                <td>Kamar Isolasi Khusus</td>
                                <td><span class="badge bg-success">Kosong (Tersedia)</span></td>
                                <td><em>- Belum Terisi -</em></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editKamar('3', 'Isolasi A-03', 'Kamar Isolasi Khusus', 'Kosong')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/KamarServlet?action=delete&id=3" class="btn btn-sm btn-danger" onclick="return confirm('Hapus kamar ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td><strong>Bangsal Melati 01</strong></td>
                                <td>Bangsal Reguler</td>
                                <td><span class="badge bg-danger">Terisi</span></td>
                                <td>Siti Aminah (RM-2026-0002)</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editKamar('4', 'Bangsal Melati 01', 'Bangsal Reguler', 'Terisi')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/KamarServlet?action=delete&id=4" class="btn btn-sm btn-danger" onclick="return confirm('Hapus kamar ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td><strong>Bangsal Melati 02</strong></td>
                                <td>Bangsal Reguler</td>
                                <td><span class="badge bg-success">Kosong (Tersedia)</span></td>
                                <td><em>- Belum Terisi -</em></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editKamar('5', 'Bangsal Melati 02', 'Bangsal Reguler', 'Kosong')"><i class="fa-solid fa-pen-to-square"></i></button>
                                    <a href="<%= request.getContextPath() %>/KamarServlet?action=delete&id=5" class="btn btn-sm btn-danger" onclick="return confirm('Hapus kamar ini?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH KAMAR -->
<div class="modal fade" id="modalTambahKamar" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Kamar Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/KamarServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nomor / Nama Kamar *</label>
                        <input type="text" name="nomor_kamar" class="form-control" placeholder="Contoh: Bangsal Melati 03" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tipe Kamar *</label>
                        <select name="tipe_kamar" class="form-select" required>
                            <option value="Bangsal Reguler">Bangsal Reguler</option>
                            <option value="Kamar Isolasi Khusus">Kamar Isolasi Khusus</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Status Awal *</label>
                        <select name="status" class="form-select" required>
                            <option value="Kosong">Kosong (Tersedia)</option>
                            <option value="Terisi">Terisi</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Kamar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT KAMAR -->
<div class="modal fade" id="modalEditKamar" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Status Kamar</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/KamarServlet?action=update" method="POST">
                <input type="hidden" name="id_kamar" id="edit_id_kamar">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nomor / Nama Kamar</label>
                        <input type="text" name="nomor_kamar" id="edit_nomor_kamar" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Tipe Kamar</label>
                        <select name="tipe_kamar" id="edit_tipe_kamar" class="form-select" required>
                            <option value="Bangsal Reguler">Bangsal Reguler</option>
                            <option value="Kamar Isolasi Khusus">Kamar Isolasi Khusus</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Status Kamar *</label>
                        <select name="status" id="edit_status" class="form-select" required>
                            <option value="Kosong">Kosong (Tersedia)</option>
                            <option value="Terisi">Terisi</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Kamar</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editKamar(id, noKamar, tipe, status) {
        document.getElementById('edit_id_kamar').value = id;
        document.getElementById('edit_nomor_kamar').value = noKamar;
        document.getElementById('edit_tipe_kamar').value = tipe;
        document.getElementById('edit_status').value = status;
        var modal = new bootstrap.Modal(document.getElementById('modalEditKamar'));
        modal.show();
    }
</script>
</body>
</html>

