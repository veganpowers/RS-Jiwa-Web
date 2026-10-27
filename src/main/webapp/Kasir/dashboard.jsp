<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale, com.rsodgj.config.Koneksi" %>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || (!"kasir".equalsIgnoreCase(currentRole) && !"admin".equalsIgnoreCase(currentRole))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    double totalPenerimaan = 0;
    int menungguBayar = 0;

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        stmt = conn.createStatement();

        rs = stmt.executeQuery("SELECT SUM(total_akhir) FROM tagihan_pembayaran WHERE status_pembayaran = 'Lunas'");
        if (rs.next()) totalPenerimaan = rs.getDouble(1);
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM tagihan_pembayaran WHERE status_pembayaran = 'Belum Lunas'");
        if (rs.next()) menungguBayar = rs.getInt(1);
        rs.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    NumberFormat nf = NumberFormat.getCurrencyInstance(new Locale("id", "ID"));
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Kasir - RS Khusus ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="dashboard" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Dashboard Kasir & Pembayaran" />
            <jsp:param name="subtitle" value="Penerimaan Kas Rawat Inap & Jalan RS ODGJ" />
        </jsp:include>

        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-success bg-opacity-10 text-success rounded-3 me-3"><i class="fa-solid fa-money-bill-wave fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL PENERIMAAN LUNAS</small>
                            <h3 class="fw-bold mb-0"><%= nf.format(totalPenerimaan).replace("Rp", "Rp ") %></h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 me-3"><i class="fa-solid fa-file-invoice fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TAGIHAN MENUNGGU BAYAR</small>
                            <h3 class="fw-bold mb-0"><%= menungguBayar %> Tagihan</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-receipt me-2 text-primary"></i> Tagihan Pasien Terkini</h6>
                <a href="tagihan_perawatan.jsp" class="btn btn-sm btn-primary">Kelola Semua Tagihan</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. Invoice</th>
                                <th>Nama Pasien</th>
                                <th>Keterangan</th>
                                <th>Total Biaya</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int cDash = 0;
                                try {
                                    String sql = "SELECT t.*, p.nama AS nama_pasien FROM tagihan_pembayaran t " +
                                                 "JOIN pasien p ON t.id_pasien = p.id_pasien ORDER BY t.id_tagihan DESC LIMIT 5";
                                    rs = stmt.executeQuery(sql);
                                    while (rs.next()) {
                                        cDash++;
                                        String noInv = rs.getString("kode_tagihan");
                                        String namaP = rs.getString("nama_pasien");
                                        String ket = rs.getString("keterangan");
                                        double total = rs.getDouble("total_akhir");
                                        String st = rs.getString("status_pembayaran");
                            %>
                            <tr>
                                <td><strong><%= noInv %></strong></td>
                                <td><%= namaP %></td>
                                <td><small><%= ket != null ? ket : "-" %></small></td>
                                <td><%= nf.format(total).replace("Rp", "Rp ") %></td>
                                <td>
                                    <% if ("Lunas".equalsIgnoreCase(st)) { %>
                                        <span class="badge bg-success">Lunas</span>
                                    <% } else if ("Jaminan BPJS / Dinsos".equalsIgnoreCase(st)) { %>
                                        <span class="badge bg-info text-dark">Jaminan BPJS</span>
                                    <% } else { %>
                                        <span class="badge bg-warning text-dark">Belum Lunas</span>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(conn);
                                }

                                if (cDash == 0) {
                            %>
                            <tr><td colspan="5" class="text-center py-4 text-muted">Belum ada transaksi pembayaran.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
