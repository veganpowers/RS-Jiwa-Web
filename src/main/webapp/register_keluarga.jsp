<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrasi Keluarga Pasien - RS Khusus ODGJ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f4f8; display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
        .card-reg { background: #fff; width: 500px; padding: 35px 30px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); border-top: 5px solid #0284c7; }
        h1 { font-size: 22px; color: #0f172a; text-align: center; margin-bottom: 6px; font-weight: 700; }
        .subtitle { text-align: center; color: #64748b; font-size: 13px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="card-reg">
        <h1>Registrasi Akun Keluarga Pasien</h1>
        <p class="subtitle">Daftarkan akun untuk memantau kondisi dan jadwal besuk pasien ODGJ</p>

        <% 
            String error = request.getParameter("error");
            if ("pasien_not_found".equals(error)) { 
        %>
            <div class="alert alert-danger py-2 small" role="alert">
                <i class="fa-solid fa-triangle-exclamation me-1"></i> NIK atau No. RM Pasien tidak ditemukan di sistem RS! Harap pastikan pasien sudah didaftarkan terlebih dahulu oleh petugas.
            </div>
        <% } else if ("username_exists".equals(error)) { %>
            <div class="alert alert-warning py-2 small" role="alert">
                <i class="fa-solid fa-circle-exclamation me-1"></i> Username sudah digunakan, silakan pilih username lain.
            </div>
        <% } else if ("empty_fields".equals(error)) { %>
            <div class="alert alert-danger py-2 small" role="alert">
                <i class="fa-solid fa-circle-xmark me-1"></i> Seluruh kolom bertanda bintang (*) wajib diisi.
            </div>
        <% } else if ("db_error".equals(error)) { %>
            <div class="alert alert-danger py-2 small" role="alert">
                <i class="fa-solid fa-server me-1"></i> Terjadi gangguan database. Silakan coba kembali.
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/RegisterKeluargaServlet" method="POST">
            <div class="mb-3">
                <label class="form-label fw-semibold small text-secondary">Username Akun *</label>
                <input type="text" name="username" class="form-control" placeholder="Contoh: keluarga_adam" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold small text-secondary">Password Akun *</label>
                <input type="password" name="password" class="form-control" placeholder="Buat password login" required>
            </div>

            <div class="mb-3">
                <label class="form-label fw-semibold small text-secondary">Nama Lengkap Wali / Keluarga *</label>
                <input type="text" name="nama" class="form-control" placeholder="Contoh: Budi Susanto" required>
            </div>

            <div class="row g-2 mb-3">
                <div class="col-6">
                    <label class="form-label fw-semibold small text-secondary">Hubungan Keluarga *</label>
                    <select name="hubungan" class="form-select" required>
                        <option value="Orang Tua">Orang Tua (Ayah/Ibu)</option>
                        <option value="Suami / Istri">Suami / Istri</option>
                        <option value="Anak Kandung">Anak Kandung</option>
                        <option value="Saudara Kandung">Saudara Kandung</option>
                        <option value="Wali Hukum">Wali Hukum</option>
                    </select>
                </div>
                <div class="col-6">
                    <label class="form-label fw-semibold small text-secondary">No. HP / WhatsApp *</label>
                    <input type="text" name="no_telp" class="form-control" placeholder="08123456789" required>
                </div>
            </div>

            <div class="mb-4">
                <label class="form-label fw-semibold small text-secondary">NIK atau No. RM Pasien yang Dirawat *</label>
                <input type="text" name="nik_pasien" class="form-control" placeholder="Masukkan 16 digit NIK atau RM (cth: RM-2026-1178)" required>
                <div class="form-text" style="font-size: 11px;">Akun Anda akan ditautkan secara otomatis ke rekam medis pasien terkait.</div>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                <i class="fa-solid fa-user-plus me-1"></i> Daftar Akun Sekarang
            </button>
        </form>

        <div class="text-center mt-3">
            <a href="index.jsp" class="text-decoration-none small text-primary">&larr; Kembali ke Halaman Login</a>
        </div>
    </div>
</body>
</html>
