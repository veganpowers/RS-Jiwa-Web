<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tagihan Perawatan Pasien - Kasir RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="tagihan" /></jsp:include>
    <div class="flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Tagihan Perawatan Pasien" />
            <jsp:param name="subtitle" value="Pencatatan dan Pembayaran Invoice Pasien (CRUD)" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-file-invoice-dollar me-2 text-primary"></i> Daftar Tagihan Pasien</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahTagihan">
                    <i class="fa-solid fa-plus me-1"></i> Buat Tagihan Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. Invoice</th>
                                <th>Nama Pasien & RM</th>
                                <th>Penjamin</th>
                                <th>Rincian Biaya</th>
                                <th>Total (Rp)</th>
                                <th>Status</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- INTEGRASI: SELECT * FROM tagihan_pembayaran JOIN pasien ... -->
                            <tr>
                                <td><strong>#INV-2026-043</strong></td>
                                <td>Bambang Wicaksono<br><small class="text-muted">RM-2026-0001</small></td>
                                <td>Umum / Tunai</td>
                                <td>Kamar Isolasi (4 hr) + Tindakan Medis + Obat</td>
                                <td><strong>Rp 3.800.000</strong></td>
                                <td><span class="badge bg-warning text-dark">Belum Bayar</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-success" onclick="if(confirm('Proses pelunasan tagihan ini?')) alert('Tagihan berhasil dilunasi!')">
                                        <i class="fa-solid fa-check"></i> Bayar
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td><strong>#INV-2026-042</strong></td>
                                <td>Siti Aminah<br><small class="text-muted">RM-2026-0002</small></td>
                                <td>BPJS PBI Jiwa</td>
                                <td>Bangsal Melati (8 hr) + Obat Risperidone</td>
                                <td><strong>Rp 4.250.000</strong></td>
                                <td><span class="badge bg-success">Lunas (BPJS)</span></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-secondary" onclick="window.print()"><i class="fa-solid fa-print"></i> Cetak</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL BUAT TAGIHAN BARU (LENGKAP DENGAN INPUT RINCIAN BIAYA) -->
<div class="modal fade" id="modalTambahTagihan" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Buat Tagihan Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <!-- INTEGRASI: Form action ke KasirServlet?action=simpan_tagihan POST -->
            <form action="<%= request.getContextPath() %>/KasirServlet?action=simpan_tagihan" method="POST">
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
                        <label class="form-label fw-semibold">Metode Pembayaran / Penjamin *</label>
                        <select name="penjamin" class="form-select" required>
                            <option value="Umum / Tunai">Umum / Tunai</option>
                            <option value="BPJS Kesehatan">BPJS Kesehatan</option>
                            <option value="Dinas Sosial">Dinas Sosial</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Rincian Biaya Perawatan *</label>
                        <textarea name="rincian_biaya" class="form-control" rows="3" placeholder="Contoh: Kamar Isolasi (4 hr) + Tindakan Medis + Obat Farmasi" required></textarea>
                        <small class="text-muted" style="font-size: 11.5px;">Masukkan komponen perawatan pasien (sewa kamar, obat, atau visit dokter).</small>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Total Biaya Perawatan (Rp) *</label>
                        <input type="number" name="total_biaya" class="form-control" placeholder="Contoh: 1500000" min="0" required>
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
