<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<%
    String status = request.getParameter("status");
    String msg = request.getParameter("msg");

    // Tangani Hapus Jadwal via GET
    String action = request.getParameter("action");
    String idJadwalStr = request.getParameter("id");
    if ("delete".equalsIgnoreCase(action) && idJadwalStr != null) {
        Connection connDel = null;
        PreparedStatement stmtDel = null;
        try {
            connDel = Koneksi.getConnection();
            stmtDel = connDel.prepareStatement("DELETE FROM jadwal_dokter WHERE id_jadwal = ?");
            stmtDel.setInt(1, Integer.parseInt(idJadwalStr.trim()));
            stmtDel.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/Admin/jadwal_dokter.jsp?msg=deleted");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (stmtDel != null) try { stmtDel.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(connDel);
        }
    }

    // Tangani Simpan Jadwal Baru via POST
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String idDokterStr = request.getParameter("id_dokter");
        String hari = request.getParameter("hari");
        String jamMulai = request.getParameter("jam_mulai");
        String jamSelesai = request.getParameter("jam_selesai");
        String ruangan = request.getParameter("ruangan");

        Connection connIns = null;
        PreparedStatement stmtIns = null;
        try {
            connIns = Koneksi.getConnection();
            String sqlIns = "INSERT INTO jadwal_dokter (id_dokter, hari, jam_mulai, jam_selesai, ruang_praktik, kuota_pasien, status) " +
                            "VALUES (?, ?, ?, ?, ?, 15, 'Aktif')";
            stmtIns = connIns.prepareStatement(sqlIns);
            stmtIns.setInt(1, Integer.parseInt(idDokterStr.trim()));
            stmtIns.setString(2, hari);
            stmtIns.setString(3, (jamMulai != null && !jamMulai.isEmpty()) ? jamMulai : "08:00:00");
            stmtIns.setString(4, (jamSelesai != null && !jamSelesai.isEmpty()) ? jamSelesai : "13:00:00");
            stmtIns.setString(5, ruangan != null ? ruangan : "Poli Jiwa 1");
            stmtIns.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/Admin/jadwal_dokter.jsp?status=success");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (stmtIns != null) try { stmtIns.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(connIns);
        }
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jadwal Dokter - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="jadwal" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Jadwal Praktik Dokter" />
            <jsp:param name="subtitle" value="Atur Shift Praktik dan Poliklinik Dokter Spesialis Jiwa (CRUD)" />
        </jsp:include>

        <% if ("success".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Jadwal praktik dokter berhasil ditambahkan!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Jadwal praktik dokter berhasil dihapus!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-calendar-days me-2 text-primary"></i> Jadwal Praktik Mingguan Dokter</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahJadwal">
                    <i class="fa-solid fa-plus me-1"></i> Tambah Jadwal Praktik
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Hari</th>
                                <th>Nama Dokter</th>
                                <th>Spesialisasi</th>
                                <th>Jam Praktik</th>
                                <th>Ruang Poliklinik</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection connJ = null;
                                Statement stmtJ = null;
                                ResultSet rsJ = null;
                                int noJ = 0;
                                try {
                                    connJ = Koneksi.getConnection();
                                    stmtJ = connJ.createStatement();
                                    String sqlJ = "SELECT j.*, d.nama_dokter, d.spesialisasi FROM jadwal_dokter j " +
                                                  "JOIN dokter d ON j.id_dokter = d.id_dokter ORDER BY FIELD(j.hari, 'Senin','Selasa','Rabu','Kamis','Jumat','Sabtu','Minggu'), j.jam_mulai ASC";
                                    rsJ = stmtJ.executeQuery(sqlJ);
                                    while (rsJ.next()) {
                                        noJ++;
                                        int idJadwal = rsJ.getInt("id_jadwal");
                                        String hari = rsJ.getString("hari");
                                        String namaDokter = rsJ.getString("nama_dokter");
                                        String spe = rsJ.getString("spesialisasi");
                                        Time jmMulai = rsJ.getTime("jam_mulai");
                                        Time jmSelesai = rsJ.getTime("jam_selesai");
                                        String ruangPrak = rsJ.getString("ruang_praktik");
                                        String jamFormat = (jmMulai != null ? jmMulai.toString().substring(0, 5) : "08:00") + " - " + 
                                                           (jmSelesai != null ? jmSelesai.toString().substring(0, 5) : "13:00") + " WIB";
                            %>
                            <tr>
                                <td><strong><%= hari %></strong></td>
                                <td><%= namaDokter %></td>
                                <td><%= spe %></td>
                                <td><span class="badge bg-light text-dark border"><%= jamFormat %></span></td>
                                <td><%= ruangPrak %></td>
                                <td class="text-center">
                                    <a href="jadwal_dokter.jsp?action=delete&id=<%= idJadwal %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Hapus jadwal praktik <%= namaDokter %> pada hari <%= hari %>?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsJ != null) try { rsJ.close(); } catch (SQLException ignored) {}
                                    if (stmtJ != null) try { stmtJ.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connJ);
                                }

                                if (noJ == 0) {
                            %>
                            <tr><td colspan="6" class="text-center py-4 text-muted">Belum ada jadwal dokter tersimpan.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH JADWAL (SEMUA INPUT SCROLL OPTION) -->
<div class="modal fade" id="modalTambahJadwal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Jadwal Praktik</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="jadwal_dokter.jsp" method="POST">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Pilih Dokter *</label>
                        <select name="id_dokter" class="form-select" required>
                            <option value="">-- Pilih Dokter Spesialis --</option>
                            <%
                                Connection connD = null;
                                Statement stmtD = null;
                                ResultSet rsD = null;
                                try {
                                    connD = Koneksi.getConnection();
                                    stmtD = connD.createStatement();
                                    rsD = stmtD.executeQuery("SELECT id_dokter, nama_dokter, spesialisasi FROM dokter ORDER BY id_dokter ASC");
                                    while (rsD.next()) {
                                        int idDoc = rsD.getInt("id_dokter");
                                        String nmDoc = rsD.getString("nama_dokter");
                            %>
                            <option value="<%= idDoc %>"><%= nmDoc %></option>
                            <%
                                    }
                                } catch (Exception ignored) {
                                } finally {
                                    if (rsD != null) try { rsD.close(); } catch (SQLException ignored) {}
                                    if (stmtD != null) try { stmtD.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connD);
                                }
                            %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Hari Praktik *</label>
                        <select name="hari" class="form-select" required>
                            <option value="">-- Pilih Hari Praktik --</option>
                            <option value="Senin">Senin</option>
                            <option value="Selasa">Selasa</option>
                            <option value="Rabu">Rabu</option>
                            <option value="Kamis">Kamis</option>
                            <option value="Jumat">Jumat</option>
                            <option value="Sabtu">Sabtu</option>
                            <option value="Minggu">Minggu</option>
                        </select>
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label class="form-label fw-semibold">Jam Mulai Praktik *</label>
                            <select name="jam_mulai" class="form-select" required>
                                <option value="08:00:00">08:00 WIB</option>
                                <option value="08:30:00">08:30 WIB</option>
                                <option value="09:00:00">09:00 WIB</option>
                                <option value="09:30:00">09:30 WIB</option>
                                <option value="10:00:00">10:00 WIB</option>
                                <option value="13:00:00">13:00 WIB</option>
                                <option value="14:00:00">14:00 WIB</option>
                            </select>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-semibold">Jam Selesai Praktik *</label>
                            <select name="jam_selesai" class="form-select" required>
                                <option value="12:00:00">12:00 WIB</option>
                                <option value="12:30:00">12:30 WIB</option>
                                <option value="13:00:00" selected>13:00 WIB</option>
                                <option value="14:00:00">14:00 WIB</option>
                                <option value="15:00:00">15:00 WIB</option>
                                <option value="16:00:00">16:00 WIB</option>
                                <option value="17:00:00">17:00 WIB</option>
                            </select>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Ruangan Poli *</label>
                        <select name="ruangan" class="form-select" required>
                            <option value="">-- Pilih Ruang Poliklinik --</option>
                            <option value="Poli Jiwa Dewasa 1">Poli Jiwa Dewasa 1</option>
                            <option value="Poli Jiwa Dewasa 2">Poli Jiwa Dewasa 2</option>
                            <option value="Poli Adiksi & Konseling">Poli Adiksi & Konseling</option>
                            <option value="Poli Anak & Remaja">Poli Anak & Remaja</option>
                            <option value="Poli Psikoterapi & Evaluasi">Poli Psikoterapi & Evaluasi</option>
                            <option value="Ruang Konsultasi Forensik">Ruang Konsultasi Forensik</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Jadwal</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
