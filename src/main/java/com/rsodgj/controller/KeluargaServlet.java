package com.rsodgj.controller;

import com.rsodgj.config.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * KeluargaServlet - Menangani pengajuan izin besuk dari keluarga pasien
 */
@WebServlet("/KeluargaServlet")
public class KeluargaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("daftar_besuk".equalsIgnoreCase(action) || action == null || action.trim().isEmpty()) {
            String idPasienStr = request.getParameter("id_pasien");
            String tanggal = request.getParameter("tanggal");
            String sesi = request.getParameter("sesi");
            String namaPengunjung = request.getParameter("nama_pengunjung");
            String jumlahStr = request.getParameter("jumlah");

            HttpSession session = request.getSession(false);
            Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

            if (idPasienStr != null && !idPasienStr.trim().isEmpty() &&
                tanggal != null && !tanggal.trim().isEmpty()) {

                Connection conn = null;
                PreparedStatement stmt = null;
                try {
                    conn = Koneksi.getConnection();
                    int idPasien = Integer.parseInt(idPasienStr.trim());
                    int jumlah = 1;
                    if (jumlahStr != null && !jumlahStr.trim().isEmpty()) {
                        jumlah = Integer.parseInt(jumlahStr.trim());
                    }

                    // Status awal izin adalah 'Menunggu Persetujuan' (harus disetujui oleh perawat)
                    String sql = "INSERT INTO jadwal_besuk (id_pasien, id_user, tanggal_besuk, sesi_waktu, nama_pengunjung, jumlah_keluarga, status_izin) " +
                                 "VALUES (?, ?, ?, ?, ?, ?, 'Menunggu Persetujuan')";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, idPasien);
                    if (userId != null) {
                        stmt.setInt(2, userId);
                    } else {
                        stmt.setNull(2, java.sql.Types.INTEGER);
                    }
                    stmt.setString(3, tanggal);
                    stmt.setString(4, sesi != null ? sesi : "Sesi Siang (10:00 - 11:30 WIB)");
                    stmt.setString(5, namaPengunjung != null ? namaPengunjung : "Keluarga Pasien");
                    stmt.setInt(6, jumlah);
                    stmt.executeUpdate();

                } catch (SQLException | NumberFormatException e) {
                    e.printStackTrace();
                    response.sendRedirect(request.getContextPath() + "/Keluarga/jadwal_besuk.jsp?error=db_error");
                    return;
                } finally {
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    Koneksi.closeConnection(conn);
                }
            }
            response.sendRedirect(request.getContextPath() + "/Keluarga/jadwal_besuk.jsp?status=sukses");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/Keluarga/dashboard.jsp");
    }
}
