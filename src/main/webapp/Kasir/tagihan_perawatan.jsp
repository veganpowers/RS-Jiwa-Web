<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale, com.rsodgj.config.Koneksi" %>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || (!"kasir".equalsIgnoreCase(currentRole) && !"admin".equalsIgnoreCase(currentRole))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Tagihan Pasien - Kasir RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="tagihan" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Manajemen Tagihan & Invoice" />
            <jsp:param name="subtitle" value="Penerbitan Billing Perawatan, Pelunasan Kasir, & Kwitansi" />
        </jsp:include>

        <% if ("sukses".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Transaksi pembayaran / tagihan berhasil diproses!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-file-invoice-dollar me-2 text-primary"></i> Data Tagihan Perawatan Pasien</h6>
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
                                <th>Nama Pasien & RM</th>
                                <th>Keterangan / Rincian</th>
                                <th>Total Biaya</th>
                                <th>Status Pembayaran</th>
                                <th class="text-center" style="width: 150px;">Aksi Kasir</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection connKas = null;
                                Statement stmtKas = null;
                                ResultSet rsKas = null;
                                int cKas = 0;
                                try {
                                    connKas = Koneksi.getConnection();
                                    stmtKas = connKas.createStatement();
                                    String sqlKas = "SELECT t.*, p.nama AS nama_pasien, p.no_rekam_medis " +
                                                    "FROM tagihan_pembayaran t " +
                                                    "JOIN pasien p ON t.id_pasien = p.id_pasien " +
                                                    "ORDER BY t.id_tagihan DESC";
                                    rsKas = stmtKas.executeQuery(sqlKas);
                                    while (rsKas.next()) {
                                        cKas++;
                                        String noInv = rsKas.getString("kode_tagihan");
                                        String namaP = rsKas.getString("nama_pasien");
                                        String noRm = rsKas.getString("no_rekam_medis");
                                        String rincian = rsKas.getString("keterangan");
                                        double total = rsKas.getDouble("total_akhir");
                                        String stBayar = rsKas.getString("status_pembayaran");
                            %>
                            <tr>
                                <td><strong><%= noInv %></strong></td>
                                <td><%= namaP %><br><small class="text-muted"><%= noRm %></small></td>
                                <td><small><%= (rincian != null) ? rincian : "-" %></small></td>
                                <td><strong><%= nf.format(total).replace("Rp", "Rp ") %></strong></td>
                                <td>
                                    <% if ("Lunas".equalsIgnoreCase(stBayar)) { %>
                                        <span class="badge bg-success">Lunas</span>
                                    <% } else if ("Jaminan BPJS / Dinsos".equalsIgnoreCase(stBayar)) { %>
                                        <span class="badge bg-info text-dark">Jaminan BPJS / Dinsos</span>
                                    <% } else { %>
                                        <span class="badge bg-warning text-dark">Belum Lunas</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <% if ("Belum Lunas".equalsIgnoreCase(stBayar)) { %>
                                        <a href="<%= request.getContextPath() %>/TagihanServlet?action=bayar&no=<%= noInv %>" 
                                           class="btn btn-sm btn-success" 
                                           onclick="return confirm('Konfirmasi pelunasan tagihan <%= noInv %> sebesar <%= nf.format(total) %>?')">
                                            <i class="fa-solid fa-check me-1"></i> Bayar
                                        </a>
                                    <% } else { %>
                                        <button class="btn btn-sm btn-outline-secondary" onclick="window.print()"><i class="fa-solid fa-print me-1"></i> Cetak</button>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsKas != null) try { rsKas.close(); } catch (SQLException ignored) {}
                                    if (stmtKas != null) try { stmtKas.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connKas);
                                }

                                if (cKas == 0) {
                            %>
                            <tr><td colspan="6" class="text-center py-4 text-muted">Belum ada tagihan perawatan yang terdaftar.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Terbitkan Tagihan Baru -->
<div class="modal fade" id="modalTambahTagihan" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Terbitkan Tagihan Pasien Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="<%= request.getContextPath() %>/TagihanServlet?action=insert" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Pilih Pasien *</label>
                        <select name="id_pasien" class="form-select" required>
                            <option value="">-- Pilih Pasien Penerima Billing --</option>
                            <jsp:include page="/inc_dropdown_pasien.jsp" />
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Penjamin Biaya *</label>
                        <select name="penjamin" class="form-select" required>
                            <option value="Umum / Tunai">Umum / Tunai Mandiri</option>
                            <option value="BPJS Kesehatan PBI Jiwa">BPJS Kesehatan PBI Jiwa</option>
                            <option value="BPJS Non-PBI / Mandiri">BPJS Non-PBI / Mandiri</option>
                            <option value="Subsidi Dinsos / Pemda">Subsidi Dinsos / Pemda</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Total Biaya (Rp) *</label>
                        <input type="number" name="total" class="form-control" placeholder="Contoh: 1500000" min="0" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Rincian / Keterangan Tagihan</label>
                        <textarea name="rincian_biaya" class="form-control" rows="2" placeholder="Contoh: Perawatan bangsal 3 hari, obat antipsikotik, dan visit dokter DPJP"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary"><i class="fa-solid fa-save me-1"></i> Simpan & Terbitkan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
