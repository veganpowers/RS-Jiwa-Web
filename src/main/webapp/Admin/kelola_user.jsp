<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<%
    String status = request.getParameter("status");
    String msg = request.getParameter("msg");

    // Tangani aksi HAPUS user via GET langsung di halaman ini agar sederhana & pasti jalan
    String action = request.getParameter("action");
    String idUserStr = request.getParameter("id");
    if ("delete".equalsIgnoreCase(action) && idUserStr != null) {
        Connection connDel = null;
        PreparedStatement stmtDel = null;
        try {
            connDel = Koneksi.getConnection();
            stmtDel = connDel.prepareStatement("DELETE FROM users WHERE id = ?");
            stmtDel.setInt(1, Integer.parseInt(idUserStr.trim()));
            stmtDel.executeUpdate();
            response.sendRedirect(request.getContextPath() + "/Admin/kelola_user.jsp?msg=deleted");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (stmtDel != null) try { stmtDel.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(connDel);
        }
    }

    // Tangani aksi INSERT & UPDATE user via POST
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String formAction = request.getParameter("action");
        String idU = request.getParameter("id_user");
        String uName = request.getParameter("username");
        String uPass = request.getParameter("password");
        String uRole = request.getParameter("role");

        Connection connP = null;
        PreparedStatement stmtP = null;
        try {
            connP = Koneksi.getConnection();
            if ("update".equalsIgnoreCase(formAction) && idU != null) {
                if (uPass != null && !uPass.trim().isEmpty()) {
                    stmtP = connP.prepareStatement("UPDATE users SET username = ?, password = ?, role = ? WHERE id = ?");
                    stmtP.setString(1, uName);
                    stmtP.setString(2, uPass);
                    stmtP.setString(3, uRole);
                    stmtP.setInt(4, Integer.parseInt(idU.trim()));
                } else {
                    stmtP = connP.prepareStatement("UPDATE users SET username = ?, role = ? WHERE id = ?");
                    stmtP.setString(1, uName);
                    stmtP.setString(2, uRole);
                    stmtP.setInt(3, Integer.parseInt(idU.trim()));
                }
                stmtP.executeUpdate();
            } else {
                stmtP = connP.prepareStatement("INSERT INTO users (username, password, role) VALUES (?, ?, ?)");
                stmtP.setString(1, uName);
                stmtP.setString(2, uPass);
                stmtP.setString(3, uRole);
                stmtP.executeUpdate();
            }
            response.sendRedirect(request.getContextPath() + "/Admin/kelola_user.jsp?status=success");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (stmtP != null) try { stmtP.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(connP);
        }
    }
%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Pengguna Sistem - Admin RS ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/custom.css">
    
</head>
<body>
<div class="d-flex">
    <jsp:include page="inc_sidebar.jsp"><jsp:param name="active" value="user" /></jsp:include>
    <div class="main-content flex-grow-1 p-4">
        <jsp:include page="inc_topbar.jsp">
            <jsp:param name="title" value="Kelola Akun & Hak Akses Pengguna" />
            <jsp:param name="subtitle" value="Manajemen Kredensial Login Administrator, Medis, Petugas, dan Keluarga (CRUD)" />
        </jsp:include>

        <% if ("success".equals(status)) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-circle-check me-2"></i> Akun pengguna berhasil disimpan/diperbarui!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fa-solid fa-trash-can me-2"></i> Akun pengguna berhasil dihapus!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h6 class="m-0 fw-bold"><i class="fa-solid fa-users-gear me-2 text-primary"></i> Daftar Akun Pengguna Aktif</h6>
                <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#modalTambahUser">
                    <i class="fa-solid fa-user-plus me-1"></i> Buat Akun Baru
                </button>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>No</th>
                                <th>Username</th>
                                <th>Role / Hak Akses</th>
                                <th>Tanggal Dibuat</th>
                                <th class="text-center" style="width: 140px;">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                Connection connU = null;
                                Statement stmtU = null;
                                ResultSet rsU = null;
                                int noU = 0;
                                try {
                                    connU = Koneksi.getConnection();
                                    stmtU = connU.createStatement();
                                    rsU = stmtU.executeQuery("SELECT * FROM users ORDER BY id ASC");
                                    while (rsU.next()) {
                                        noU++;
                                        int idUser = rsU.getInt("id");
                                        String uname = rsU.getString("username");
                                        String role = rsU.getString("role");
                                        Timestamp tgl = rsU.getTimestamp("created_at");
                            %>
                            <tr>
                                <td><%= noU %></td>
                                <td><strong><%= uname %></strong></td>
                                <td><span class="badge bg-secondary text-uppercase"><%= role %></span></td>
                                <td><small class="text-muted"><%= (tgl != null) ? tgl.toString().substring(0, 16) : "-" %></small></td>
                                <td class="text-center">
                                    <button class="btn btn-sm btn-warning text-dark me-1" 
                                            onclick="editUser('<%= idUser %>', '<%= uname %>', '<%= role %>')">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <a href="kelola_user.jsp?action=delete&id=<%= idUser %>" 
                                       class="btn btn-sm btn-danger" 
                                       onclick="return confirm('Hapus akun <%= uname %>?')">
                                        <i class="fa-solid fa-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                    }
                                } catch (Exception e) {
                                    e.printStackTrace();
                                } finally {
                                    if (rsU != null) try { rsU.close(); } catch (SQLException ignored) {}
                                    if (stmtU != null) try { stmtU.close(); } catch (SQLException ignored) {}
                                    Koneksi.closeConnection(connU);
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MODAL TAMBAH USER -->
<div class="modal fade" id="modalTambahUser" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Tambah Akun Pengguna</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="kelola_user.jsp" method="POST">
                <input type="hidden" name="action" value="insert">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Username *</label>
                        <input type="text" name="username" class="form-control" placeholder="Contoh: dokter_citra" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Password *</label>
                        <input type="password" name="password" class="form-control" placeholder="Minimal 6 karakter" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Role Pengguna *</label>
                        <select name="role" class="form-select" required>
                            <option value="admin">Administrator (Super Admin)</option>
                            <option value="dokter">Dokter Spesialis Jiwa</option>
                            <option value="perawat">Perawat / Ners</option>
                            <option value="keluarga">Keluarga Pasien</option>
                            <option value="farmasi">Petugas Farmasi / Apotek</option>
                            <option value="kasir">Petugas Kasir / Billing</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-primary">Simpan Akun</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- MODAL EDIT USER -->
<div class="modal fade" id="modalEditUser" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold">Edit Akun Pengguna</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="kelola_user.jsp" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id_user" id="edit_id_user">
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Username *</label>
                        <input type="text" name="username" id="edit_username" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Password Baru</label>
                        <input type="password" name="password" class="form-control" placeholder="Kosongkan jika tidak ingin mengubah password">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Role Pengguna *</label>
                        <select name="role" id="edit_role" class="form-select" required>
                            <option value="admin">Administrator (Super Admin)</option>
                            <option value="dokter">Dokter Spesialis Jiwa</option>
                            <option value="perawat">Perawat / Ners</option>
                            <option value="keluarga">Keluarga Pasien</option>
                            <option value="farmasi">Petugas Farmasi / Apotek</option>
                            <option value="kasir">Petugas Kasir / Billing</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    <button type="submit" class="btn btn-warning text-dark">Update Akun</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function editUser(id, uname, role) {
        document.getElementById('edit_id_user').value = id;
        document.getElementById('edit_username').value = uname;
        document.getElementById('edit_role').value = role;
        var modal = new bootstrap.Modal(document.getElementById('modalEditUser'));
        modal.show();
    }
</script>
</body>
</html>
