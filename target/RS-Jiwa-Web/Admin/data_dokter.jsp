<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Data Dokter - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="dokter" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Data Dokter Spesialis" />
            <jsp:param name="subtitle" value="Manajemen Data Master Dokter Psikiatri (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-user-doctor me-2 text-primary"></i> Daftar Dokter Spesialis Jiwa</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahDokter">
                    <i class="fa-solid fa-plus me-1"></i> Tambah Dokter Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No</th>
                                <th>Nama Lengkap & Gelar</th>
                                <th>SIP</th>
                                <th>Spesialisasi</th>
                                <th>No. Handphone</th>
                                <th>Email</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: Loop SELECT * FROM dokter ORDER BY id_dokter ASC -->
                            <tr>
                                <td>1</td>
                                <td><strong>dr. Hendra Pratama, Sp.KJ</strong></td>
                                <td><code>SIP.446/089/DSJ/2022</code></td>
                                <td>Psikiatri Klinis & Dewasa</td>
                                <td>0812-3456-7890</td>
                                <td>hendra.spkj@rsodgj.com</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editDokter('1', 'dr. Hendra Pratama, Sp.KJ', 'SIP.446/089/DSJ/2022', 'Psikiatri Klinis & Dewasa', '0812-3456-7890', 'hendra.spkj@rsodgj.com')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="<%= request.getContextPath() %>/DokterServlet?action=delete&id=1" class="btn btn-sm btn-danger" onclick="return confirm('Hapus dokter ini?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td><strong>dr. Citra Dewi, Sp.KJ</strong></td>
                                <td><code>SIP.446/102/DSJ/2023</code></td>
                                <td>Psikiatri Forensik & Adiksi</td>
                                <td>0813-9876-5432</td>
                                <td>citra.dewi@rsodgj.com</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editDokter('2', 'dr. Citra Dewi, Sp.KJ', 'SIP.446/102/DSJ/2023', 'Psikiatri Forensik & Adiksi', '0813-9876-5432', 'citra.dewi@rsodgj.com')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="<%= request.getContextPath() %>/DokterServlet?action=delete&id=2" class="btn btn-sm btn-danger" onclick="return confirm('Hapus dokter ini?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td><strong>dr. Bambang Soedjarwo, Sp.KJ (K)</strong></td>
                                <td><code>SIP.446/055/DSJ/2019</code></td>
                                <td>Psikiatri Anak & Remaja</td>
                                <td>0811-2233-4455</td>
                                <td>bambang.s@rsodgj.com</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="editDokter('3', 'dr. Bambang Soedjarwo, Sp.KJ (K)', 'SIP.446/055/DSJ/2019', 'Psikiatri Anak & Remaja', '0811-2233-4455', 'bambang.s@rsodgj.com')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="<%= request.getContextPath() %>/DokterServlet?action=delete&id=3" class="btn btn-sm btn-danger" onclick="return confirm('Hapus dokter ini?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH DOKTER -->
<div class="modal fade" id="modalTambahDokter" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Dokter Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/DokterServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Lengkap & Gelar *</label>
                        <input type="text" name="nama_dokter" class="form-control" placeholder="dr. Nama, Sp.KJ" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nomor SIP *</label>
                        <input type="text" name="sip" class="form-control" placeholder="SIP.446/xxx/DSJ/2026" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Spesialisasi *</label>
                        <input type="text" name="spesialisasi" class="form-control" placeholder="Contoh: Psikiatri Klinis Dewasa" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">No. HP / WhatsApp *</label>
                        <input type="text" name="no_telp" class="form-control" placeholder="08123456789" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email</label>
                        <input type="email" name="email" class="form-control" placeholder="dokter@rsodgj.com">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Dokter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT DOKTER -->
<div class="modal fade" id="modalEditDokter" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Data Dokter</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/DokterServlet?action=update" method="POST">
                <input type="hidden" name="id_dokter" id="edit_id_dokter">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Lengkap & Gelar *</label>
                        <input type="text" name="nama_dokter" id="edit_nama_dokter" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nomor SIP *</label>
                        <input type="text" name="sip" id="edit_sip" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Spesialisasi *</label>
                        <input type="text" name="spesialisasi" id="edit_spesialisasi" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">No. HP / WhatsApp *</label>
                        <input type="text" name="no_telp" id="edit_no_telp" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Email</label>
                        <input type="email" name="email" id="edit_email" class="form-control">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Dokter</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editDokter(id, nama, sip, spesialisasi, noTelp, email) {
        document.getElementById('edit_id_dokter').value = id;
        document.getElementById('edit_nama_dokter').value = nama;
        document.getElementById('edit_sip').value = sip;
        document.getElementById('edit_spesialisasi').value = spesialisasi;
        document.getElementById('edit_no_telp').value = noTelp;
        document.getElementById('edit_email').value = email;
        var modal = new bootstrap.Modal(document.getElementById('modalEditDokter'));
        modal.show();
    }
</script>
</body>
</html>

