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
    <title>Lapor Insiden Darurat - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="insiden" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Pelaporan Insiden & Kegawatdaruratan Jiwa" />
            <jsp:param name="subtitle" value="Pencatatan Cepat Pasien Agresif, Percobaan Melarikan Diri, & Tindakan Fiksasi" />
        </jsp:include>

        <% if ("sukses".equals(status)) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-2"></i> Laporan insiden darurat berhasil disimpan dan tercatat di sistem!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- FORM PELAPORAN INSIDEN -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-triangle-exclamation me-2 text-danger"></i> Form Laporan Insiden</h6>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/PerawatServlet?action=simpan_insiden" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien Terkait *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien --</option>
                                    <jsp:include page="/inc_dropdown_pasien.jsp" />
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Waktu Kejadian *</label>
                                <input type="datetime-local" name="waktu" class="form-control" required value="2026-10-26T10:00">
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Jenis Kejadian / Insiden *</label>
                                <select name="jenis_insiden" class="form-select" required>
                                    <option value="Gaduh Gelisah & Mengamuk">Gaduh Gelisah & Mengamuk</option>
                                    <option value="Percobaan Melarikan Diri">Percobaan Melarikan Diri (Kabur)</option>
                                    <option value="Menolak Minum Obat">Menolak Minum Obat & Melawan</option>
                                    <option value="Merusak Fasilitas">Merusak Fasilitas Bangsal</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Kronologi Singkat *</label>
                                <textarea name="kronologi" class="form-control" rows="2" placeholder="Ceritakan bagaimana insiden terjadi..." required></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tindakan Penanganan Awal *</label>
                                <select name="penanganan" class="form-select" required>
                                    <option value="Fiksasi Fisik (Restraint Kamar Isolasi)">Fiksasi Fisik (Restraint Kamar Isolasi)</option>
                                    <option value="Injeksi Penenang (Diazepam / CPZ)">Injeksi Penenang (Diazepam / CPZ)</option>
                                    <option value="De-eskalasi Verbal">De-eskalasi Verbal & Pendampingan</option>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-danger w-100 py-2"><i class="fa-solid fa-bell me-1"></i> Kirim Laporan Insiden</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- TABEL ARSIP INSIDEN DARURAT -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-list-check me-2 text-danger"></i> Arsip Kejadian Terakhir</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Pasien</th>
                                        <th>Jenis Insiden</th>
                                        <th>Tindakan</th>
                                        <th>Waktu</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection connIns = null;
                                        Statement stmtIns = null;
                                        ResultSet rsIns = null;
                                        int cIns = 0;
                                        try {
                                            connIns = Koneksi.getConnection();
                                            stmtIns = connIns.createStatement();
                                            String sqlIns = "SELECT i.*, p.nama AS nama_pasien, p.no_rekam_medis " +
                                                            "FROM insiden_darurat i " +
                                                            "JOIN pasien p ON i.id_pasien = p.id_pasien " +
                                                            "ORDER BY i.id_insiden DESC LIMIT 6";
                                            rsIns = stmtIns.executeQuery(sqlIns);
                                            while (rsIns.next()) {
                                                cIns++;
                                                String namaP = rsIns.getString("nama_pasien");
                                                String jenis = rsIns.getString("jenis_insiden");
                                                String tind = rsIns.getString("tindakan_deeskalasi");
                                                String tgl = rsIns.getString("waktu_kejadian");
                                    %>
                                    <tr>
                                        <td><strong><%= namaP %></strong></td>
                                        <td><span class="badge bg-danger"><%= jenis %></span></td>
                                        <td><small><%= tind %></small></td>
                                        <td><small><%= tgl %></small></td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsIns != null) try { rsIns.close(); } catch (SQLException ignored) {}
                                            if (stmtIns != null) try { stmtIns.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connIns);
                                        }

                                        if (cIns == 0) {
                                    %>
                                    <tr><td colspan="4" class="text-center py-4 text-muted">Belum ada insiden darurat tercatat.</td></tr>
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
