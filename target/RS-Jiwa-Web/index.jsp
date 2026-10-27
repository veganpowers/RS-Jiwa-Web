<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistem Informasi RS Khusus ODGJ</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f4f8; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .login-card { background: #fff; width: 420px; padding: 35px 30px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); border-top: 5px solid #0284c7; }
        h1 { font-size: 24px; color: #0f172a; text-align: center; margin-bottom: 8px; }
        .subtitle { text-align: center; color: #64748b; font-size: 14px; margin-bottom: 25px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px; }
        input[type="text"], input[type="password"], select { width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; transition: border-color 0.2s; }
        input[type="text"]:focus, input[type="password"]:focus, select:focus { border-color: #0284c7; outline: none; }
        .btn-submit { width: 100%; background: #0284c7; color: white; padding: 12px; border: none; border-radius: 6px; font-size: 15px; font-weight: 600; cursor: pointer; transition: background 0.2s; margin-top: 10px; }
        .btn-submit:hover { background: #0369a1; }
        .links { margin-top: 20px; display: flex; justify-content: space-between; font-size: 13px; }
        .links a { color: #0284c7; text-decoration: none; }
        .links a:hover { text-decoration: underline; }
        .alert { padding: 10px 12px; border-radius: 6px; font-size: 13px; margin-bottom: 15px; }
        .alert-danger { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
    </style>
</head>
<body>
    <div class="login-card">
        <h1>RS Khusus ODGJ</h1>
        <p class="subtitle">Sistem Informasi Pelayanan Pasien Jiwa</p>

        <% 
            String error = request.getParameter("error");
            if ("invalid_credentials".equals(error)) {
        %>
            <div class="alert alert-danger">Username, password, atau role tidak sesuai!</div>
        <%  } else if ("empty_fields".equals(error)) { %>
            <div class="alert alert-danger">Harap isi username dan password!</div>
        <%  } else if ("logged_out".equals(request.getParameter("status"))) { %>
            <div class="alert alert-success">Anda telah berhasil logout.</div>
        <%  } %>

        <form action="<%= request.getContextPath() %>/LoginServlet" method="POST">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" placeholder="Masukkan username" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Masukkan password" required>
            </div>

            <div class="form-group">
                <label for="role">Pilih Role</label>
                <select id="role" name="role" required>
                    <option value="" disabled selected>-- Pilih Peran / Role --</option>
                    <option value="admin">Administrator</option>
                    <option value="dokter">Dokter Spesialis Jiwa</option>
                    <option value="perawat">Perawat / Ners</option>
                    <option value="keluarga">Keluarga Pasien</option>
                    <option value="farmasi">Petugas Farmasi / Apotek</option>
                    <option value="kasir">Petugas Kasir / Pembayaran</option>
                </select>
            </div>

            <button type="submit" class="btn-submit">Masuk ke Sistem</button>
        </form>

        <div class="links">
            <a href="register_keluarga.jsp">Daftar Akun Keluarga</a>
            <a href="lupa_password.jsp">Lupa Password?</a>
        </div>
    </div>
</body>
</html>

