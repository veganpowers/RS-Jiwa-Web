<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<%
    String status = request.getParameter("status");
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Resep Obat Pasien - Dokter RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="resep" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Pemberian Resep Obat Jiwa" />
            <jsp:param name="subtitle" value="Peresepan Psikofarmaka untuk Pasien ODGJ Rawat Inap & Rawat Jalan" />
        </jsp:include>

        <% if ("sukses".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Resep obat berhasil dikirim ke Farmasi / Apotek!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- FORM INPUT RESEP -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-file-prescription me-2 text-primary"></i> Buat Resep Baru</h6>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/ResepServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien Penerima --</option>
                                    <jsp:include page="/inc_dropdown_pasien.jsp">
                                        <jsp:param name="rm" value="<%= request.getParameter(\"rm\") %>" />
                                    </jsp:include>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Nama Obat Jiwa *</label>
                                <select name="id_obat" class="form-select" required>
                                    <option value="">-- Pilih Obat dari Master Stok --</option>
                                    <%
                                        Connection connObat = null;
                                        Statement stmtO = null;
                                        ResultSet rsO = null;
                                        try {
                                            connObat = Koneksi.getConnection();
                                            stmtO = connObat.createStatement();
                                            rsO = stmtO.executeQuery("SELECT id_obat, nama_obat, kategori, bentuk_sediaan, stok FROM obat ORDER BY nama_obat ASC");
                                            while (rsO.next()) {
                                                int idO = rsO.getInt("id_obat");
                                                String nmO = rsO.getString("nama_obat");
                                                String kat = rsO.getString("kategori");
                                                String btk = rsO.getString("bentuk_sediaan");
                                                int stok = rsO.getInt("stok");
                                    %>
                                    <option value="<%= idO %>"><%= nmO %> (<%= btk %> - Stok: <%= stok %>)</option>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsO != null) try { rsO.close(); } catch (SQLException ignored) {}
                                            if (stmtO != null) try { stmtO.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connObat);
                                        }
                                    %>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Jumlah (Qty) *</label>
                                <input type="number" name="jumlah" class="form-control" placeholder="Contoh: 10" min="1" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Dosis & Aturan Minum *</label>
                                <input type="text" name="aturan_minum" class="form-control" placeholder="Contoh: 2x1 tablet sesudah makan" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Instruksi Khusus Perawat</label>
                                <textarea name="catatan" class="form-control" rows="2" placeholder="Contoh: Pastikan obat ditelan di depan perawat..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2"><i class="fa-solid fa-paper-plane me-1"></i> Kirim Resep ke Farmasi</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- DAFTAR RESEP TERAKHIR -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Resep yang Baru Dibuat</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Pasien</th>
                                        <th>Obat & Dosis</th>
                                        <th>Jumlah</th>
                                        <th>Status Farmasi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection connRsp = null;
                                        Statement stmtRsp = null;
                                        ResultSet rsRsp = null;
                                        int cRsp = 0;
                                        try {
                                            connRsp = Koneksi.getConnection();
                                            stmtRsp = connRsp.createStatement();
                                            String sqlRsp = "SELECT r.*, p.nama AS nama_pasien, p.no_rekam_medis, o.nama_obat " +
                                                            "FROM resep_obat r " +
                                                            "JOIN pasien p ON r.id_pasien = p.id_pasien " +
                                                            "JOIN obat o ON r.id_obat = o.id_obat " +
                                                            "ORDER BY r.id_resep DESC LIMIT 6";
                                            rsRsp = stmtRsp.executeQuery(sqlRsp);
                                            while (rsRsp.next()) {
                                                cRsp++;
                                                String namaP = rsRsp.getString("nama_pasien");
                                                String nmObat = rsRsp.getString("nama_obat");
                                                String dosis = rsRsp.getString("aturan_pakai");
                                                int jml = rsRsp.getInt("jumlah");
                                                String st = rsRsp.getString("status_tebus");
                                    %>
                                    <tr>
                                        <td><strong><%= namaP %></strong></td>
                                        <td><%= nmObat %><br><small class="text-muted"><%= dosis %></small></td>
                                        <td><%= jml %></td>
                                        <td>
                                            <% if ("Diserahkan".equalsIgnoreCase(st)) { %>
                                                <span class="badge bg-success">Siap / Diserahkan</span>
                                            <% } else { %>
                                                <span class="badge bg-warning text-dark"><%= (st != null ? st : "Menunggu") %></span>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsRsp != null) try { rsRsp.close(); } catch (SQLException ignored) {}
                                            if (stmtRsp != null) try { stmtRsp.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connRsp);
                                        }

                                        if (cRsp == 0) {
                                    %>
                                    <tr><td colspan="4" class="text-center py-4 text-muted">Belum ada resep tercatat.</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
