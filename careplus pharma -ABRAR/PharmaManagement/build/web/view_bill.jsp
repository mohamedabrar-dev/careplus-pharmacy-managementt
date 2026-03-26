<%-- 
    Document   : view_bill
    Created on : Jan 29, 2026, 11:38:14 AM
    Author     : admin
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.pharma.config.dbconfig" %>

<%
if(session.getAttribute("username")==null){
    response.sendRedirect("login.jsp");
    return;
}

String id=request.getParameter("id");
if(id==null){
    out.println("Invalid Bill");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Invoice - CarePlus Pharmacy</title>

<style>

body{
background:#eef2f7;
font-family:'Segoe UI',sans-serif;
margin:0;
padding:30px;
}

/* MAIN CARD */
.invoice-card{
max-width:850px;
margin:auto;
background:white;
padding:45px;
border-radius:14px;
box-shadow:0 12px 40px rgba(0,0,0,0.08);
}

/* HEADER */
.header{
display:flex;
justify-content:space-between;
align-items:flex-start;
border-bottom:2px solid #f1f5f9;
padding-bottom:25px;
margin-bottom:30px;
}

.logo-area{
display:flex;
gap:16px;
align-items:center;
}

.logo-area img{
height:60px;
border-radius:10px;
}

.logo-area h1{
margin:0;
font-size:28px;
color:#10b981;
letter-spacing:-0.3px;
}

.logo-area small{
display:block;
color:#64748b;
margin-top:4px;
font-size:13px;
}

/* BILL INFO */
.bill-info{
text-align:right;
}

.badge{
background:#dcfce7;
color:#166534;
padding:5px 14px;
border-radius:20px;
font-weight:bold;
font-size:12px;
display:inline-block;
margin-bottom:8px;
}

/* CUSTOMER */
.customer{
background:#f8fafc;
padding:18px;
border-radius:10px;
display:flex;
justify-content:space-between;
margin-bottom:25px;
}

/* TABLE */
table{
width:100%;
border-collapse:collapse;
}

th{
background:#1e293b;
color:white;
padding:12px;
text-align:left;
font-size:13px;
}

td{
padding:14px;
border-bottom:1px solid #f1f5f9;
}

/* TOTAL */
.total{
margin-top:25px;
width:320px;
margin-left:auto;
}

.row{
display:flex;
justify-content:space-between;
padding:8px 0;
}

.grand{
border-top:2px solid #1e293b;
margin-top:8px;
font-size:22px;
font-weight:bold;
}

/* FOOTER */
.footer{
margin-top:50px;
text-align:center;
border-top:1px dashed #cbd5e1;
padding-top:18px;
color:#94a3b8;
}

/* BUTTONS */
.actions{
margin-top:25px;
text-align:center;
}

.btn{
padding:12px 25px;
border:none;
border-radius:8px;
cursor:pointer;
font-weight:bold;
margin:5px;
}

.print{ background:#1e293b;color:white; }
.back{ background:#cbd5e1; }

@media print{
.actions{display:none;}
body{background:white;padding:0;}
.invoice-card{box-shadow:none;margin:0;width:100%;}
}

</style>
</head>

<body>

<div class="invoice-card">

<%
try{
Connection con=new dbconfig().getConnection();

PreparedStatement psSale=con.prepareStatement("SELECT * FROM sales WHERE id=?");
psSale.setInt(1,Integer.parseInt(id));
ResultSet rsSale=psSale.executeQuery();

if(!rsSale.next()){ out.println("Invoice not found"); return; }

String billNumber=String.format("INV-%06d",rsSale.getInt("id"));

PreparedStatement psItem=con.prepareStatement("SELECT * FROM sales_items WHERE sale_id=?");
psItem.setInt(1,Integer.parseInt(id));
ResultSet rsItem=psItem.executeQuery();
%>

<!-- HEADER -->
<div class="header">

<div class="logo-area">
<img src="images/careplus.png">
<div>
<h1>CAREPLUS PHARMACY</h1>
<small>123 Medical Square • +91 98765 43210</small>
</div>
</div>

<div class="bill-info">
<div class="badge">PAID</div>
<div style="font-size:18px;font-weight:bold;"><%=billNumber%></div>
<div style="color:#64748b;"><%=rsSale.getTimestamp("sale_date")%></div>
</div>

</div>

<!-- CUSTOMER -->
<div class="customer">
<div>
<b>Customer</b><br>
<%=rsSale.getString("customer_name")%>
</div>

<div>
<b>Phone</b><br>
<%=rsSale.getString("customer_phone")%>
</div>
</div>

<!-- TABLE -->
<table>
<tr>
<th>#</th>
<th>Medicine</th>
<th>Qty</th>
<th>Price</th>
<th style="text-align:right;">Amount</th>
</tr>

<%
int c=1;
double subtotal=0;
while(rsItem.next()){
double t=rsItem.getInt("quantity")*rsItem.getDouble("price");
subtotal+=t;
%>

<tr>
<td><%=c++%></td>
<td><b><%=rsItem.getString("medicine_name")%></b></td>
<td><%=rsItem.getInt("quantity")%></td>
<td>₹<%=String.format("%.2f",rsItem.getDouble("price"))%></td>
<td style="text-align:right;">₹<%=String.format("%.2f",t)%></td>
</tr>

<% } %>
</table>

<!-- TOTAL -->
<div class="total">
<div class="row"><span>Subtotal</span><span>₹<%=String.format("%.2f",subtotal)%></span></div>
<div class="row"><span>Tax (5%)</span><span>₹<%=String.format("%.2f",rsSale.getDouble("total_amount")-subtotal)%></span></div>
<div class="row grand"><span>Total</span><span>₹<%=String.format("%.2f",rsSale.getDouble("total_amount"))%></span></div>
</div>

<div class="footer">
Thank you for choosing CarePlus Pharmacy
</div>

<%
con.close();
}catch(Exception e){
out.println("Error loading invoice");
}
%>

</div>

<div class="actions">
<a href="billing.jsp" class="btn back">← New Sale</a>
<button onclick="window.print()" class="btn print">Print Invoice</button>
</div>

</body>
</html>