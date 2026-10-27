<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.rsodgj.config.Koneksi" %>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || !"perawat".equalsIgnoreCase(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    int isolasiCount = 0;
    int regulerCount = 0;
    int insidenCount = 0;

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        stmt = conn.createStatement();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM pasien WHERE status_perawatan = 'Isolasi Khusus'");
        if (rs.next()) isolasiCount = rs.getInt(1);
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM pasien WHERE status_perawatan = 'Rawat Inap'");
        if (rs.next()) regulerCount = rs.getInt(1);
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM insiden_darurat");
        if (rs.next()) insidenCount = rs.getInt(1);
        rs.close();

    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Perawat - RS Khusus ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="dashboard" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Dashboard Asuhan Keperawatan" />
            <jsp:param name="subtitle" value="Monitoring Harian Kondisi Pasien, TTV & Keselamatan Bangsal" />
        </jsp:include>

        <div class="alert alert-primary mb-4">
            <h5 class="alert-heading fw-bold mb-1"><i class="fa-solid fa-user-nurse me-2"></i> Selamat Bertugas, Ners</h5>
            <p class="mb-0">Gunakan menu navigasi untuk memantau tanda-tanda vital (TTV), jadwal pemberian obat, pindah kamar, verifikasi besuk, dan laporan insiden darurat.</p>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-danger bg-opacity-10 text-danger rounded-3 me-3"><i class="fa-solid fa-lock fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">PASIEN ISOLASI</small>
                            <h3 class="fw-bold mb-0"><%= isolasiCount %> Pasien</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-3 me-3"><i class="fa-solid fa-bed fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">BANGSAL REGULER</small>
                            <h3 class="fw-bold mb-0"><%= regulerCount %> Pasien</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 me-3"><i class="fa-solid fa-triangle-exclamation fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">INSIDEN TERCATAT</small>
                            <h3 class="fw-bold mb-0"><%= insidenCount %> Kejadian</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-list me-2 text-primary"></i> Daftar Pasien Rawat Inap & Status Terkini</h6>
                <a href="pantau_kondisi_harian.jsp" class="btn btn-sm btn-primary"><i class="fa-solid fa-plus me-1"></i> Catat Observasi TTV</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. RM</th>
                                <th>Nama Pasien</th>
                                <th>Kamar / Bangsal</th>
                                <th>Tingkat Agitasi</th>
                                <th>Status Rawat</th>
                                <th class="text-center">Aksi Keperawatan</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int countList = 0;
                                try {
                                    String sql = "SELECT p.*, k.nama_kamar " +
                                                 "FROM pasien p " +
                                                 "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                 "ORDER BY p.id_pasien DESC LIMIT 6";
                                    rs = stmt.executeQuery(sql);
                                    while (rs.next()) {
                                        countList++;
                                        int idPas = rs.getInt("id_pasien");
                                        String noRm = rs.getString("no_rekam_medis");
                                        String namaPas = rs.getString("nama");
                                        String namaKamar = rs.getString("nama_kamar");
                                        if (namaKamar == null) namaKamar = "Belum Ada Kamar";
                                        String agitasi = rs.getString("tingkat_agitasi");
                                        String statusRawat = rs.getString("status_perawatan");
                            %>
                            <tr>
                                <td><strong><%= noRm %></strong></td>
                                <td><%= namaPas %></td>
                                <td><span class="badge <%= namaKamar.toLowerCase().contains("isolasi") ? "bg-danger" : "bg-info text-dark" %>"><%= namaKamar %></span></td>
                                <td><span class="badge bg-secondary"><%= agitasi != null ? agitasi : "Tenang" %></span></td>
                                <td><span class="badge bg-primary"><%= statusRawat %></span></td>
                                <td class="text-center">
                                    <a href="pantau_kondisi_harian.jsp?rm=<%= noRm %>" class="btn btn-sm btn-outline-primary"><i class="fa-solid fa-heart-pulse me-1"></i> Observasi</a>
                                    <a href="jadwal_jaga.jsp?id=<%= idPas %>" class="btn btn-sm btn-outline-secondary"><i class="fa-solid fa-door-open me-1"></i> Pindah Kamar</a>
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

                                if (countList == 0) {
                            %>
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">Belum ada pasien rawat yang perlu diawasi.</td>
                            </tr>
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
