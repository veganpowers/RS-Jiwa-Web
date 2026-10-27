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
 * AdminCrudServlet - Menangani operasi CRUD terpusat untuk Data Master Administrator:
 * - /DokterServlet (CRUD Dokter)
 * - /PerawatAdminServlet (CRUD Perawat)
 * - /KamarDataServlet (CRUD Kamar)
 * - /ObatServlet (CRUD Obat)
 */
@WebServlet({"/DokterServlet", "/PerawatAdminServlet", "/KamarDataServlet", "/ObatServlet"})
public class AdminCrudServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String servletPath = request.getServletPath();
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if ("delete".equalsIgnoreCase(action) && idStr != null && !idStr.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement stmt = null;
            try {
                conn = Koneksi.getConnection();
                int id = Integer.parseInt(idStr.trim());

                if (servletPath.contains("DokterServlet")) {
                    stmt = conn.prepareStatement("DELETE FROM dokter WHERE id_dokter = ?");
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                    response.sendRedirect(request.getContextPath() + "/Admin/data_dokter.jsp?msg=deleted");
                    return;
                } else if (servletPath.contains("PerawatAdminServlet")) {
                    stmt = conn.prepareStatement("DELETE FROM perawat WHERE id_perawat = ?");
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                    response.sendRedirect(request.getContextPath() + "/Admin/data_perawat.jsp?msg=deleted");
                    return;
                } else if (servletPath.contains("KamarDataServlet")) {
                    stmt = conn.prepareStatement("DELETE FROM kamar WHERE id_kamar = ?");
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                    response.sendRedirect(request.getContextPath() + "/Admin/data_kamar_isolasi.jsp?msg=deleted");
                    return;
                } else if (servletPath.contains("ObatServlet")) {
                    stmt = conn.prepareStatement("DELETE FROM obat WHERE id_obat = ?");
                    stmt.setInt(1, id);
                    stmt.executeUpdate();
                    response.sendRedirect(request.getContextPath() + "/Admin/kelola_obat.jsp?msg=deleted");
                    return;
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
            } finally {
                if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                Koneksi.closeConnection(conn);
            }
        }

        response.sendRedirect(request.getContextPath() + "/Admin/dashboard.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String servletPath = request.getServletPath();
        String action = request.getParameter("action");
        if (action == null) action = "insert";

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = Koneksi.getConnection();

            if (servletPath.contains("DokterServlet")) {
                // CRUD DOKTER
                String idStr = request.getParameter("id_dokter");
                String nama = request.getParameter("nama_dokter");
                String sip = request.getParameter("sip");
                String spesialisasi = request.getParameter("spesialisasi");
                String noHp = request.getParameter("no_hp");
                String email = request.getParameter("email");

                if ("update".equalsIgnoreCase(action) && idStr != null) {
                    stmt = conn.prepareStatement("UPDATE dokter SET nama_dokter = ?, no_str = ?, spesialisasi = ?, no_telp = ?, email = ? WHERE id_dokter = ?");
                    stmt.setString(1, nama);
                    stmt.setString(2, sip);
                    stmt.setString(3, spesialisasi);
                    stmt.setString(4, noHp);
                    stmt.setString(5, email);
                    stmt.setInt(6, Integer.parseInt(idStr.trim()));
                    stmt.executeUpdate();
                } else {
                    stmt = conn.prepareStatement("INSERT INTO dokter (nama_dokter, no_str, spesialisasi, no_telp, email) VALUES (?, ?, ?, ?, ?)");
                    stmt.setString(1, nama);
                    stmt.setString(2, sip != null ? sip : "STR-" + System.currentTimeMillis() % 100000);
                    stmt.setString(3, spesialisasi);
                    stmt.setString(4, noHp);
                    stmt.setString(5, email != null ? email : "-");
                    stmt.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/Admin/data_dokter.jsp?status=success");
                return;

            } else if (servletPath.contains("PerawatAdminServlet")) {
                // CRUD PERAWAT
                String idStr = request.getParameter("id_perawat");
                String nama = request.getParameter("nama_perawat");
                String nira = request.getParameter("nira");
                String ruangan = request.getParameter("ruangan");
                String noHp = request.getParameter("no_hp");

                if ("update".equalsIgnoreCase(action) && idStr != null) {
                    stmt = conn.prepareStatement("UPDATE perawat SET nama_perawat = ?, no_str = ?, ruang_jaga = ?, no_telp = ? WHERE id_perawat = ?");
                    stmt.setString(1, nama);
                    stmt.setString(2, nira);
                    stmt.setString(3, ruangan);
                    stmt.setString(4, noHp);
                    stmt.setInt(5, Integer.parseInt(idStr.trim()));
                    stmt.executeUpdate();
                } else {
                    stmt = conn.prepareStatement("INSERT INTO perawat (nama_perawat, no_str, kualifikasi, ruang_jaga, no_telp) VALUES (?, ?, 'S.Kep., Ns', ?, ?)");
                    stmt.setString(1, nama);
                    stmt.setString(2, nira != null ? nira : "NIRA-" + System.currentTimeMillis() % 100000);
                    stmt.setString(3, ruangan);
                    stmt.setString(4, noHp);
                    stmt.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/Admin/data_perawat.jsp?status=success");
                return;

            } else if (servletPath.contains("KamarDataServlet")) {
                // CRUD KAMAR
                String idStr = request.getParameter("id_kamar");
                String nama = request.getParameter("nama_kamar");
                String tipe = request.getParameter("tipe_kamar");
                String kapasitasStr = request.getParameter("kapasitas");

                int kapasitas = 1;
                if (kapasitasStr != null && !kapasitasStr.trim().isEmpty()) {
                    kapasitas = Integer.parseInt(kapasitasStr.trim());
                }

                String jenisDb = "isolasi";
                if (tipe != null && tipe.toLowerCase().contains("reguler")) {
                    jenisDb = "reguler";
                } else if (tipe != null && tipe.toLowerCase().contains("vip")) {
                    jenisDb = "vip_jiwa";
                }

                if ("update".equalsIgnoreCase(action) && idStr != null) {
                    stmt = conn.prepareStatement("UPDATE kamar SET nama_kamar = ?, jenis = ?, kapasitas = ? WHERE id_kamar = ?");
                    stmt.setString(1, nama);
                    stmt.setString(2, jenisDb);
                    stmt.setInt(3, kapasitas);
                    stmt.setInt(4, Integer.parseInt(idStr.trim()));
                    stmt.executeUpdate();
                } else {
                    stmt = conn.prepareStatement("INSERT INTO kamar (nama_kamar, jenis, kapasitas, terisi, tarif_per_hari) VALUES (?, ?, ?, 0, 150000)");
                    stmt.setString(1, nama);
                    stmt.setString(2, jenisDb);
                    stmt.setInt(3, kapasitas);
                    stmt.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/Admin/data_kamar_isolasi.jsp?status=success");
                return;

            } else if (servletPath.contains("ObatServlet")) {
                // CRUD OBAT
                String idStr = request.getParameter("id_obat");
                String nama = request.getParameter("nama_obat");
                String kategori = request.getParameter("kategori");
                String sediaan = request.getParameter("bentuk_sediaan");
                String stokStr = request.getParameter("stok");
                String hargaStr = request.getParameter("harga");

                int stok = 0;
                if (stokStr != null && !stokStr.trim().isEmpty()) stok = Integer.parseInt(stokStr.trim());
                double harga = 0;
                if (hargaStr != null && !hargaStr.trim().isEmpty()) harga = Double.parseDouble(hargaStr.trim());

                if ("update".equalsIgnoreCase(action) && idStr != null) {
                    stmt = conn.prepareStatement("UPDATE obat SET nama_obat = ?, kategori = ?, bentuk_sediaan = ?, stok = ?, harga = ? WHERE id_obat = ?");
                    stmt.setString(1, nama);
                    stmt.setString(2, kategori != null ? kategori : "Antipsikotik Atipikal");
                    stmt.setString(3, sediaan != null ? sediaan : "Tablet");
                    stmt.setInt(4, stok);
                    stmt.setDouble(5, harga);
                    stmt.setInt(6, Integer.parseInt(idStr.trim()));
                    stmt.executeUpdate();
                } else {
                    String kodeObat = "OBT-" + System.currentTimeMillis() % 100000;
                    stmt = conn.prepareStatement("INSERT INTO obat (kode_obat, nama_obat, kategori, bentuk_sediaan, stok, harga) VALUES (?, ?, ?, ?, ?, ?)");
                    stmt.setString(1, kodeObat);
                    stmt.setString(2, nama);
                    stmt.setString(3, kategori != null ? kategori : "Antipsikotik Atipikal");
                    stmt.setString(4, sediaan != null ? sediaan : "Tablet");
                    stmt.setInt(5, stok);
                    stmt.setDouble(6, harga);
                    stmt.executeUpdate();
                }
                response.sendRedirect(request.getContextPath() + "/Admin/kelola_obat.jsp?status=success");
                return;
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(conn);
        }

        response.sendRedirect(request.getContextPath() + "/Admin/dashboard.jsp");
    }
}

