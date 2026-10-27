package com.rsodgj.controller;

import com.rsodgj.config.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * RegisterKeluargaServlet - Menangani pendaftaran akun keluarga pasien ODGJ
 * Akun ditautkan ke pasien berdasarkan NIK atau No. Rekam Medis.
 */
@WebServlet("/RegisterKeluargaServlet")
public class RegisterKeluargaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String namaWali = request.getParameter("nama");
        String nikPasien = request.getParameter("nik_pasien");
        String noTelp = request.getParameter("no_telp");
        String hubungan = request.getParameter("hubungan");

        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            namaWali == null || namaWali.trim().isEmpty() ||
            nikPasien == null || nikPasien.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/register_keluarga.jsp?error=empty_fields");
            return;
        }

        if (hubungan == null || hubungan.trim().isEmpty()) {
            hubungan = "Keluarga / Wali";
        }
        if (noTelp == null || noTelp.trim().isEmpty()) {
            noTelp = "-";
        }

        Connection conn = null;
        PreparedStatement stmtUser = null;
        PreparedStatement stmtCekPasien = null;
        PreparedStatement stmtKeluarga = null;
        ResultSet rsPasien = null;
        ResultSet rsUserKey = null;

        try {
            conn = Koneksi.getConnection();

            // 1. Cari pasien berdasarkan NIK atau No. RM secara presisi
            String qCekPasien = "SELECT id_pasien, nama, no_rekam_medis FROM pasien WHERE nik = ? OR no_rekam_medis = ? LIMIT 1";
            stmtCekPasien = conn.prepareStatement(qCekPasien);
            stmtCekPasien.setString(1, nikPasien.trim());
            stmtCekPasien.setString(2, nikPasien.trim());
            rsPasien = stmtCekPasien.executeQuery();

            if (!rsPasien.next()) {
                response.sendRedirect(request.getContextPath() + "/register_keluarga.jsp?error=pasien_not_found");
                return;
            }
            int idPasien = rsPasien.getInt("id_pasien");

            // 2. Cek apakah username sudah ada
            PreparedStatement stmtCekUser = conn.prepareStatement("SELECT id FROM users WHERE username = ?");
            stmtCekUser.setString(1, username.trim());
            ResultSet rsUserAda = stmtCekUser.executeQuery();
            if (rsUserAda.next()) {
                rsUserAda.close();
                stmtCekUser.close();
                response.sendRedirect(request.getContextPath() + "/register_keluarga.jsp?error=username_exists");
                return;
            }
            rsUserAda.close();
            stmtCekUser.close();

            // 3. Simpan ke tabel users
            String sqlUser = "INSERT INTO users (username, password, role) VALUES (?, ?, 'keluarga')";
            stmtUser = conn.prepareStatement(sqlUser, Statement.RETURN_GENERATED_KEYS);
            stmtUser.setString(1, username.trim());
            stmtUser.setString(2, password.trim());
            stmtUser.executeUpdate();

            rsUserKey = stmtUser.getGeneratedKeys();
            int newUserId = 0;
            if (rsUserKey.next()) {
                newUserId = rsUserKey.getInt(1);
            }

            // 4. Hubungkan id_user dengan id_pasien di tabel keluarga_pasien
            // Cek apakah relasi keluarga untuk pasien ini sudah ada tanpa id_user
            PreparedStatement stmtCekK = conn.prepareStatement("SELECT id_keluarga FROM keluarga_pasien WHERE id_pasien = ? LIMIT 1");
            stmtCekK.setInt(1, idPasien);
            ResultSet rsK = stmtCekK.executeQuery();
            if (rsK.next()) {
                int idKeluargaAda = rsK.getInt("id_keluarga");
                String sqlUpd = "UPDATE keluarga_pasien SET id_user = ?, nama_wali = ?, hubungan = ?, no_telp = ? WHERE id_keluarga = ?";
                PreparedStatement stmtUpd = conn.prepareStatement(sqlUpd);
                stmtUpd.setInt(1, newUserId);
                stmtUpd.setString(2, namaWali.trim());
                stmtUpd.setString(3, hubungan.trim());
                stmtUpd.setString(4, noTelp.trim());
                stmtUpd.setInt(5, idKeluargaAda);
                stmtUpd.executeUpdate();
                stmtUpd.close();
            } else {
                String sqlIns = "INSERT INTO keluarga_pasien (id_pasien, id_user, nama_wali, hubungan, no_telp) VALUES (?, ?, ?, ?, ?)";
                stmtKeluarga = conn.prepareStatement(sqlIns);
                stmtKeluarga.setInt(1, idPasien);
                stmtKeluarga.setInt(2, newUserId);
                stmtKeluarga.setString(3, namaWali.trim());
                stmtKeluarga.setString(4, hubungan.trim());
                stmtKeluarga.setString(5, noTelp.trim());
                stmtKeluarga.executeUpdate();
            }
            rsK.close();
            stmtCekK.close();

            response.sendRedirect(request.getContextPath() + "/index.jsp?status=reg_success");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/register_keluarga.jsp?error=db_error");
        } finally {
            if (rsPasien != null) try { rsPasien.close(); } catch (SQLException ignored) {}
            if (rsUserKey != null) try { rsUserKey.close(); } catch (SQLException ignored) {}
            if (stmtCekPasien != null) try { stmtCekPasien.close(); } catch (SQLException ignored) {}
            if (stmtUser != null) try { stmtUser.close(); } catch (SQLException ignored) {}
            if (stmtKeluarga != null) try { stmtKeluarga.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(conn);
        }
    }
}
