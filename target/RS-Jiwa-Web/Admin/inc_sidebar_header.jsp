<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String themeLogo = (session.getAttribute("hospital_logo") != null) ? (String) session.getAttribute("hospital_logo") : null;
%>
<div class="sidebar-header">
    <div style="display:flex; align-items:center; gap:10px;">
        <% if (themeLogo != null && !themeLogo.trim().isEmpty()) { %>
            <img src="<%= request.getContextPath() %>/<%= themeLogo %>" alt="Logo RS" style="width:34px; height:34px; object-fit:contain; border-radius:6px;">
        <% } else { %>
            <i class="fa-solid fa-hospital" style="font-size:22px; color: var(--secondary-color);"></i>
        <% } %>
        <div>
            <h2>RS Khusus ODGJ</h2>
            <p>Administrator Portal</p>
        </div>
    </div>
</div>
