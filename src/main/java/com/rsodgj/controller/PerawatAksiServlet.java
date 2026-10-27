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
 * PerawatAksiServlet - Menangani aksi operasional perawat:
 * - Pindah Kamar (action=pindah_kamar)
 * - Simpan TTV & Catatan Perilaku (action=simpan_ttv)
 * - Lapor Insiden Darurat (action=simpan_insiden)
 * - Verifikasi Izin Besuk Keluarga (action=setujui_besuk / tolak_besuk via GET & POST)
 */
@WebServlet({"/PerawatServlet", "/KamarServlet", "/PerawatAksiServlet"})
public class PerawatAksiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String idBesukStr = request.getParameter("id_besuk");

        if ("berikan_obat".equalsIgnoreCase(action)) {
            String idResepStr = request.getParameter("id");
            if (idResepStr != null && !idResepStr.trim().isEmpty()) {
                Connection conn = null;
                PreparedStatement stmt = null;
                try {
                    conn = Koneksi.getConnection();
                    int idResep = Integer.parseInt(idResepStr.trim());
                    stmt = conn.prepareStatement("UPDATE resep_obat SET status_tebus = 'Sudah Diberikan' WHERE id_resep = ?");
                    stmt.setInt(1, idResep);
                    stmt.executeUpdate();
                } catch (SQLException | NumberFormatException e) {
                    e.printStackTrace();
                } finally {
                    if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                    Koneksi.closeConnection(conn);
                }
            }
            response.sendRedirect(request.getContextPath() + "/Perawat/log_tindakan.jsp?status=sukses");
            return;
        }

        if (idBesukStr != null && !idBesukStr.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement stmt = null;
            try {
                conn = Koneksi.getConnection();
                int idBesuk = Integer.parseInt(idBesukStr.trim());
                if ("setujui_besuk".equalsIgnoreCase(action)) {
                    stmt = conn.prepareStatement("UPDATE jadwal_besuk SET status_izin = 'Disetujui Ners' WHERE id_besuk = ?");
                    stmt.setInt(1, idBesuk);
                    stmt.executeUpdate();
                } else if ("tolak_besuk".equalsIgnoreCase(action)) {
                    stmt = conn.prepareStatement("UPDATE jadwal_besuk SET status_izin = 'Ditolak' WHERE id_besuk = ?");
                    stmt.setInt(1, idBesuk);
                    stmt.executeUpdate();
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
            } finally {
                if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                Koneksi.closeConnection(conn);
            }
        }

        response.sendRedirect(request.getContextPath() + "/Perawat/verifikasi_besuk.jsp?status=sukses");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = Koneksi.getConnection();

            if ("pindah_kamar".equalsIgnoreCase(action)) {
                String idPasienStr = request.getParameter("id_pasien");
                String idKamarBaruStr = request.getParameter("id_kamar_baru");

                if (idPasienStr != null && !idPasienStr.trim().isEmpty()) {
                    int idPasien = Integer.parseInt(idPasienStr.trim());
                    Integer idKamarBaru = null;
                    if (idKamarBaruStr != null && !idKamarBaruStr.trim().isEmpty() && !"-".equals(idKamarBaruStr.trim())) {
                        idKamarBaru = Integer.parseInt(idKamarBaruStr.trim());
                    }

                    String sql = "UPDATE pasien SET id_kamar = ? WHERE id_pasien = ?";
                    stmt = conn.prepareStatement(sql);
                    if (idKamarBaru != null) {
                        stmt.setInt(1, idKamarBaru);
                    } else {
                        stmt.setNull(1, java.sql.Types.INTEGER);
                    }
                    stmt.setInt(2, idPasien);
                    stmt.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/Perawat/jadwal_jaga.jsp?status=pindah_sukses");
                return;

            } else if ("simpan_ttv".equalsIgnoreCase(action)) {
                String idPasienStr = request.getParameter("id_pasien");
                String statusPerilaku = request.getParameter("status_perilaku");

                if (idPasienStr != null && !idPasienStr.trim().isEmpty()) {
                    int idPasien = Integer.parseInt(idPasienStr.trim());
                    String sqlAgitasi = "UPDATE pasien SET tingkat_agitasi = ? WHERE id_pasien = ?";
                    stmt = conn.prepareStatement(sqlAgitasi);
                    String agitasiDB = "Tenang";
                    if (statusPerilaku != null && (statusPerilaku.contains("Gelisah") || statusPerilaku.contains("Agresif"))) {
                        agitasiDB = "Agitasi Berat / Gaduh Gelisah";
                    } else if (statusPerilaku != null && statusPerilaku.contains("Gelisah")) {
                        agitasiDB = "Gelisah Ringan";
                    }
                    stmt.setString(1, agitasiDB);
                    stmt.setInt(2, idPasien);
                    stmt.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/Perawat/pantau_kondisi_harian.jsp?status=sukses");
                return;

            } else if ("simpan_insiden".equalsIgnoreCase(action)) {
                String idPasienStr = request.getParameter("id_pasien");
                String waktu = request.getParameter("waktu");
                String jenisInsiden = request.getParameter("jenis_insiden");
                String kronologi = request.getParameter("kronologi");
                String penanganan = request.getParameter("penanganan");

                if (idPasienStr != null && !idPasienStr.trim().isEmpty()) {
                    int idPasien = Integer.parseInt(idPasienStr.trim());
                    String sql = "INSERT INTO insiden_darurat (id_pasien, id_perawat, waktu_kejadian, jenis_insiden, deskripsi, tindakan_deeskalasi, tingkat_keparahan, status_penanganan) " +
                                 "VALUES (?, 1, ?, ?, ?, ?, 'Sedang', 'Observasi Ketat')";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, idPasien);
                    stmt.setString(2, (waktu != null && !waktu.isEmpty()) ? (waktu.replace("T", " ") + ":00") : "2026-10-26 10:00:00");
                    stmt.setString(3, jenisInsiden != null ? jenisInsiden : "Gaduh Gelisah");
                    stmt.setString(4, kronologi != null ? kronologi : "-");
                    stmt.setString(5, penanganan != null ? penanganan : "Fiksasi Fisik");
                    stmt.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/Perawat/insiden_darurat.jsp?status=sukses");
                return;
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(conn);
        }

        response.sendRedirect(request.getContextPath() + "/Perawat/dashboard.jsp");
    }
}
