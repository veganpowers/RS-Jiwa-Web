package com.rsodgj.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.rsodgj.config.Koneksi;

@WebServlet("/FarmasiServlet")
public class FarmasiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idResepStr = request.getParameter("id");

        if (idResepStr != null && !idResepStr.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement stmt = null;
            PreparedStatement stmtObat = null;
            PreparedStatement stmtCheck = null;
            ResultSet rsCheck = null;

            try {
                conn = Koneksi.getConnection();
                int idResep = Integer.parseInt(idResepStr.trim());

                if ("racik".equalsIgnoreCase(action)) {
                    // Update status jadi 'Diproses Farmasi'
                    String sql = "UPDATE resep_obat SET status_tebus = 'Diproses Farmasi' WHERE id_resep = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, idResep);
                    stmt.executeUpdate();
                } else if ("serahkan".equalsIgnoreCase(action)) {
                    // Cek id_obat dan jumlah di resep
                    String sqlCheck = "SELECT id_obat, jumlah, status_tebus FROM resep_obat WHERE id_resep = ?";
                    stmtCheck = conn.prepareStatement(sqlCheck);
                    stmtCheck.setInt(1, idResep);
                    rsCheck = stmtCheck.executeQuery();

                    if (rsCheck.next()) {
                        int idObat = rsCheck.getInt("id_obat");
                        int jumlah = rsCheck.getInt("jumlah");
                        String currentStatus = rsCheck.getString("status_tebus");

                        // Update status resep jadi 'Sudah Diambil'
                        String sqlUpdate = "UPDATE resep_obat SET status_tebus = 'Sudah Diambil' WHERE id_resep = ?";
                        stmt = conn.prepareStatement(sqlUpdate);
                        stmt.setInt(1, idResep);
                        stmt.executeUpdate();

                        // Kurangi stok obat jika sebelumnya belum diambil/diserahkan
                        if (!"Sudah Diambil".equalsIgnoreCase(currentStatus) && !"Sudah Diberikan".equalsIgnoreCase(currentStatus)) {
                            String sqlObat = "UPDATE obat SET stok = GREATEST(0, stok - ?) WHERE id_obat = ?";
                            stmtObat = conn.prepareStatement(sqlObat);
                            stmtObat.setInt(1, jumlah);
                            stmtObat.setInt(2, idObat);
                            stmtObat.executeUpdate();
                        }
                    }
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
            } finally {
                if (rsCheck != null) try { rsCheck.close(); } catch (SQLException ignored) {}
                if (stmtCheck != null) try { stmtCheck.close(); } catch (SQLException ignored) {}
                if (stmtObat != null) try { stmtObat.close(); } catch (SQLException ignored) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                Koneksi.closeConnection(conn);
            }
        }

        response.sendRedirect(request.getContextPath() + "/Farmasi_Apotek/antrian_resep.jsp?status=sukses");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
