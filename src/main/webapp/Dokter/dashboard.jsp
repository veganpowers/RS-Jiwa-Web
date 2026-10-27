<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.rsodgj.config.Koneksi" %>
<%
    String currentRole = (String) session.getAttribute("role");
    if (currentRole == null || !"dokter".equalsIgnoreCase(currentRole)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    int rawatInapCount = 0;
    int rekamMedisCount = 0;
    int resepCount = 0;

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        conn = Koneksi.getConnection();
        stmt = conn.createStatement();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM pasien WHERE status_perawatan IN ('Rawat Inap', 'Isolasi Khusus')");
        if (rs.next()) rawatInapCount = rs.getInt(1);
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM rekam_medis");
        if (rs.next()) rekamMedisCount = rs.getInt(1);
        rs.close();

        rs = stmt.executeQuery("SELECT COUNT(*) FROM resep_obat");
        if (rs.next()) resepCount = rs.getInt(1);
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
    <title>Dashboard Dokter - RS Jiwa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="dashboard" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Dashboard Medis & Psikiatri" />
            <jsp:param name="subtitle" value="Monitoring Pasien Rawat Inap & Status Kesehatan Mental" />
        </jsp:include>

        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-3 me-3"><i class="fa-solid fa-bed-pulse fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">PASIEN RAWAT INAP</small>
                            <h3 class="fw-bold mb-0"><%= rawatInapCount %> Pasien</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-success bg-opacity-10 text-success rounded-3 me-3"><i class="fa-solid fa-notes-medical fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL REKAM MEDIS</small>
                            <h3 class="fw-bold mb-0"><%= rekamMedisCount %> Rekam Medis</h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 me-3"><i class="fa-solid fa-pills fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">RESEP DITERBITKAN</small>
                            <h3 class="fw-bold mb-0"><%= resepCount %> Resep</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-list me-2 text-primary"></i> Pasien Rawat Inap & Kondisi Terkini</h6>
                <a href="input_diagnosa.jsp" class="btn btn-sm btn-primary"><i class="fa-solid fa-plus me-1"></i> Input Diagnosa Baru</a>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. RM</th>
                                <th>Nama Pasien</th>
                                <th>Ruangan / Kamar</th>
                                <th>Tingkat Agitasi</th>
                                <th>Status Rawat</th>
                                <th class="text-center">Aksi Medis</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                int countP = 0;
                                try {
                                    String sql = "SELECT p.*, k.nama_kamar FROM pasien p LEFT JOIN kamar k ON p.id_kamar = k.id_kamar ORDER BY p.id_pasien DESC LIMIT 5";
                                    rs = stmt.executeQuery(sql);
                                    while (rs.next()) {
                                        countP++;
                                        String noRm = rs.getString("no_rekam_medis");
                                        String nm = rs.getString("nama");
                                        String kmr = rs.getString("nama_kamar");
                                        if (kmr == null) kmr = "Belum Ada Kamar";
                                        String agitasi = rs.getString("tingkat_agitasi");
                                        String status = rs.getString("status_perawatan");
                            %>
                            <tr>
                                <td><strong><%= noRm %></strong></td>
                                <td><%= nm %></td>
                                <td><span class="badge <%= kmr.toLowerCase().contains("isolasi") ? "bg-danger" : "bg-info text-dark" %>"><%= kmr %></span></td>
                                <td><span class="badge bg-secondary"><%= agitasi != null ? agitasi : "Tenang" %></span></td>
                                <td><span class="badge bg-success"><%= status %></span></td>
                                <td class="text-center">
                                    <a href="input_diagnosa.jsp?rm=<%= noRm %>" class="btn btn-sm btn-outline-primary"><i class="fa-solid fa-stethoscope me-1"></i> Diagnosa</a>
                                    <a href="resep_obat.jsp?rm=<%= noRm %>" class="btn btn-sm btn-outline-success"><i class="fa-solid fa-pills me-1"></i> Resep</a>
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

                                if (countP == 0) {
                            %>
                            <tr>
                                <td colspan="6" class="text-center py-4 text-muted">Belum ada data pasien terdaftar.</td>
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
