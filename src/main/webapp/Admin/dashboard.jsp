<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<%
    int totalDokter = 0;
    int totalPerawat = 0;
    int totalPasien = 0;
    int totalKamarTersedia = 0;

    Connection connDash = null;
    Statement stmtDash = null;
    ResultSet rsDash = null;
    try {
        connDash = Koneksi.getConnection();
        stmtDash = connDash.createStatement();

        rsDash = stmtDash.executeQuery("SELECT COUNT(*) FROM dokter");
        if (rsDash.next()) totalDokter = rsDash.getInt(1);
        rsDash.close();

        rsDash = stmtDash.executeQuery("SELECT COUNT(*) FROM perawat");
        if (rsDash.next()) totalPerawat = rsDash.getInt(1);
        rsDash.close();

        rsDash = stmtDash.executeQuery("SELECT COUNT(*) FROM pasien");
        if (rsDash.next()) totalPasien = rsDash.getInt(1);
        rsDash.close();

        rsDash = stmtDash.executeQuery("SELECT COUNT(*) FROM kamar WHERE terisi < kapasitas");
        if (rsDash.next()) totalKamarTersedia = rsDash.getInt(1);
        rsDash.close();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rsDash != null) try { rsDash.close(); } catch (SQLException ignored) {}
        if (stmtDash != null) try { stmtDash.close(); } catch (SQLException ignored) {}
        Koneksi.closeConnection(connDash);
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Sederhana - Administrator RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="dashboard" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Dashboard Administrator" />
            <jsp:param name="subtitle" value="Pusat Kontrol & Ringkasan Data Master Sistem Informasi RS ODGJ" />
        </jsp:include>

        <div class="alert alert-primary mb-4" role="alert">
            <h5 class="alert-heading fw-bold mb-1"><i class="fa-solid fa-hospital-user me-2"></i> Selamat Datang di Panel Utama Administrator</h5>
            <p class="mb-0">Sebagai Administrator, Anda memiliki hak akses penuh untuk melakukan operasi <strong>CRUD (Create, Read, Update, Delete)</strong> terhadap seluruh data master, medis, operasional obat, tagihan, dan akun sistem.</p>
        </div>

        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-primary bg-opacity-10 text-primary rounded-3 me-3"><i class="fa-solid fa-user-doctor fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL DOKTER</small>
                            <h3 class="fw-bold mb-0"><%= totalDokter %></h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-success bg-opacity-10 text-success rounded-3 me-3"><i class="fa-solid fa-user-nurse fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL PERAWAT</small>
                            <h3 class="fw-bold mb-0"><%= totalPerawat %></h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-danger bg-opacity-10 text-danger rounded-3 me-3"><i class="fa-solid fa-bed-pulse fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">TOTAL PASIEN</small>
                            <h3 class="fw-bold mb-0"><%= totalPasien %></h3>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm">
                    <div class="card-body d-flex align-items-center">
                        <div class="p-3 bg-warning bg-opacity-10 text-warning rounded-3 me-3"><i class="fa-solid fa-door-open fa-2x"></i></div>
                        <div>
                            <small class="text-muted fw-bold">KAMAR TERSEDIA</small>
                            <h3 class="fw-bold mb-0"><%= totalKamarTersedia %></h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row g-4">
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Pendaftaran Pasien Terbaru</h6>
                        <a href="data_pasien.jsp" class="btn btn-sm btn-outline-primary">Kelola Semua Pasien</a>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>No. RM</th>
                                        <th>Nama Lengkap</th>
                                        <th>Status Rawat</th>
                                        <th>Kamar</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection connTabelP = null;
                                        Statement stmtTP = null;
                                        ResultSet rsTP = null;
                                        int cDash = 0;
                                        try {
                                            connTabelP = Koneksi.getConnection();
                                            stmtTP = connTabelP.createStatement();
                                            String sqlTP = "SELECT p.no_rekam_medis, p.nama, p.status_perawatan, k.nama_kamar " +
                                                           "FROM pasien p LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                           "ORDER BY p.id_pasien DESC LIMIT 5";
                                            rsTP = stmtTP.executeQuery(sqlTP);
                                            while (rsTP.next()) {
                                                cDash++;
                                                String rm = rsTP.getString("no_rekam_medis");
                                                String nm = rsTP.getString("nama");
                                                String st = rsTP.getString("status_perawatan");
                                                String km = rsTP.getString("nama_kamar");
                                    %>
                                    <tr>
                                        <td><strong><%= rm %></strong></td>
                                        <td><%= nm %></td>
                                        <td>
                                            <% if ("Rawat Inap".equalsIgnoreCase(st) || "Isolasi Khusus".equalsIgnoreCase(st)) { %>
                                                <span class="badge bg-danger"><%= st %></span>
                                            <% } else { %>
                                                <span class="badge bg-success"><%= st %></span>
                                            <% } %>
                                        </td>
                                        <td><%= (km != null ? km : "-") %></td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsTP != null) try { rsTP.close(); } catch (SQLException ignored) {}
                                            if (stmtTP != null) try { stmtTP.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connTabelP);
                                        }

                                        if (cDash == 0) {
                                    %>
                                    <tr><td colspan="4" class="text-center py-3 text-muted">Belum ada pasien terdaftar.</td></tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-bolt me-2 text-primary"></i> Navigasi Akses Cepat CRUD</h6>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="data_dokter.jsp" class="btn btn-outline-primary text-start"><i class="fa-solid fa-user-doctor me-2"></i> Master Data Dokter</a>
                            <a href="data_perawat.jsp" class="btn btn-outline-primary text-start"><i class="fa-solid fa-user-nurse me-2"></i> Master Data Perawat</a>
                            <a href="data_pasien.jsp" class="btn btn-outline-primary text-start"><i class="fa-solid fa-bed-pulse me-2"></i> Registrasi & Data Pasien</a>
                            <a href="data_kamar_isolasi.jsp" class="btn btn-outline-primary text-start"><i class="fa-solid fa-door-closed me-2"></i> Ketersediaan Kamar Perawatan</a>
                            <a href="kelola_tagihan.jsp" class="btn btn-outline-primary text-start"><i class="fa-solid fa-file-invoice-dollar me-2"></i> Kasir & Billing Pasien</a>
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
