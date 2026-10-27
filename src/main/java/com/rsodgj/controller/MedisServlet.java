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
 * MedisServlet - Menangani aksi medis Dokter:
 * - Diagnosa & Rekam Medis (/DiagnosaServlet)
 * - Resep Obat Jiwa (/ResepServlet)
 */
@WebServlet({"/DiagnosaServlet", "/ResepServlet"})
public class MedisServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String servletPath = request.getServletPath();

        HttpSession session = request.getSession(false);
        Integer userId = (session != null) ? (Integer) session.getAttribute("userId") : null;

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = Koneksi.getConnection();

            if (servletPath != null && servletPath.contains("DiagnosaServlet")) {
                // Form Diagnosa
                String idPasienStr = request.getParameter("id_pasien");
                String tanggal = request.getParameter("tanggal");
                String keluhan = request.getParameter("keluhan");
                String diagnosa = request.getParameter("diagnosa");
                String rencana = request.getParameter("rencana");
                String catatan = request.getParameter("catatan_keamanan");

                if (idPasienStr != null && !idPasienStr.trim().isEmpty()) {
                    int idPasien = Integer.parseInt(idPasienStr.trim());
                    String sql = "INSERT INTO rekam_medis (id_pasien, id_dokter, tgl_periksa, keluhan_utama, diagnosa_utama, rencana_terapi, catatan_keamanan) " +
                                 "VALUES (?, 1, ?, ?, ?, ?, ?)";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, idPasien);
                    stmt.setString(2, (tanggal != null && !tanggal.isEmpty()) ? (tanggal + " 08:00:00") : "2026-10-26 08:00:00");
                    stmt.setString(3, keluhan != null ? keluhan : "-");
                    stmt.setString(4, diagnosa != null ? diagnosa : "-");
                    stmt.setString(5, rencana != null ? rencana : "-");
                    stmt.setString(6, catatan != null ? catatan : "-");
                    stmt.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/Dokter/input_diagnosa.jsp?status=sukses");
                return;

            } else if (servletPath != null && servletPath.contains("ResepServlet")) {
                // Form Resep Obat
                String idPasienStr = request.getParameter("id_pasien");
                String idObatStr = request.getParameter("id_obat");
                String jumlahStr = request.getParameter("jumlah");
                String aturan = request.getParameter("aturan_minum");
                String catatan = request.getParameter("catatan");

                if (idPasienStr != null && !idPasienStr.trim().isEmpty() &&
                    idObatStr != null && !idObatStr.trim().isEmpty()) {
                    int idPasien = Integer.parseInt(idPasienStr.trim());
                    int idObat = Integer.parseInt(idObatStr.trim());
                    int jumlah = 1;
                    if (jumlahStr != null && !jumlahStr.trim().isEmpty()) {
                        jumlah = Integer.parseInt(jumlahStr.trim());
                    }

                    String sql = "INSERT INTO resep_obat (id_pasien, id_dokter, id_obat, jumlah, aturan_pakai, catatan_resep, status_tebus) " +
                                 "VALUES (?, 1, ?, ?, ?, ?, 'Menunggu')";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, idPasien);
                    stmt.setInt(2, idObat);
                    stmt.setInt(3, jumlah);
                    stmt.setString(4, (aturan != null && !aturan.trim().isEmpty()) ? aturan : "1x1 tablet");
                    stmt.setString(5, catatan != null ? catatan : "-");
                    stmt.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/Dokter/resep_obat.jsp?status=sukses");
                return;
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(conn);
        }

        response.sendRedirect(request.getContextPath() + "/Dokter/dashboard.jsp");
    }
}

