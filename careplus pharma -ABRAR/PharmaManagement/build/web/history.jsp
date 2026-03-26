<%-- 
    Document   : history
    Created on : Dec 31, 2025, 12:07:45 PM
    Author     : admin
--%>

<%@page import="com.pharma.config.dbconfig"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.Connection"%>
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
    <title>Sales Audit - CAREPLUS PHARMACY</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/main.css?v=106">
    
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; margin: 0; }
        .main-content { margin-left: 240px; padding: 40px; }
        
        /* Premium Header Styling */
        .history-header { margin-bottom: 40px; }
        .history-header h1 {
            margin: 0; font-weight: 850; font-size: 32px; letter-spacing: -1px;
            background: linear-gradient(90deg, #1e293b, #4338ca);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }

        /* Filter Section */
        .filter-card {
            background: white; padding: 25px; border-radius: 20px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
            margin-bottom: 30px; border: 1px solid #e2e8f0;
            display: flex; gap: 20px; align-items: flex-end;
        }

        /* Data Table Styling */
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

        /* Stylish Text & Components */
        .text-id { color: #4338ca; font-weight: 800; font-family: 'Courier New', monospace; font-size: 15px; }
        .text-amount { font-weight: 800; color: #0f172a; font-size: 16px; }
        .currency-label { font-size: 12px; color: #64748b; font-weight: 600; margin-right: 2px; }
        
        .badge-paid {
            background: #dcfce7; color: #166534; padding: 6px 14px;
            border-radius: 10px; font-size: 11px; font-weight: 800;
            display: inline-flex; align-items: center; gap: 6px;
        }
        .badge-paid::before {
            content: ''; width: 6px; height: 6px; background: #22c55e; border-radius: 50%;
        }

        .btn-view {
            text-decoration: none; background: #f1f5f9; color: #475569;
            padding: 10px 20px; border-radius: 12px; font-size: 13px;
            font-weight: 700; transition: 0.2s; border: 1px solid #e2e8f0;
        }
        .btn-view:hover { background: #4338ca; color: white; border-color: #4338ca; }
        
        input[type="date"] {
            border: 1.5px solid #e2e8f0; padding: 10px; border-radius: 10px; outline: none; width: 100%;
        }
    </style>
</head>
<body>

<jsp:include page="sidebar.jsp"/>

<div class="app-wrapper">
    <div class="main-content">
        <div class="history-header">
            <h1>Sales Revenue & Audit</h1>
            <p style="color: #64748b; margin: 8px 0 0; font-size: 15px; font-weight: 500;">
                Review historical transactions and verify pharmaceutical revenue streams.
            </p>
        </div>

        <form method="get" class="filter-card">
            <div style="flex: 1;">
                <label style="display:block; margin-bottom:8px; font-weight:700; font-size:11px; color:#64748b; text-transform:uppercase;">From Date</label>
                <input type="date" name="fromDate" value="<%= request.getParameter("fromDate") != null ? request.getParameter("fromDate") : "" %>">
            </div>
            <div style="flex: 1;">
                <label style="display:block; margin-bottom:8px; font-weight:700; font-size:11px; color:#64748b; text-transform:uppercase;">To Date</label>
                <input type="date" name="toDate" value="<%= request.getParameter("toDate") != null ? request.getParameter("toDate") : "" %>">
            </div>
            <div style="display:flex; gap:10px;">
                <button type="submit" class="btn btn-primary" style="padding: 12px 25px; border-radius:12px;">Apply Filter</button>
                <a href="history.jsp" class="btn btn-secondary" style="padding: 12px 20px; border-radius:12px; text-decoration:none;">Reset</a>
            </div>
        </form>

        <table class="data-table">
            <thead>
                <tr>
                    <th>Invoice ID</th>
                    <th>Date & Time</th>
                    <th>Customer Details</th>
                    <th style="text-align:center;">Action</th>
                    <th>Revenue</th>
                    <th style="text-align:right;">Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection con = null; PreparedStatement ps = null; ResultSet rs = null;
                    try {
                        con = new dbconfig().getConnection();
                        String fDate = request.getParameter("fromDate");
                        String tDate = request.getParameter("toDate");
                        
                        String sql = "SELECT * FROM sales";
                        if(fDate != null && !fDate.isEmpty() && tDate != null && !tDate.isEmpty()){
                            sql += " WHERE DATE(sale_date) BETWEEN ? AND ?";
                        }
                        sql += " ORDER BY id DESC";
                        
                        ps = con.prepareStatement(sql);
                        if(sql.contains("BETWEEN")){ ps.setString(1, fDate); ps.setString(2, tDate); }
                        
                        rs = ps.executeQuery();
                        while(rs.next()){
                %>
                <tr>
                    <td><span class="text-id">#INV-<%= rs.getInt("id") %></span></td>
                    <td><div style="font-weight:600; color:#475569; font-size:14px;"><%= rs.getString("sale_date") %></div></td>
                    <td>
                        <div style="font-weight:700; color:#1e293b;"><%= rs.getString("customer_name") %></div>
                        <div style="font-size:12px; color:#94a3b8;"><%= rs.getString("customer_phone") %></div>
                    </td>
                    <td style="text-align:center;">
                        <a href="view_bill.jsp?id=<%= rs.getInt("id") %>" class="btn-view">View Bill</a>
                    </td>
                    <td>
                        <span class="text-amount">
                            <span class="currency-label">Rs.</span><%= String.format("%.2f", rs.getDouble("total_amount")) %>
                        </span>
                    </td>
                    <td style="text-align:right;">
                        <span class="badge-paid">Settled</span>
                    </td>
                </tr>
                <%      }
                    } catch(Exception e){ e.printStackTrace(); } 
                    finally { if(rs!=null)rs.close(); if(ps!=null)ps.close(); if(con!=null)con.close(); }
                %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
