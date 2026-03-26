<%-- 
    Document   : suppliers
    Created on : Feb 9, 2026
    Author     : admin
--%>
<%@ page import="java.sql.*" %>
<%@ page import="com.pharma.config.dbconfig" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<%
response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

if(session.getAttribute("username")==null){
    response.sendRedirect("login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Partners & Suppliers - CAREPLUS PHARMACY</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/main.css?v=107">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/browser/font-awesome.min.css">
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; margin: 0; }
        .main-content { margin-left: 240px; padding: 40px; }
        
        /* Premium Header Styling */
        .supplier-header { margin-bottom: 35px; }
        .supplier-header h1 {
            margin: 0; font-weight: 850; font-size: 32px; letter-spacing: -1px;
            background: linear-gradient(90deg, #1e293b, #4338ca);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }

        /* Form Card Styling */
        .form-card {
            background: white; padding: 30px; border-radius: 20px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            margin-bottom: 35px; border: 1px solid #e2e8f0;
        }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            align-items: end;
        }

        /* Modern Table Layout */
        .data-table { width: 100%; border-collapse: separate; border-spacing: 0 12px; }
        .data-table thead th {
            padding: 0 20px 10px; text-align: left; font-size: 12px;
            text-transform: uppercase; color: #64748b; font-weight: 700;
        }
        .data-table tbody tr {
            background: white; border-radius: 16px; transition: 0.3s;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }
        .data-table tbody tr:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 20px -5px rgba(0,0,0,0.08);
        }
        .data-table td { padding: 20px; border: none; }
        .data-table td:first-child { border-radius: 16px 0 0 16px; }
        .data-table td:last-child { border-radius: 0 16px 16px 0; }

        /* Stylish Action Buttons */
        .btn-delete {
            background: #fff1f2; color: #be123c; border: 1px solid #fecdd3;
            padding: 10px 18px; border-radius: 12px; font-weight: 700;
            text-decoration: none; font-size: 12px; transition: 0.3s;
            display: inline-flex; align-items: center; gap: 8px;
        }
        .btn-delete:hover { background: #be123c; color: white; transform: translateY(-2px); }

        .form-input {
            width: 100%; border: 1.5px solid #e2e8f0; padding: 12px;
            border-radius: 12px; outline: none; transition: 0.3s; font-size: 14px;
        }
        .form-input:focus { border-color: #4338ca; box-shadow: 0 0 0 4px rgba(67, 56, 202, 0.1); }
        
        .label-text { display: block; margin-bottom: 8px; font-weight: 700; font-size: 12px; color: #64748b; text-transform: uppercase; }
        .text-id { color: #4338ca; font-weight: 800; font-family: 'Courier New', monospace; }
    </style>
</head>

<body>

<jsp:include page="sidebar.jsp"/>

<div class="app-wrapper">
    <div class="main-content">
        
        <div class="supplier-header">
            <h1>Supply Chain Partners</h1>
            <p style="color: #64748b; margin: 8px 0 0; font-size: 15px; font-weight: 500;">
                Connect and manage authorized pharmaceutical distributors and vendors.
            </p>
        </div>

        <div class="form-card">
            <h3 style="margin-top:0; margin-bottom:25px; font-size: 16px; color: #1e293b; font-weight: 800;">
                <i class="fas fa-plus-circle" style="color:#4338ca;"></i> Register New Partner
            </h3>

            <form action="SupplierServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-grid">
                    <div>
                        <label class="label-text">Company Name</label>
                        <input class="form-input" type="text" name="supplier_name" required>
                    </div>
                    <div>
                        <label class="label-text">Contact Person</label>
                        <input class="form-input" type="text" name="contact_person">
                    </div>
                    <div>
                        <label class="label-text">Phone Number</label>
                        <input class="form-input" type="text" name="phone">
                    </div>
                    <div>
                        <label class="label-text">Email Address</label>
                        <input class="form-input" type="email" name="email">
                    </div>
                    <div>
                        <label class="label-text">Office Address</label>
                        <input class="form-input" type="text" name="address">
                    </div>
                    <button type="submit" class="btn btn-primary" style="height: 48px; border-radius:12px; font-weight:700;">
                        Save Partner
                    </button>
                </div>
            </form>
        </div>

        <table class="data-table">
            <thead>
                <tr>
                    <th>Partner ID</th>
                    <th>Supplier Details</th>
                    <th>Representative</th>
                    <th>Connect</th>
                    <th style="text-align: right;">Management</th>
                </tr>
            </thead>
            <tbody>

<%
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;
    try {
        con = new dbconfig().getConnection();
        st = con.createStatement();
        rs = st.executeQuery("SELECT * FROM suppliers ORDER BY supplier_id DESC");

        while(rs.next()){
%>
<tr>
    <td><span class="text-id">#SUP-<%=rs.getInt("supplier_id")%></span></td>
    <td>
        <div style="font-weight:700; color:#1e293b; font-size:15px;"><%=rs.getString("supplier_name")%></div>
        <div style="font-size:12px; color:#94a3b8;"><i class="fas fa-location-dot"></i> <%=rs.getString("address")%></div>
    </td>
    <td>
        <div style="font-weight:600; color:#475569;"><%=rs.getString("contact_person")%></div>
    </td>
    <td>
        <div style="font-size:13px; color:#1e293b; font-weight:500;"><i class="fas fa-phone" style="color:#94a3b8;"></i> <%=rs.getString("phone")%></div>
        <div style="font-size:12px; color:#4338ca; font-weight:600;"><i class="fas fa-envelope"></i> <%=rs.getString("email")%></div>
    </td>
    <td style="text-align: right;">
        <a href="SupplierServlet?action=delete&id=<%=rs.getInt("supplier_id")%>" 
           class="btn-delete" onclick="return confirm('Archive this partner record?')">
            <i class="fas fa-trash-can"></i> Delete
        </a>
    </td>
</tr>
<%
        }
    } catch(Exception e){
        out.print("<tr><td colspan='5' style='text-align:center; color:red;'>Error fetching registry.</td></tr>");
    } finally {
        if(rs != null) rs.close(); if(st != null) st.close(); if(con != null) con.close();
    }
%>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>