<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- TOPBAR SEDERHANA ROLE FARMASI -->
<div class="d-flex justify-content-between align-items-center pb-3 mb-4 border-bottom">
    <div>
        <h4 class="m-0 fw-bold">${param.title}</h4>
        <small class="text-muted">${param.subtitle}</small>
    </div>
    <span class="badge bg-light text-dark border p-2">
        Login: <strong><%= session.getAttribute("username") != null ? session.getAttribute("username") : "Apt. Faisal Anwar, S.Farm" %></strong> (Farmasi)
    </span>
</div>

