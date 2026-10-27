<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrasi Keluarga Pasien - RS Khusus ODGJ</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f4f8; display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
        .card { background: #fff; width: 480px; padding: 35px 30px; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); border-top: 5px solid #0284c7; }
        h1 { font-size: 22px; color: #0f172a; text-align: center; margin-bottom: 8px; }
        .subtitle { text-align: center; color: #64748b; font-size: 13px; margin-bottom: 25px; }
        .form-group { margin-bottom: 16px; }
        label { display: block; font-size: 13px; font-weight: 600; color: #334155; margin-bottom: 6px; }
        input[type="text"], input[type="password"] { width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 6px; font-size: 14px; }
        input:focus { border-color: #0284c7; outline: none; }
        .btn-submit { width: 100%; background: #0284c7; color: white; padding: 12px; border: none; border-radius: 6px; font-size: 15px; font-weight: 600; cursor: pointer; margin-top: 10px; }
        .btn-submit:hover { background: #0369a1; }
        .back-link { display: block; text-align: center; margin-top: 20px; color: #0284c7; text-decoration: none; font-size: 13px; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="card">
        <h1>Registrasi Akun Keluarga Pasien</h1>
        <p class="subtitle">Daftarkan akun untuk memantau kondisi dan jadwal besuk pasien</p>

        <form action="<%= request.getContextPath() %>/index.jsp" method="GET">
            <div class="form-group">
                <label for="username">Username Akun</label>
                <input type="text" id="username" name="username" placeholder="Masukkan username" required>
            </div>
            <div class="form-group">
                <label for="nama">Nama Lengkap Penanggung Jawab</label>
                <input type="text" id="nama" name="nama" placeholder="Nama wali/keluarga" required>
            </div>
            <div class="form-group">
                <label for="nik_pasien">NIK Pasien ODGJ yang Dirawat</label>
                <input type="text" id="nik_pasien" name="nik_pasien" placeholder="16 digit NIK Pasien" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Buat password baru" required>
            </div>
            <button type="submit" class="btn-submit">Daftar Sekarang</button>
        </form>

        <a href="index.jsp" class="back-link">&larr; Kembali ke Halaman Login</a>
    </div>
</body>
</html>

