<%-- 
    Document   : login
    Created on : Dec 31, 2025, 12:04:20 PM
    Author     : admin
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.pharma.config.dbconfig" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CarePlus | Secure Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Inter", "Segoe UI", Tahoma, sans-serif;
            background: #0f172a; /* Deep Navy */
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        /* Abstract Glow Backgrounds */
        .bg-glow-1 {
            position: absolute; top: -10%; left: -10%;
            width: 500px; height: 500px;
            background: #10b981; filter: blur(160px);
            opacity: 0.1; z-index: 1;
        }
        .bg-glow-2 {
            position: absolute; bottom: -10%; right: -10%;
            width: 500px; height: 500px;
            background: #3b82f6; filter: blur(160px);
            opacity: 0.1; z-index: 1;
        }

        /* Login Card Animation */
        @keyframes slideUpFade {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .login-card {
            position: relative;
            z-index: 10;
            width: 90%;
            max-width: 420px;
            background: rgba(30, 41, 59, 0.7); /* Translucent Slate */
            backdrop-filter: blur(12px); /* Glass effect */
            padding: 50px 40px;
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
            text-align: center;
            animation: slideUpFade 0.8s ease-out;
        }

        .logo-box img {
            height: 70px;
            margin-bottom: 20px;
            filter: drop-shadow(0 0 10px rgba(16, 185, 129, 0.3));
        }

        .logo-box h1 {
            color: #ffffff;
            font-size: 28px;
            font-weight: 800;
            letter-spacing: -1px;
            margin-bottom: 8px;
        }

        .logo-box p {
            color: #94a3b8;
            font-size: 14px;
            margin-bottom: 40px;
        }

        /* Form Styling */
        .form-group {
            text-align: left;
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            color: #94a3b8;
            font-size: 11px;
            font-weight: 700;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 1px;
            padding-left: 5px;
        }

        .input-wrapper {
            position: relative;
            display: flex;
            align-items: center;
        }

        .input-wrapper i {
            position: absolute;
            left: 16px;
            color: #64748b;
            font-size: 16px;
        }

        .input-control {
            width: 100%;
            padding: 14px 16px 14px 45px;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(51, 65, 85, 1);
            border-radius: 14px;
            color: #ffffff;
            font-size: 15px;
            transition: all 0.3s;
        }

        .input-control:focus {
            outline: none;
            border-color: #10b981;
            background: rgba(15, 23, 42, 0.8);
            box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1);
        }

        .btn-submit {
            width: 100%;
            padding: 16px;
            background: #10b981; /* Medicine Green */
            color: #ffffff;
            border: none;
            border-radius: 14px;
            font-weight: 700;
            font-size: 16px;
            cursor: pointer;
            margin-top: 15px;
            transition: all 0.3s;
            box-shadow: 0 10px 15px -3px rgba(16, 185, 129, 0.3);
        }

        .btn-submit:hover {
            background: #059669;
            transform: translateY(-2px);
            box-shadow: 0 20px 25px -5px rgba(16, 185, 129, 0.4);
        }

        .error-msg {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
            padding: 14px;
            border-radius: 12px;
            font-size: 13px;
            margin-bottom: 25px;
            border: 1px solid rgba(239, 68, 68, 0.2);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .footer-text {
            margin-top: 35px;
            color: #64748b;
            font-size: 12px;
            font-weight: 500;
        }
    </style>
</head>
<body>

    <div class="bg-glow-1"></div>
    <div class="bg-glow-2"></div>

    <div class="login-card">
        <div class="logo-box">
            <img src="images/careplus.png" alt="CarePlus Logo">
            <h1>CAREPLUS<span>+</span></h1>
            <p>Authorized Personnel Only</p>
        </div>

        <%
            String err = request.getParameter("error");
            if (err != null && err.equals("invalid")) {
        %>
            <div class="error-msg">
                <i class="fas fa-circle-exclamation"></i>
                Invalid credentials. Please try again.
            </div>
        <% 
            } 
        %>

        <form action="Login" method="post">
            <div class="form-group">
                <label>Username</label>
                <div class="input-wrapper">
                    <i class="fas fa-user"></i>
                    <input type="text" name="username" class="input-control" 
                           placeholder="Enter username" required autofocus>
                </div>
            </div>

            <div class="form-group">
                <label>Password</label>
                <div class="input-wrapper">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" class="input-control" 
                           placeholder="Enter password" required>
                </div>
            </div>

            <button type="submit" class="btn-submit">
                Secure Login <i class="fas fa-arrow-right" style="margin-left:8px; font-size:14px;"></i>
            </button>
        </form>

        <div class="footer-text">
            &copy; 2026 CarePlus Pharmacy Management System
        </div>
    </div>

</body>
</html>