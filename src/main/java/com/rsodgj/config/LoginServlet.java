package com.rsodgj.config;

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
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/index.jsp?status=logged_out");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String selectedRole = request.getParameter("role");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=empty_fields");
            return;
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = Koneksi.getConnection();
            String sql;
            if (selectedRole != null && !selectedRole.trim().isEmpty()) {
                sql = "SELECT id, username, role FROM users WHERE username = ? AND password = ? AND role = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username.trim());
                stmt.setString(2, password.trim());
                stmt.setString(3, selectedRole.trim().toLowerCase());
            } else {
                sql = "SELECT id, username, role FROM users WHERE username = ? AND password = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username.trim());
                stmt.setString(2, password.trim());
            }

            rs = stmt.executeQuery();

            if (rs.next()) {
                int userId = rs.getInt("id");
                String userRole = rs.getString("role");
                String uname = rs.getString("username");

                HttpSession session = request.getSession();
                session.setAttribute("userId", userId);
                session.setAttribute("username", uname);
                session.setAttribute("role", userRole);

                // Routing berdasarkan role menggunakan switch-case
                switch (userRole.toLowerCase()) {
                    case "admin":
                        response.sendRedirect(request.getContextPath() + "/Admin/dashboard.jsp");
                        break;
                    case "dokter":
                        response.sendRedirect(request.getContextPath() + "/Dokter/dashboard.jsp");
                        break;
                    case "perawat":
                        response.sendRedirect(request.getContextPath() + "/Perawat/dashboard.jsp");
                        break;
                    case "keluarga":
                        response.sendRedirect(request.getContextPath() + "/Keluarga/dashboard.jsp");
                        break;
                    case "farmasi":
                        response.sendRedirect(request.getContextPath() + "/Farmasi_Apotek/dashboard.jsp");
                        break;
                    case "kasir":
                        response.sendRedirect(request.getContextPath() + "/Kasir/dashboard.jsp");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/index.jsp?error=role_unknown");
                        break;
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/index.jsp?error=invalid_credentials");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=db_error");
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
            Koneksi.closeConnection(conn);
        }
    }
}

