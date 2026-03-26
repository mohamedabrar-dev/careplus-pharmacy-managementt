<%-- 
    Document   : view_purchase
    Created on : Feb 11, 2026, 12:34:43 PM
    Author     : admin
--%>

<%@ page import="java.sql.*" %>
<%@ page import="com.pharma.config.dbconfig" %>
<%@ page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Purchase Invoice - #<%= request.getParameter("id") %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/main.css?v=112">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f8fafc; color: #1e293b; margin: 0; }
        .main-content { margin-left: 240px; padding: 40px; }

        /* Invoice Container */
        .invoice-paper {
            background: white;
            padding: 50px;
            border-radius: 24px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.03);
            border: 1px solid #e2e8f0;
            max-width: 900px;
            margin: 0 auto;
        }

        /* Branding & Header */
        .invoice-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 40px; }
        .brand-h1 { 
            margin: 0; font-weight: 850; font-size: 28px; letter-spacing: -1px;
            background: linear-gradient(90deg, #1e293b, #4338ca);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent;
        }
        .invoice-label { 
            background: #f1f5f9; padding: 10px 20px; border-radius: 12px;
            text-align: right;
        }
        .invoice-label h2 { margin: 0; font-size: 14px; color: #64748b; text-transform: uppercase; letter-spacing: 1px; }
        .invoice-label p { margin: 5px 0 0; font-weight: 800; color: #1e293b; font-size: 18px; }

        /* Info Grid */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; margin-bottom: 40px; border-top: 2px solid #f8fafc; padding-top: 30px; }
        .info-block h4 { margin: 0 0 10px; font-size: 12px; text-transform: uppercase; color: #94a3b8; letter-spacing: 1px; }
        .info-block p { margin: 4px 0; font-weight: 600; font-size: 15px; }

        /* Items Table */
        .data-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .data-table th { 
            text-align: left; padding: 15px; border-bottom: 2px solid #f1f5f9; 
            color: #64748b; font-size: 12px; text-transform: uppercase; 
        }
        .data-table td { padding: 20px 15px; border-bottom: 1px solid #f8fafc; font-size: 14px; font-weight: 500; }
        .text-bold { font-weight: 700; color: #1e293b; }

        /* Total Section */
        .total-box { 
            margin-top: 30px; padding: 25px; background: #f8fafc; border-radius: 16px;
            display: flex; justify-content: flex-end; align-items: center; gap: 20px;
        }
        .total-box span { font-size: 14px; font-weight: 700; color: #64748b; text-transform: uppercase; }
        .total-box b { font-size: 24px; font-weight: 850; color: #4338ca; }

        .btn-print {
            background: #1e293b; color: white; border: none; padding: 12px 25px;
            border-radius: 12px; font-weight: 700; cursor: pointer; margin-bottom: 20px;
            display: inline-flex; align-items: center; gap: 10px; transition: 0.3s;
        }
        .btn-print:hover { background: #4338ca; transform: translateY(-2px); }

        @media print {
            .sidebar, .btn-print, .main-content { margin: 0 !important; padding: 0 !important; }
            .sidebar, .btn-print { display: none !important; }
            .invoice-paper { box-shadow: none; border: none; width: 100%; max-width: 100%; }
            body { background: white; }
        }
    </style>
</head>
<body>

<jsp:include page="sidebar.jsp"/>

<div class="app-wrapper">
    <div class="main-content">
        
        <button onclick="window.print()" class="btn-print">
            <i class="fa-solid fa-print"></i> Print Official Invoice
        </button>

        <%
            int purchaseId = Integer.parseInt(request.getParameter("id"));
            Connection con = null;
            try {
                con = new dbconfig().getConnection();
                PreparedStatement ps = con.prepareStatement(
                    "SELECT p.*, s.supplier_name, s.phone, s.email, s.address " +
                    "FROM purchases p " +
                    "JOIN suppliers s ON p.supplier_id = s.supplier_id " +
                    "WHERE p.purchase_id=?"
                );
                ps.setInt(1, purchaseId);
                ResultSet rs = ps.executeQuery();
                if(rs.next()){
        %>

        <div class="invoice-paper">
            <div class="invoice-header">
                <div>
                    <h1 class="brand-h1">CAREPLUS PHARMACY</h1>
                    <p style="color: #64748b; font-size: 13px; margin: 5px 0;">Healthcare Distribution & Supply Audit</p>
                </div>
                <div class="invoice-label">
                    <h2>Purchase Order</h2>
                    <p>#<%= rs.getString("invoice_number") %></p>
                </div>
            </div>

            <div class="info-grid">
                <div class="info-block">
                    <h4>Supplier Partner</h4>
                    <p class="text-bold"><%= rs.getString("supplier_name") %></p>
                    <p style="color:#64748b;"><i class="fa-solid fa-phone" style="font-size: 11px;"></i> <%= rs.getString("phone") %></p>
                    <p style="color:#64748b;"><i class="fa-solid fa-envelope" style="font-size: 11px;"></i> <%= rs.getString("email") %></p>
                </div>
                <div class="info-block" style="text-align: right;">
                    <h4>Filing Date</h4>
                    <p class="text-bold"><%= rs.getDate("purchase_date") %></p>
                    <p style="color:#64748b; margin-top:10px;">Status: <span style="color:#10b981;">● Completed</span></p>
                </div>
            </div>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>Inventory Item</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th style="text-align: right;">Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        PreparedStatement ps2 = con.prepareStatement(
                            "SELECT pi.*, m.name FROM purchase_items pi " +
                            "JOIN medicines m ON pi.medicine_id = m.id " +
                            "WHERE pi.purchase_id=?"
                        );
                        ps2.setInt(1, purchaseId);
                        ResultSet rs2 = ps2.executeQuery();
                        while(rs2.next()){
                    %>
                    <tr>
                        <td class="text-bold"><%= rs2.getString("name") %></td>
                        <td><%= rs2.getInt("quantity") %> Units</td>
                        <td>Rs. <%= String.format("%.2f", rs2.getDouble("purchase_price")) %></td>
                        <td style="text-align: right;" class="text-bold">Rs. <%= String.format("%.2f", rs2.getDouble("subtotal")) %></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="total-box">
                <span>Total Expenditure</span>
                <b>Rs. <%= String.format("%.2f", rs.getDouble("total_amount")) %></b>
            </div>

            <div style="margin-top: 60px; border-top: 1px solid #f1f5f9; padding-top: 20px; font-size: 12px; color: #94a3b8; text-align: center;">
                This is a computer-generated procurement document for CarePlus Pharmacy.
            </div>
        </div>

        <% 
                }
            } catch(Exception e) { 
                out.print("<div class='invoice-paper'>Error retrieving invoice data.</div>"); 
            } finally {
                if(con != null) con.close();
            }
        %>
    </div>
</div>

</body>
</html>