<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.rsodgj.config.Koneksi" %>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || !"farmasi".equalsIgnoreCase(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String action = request.getParameter("action");
    if ("tambah_stok".equalsIgnoreCase(action)) {
        String idObatStr = request.getParameter("id_obat");
        String jumlahStr = request.getParameter("jumlah");
        if (idObatStr != null && jumlahStr != null) {
            Connection connU = null;
            PreparedStatement stmtU = null;
            try {
                connU = Koneksi.getConnection();
                stmtU = connU.prepareStatement("UPDATE obat SET stok = stok + ? WHERE id_obat = ?");
                stmtU.setInt(1, Integer.parseInt(jumlahStr.trim()));
                stmtU.setInt(2, Integer.parseInt(idObatStr.trim()));
                stmtU.executeUpdate();
                response.sendRedirect("kelola_stok_obat.jsp?status=sukses");
                return;
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (stmtU != null) try { stmtU.close(); } catch (SQLException ignored) {}
                Koneksi.closeConnection(connU);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Stok Obat Jiwa - Farmasi RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="stok" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Katalog & Stok Fisik Obat" />
            <jsp:param name="subtitle" value="Manajemen Inventaris Obat Psikofarmaka dan Kebutuhan Bangsal" />
        </jsp:include>

        <% if ("sukses".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Stok obat berhasil diperbarui!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-boxes-stacked me-2 text-primary"></i> Data Stok Fisik Obat</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Kode</th>
                                <th>Nama Obat & Dosis</th>
                                <th>Kategori</th>
                                <th>Bentuk Sediaan</th>
                                <th>Stok Fisik</th>
                                <th>Harga Satuan</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection conn = null;
                                Statement stmt = null;
                                ResultSet rs = null;
                                int count = 0;
                                try {
                                    conn = Koneksi.getConnection();
                                    stmt = conn.createStatement();
                                    rs = stmt.executeQuery("SELECT * FROM obat ORDER BY id_obat ASC");
                                    while (rs.next()) {
                                        count++;
                                        int idObat = rs.getInt("id_obat");
                                        String kode = rs.getString("kode_obat");
                                        String nama = rs.getString("nama_obat");
                                        String dosis = rs.getString("dosis");
                                        String kategori = rs.getString("kategori");
                                        String sediaan = rs.getString("bentuk_sediaan");
                                        int stok = rs.getInt("stok");
                                        String satuan = rs.getString("satuan");
                                        double harga = rs.getDouble("harga");
                            %>
                            <tr>
                                <td><code><%= kode %></code></td>
                                <td>
                                    <strong><%= nama %></strong>
                                    <% if (dosis != null && !dosis.isEmpty()) { %>
                                        <small class="text-muted">(<%= dosis %>)</small>
                                    <% } %>
                                </td>
                                <td><span class="badge bg-secondary"><%= kategori %></span></td>
                                <td><%= sediaan %></td>
                                <td>
                                    <% if (stok <= 10) { %>
                                        <span class="badge bg-danger"><%= stok %> <%= satuan %> (Kritis)</span>
                                    <% } else if (stok <= 30) { %>
                                        <span class="badge bg-warning text-dark"><%= stok %> <%= satuan %> (Menipis)</span>
                                    <% } else { %>
                                        <span class="badge bg-success"><%= stok %> <%= satuan %></span>
                                    <% } %>
                                </td>
                                <td>Rp <%= String.format("%,.0f", harga) %></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-outline-primary" 
                                            onclick="openTambahStok(<%= idObat %>, '<%= nama %>')">
                                        <i class="fa-solid fa-plus me-1"></i> Tambah
                                    </button>
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

                                if (count == 0) {
                            %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">Belum ada data obat di katalog.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Modal Tambah Stok -->
<div class="modal fade" id="modalTambahStok" tabindex="-1">
    <div class="modal-dialog">
        <form action="kelola_stok_obat.jsp" method="POST">
            <input type="hidden" name="action" value="tambah_stok">
            <input type="hidden" name="id_obat" id="modal_id_obat">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Tambah Stok Obat</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label text-muted">Nama Obat</label>
                        <input type="text" id="modal_nama_obat" class="form-control" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Jumlah Tambahan Stok</label>
                        <input type="number" name="jumlah" class="form-control" min="1" value="50" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary"><i class="fa-solid fa-plus me-1"></i> Tambahkan</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function openTambahStok(id, nama) {
        document.getElementById('modal_id_obat').value = id;
        document.getElementById('modal_nama_obat').value = nama;
        new bootstrap.Modal(document.getElementById('modalTambahStok')).show();
    }
</script>
</body>
</html>
