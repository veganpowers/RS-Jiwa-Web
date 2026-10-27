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
    <title>Pantau Kondisi Harian (TTV) - Perawat RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="pantau" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Pencatatan Kondisi Fisik & Observasi Harian Pasien" />
            <jsp:param name="subtitle" value="Monitoring Tanda-Tanda Vital (TTV) dan Status Perilaku Pasien Jiwa" />
        </jsp:include>

        <% if ("sukses".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Data observasi TTV dan catatan perilaku pasien berhasil dicatat!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <!-- FORM INPUT OBSERVASI DASAR -->
            <div class="col-md-5">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-file-medical me-2 text-primary"></i> Formulir Observasi Pasien</h6>
                    </div>
                    <div class="card-body">
                        <form action="<%= request.getContextPath() %>/PerawatServlet?action=simpan_ttv" method="POST">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Pilih Pasien *</label>
                                <select name="id_pasien" class="form-select" required>
                                    <option value="">-- Pilih Pasien Rawat --</option>
                                    <jsp:include page="/inc_dropdown_pasien.jsp" />
                                </select>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Tekanan Darah *</label>
                                    <input type="text" name="tensi" class="form-control" placeholder="Contoh: 120/80" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Suhu Tubuh (&deg;C) *</label>
                                    <input type="text" name="suhu" class="form-control" placeholder="Contoh: 36.5" required>
                                </div>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Nadi (bpm)</label>
                                    <input type="number" name="nadi" class="form-control" placeholder="Contoh: 80">
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold">Pernapasan (x/mnt)</label>
                                    <input type="number" name="respirasi" class="form-control" placeholder="Contoh: 18">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Tingkat Perilaku & Agitasi Saat Ini *</label>
                                <select name="status_perilaku" class="form-select" required>
                                    <option value="Tenang / Kooperatif">Tenang / Kooperatif</option>
                                    <option value="Gelisah / Mondar-mandir">Gelisah / Mondar-mandir</option>
                                    <option value="Menolak Interaksi / Menarik Diri">Menolak Interaksi / Menarik Diri</option>
                                    <option value="Agresif Verbal (Mencaci / Berteriak)">Agresif Verbal (Mencaci / Berteriak)</option>
                                    <option value="Agresif Fisik (Gaduh Gelisah)">Agresif Fisik (Gaduh Gelisah)</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Catatan Observasi Perawat</label>
                                <textarea name="catatan_perilaku" class="form-control" rows="3" placeholder="Catatan kebiasaan tidur, makan, atau interaksi sosial pasien..."></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 py-2"><i class="fa-solid fa-save me-1"></i> Simpan Catatan Harian</button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- LOG CATATAN HARIAN TERAKHIR -->
            <div class="col-md-7">
                <div class="card border-0 shadow-sm">
                    <div class="card-header bg-white py-3">
                        <h6 class="m-0 fw-bold"><i class="fa-solid fa-clock-rotate-left me-2 text-primary"></i> Log Pemantauan Terkini</h6>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th>Pasien & Kamar</th>
                                        <th>TTV (TD / Suhu)</th>
                                        <th>Status Perilaku</th>
                                        <th>Perawat Jaga</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        Connection connTtv = null;
                                        Statement stmtTtv = null;
                                        ResultSet rsTtv = null;
                                        int cTtv = 0;
                                        try {
                                            connTtv = Koneksi.getConnection();
                                            stmtTtv = connTtv.createStatement();
                                            String sqlTtv = "SELECT p.nama AS nama_pasien, p.no_rekam_medis, k.nama_kamar, p.tingkat_agitasi " +
                                                            "FROM pasien p LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                                                            "ORDER BY p.id_pasien DESC LIMIT 6";
                                            rsTtv = stmtTtv.executeQuery(sqlTtv);
                                            while (rsTtv.next()) {
                                                cTtv++;
                                                String namaP = rsTtv.getString("nama_pasien");
                                                String noRm = rsTtv.getString("no_rekam_medis");
                                                String kmr = rsTtv.getString("nama_kamar");
                                                String agitasi = rsTtv.getString("tingkat_agitasi");
                                    %>
                                    <tr>
                                        <td><strong><%= namaP %></strong><br><small class="text-muted"><%= (kmr != null ? kmr : noRm) %></small></td>
                                        <td><span class="badge bg-light text-dark border">120/80 mmHg</span><br><small>36.5 &deg;C</small></td>
                                        <td>
                                            <% if (agitasi != null && agitasi.contains("Agitasi")) { %>
                                                <span class="badge bg-danger"><%= agitasi %></span>
                                            <% } else { %>
                                                <span class="badge bg-success"><%= (agitasi != null ? agitasi : "Tenang") %></span>
                                            <% } %>
                                        </td>
                                        <td><small>Ners Shift</small></td>
                                    </tr>
                                    <%
                                            }
                                        } catch (Exception e) {
                                            e.printStackTrace();
                                        } finally {
                                            if (rsTtv != null) try { rsTtv.close(); } catch (SQLException ignored) {}
                                            if (stmtTtv != null) try { stmtTtv.close(); } catch (SQLException ignored) {}
                                            Koneksi.closeConnection(connTtv);
                                        }

                                        if (cTtv == 0) {
                                    %>
                                    <tr><td colspan="4" class="text-center py-4 text-muted">Belum ada catatan observasi.</td></tr>
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
