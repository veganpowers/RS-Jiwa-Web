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

/**
 * TagihanServlet - Menangani penerbitan tagihan kasir dan pembayaran invoice
 */
@WebServlet("/TagihanServlet")
public class TagihanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String kodeTagihan = request.getParameter("no");

        if ("bayar".equalsIgnoreCase(action) && kodeTagihan != null) {
            Connection conn = null;
            PreparedStatement stmt = null;
            try {
                conn = Koneksi.getConnection();
                String sql = "UPDATE tagihan_pembayaran SET status_pembayaran = 'Lunas', tgl_pembayaran = CURRENT_TIMESTAMP WHERE kode_tagihan = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, kodeTagihan.trim());
                stmt.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                Koneksi.closeConnection(conn);
            }
        }
        
        String referer = request.getHeader("referer");
        if (referer != null && referer.contains("Kasir")) {
            response.sendRedirect(request.getContextPath() + "/Kasir/tagihan_perawatan.jsp?status=sukses");
        } else {
            response.sendRedirect(request.getContextPath() + "/Admin/kelola_tagihan.jsp?status=sukses");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("insert".equalsIgnoreCase(action)) {
            String idPasienStr = request.getParameter("id_pasien");
            String penjamin = request.getParameter("penjamin");
            String rincian = request.getParameter("rincian_biaya");
            String totalStr = request.getParameter("total");

            if (idPasienStr != null && !idPasienStr.trim().isEmpty()) {
                Connection conn = null;
                PreparedStatement stmt = null;
                try {
                    conn = Koneksi.getConnection();
                    int idPasien = Integer.parseInt(idPasienStr.trim());
                    double total = 0;
                    if (totalStr != null && !totalStr.trim().isEmpty()) {
                        total = Double.parseDouble(totalStr.trim());
                    }
                    String kodeTagihan = "INV-" + (System.currentTimeMillis() % 1000000);

                    String statusAwal = "Belum Lunas";
                    if (penjamin != null && penjamin.contains("BPJS")) {
                        statusAwal = "Jaminan BPJS / Dinsos";
                    }

                    String sql = "INSERT INTO tagihan_pembayaran (kode_tagihan, id_pasien, total_biaya_kamar, total_biaya_obat, total_biaya_tindakan, total_akhir, status_pembayaran, keterangan) " +
                                 "VALUES (?, ?, 0, 0, 0, ?, ?, ?)";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, kodeTagihan);
                    stmt.setInt(2, idPasien);
                    stmt.setDouble(3, total);
                    stmt.setString(4, statusAwal);
                    stmt.setString(5, (penjamin != null ? ("[" + penjamin + "] ") : "") + (rincian != null ? rincian : "Biaya Perawatan"));
                    stmt.executeUpdate();

                } catch (SQLException | NumberFormatException e) {
                    e.printStackTrace();
                } finally {
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    Koneksi.closeConnection(conn);
                }
            }
        }

        String referer = request.getHeader("referer");
        if (referer != null && referer.contains("Kasir")) {
            response.sendRedirect(request.getContextPath() + "/Kasir/tagihan_perawatan.jsp?status=sukses");
        } else {
            response.sendRedirect(request.getContextPath() + "/Admin/kelola_tagihan.jsp?status=sukses");
        }
    }
}
