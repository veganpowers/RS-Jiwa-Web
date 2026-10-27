package com.rsodgj.controller;

import com.rsodgj.config.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * PasienServlet - Mengelola operasi CRUD data pasien RS ODGJ
 * Menggunakan HttpServlet murni dan PreparedStatement JDBC dasar.
 */
@WebServlet("/PasienServlet")
public class PasienServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * READ & DELETE (via URL query param)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        if ("delete".equalsIgnoreCase(action)) {
            // Operasi DELETE
            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                Connection conn = null;
                PreparedStatement stmt = null;
                try {
                    conn = Koneksi.getConnection();
                    // Hapus relasi keluarga terlebih dahulu jika ada
                    PreparedStatement stmtKeluarga = conn.prepareStatement("DELETE FROM keluarga_pasien WHERE id_pasien = ?");
                    stmtKeluarga.setInt(1, Integer.parseInt(idStr.trim()));
                    stmtKeluarga.executeUpdate();
                    stmtKeluarga.close();

                    // Hapus pasien
                    String sql = "DELETE FROM pasien WHERE id_pasien = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(idStr.trim()));
                    stmt.executeUpdate();
                } catch (SQLException | NumberFormatException e) {
                    e.printStackTrace();
                } finally {
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    Koneksi.closeConnection(conn);
                }
            }
            // Redirect kembali ke halaman tabel pasien setelah hapus
            String redirectFrom = request.getParameter("from");
            if ("perawat".equalsIgnoreCase(redirectFrom)) {
                response.sendRedirect(request.getContextPath() + "/Perawat/pendaftaran_pasien.jsp?msg=deleted");
            } else {
                response.sendRedirect(request.getContextPath() + "/Admin/data_pasien.jsp?msg=deleted");
            }
            return;
        }

        // Operasi READ / List Data Pasien
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Map<String, Object>> listPasien = new ArrayList<>();

        try {
            conn = Koneksi.getConnection();
            String sql = "SELECT p.*, k.nama_kamar, kp.nama_wali, kp.no_telp AS kontak_wali " +
                         "FROM pasien p " +
                         "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                         "LEFT JOIN keluarga_pasien kp ON p.id_pasien = kp.id_pasien " +
                         "ORDER BY p.id_pasien DESC";
            stmt = conn.prepareStatement(sql);
            rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> p = new HashMap<>();
                p.put("id_pasien", rs.getInt("id_pasien"));
                p.put("no_rekam_medis", rs.getString("no_rekam_medis"));
                p.put("nama", rs.getString("nama"));
                p.put("nik", rs.getString("nik"));
                p.put("jenis_kelamin", rs.getString("jenis_kelamin"));
                p.put("tgl_lahir", rs.getString("tgl_lahir"));
                p.put("alamat", rs.getString("alamat"));
                p.put("status_perawatan", rs.getString("status_perawatan"));
                p.put("tingkat_agitasi", rs.getString("tingkat_agitasi"));
                p.put("nama_kamar", rs.getString("nama_kamar"));
                p.put("kontak_wali", rs.getString("kontak_wali"));
                p.put("nama_wali", rs.getString("nama_wali"));
                listPasien.add(p);
            }
            request.setAttribute("listPasien", listPasien);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(conn);
        }

        // Teruskan ke JSP sesuai asal request
        String view = request.getParameter("view");
        if ("perawat".equalsIgnoreCase(view)) {
            request.getRequestDispatcher("/Perawat/pendaftaran_pasien.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/Admin/data_pasien.jsp").forward(request, response);
        }
    }

    /**
     * CREATE & UPDATE (via Form POST)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "insert";
        }

        // Ambil data input dari Form
        String idStr = request.getParameter("id_pasien");
        String noRm = request.getParameter("no_rm");
        String nik = request.getParameter("nik");
        String nama = request.getParameter("nama_pasien");
        String jk = request.getParameter("jenis_kelamin");
        String statusRawat = request.getParameter("status_rawat");
        String kamarVal = request.getParameter("nomor_kamar");
        String kontakWali = request.getParameter("kontak_wali");
        String alamat = request.getParameter("alamat");
        String tglLahir = request.getParameter("tgl_lahir");
        String agitasi = request.getParameter("tingkat_agitasi");
        String source = request.getParameter("source"); // "admin" atau "perawat"

        // Normalisasi format enum jenis_kelamin
        if ("L".equalsIgnoreCase(jk) || "Laki-laki".equalsIgnoreCase(jk)) {
            jk = "Laki-laki";
        } else {
            jk = "Perempuan";
        }

        // Normalisasi enum status_perawatan: 'Rawat Inap','Rawat Jalan','Isolasi Khusus','Selesai'
        if (statusRawat == null || statusRawat.trim().isEmpty()) {
            statusRawat = "Rawat Inap";
        }

        // Normalisasi enum tingkat_agitasi: 'Tenang','Gelisah Ringan','Agitasi Berat / Gaduh Gelisah'
        if (agitasi == null || agitasi.trim().isEmpty()) {
            agitasi = "Tenang";
        }
        if (tglLahir == null || tglLahir.trim().isEmpty()) {
            tglLahir = "1995-01-01";
        }
        if (alamat == null || alamat.trim().isEmpty()) {
            alamat = "-";
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = Koneksi.getConnection();

            // Cari id_kamar jika ada input kamar
            Integer idKamar = null;
            if (kamarVal != null && !kamarVal.trim().isEmpty() && !"-".equals(kamarVal.trim())) {
                try {
                    // Coba parse jika form mengirim id_kamar berupa integer
                    idKamar = Integer.parseInt(kamarVal.trim());
                } catch (NumberFormatException e) {
                    // Jika form mengirim nama atau teks kamar, cari dari DB
                    String qKamar = "SELECT id_kamar FROM kamar WHERE nama_kamar LIKE ? LIMIT 1";
                    PreparedStatement stmtKamar = conn.prepareStatement(qKamar);
                    stmtKamar.setString(1, "%" + kamarVal.trim() + "%");
                    ResultSet rsK = stmtKamar.executeQuery();
                    if (rsK.next()) {
                        idKamar = rsK.getInt("id_kamar");
                    }
                    rsK.close();
                    stmtKamar.close();
                }
            }

            if ("update".equalsIgnoreCase(action)) {
                // Operasi UPDATE
                String sql = "UPDATE pasien SET nik = ?, nama = ?, jenis_kelamin = ?, status_perawatan = ?, " +
                             "tingkat_agitasi = ?, id_kamar = ? WHERE id_pasien = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, nik);
                stmt.setString(2, nama);
                stmt.setString(3, jk);
                stmt.setString(4, statusRawat);
                stmt.setString(5, agitasi);
                if (idKamar != null) {
                    stmt.setInt(6, idKamar);
                } else {
                    stmt.setNull(6, java.sql.Types.INTEGER);
                }
                stmt.setInt(7, Integer.parseInt(idStr.trim()));
                stmt.executeUpdate();

                // Simpan atau update kontak keluarga jika ada
                if (kontakWali != null && !kontakWali.trim().isEmpty()) {
                    String sqlCheckWali = "SELECT id_keluarga FROM keluarga_pasien WHERE id_pasien = ?";
                    PreparedStatement stmtC = conn.prepareStatement(sqlCheckWali);
                    stmtC.setInt(1, Integer.parseInt(idStr.trim()));
                    ResultSet rsC = stmtC.executeQuery();
                    if (rsC.next()) {
                        PreparedStatement stmtUpdWali = conn.prepareStatement("UPDATE keluarga_pasien SET no_telp = ? WHERE id_pasien = ?");
                        stmtUpdWali.setString(1, kontakWali);
                        stmtUpdWali.setInt(2, Integer.parseInt(idStr.trim()));
                        stmtUpdWali.executeUpdate();
                        stmtUpdWali.close();
                    } else {
                        PreparedStatement stmtInsWali = conn.prepareStatement("INSERT INTO keluarga_pasien (id_pasien, nama_wali, hubungan, no_telp) VALUES (?, 'Wali Pasien', 'Keluarga', ?)");
                        stmtInsWali.setInt(1, Integer.parseInt(idStr.trim()));
                        stmtInsWali.setString(2, kontakWali);
                        stmtInsWali.executeUpdate();
                        stmtInsWali.close();
                    }
                    rsC.close();
                    stmtC.close();
                }

            } else {
                // Operasi CREATE / INSERT
                if (noRm == null || noRm.trim().isEmpty()) {
                    noRm = "RM-2026-" + (System.currentTimeMillis() % 9000 + 1000);
                }

                String sql = "INSERT INTO pasien (no_rekam_medis, nama, nik, jenis_kelamin, tgl_lahir, alamat, " +
                             "status_perawatan, tingkat_agitasi, id_kamar, id_dokter_dpjp) " +
                             "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 1)";
                stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                stmt.setString(1, noRm);
                stmt.setString(2, nama);
                stmt.setString(3, nik);
                stmt.setString(4, jk);
                stmt.setString(5, tglLahir);
                stmt.setString(6, alamat);
                stmt.setString(7, statusRawat);
                stmt.setString(8, agitasi);
                if (idKamar != null) {
                    stmt.setInt(9, idKamar);
                } else {
                    stmt.setNull(9, java.sql.Types.INTEGER);
                }
                stmt.executeUpdate();

                rs = stmt.getGeneratedKeys();
                int newPasienId = 0;
                if (rs.next()) {
                    newPasienId = rs.getInt(1);
                }

                // Tambahkan data keluarga ke tabel keluarga_pasien
                if (newPasienId > 0 && kontakWali != null && !kontakWali.trim().isEmpty()) {
                    String sqlWali = "INSERT INTO keluarga_pasien (id_pasien, nama_wali, hubungan, no_telp) " +
                                     "VALUES (?, 'Wali Pasien', 'Keluarga', ?)";
                    PreparedStatement stmtWali = conn.prepareStatement(sqlWali);
                    stmtWali.setInt(1, newPasienId);
                    stmtWali.setString(2, kontakWali);
                    stmtWali.executeUpdate();
                    stmtWali.close();
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(conn);
        }

        // Redirect sukses kembali ke halaman asal
        if ("perawat".equalsIgnoreCase(source)) {
            response.sendRedirect(request.getContextPath() + "/Perawat/pendaftaran_pasien.jsp?status=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/Admin/data_pasien.jsp?status=success");
        }
    }
}
