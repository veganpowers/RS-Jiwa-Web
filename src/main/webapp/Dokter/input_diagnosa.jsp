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
    <title>Pemeriksaan & Diagnosa - Dokter RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="diagnosa" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Pemeriksaan & Input Diagnosa Medis" />
            <jsp:param name="subtitle" value="Pencatatan Hasil Evaluasi Status Mental dan Anamnesa Pasien ODGJ" />
        </jsp:include>

        <% if ("sukses".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Hasil pemeriksaan dan diagnosa medis berhasil disimpan ke rekam medis!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- FORM INPUT DIAGNOSA DASAR -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-file-circle-plus me-2 text-primary"></i> Formulir Rekam Medis</h6>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/DiagnosaServlet" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien ODGJ *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien --</option>
                                    <jsp:include page="/inc_dropdown_pasien.jsp">
                                        <jsp:param name="rm" value="<%= request.getParameter(\"rm\") %>" />
                                    </jsp:include>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tanggal Pemeriksaan *</label>
                                <input type="date" name="tanggal" class="form-control" value="2026-10-26" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Keluhan Utama & Gejala *</label>
                                <textarea name="keluhan" class="form-control" rows="3" placeholder="Contoh: Pasien berteriak gelisah, mengaku mendengar suara bisikan tak kasat mata..." required></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Kode & Nama Diagnosa (ICD-10) *</label>
                                <select name="diagnosa" class="form-select" required>
                                    <option value="F20.0 Skizofrenia Paranoid">F20.0 Skizofrenia Paranoid</option>
                                    <option value="F31.0 Gangguan Afektif Bipolar">F31.0 Gangguan Afektif Bipolar</option>
                                    <option value="F32.0 Episode Depresi Berat">F32.0 Episode Depresi Berat</option>
                                    <option value="F10.0 Gangguan Mental Terkait Zat">F10.0 Gangguan Mental Terkait Zat/Adiksi</option>
                                    <option value="F41.0 Gangguan Cemas & Panik">F41.0 Gangguan Cemas & Panik</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Rencana Tindakan Medis *</label>
                                <textarea name="rencana" class="form-control" rows="2" placeholder="Contoh: Terapi antipsikotik oral, observasi ketat di bangsal..." required></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2"><i class="fa-solid fa-save me-1"></i> Simpan Diagnosa Medis</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- RIWAYAT DIAGNOSA TERAKHIR -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Riwayat Diagnosa Terkini</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Pasien</th>
                                        <th>Diagnosa ICD-10</th>
                                        <th>Keluhan</th>
                                        <th>Tanggal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection connRM = null;
                                        Statement stmtRM = null;
                                        ResultSet rsRM = null;
                                        int cRM = 0;
                                        try {
                                            connRM = Koneksi.getConnection();
                                            stmtRM = connRM.createStatement();
                                            String sqlRM = "SELECT rm.*, p.nama AS nama_pasien, p.no_rekam_medis " +
                                                           "FROM rekam_medis rm " +
                                                           "JOIN pasien p ON rm.id_pasien = p.id_pasien " +
                                                           "ORDER BY rm.id_rm DESC LIMIT 6";
                                            rsRM = stmtRM.executeQuery(sqlRM);
                                            while (rsRM.next()) {
                                                cRM++;
                                                String namaP = rsRM.getString("nama_pasien");
                                                String noRm = rsRM.getString("no_rekam_medis");
                                                String diag = rsRM.getString("diagnosa_utama");
                                                String kel = rsRM.getString("keluhan_utama");
                                                String tgl = rsRM.getString("tgl_periksa");
                                    %>
                                    <tr>
                                        <td><strong><%= namaP %></strong><br><small class="text-muted"><%= noRm %></small></td>
                                        <td><span class="badge bg-primary"><%= diag %></span></td>
                                        <td><small><%= (kel != null && kel.length() > 30) ? kel.substring(0, 30) + "..." : kel %></small></td>
                                        <td><small><%= tgl %></small></td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsRM != null) try { rsRM.close(); } catch (SQLException ignored) {}
                                            if (stmtRM != null) try { stmtRM.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connRM);
                                        }

                                        if (cRM == 0) {
                                    %>
                                    <tr><td colspan="4" class="text-center py-4 text-muted">Belum ada rekam medis tersimpan.</td></tr>
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
