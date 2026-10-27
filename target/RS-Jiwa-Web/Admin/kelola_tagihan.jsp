<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Tagihan - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="tagihan" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Tagihan & Keuangan Pasien" />
            <jsp:param name="subtitle" value="Pencatatan Invoice Pembayaran Perawatan Pasien (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-file-invoice-dollar me-2 text-primary"></i> Data Master Tagihan Pasien</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahTagihan">
                    <i class="fa-solid fa-plus me-1"></i> Terbitkan Tagihan Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. Invoice</th>
                                <th>Nama Pasien</th>
                                <th>Penjamin</th>
                                <th>Rincian Biaya</th>
                                <th>Total Biaya</th>
                                <th>Status</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM tagihan_pembayaran JOIN pasien ... -->
                            <tr>
                                <td><strong>#INV-2026-043</strong></td>
                                <td>Bambang Wicaksono</td>
                                <td>Umum / Tunai</td>
                                <td>Kamar Isolasi (4 hr) + Tindakan Medis + Obat</td>
                                <td><strong>Rp 3.800.000</strong></td>
                                <td><span class="badge bg-warning text-dark">Belum Lunas</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-success" onclick="if(confirm('Ubah status tagihan ini menjadi Lunas?')) alert('Status berhasil diperbarui!')"><i class="fa-solid fa-check"></i></button>
                                    <button class="btn btn-sm btn-danger" onclick="if(confirm('Hapus tagihan ini?')) alert('Tagihan dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#INV-2026-042</strong></td>
                                <td>Siti Aminah</td>
                                <td>BPJS PBI Jiwa</td>
                                <td>Bangsal Melati (8 hr) + Farmasi Obat</td>
                                <td><strong>Rp 4.250.000</strong></td>
                                <td><span class="badge bg-success">Lunas</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-secondary" onclick="window.print()"><i class="fa-solid fa-print"></i></button>
                                    <button class="btn btn-sm btn-danger" onclick="if(confirm('Hapus tagihan ini?')) alert('Tagihan dihapus!')"><i class="fa-solid fa-trash"></i></button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH TAGIHAN (LENGKAP DENGAN RINCIAN BIAYA) -->
<div class="modal fade" id="modalTambahTagihan" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Terbitkan Tagihan Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <!-- INTEGRASI: Form action ke TagihanServlet?action=insert POST -->
            <form action="<%= request.getContextPath() %>/TagihanServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Pilih Pasien *</label>
                        <select name="id_pasien" class="form-select" required>
                            <option value="">-- Pilih Pasien --</option>
                            <option value="1">RM-2026-0001 - Bambang Wicaksono</option>
                            <option value="2">RM-2026-0002 - Siti Aminah</option>
                            <option value="4">RM-2026-0004 - Agus Prasetyo</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Penjamin / Cara Bayar *</label>
                        <select name="penjamin" class="form-select" required>
                            <option value="Umum / Tunai">Umum / Tunai</option>
                            <option value="BPJS Kesehatan">BPJS Kesehatan</option>
                            <option value="Dinas Sosial">Dinas Sosial</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Rincian Biaya Perawatan *</label>
                        <textarea name="rincian_biaya" class="form-control" rows="3" placeholder="Contoh: Sewa kamar 5 hari, visit dokter, terapi TAK, resep obat..." required></textarea>
                        <small class="text-muted" style="font-size: 11.5px;">Tuliskan item layanan yang ditagihkan kepada pasien.</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Total Tagihan (Rp) *</label>
                        <input type="number" name="total" class="form-control" placeholder="Contoh: 2500000" min="0" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save me-1"></i> Simpan Tagihan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
