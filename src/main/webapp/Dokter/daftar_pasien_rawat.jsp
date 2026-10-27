<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Daftar Pasien Rawat - Dokter Spesialis Jiwa</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="pasien" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Daftar Pasien Asuhan Dokter (DPJP)" />
            <jsp:param name="subtitle" value="Daftar Pasien ODGJ yang Sedang Menjalani Rawat Inap & Rawat Jalan" />
        </jsp:include>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-bed-pulse me-2 text-primary"></i> Pasien Rawat Jiwa Aktif</h6>
                <div style="width: 250px;">
                    <input type="text" class="form-control form-control-sm" placeholder="Cari No. RM / Nama Pasien...">
                </div>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No. RM</th>
                                <th>Nama Lengkap</th>
                                <th>JK / Tgl Lahir</th>
                                <th>Kamar / Ruangan</th>
                                <th>Status Rawat</th>
                                <th>Kondisi / Agitasi</th>
                                <th class="text-center" style="width: 180px;">Aksi Medis</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection connDokter = null;
                                Statement stmtDokter = null;
                                ResultSet rsDokter = null;
                                int countDokter = 0;
                                try {
                                    connDokter = Koneksi.getConnection();
                                    stmtDokter = connDokter.createStatement();
                                    String sqlD = "SELECT p.*, k.nama_kamar " +
                                                  "FROM pasien p LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                  "ORDER BY p.id_pasien DESC";
                                    rsDokter = stmtDokter.executeQuery(sqlD);
                                    while (rsDokter.next()) {
                                        countDokter++;
                                        int idPasien = rsDokter.getInt("id_pasien");
                                        String noRm = rsDokter.getString("no_rekam_medis");
                                        String nama = rsDokter.getString("nama");
                                        String jk = rsDokter.getString("jenis_kelamin");
                                        String tgl = rsDokter.getString("tgl_lahir");
                                        String namaKamar = rsDokter.getString("nama_kamar");
                                        String statusRawat = rsDokter.getString("status_perawatan");
                                        String agitasi = rsDokter.getString("tingkat_agitasi");
                                        String displayKamar = (namaKamar != null) ? namaKamar : "-";
                            %>
                            <tr>
                                <td><strong><%= noRm %></strong></td>
                                <td><%= nama %></td>
                                <td><%= ("Laki-laki".equalsIgnoreCase(jk) ? "L" : "P") %> / <%= (tgl != null ? tgl : "-") %></td>
                                <td><%= displayKamar %></td>
                                <td>
                                    <% if ("Rawat Inap".equalsIgnoreCase(statusRawat) || "Isolasi Khusus".equalsIgnoreCase(statusRawat)) { %>
                                        <span class="badge bg-danger"><%= statusRawat %></span>
                                    <% } else { %>
                                        <span class="badge bg-success"><%= statusRawat %></span>
                                    <% } %>
                                </td>
                                <td><%= (agitasi != null ? agitasi : "Tenang") %></td>
                                <td class="text-center">
                                    <a href="input_diagnosa.jsp?rm=<%= noRm %>" class="btn btn-sm btn-primary"><i class="fa-solid fa-stethoscope"></i> Diagnosa</a>
                                    <a href="resep_obat.jsp?rm=<%= noRm %>" class="btn btn-sm btn-success"><i class="fa-solid fa-pills"></i> Resep</a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsDokter != null) try { rsDokter.close(); } catch (SQLException ignored) {}
                                    if (stmtDokter != null) try { stmtDokter.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connDokter);
                                }

                                if (countDokter == 0) {
                            %>
                            <tr><td colspan="7" class="text-center py-4 text-muted">Belum ada data pasien rawat.</td></tr>
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
