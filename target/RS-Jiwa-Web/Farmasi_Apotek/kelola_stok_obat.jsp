<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Stok Obat - Farmasi RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    <style>body { min-height: 100vh; background-color: #f8f9fa; }</style>
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="stok" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Stok Obat Jiwa" />
            <jsp:param name="subtitle" value="Data Master Obat dan Pembaruan Jumlah Stok Fisik (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-boxes-stacked me-2 text-primary"></i> Master Data Obat</h6>
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
                                <th>Nama Obat & Sediaan</th>
                                <th>Golongan</th>
                                <th>Stok Fisik</th>
                                <th>Harga Satuan</th>
                                <th class="text-center" style="width: 160px;">Aksi</th>
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
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="tambahStok('OB-001', 'Haloperidol 5 mg')"><i class="fa-solid fa-plus"></i> Stok</button>
                                </td>
                            </tr>
                            <tr>
                                <td><code>OB-002</code></td>
                                <td><strong>Risperidone 2 mg</strong> (Tablet)</td>
                                <td>Obat Keras</td>
                                <td><span class="badge bg-success">240 Tablet</span></td>
                                <td>Rp 3.500</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="tambahStok('OB-002', 'Risperidone 2 mg')"><i class="fa-solid fa-plus"></i> Stok</button>
                                </td>
                            </tr>
                            <tr>
                                <td><code>OB-004</code></td>
                                <td><strong>Diazepam 10 mg / 2ml</strong> (Injeksi)</td>
                                <td>Psikotropika Gol. IV</td>
                                <td><span class="badge bg-danger">8 Ampul (Kritis)</span></td>
                                <td>Rp 18.000</td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" onclick="tambahStok('OB-004', 'Diazepam Injeksi')"><i class="fa-solid fa-plus"></i> Stok</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH OBAT BARU -->
<div class="modal fade" id="modalTambahObat" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Obat Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/FarmasiServlet?action=tambah_obat" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Kode Obat *</label>
                        <input type="text" name="kode_obat" class="form-control" placeholder="Contoh: OB-006" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Nama Obat & Kekuatan *</label>
                        <input type="text" name="nama_obat" class="form-control" placeholder="Contoh: Clozapine 25 mg" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Golongan *</label>
                        <select name="golongan" class="form-select" required>
                            <option value="Obat Keras">Obat Keras</option>
                            <option value="Psikotropika Gol. IV">Psikotropika Gol. IV</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Jumlah Stok Awal *</label>
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function tambahStok(kode, nama) {
        var tambah = prompt("Masukkan jumlah penambahan stok untuk " + nama + ":", "50");
        if(tambah) {
            alert("Stok " + nama + " berhasil ditambahkan sebanyak " + tambah + "!");
        }
    }
</script>
</body>
</html>

