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
    <title>Verifikasi Izin Besuk - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="verifikasi_besuk" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Verifikasi & Persetujuan Izin Besuk Pasien" />
            <jsp:param name="subtitle" value="Persetujuan Kunjungan Tatap Muka Keluarga Berdasarkan Evaluasi Kestabilan Pasien Jiwa" />
        </jsp:include>

        <% if ("sukses".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Status permohonan kunjungan besuk berhasil diperbarui!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-clipboard-check me-2 text-primary"></i> Daftar Permohonan Izin Besuk dari Keluarga</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No</th>
                                <th>Pasien ODGJ</th>
                                <th>Kamar / Kondisi</th>
                                <th>Tanggal Besuk</th>
                                <th>Sesi Waktu</th>
                                <th>Nama Pengunjung</th>
                                <th>Jumlah</th>
                                <th>Status Izin</th>
                                <th class="text-center" style="width: 170px;">Aksi Ners</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection connBesuk = null;
                                Statement stmtBesuk = null;
                                ResultSet rsBesuk = null;
                                int cBesuk = 0;
                                try {
                                    connBesuk = Koneksi.getConnection();
                                    stmtBesuk = connBesuk.createStatement();
                                    String sqlBesuk = "SELECT jb.*, p.nama AS nama_pasien, p.no_rekam_medis, p.tingkat_agitasi, k.nama_kamar " +
                                                      "FROM jadwal_besuk jb " +
                                                      "JOIN pasien p ON jb.id_pasien = p.id_pasien " +
                                                      "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                      "ORDER BY jb.id_besuk DESC";
                                    rsBesuk = stmtBesuk.executeQuery(sqlBesuk);
                                    while (rsBesuk.next()) {
                                        cBesuk++;
                                        int idBesuk = rsBesuk.getInt("id_besuk");
                                        String namaP = rsBesuk.getString("nama_pasien");
                                        String noRm = rsBesuk.getString("no_rekam_medis");
                                        String agitasi = rsBesuk.getString("tingkat_agitasi");
                                        String kmr = rsBesuk.getString("nama_kamar");
                                        String tglBesuk = rsBesuk.getString("tanggal_besuk");
                                        String sesiWaktu = rsBesuk.getString("sesi_waktu");
                                        String pengunjung = rsBesuk.getString("nama_pengunjung");
                                        int jml = rsBesuk.getInt("jumlah_keluarga");
                                        String statusIzin = rsBesuk.getString("status_izin");
                            %>
                            <tr>
                                <td><%= cBesuk %></td>
                                <td><strong><%= namaP %></strong><br><small class="text-muted"><%= noRm %></small></td>
                                <td>
                                    <small><%= (kmr != null ? kmr : "-") %></small><br>
                                    <% if (agitasi != null && agitasi.contains("Agitasi")) { %>
                                        <span class="badge bg-danger"><%= agitasi %></span>
                                    <% } else { %>
                                        <span class="badge bg-success"><%= (agitasi != null ? agitasi : "Tenang") %></span>
                                    <% } %>
                                </td>
                                <td><%= tglBesuk %></td>
                                <td><%= sesiWaktu %></td>
                                <td><%= pengunjung %></td>
                                <td><%= jml %> Org</td>
                                <td>
                                    <% if ("Disetujui Ners".equalsIgnoreCase(statusIzin)) { %>
                                        <span class="badge bg-success"><i class="fa-solid fa-check me-1"></i> Disetujui</span>
                                    <% } else if ("Ditolak".equalsIgnoreCase(statusIzin)) { %>
                                        <span class="badge bg-danger"><i class="fa-solid fa-xmark me-1"></i> Ditolak</span>
                                    <% } else { %>
                                        <span class="badge bg-warning text-dark"><i class="fa-solid fa-clock me-1"></i> Menunggu Persetujuan</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <% if ("Menunggu Persetujuan".equalsIgnoreCase(statusIzin)) { %>
                                        <a href="<%= request.getContextPath() %>/PerawatServlet?action=setujui_besuk&id_besuk=<%= idBesuk %>" 
                                           class="btn btn-sm btn-success me-1" 
                                           onclick="return confirm('Setujui permohonan kunjungan besuk untuk pasien <%= namaP %>?')">
                                            <i class="fa-solid fa-check"></i> Setujui
                                        </a>
                                        <a href="<%= request.getContextPath() %>/PerawatServlet?action=tolak_besuk&id_besuk=<%= idBesuk %>" 
                                           class="btn btn-sm btn-outline-danger" 
                                           onclick="return confirm('Tolak permohonan kunjungan besuk?')">
                                            <i class="fa-solid fa-xmark"></i> Tolak
                                        </a>
                                    <% } else { %>
                                        <small class="text-muted">Sudah Diproses</small>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsBesuk != null) try { rsBesuk.close(); } catch (SQLException ignored) {}
                                    if (stmtBesuk != null) try { stmtBesuk.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connBesuk);
                                }

                                if (cBesuk == 0) {
                            %>
                            <tr>
                                <td colspan="9" class="text-center py-4 text-muted">Belum ada pengajuan izin besuk dari keluarga pasien.</td>
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

