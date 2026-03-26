<%-- 
    Document   : purchase history
    Created on : Feb 11, 2026, 12:34:05 PM
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
<title>Purchase History - CAREPLUS</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

<style>
    body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; margin: 0; }
    .main-content { margin-left: 280px; padding: 40px; }
    
    .history-header { margin-bottom: 35px; display: flex; justify-content: space-between; align-items: flex-end; }
    .history-header h1 { margin: 0; font-weight: 800; font-size: 30px; color: #0f172a; letter-spacing: -1px; }

    .data-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
    .data-table thead th { padding: 0 20px 15px; text-align: left; font-size: 11px; text-transform: uppercase; color: #64748b; font-weight: 700; letter-spacing: 1px; }
    
    .data-table tbody tr { background: white; transition: 0.3s; box-shadow: 0 2px 4px rgba(0,0,0,0.02); border-radius: 12px; }
    .data-table tbody tr:hover { transform: translateY(-2px); box-shadow: 0 8px 15px rgba(0,0,0,0.05); }
    
    .data-table td { padding: 18px 20px; border: none; }
    .data-table td:first-child { border-radius: 12px 0 0 12px; }
    .data-table td:last-child { border-radius: 0 12px 12px 0; }

    .text-invoice { color: #10b981; font-weight: 800; font-family: 'Courier New', monospace; font-size: 14px; background: rgba(16, 185, 129, 0.1); padding: 4px 8px; border-radius: 6px; }
    .text-supplier { color: #0f172a; font-weight: 700; font-size: 15px; display: block; }
    .text-date { color: #64748b; font-size: 13px; font-weight: 500; }
    .text-amount { font-weight: 800; color: #0f172a; font-size: 16px; }

    .btn-view {
        text-decoration: none; background: #0f172a; color: white;
        padding: 10px 18px; border-radius: 10px; font-size: 12px;
        font-weight: 700; transition: 0.2s; display: inline-flex; align-items: center; gap: 8px;
    }
    .btn-view:hover { background: #10b981; transform: scale(1.05); }
    
    .badge-procure { background: #e0f2fe; color: #0369a1; padding: 4px 10px; border-radius: 6px; font-size: 10px; font-weight: 800; text-transform: uppercase; margin-top: 5px; display: inline-block; }
</style>
</head>
<body>

<jsp:include page="sidebar.jsp"/>

<div class="main-content">
<div class="history-header">
<div>
<h1>Purchase History</h1>
<p style="color: #64748b; margin: 5px 0 0; font-size: 14px;">Review and manage all stock procurement logs.</p>
</div>
<a href="purchase.jsp" class="btn-view" style="background:#10b981;"><i class="fa-solid fa-plus"></i> New Purchase</a>
</div>

<table class="data-table">
    <thead>
        <tr>
            <th>Invoice</th>
            <th>Supplier Info</th>
            <th>Date of Entry</th>
            <th>Total Value</th>
            <th style="text-align: right;">Action</th>
        </tr>
    </thead>
    <tbody>
        <%
            try {
                Connection con = new dbconfig().getConnection();
                Statement st = con.createStatement();
                ResultSet rs = st.executeQuery(
                    "SELECT p.*, s.supplier_name FROM purchases p " +
                    "JOIN suppliers s ON p.supplier_id = s.supplier_id " +
                    "ORDER BY p.purchase_id DESC"
                );
                
                while(rs.next()){
        %>
        <tr>
            <td><span class="text-invoice"><%= rs.getString("invoice_number") %></span></td>
            <td>
                <span class="text-supplier"><%= rs.getString("supplier_name") %></span>
                <span class="badge-procure">Verified</span>
            </td>
            <td><span class="text-date"><i class="fa-regular fa-calendar" style="margin-right:5px;"></i> <%= rs.getDate("purchase_date") %></span></td>
            <td><span class="text-amount">Rs. <%= String.format("%.2f", rs.getDouble("total_amount")) %></span></td>
            <td style="text-align: right;">
                <a href="view_purchase.jsp?id=<%= rs.getInt("purchase_id") %>" class="btn-view">
                    <i class="fa-solid fa-eye"></i> View Items
                </a>
            </td>
        </tr>
        <% } con.close(); } catch(Exception e) { out.print("Error: " + e.getMessage()); } %>
    </tbody>
</table>
</div>

</body>
</html>