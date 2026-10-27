<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.rsodgj.config.Koneksi" %>
<%
    String selectedRm = request.getParameter("rm");
    Connection connPasienSelect = null;
    Statement stmtPasienSelect = null;
    ResultSet rsPasienSelect = null;
    try {
        connPasienSelect = Koneksi.getConnection();
        stmtPasienSelect = connPasienSelect.createStatement();
        String sqlSelect = "SELECT p.id_pasien, p.no_rekam_medis, p.nama, k.nama_kamar, p.status_perawatan " +
                           "FROM pasien p " +
                           "LEFT JOIN kamar k ON p.id_kamar = k.id_kamar " +
                           "ORDER BY p.id_pasien DESC";
        rsPasienSelect = stmtPasienSelect.executeQuery(sqlSelect);
        while (rsPasienSelect.next()) {
            int idp = rsPasienSelect.getInt("id_pasien");
            String rm = rsPasienSelect.getString("no_rekam_medis");
            String nama = rsPasienSelect.getString("nama");
            String kmr = rsPasienSelect.getString("nama_kamar");
            String st = rsPasienSelect.getString("status_perawatan");
            String displayKmr = (kmr != null) ? (" (" + kmr + ")") : (" [" + st + "]");
            boolean isSel = (selectedRm != null && (selectedRm.equals(rm) || selectedRm.equals(String.valueOf(idp))));
%>
<option value="<%= idp %>" <%= isSel ? "selected" : "" %>>
    <%= rm %> - <%= nama %><%= displayKmr %>
</option>
<%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rsPasienSelect != null) try { rsPasienSelect.close(); } catch (SQLException ignored) {}
        if (stmtPasienSelect != null) try { stmtPasienSelect.close(); } catch (SQLException ignored) {}
        Koneksi.closeConnection(connPasienSelect);
    }
%>

