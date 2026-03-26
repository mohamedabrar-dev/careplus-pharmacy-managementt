<%-- 
    Document   : users
    Created on : Dec 31, 2025, 12:08:22 PM
    Author     : admin
--%>
<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%
if (session.getAttribute("username") == null) {
response.sendRedirect("login.jsp");
return;
}
%>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>

<!DOCTYPE html>

<html lang="en">
<head>
<meta charset="UTF-8">
<title>Identity Control - CAREPLUS</title>
<link href="" rel="stylesheet">
<link rel="stylesheet" href="">
<style>
body { font-family: 'Inter', sans-serif; background-color: #f1f5f9; color: #1e293b; margin: 0; }
.main-content { margin-left: 260px; padding: 40px; min-height: 100vh; display: flex; justify-content: center; align-items: center; }
.user-card { background: white; padding: 45px; border-radius: 24px; box-shadow: 0 15px 35px rgba(0,0,0,0.05); width: 100%; max-width: 450px; border: 1px solid #e2e8f0; position: relative; }
.user-card::before { content: ""; position: absolute; top: 0; left: 0; right: 0; height: 5px; background: #10b981; border-radius: 24px 24px 0 0; }
.form-header { text-align: center; margin-bottom: 35px; }
.icon-circle { width: 60px; height: 60px; background: rgba(16, 185, 129, 0.1); color: #10b981; border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 24px; margin: 0 auto 15px; }
.form-header h2 { margin: 0; font-weight: 800; font-size: 24px; color: #0f172a; letter-spacing: -0.5px; }
.input-group { margin-bottom: 20px; }
.input-group label { display: block; font-weight: 700; font-size: 11px; color: #64748b; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 8px; }
.input-wrapper { position: relative; }
.field-icon { position: absolute; left: 16px; top: 50%; transform: translateY(-50%); color: #94a3b8; font-size: 15px; }
.styled-input { width: 100%; padding: 12px 15px 12px 45px; border: 1px solid #e2e8f0; border-radius: 12px; font-size: 14px; font-weight: 500; transition: 0.2s; background: #f8fafc; color: #1e293b; box-sizing: border-box; }
.styled-input:focus { border-color: #10b981; background: white; outline: none; box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1); }
.btn-create { width: 100%; padding: 14px; background: #0f172a; color: white; border: none; border-radius: 12px; font-weight: 700; font-size: 15px; cursor: pointer; display: flex; align-items: center; justify-content: center; gap: 10px; transition: 0.3s; margin-top: 10px; }
.btn-create:hover { background: #10b981; transform: translateY(-2px); box-shadow: 0 8px 20px rgba(16, 185, 129, 0.25); }
.toggle-password { position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #94a3b8; cursor: pointer; padding: 5px; }
</style>
</head>
<body>
<jsp:include page="sidebar.jsp"/>
<div class="main-content">
<div class="user-card">
<div class="form-header">
<div class="icon-circle"><i class="fas fa-user-shield"></i></div>
<h2>Create Account</h2>
<p style="color:#64748b; font-size:13px; margin-top:5px;">Setup credentials</p>
</div>
<form action="UserServlet" method="post">
<div class="input-group">
<label>Username</label>
<div class="input-wrapper">
<i class="fas fa-at field-icon"></i>
<input type="text" name="username" class="styled-input" placeholder="Username" required>
</div>
</div>
<div class="input-group">
<label>Full Name</label>
<div class="input-wrapper">
<i class="fas fa-signature field-icon"></i>
<input type="text" name="fullname" class="styled-input" placeholder="Full Name" required>
</div>
</div>
<div class="input-group">
<label>Access Privilege</label>
<div class="input-wrapper">
<i class="fas fa-key field-icon"></i>
<select name="role" class="styled-input" style="appearance: none; cursor: pointer;">
<option value="staff">Pharmacist / Staff</option>
<option value="admin">System Administrator</option>
</select>
<i class="fas fa-chevron-down" style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); color: #94a3b8; pointer-events: none; font-size: 11px;"></i>
</div>
</div>
<div class="input-group">
<label>Password</label>
<div class="input-wrapper">
<i class="fas fa-lock field-icon"></i>
<input type="password" name="password" id="pass_field" class="styled-input" placeholder="Password" required>
<i class="fas fa-eye toggle-password" onclick="togglePass()"></i>
</div>
</div>
<button type="submit" class="btn-create"><i class="fas fa-user-plus"></i> Initialize Account</button>
</form>
</div>
</div>
<script>
function togglePass() {
var passField = document.getElementById('pass_field');
if (passField.type === "password") {
passField.type = "text";
} else {
passField.type = "password";
}
}
</script>
</body>
</html>
