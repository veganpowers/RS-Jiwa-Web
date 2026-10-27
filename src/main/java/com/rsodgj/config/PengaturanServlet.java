package com.rsodgj.config;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/PengaturanServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
    maxFileSize = 1024 * 1024 * 5,      // 5 MB
    maxRequestSize = 1024 * 1024 * 10   // 10 MB
)
public class PengaturanServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("save_theme".equalsIgnoreCase(action)) {
            String primaryColor = request.getParameter("primary_color");
            String secondaryColor = request.getParameter("secondary_color");
            String sidebarBg = request.getParameter("sidebar_bg");
            String sidebarText = request.getParameter("sidebar_text");

            HttpSession session = request.getSession();

            if (primaryColor != null && !primaryColor.trim().isEmpty()) {
                session.setAttribute("theme_primary", primaryColor.trim());
            }
            if (secondaryColor != null && !secondaryColor.trim().isEmpty()) {
                session.setAttribute("theme_secondary", secondaryColor.trim());
            }
            if (sidebarBg != null && !sidebarBg.trim().isEmpty()) {
                session.setAttribute("theme_sidebar_bg", sidebarBg.trim());
            }
            if (sidebarText != null && !sidebarText.trim().isEmpty()) {
                session.setAttribute("theme_sidebar_text", sidebarText.trim());
            }

            // Tangani proses upload logo jika ada
            try {
                Part filePart = request.getPart("hospital_logo");
                if (filePart != null && filePart.getSize() > 0) {
                    String submittedName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    if (submittedName != null && !submittedName.trim().isEmpty()) {
                        // Bersihkan nama file dan beri ekstensi yang aman
                        String cleanName = "logo_rs_" + System.currentTimeMillis() + "_" + submittedName.replaceAll("\\s+", "_");
                        
                        String uploadPath = getServletContext().getRealPath("/uploads");
                        File uploadDir = new File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }

                        filePart.write(uploadPath + File.separator + cleanName);
                        session.setAttribute("hospital_logo", "uploads/" + cleanName);
                    }
                }
            } catch (Exception e) {
                System.err.println("Gagal upload file logo: " + e.getMessage());
            }

            response.sendRedirect(request.getContextPath() + "/Admin/pengaturan_sistem.jsp?status=theme_saved");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/Admin/pengaturan_sistem.jsp");
    }
}

