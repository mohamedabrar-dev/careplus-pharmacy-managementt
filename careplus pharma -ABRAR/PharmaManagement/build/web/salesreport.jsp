<%-- 
    Document   : salesreport
    Created on : Feb 26, 2026, 11:01:43 AM
    Author     : admin
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.pharma.config.dbconfig" %>
<%
    // Get the period from the URL, default is 'current'
    String period = request.getParameter("period");
    if (period == null) period = "current";
    
    String monthName = (period.equals("last")) ? "Last Month" : "Current Month";
    String dateFilter = (period.equals("last")) ? 
        "MONTH(sale_date) = MONTH(CURRENT_DATE() - INTERVAL 1 MONTH) AND YEAR(sale_date) = YEAR(CURRENT_DATE() - INTERVAL 1 MONTH)" : 
        "MONTH(sale_date) = MONTH(CURRENT_DATE()) AND YEAR(sale_date) = YEAR(CURRENT_DATE())";
%>
<!DOCTYPE html>
<html>
<head>
    <title>Analytics | CarePlus</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f7f6; margin: 0; }
        .main-content { margin-left: 250px; padding: 35px; }
        .report-nav { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .report-nav h2 { margin: 0; font-size: 28px; color: #1e293b; font-weight: 800; }
        
        /* Period Toggle Buttons */
        .toggle-group { display: flex; background: #e2e8f0; padding: 5px; border-radius: 12px; gap: 5px; }
        .toggle-btn { 
            padding: 8px 16px; border-radius: 8px; text-decoration: none; font-size: 13px; font-weight: 700;
            color: #64748b; transition: 0.3s;
        }
        .toggle-btn.active { background: #ffffff; color: #10b981; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }

        .stats-strip { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card-mini { background: #ffffff; padding: 22px; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); border-bottom: 4px solid #10b981; }
        .stat-card-mini p { margin: 0; font-size: 11px; color: #64748b; text-transform: uppercase; font-weight: 700; }
        .stat-card-mini h3 { margin: 8px 0 0; font-size: 26px; color: #0f172a; }

        .chart-main-card { background: #ffffff; padding: 30px; border-radius: 20px; box-shadow: 0 10px 25px rgba(0,0,0,0.02); margin-bottom: 30px; }
        .chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .data-table-card { background: #ffffff; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 25px rgba(0,0,0,0.02); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8fafc; text-align: left; padding: 18px 25px; font-size: 12px; color: #64748b; }
        td { padding: 18px 25px; border-bottom: 1px solid #f1f5f9; font-size: 14px; }
        .btn-print { background: #10b981; color: white; border: none; padding: 12px 25px; border-radius: 12px; cursor: pointer; font-weight: 700; transition: 0.3s; }
    </style>
</head>
<body>
    <jsp:include page="sidebar.jsp"/>

    <div class="main-content">
        <div class="report-nav">
            <div>
                <h2><%= monthName %> Analytics</h2>
                <div style="color: #64748b; font-size: 14px; margin-top: 5px;">Tracking performance for the selected duration</div>
            </div>
            
            <div class="toggle-group">
                <a href="salesreport.jsp?period=current" class="toggle-btn <%= period.equals("current") ? "active" : "" %>">Current Month</a>
                <a href="salesreport.jsp?period=last" class="toggle-btn <%= period.equals("last") ? "active" : "" %>">Previous Month</a>
            </div>
        </div>

        <%
            String dayLabels = ""; String dayValues = "";
            double totalRev = 0; int totalOrders = 0;
            
            try {
                Connection con = new dbconfig().getConnection();
                String sql = "SELECT DATE(sale_date) as d, SUM(total_amount) as t, COUNT(*) as c FROM sales " +
                             "WHERE " + dateFilter + " GROUP BY DATE(sale_date) ORDER BY d ASC";
                
                ResultSet rs = con.createStatement().executeQuery(sql);
                while(rs.next()){
                    dayLabels += "'" + rs.getString("d").substring(8) + "',";
                    dayValues += rs.getDouble("t") + ",";
                    totalRev += rs.getDouble("t");
                    totalOrders += rs.getInt("c");
                }
                con.close();
            } catch(Exception e) { e.printStackTrace(); }
        %>

        <div class="stats-strip">
            <div class="stat-card-mini">
                <p>Gross Revenue</p>
                <h3>₹<%= String.format("%,.0f", totalRev) %></h3>
            </div>
            <div class="stat-card-mini" style="border-bottom-color: #3b82f6;">
                <p>Total Orders</p>
                <h3><%= totalOrders %></h3>
            </div>
            <div class="stat-card-mini" style="border-bottom-color: #f59e0b;">
                <p>Avg. Order Value</p>
                <h3>₹<%= (totalOrders > 0) ? String.format("%,.0f", totalRev/totalOrders) : "0" %></h3>
            </div>
        </div>

        <div class="chart-main-card">
            <div class="chart-header">
                <h4><i class="fas fa-chart-line" style="color:#10b981"></i> Daily Performance</h4>
                <button class="btn-print" onclick="window.print()">Download PDF</button>
            </div>
            <div style="height: 300px;"><canvas id="emeraldChart"></canvas></div>
        </div>

        <div class="data-table-card">
            <div style="padding: 20px 25px; font-weight: 700;">Transaction History (<%= monthName %>)</div>
            <table>
                <thead>
                    <tr><th>Invoice</th><th>Date</th><th>Customer</th><th>Amount</th></tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection con = new dbconfig().getConnection();
                            ResultSet rs = con.createStatement().executeQuery("SELECT * FROM sales WHERE " + dateFilter + " ORDER BY sale_date DESC");
                            while(rs.next()){
                    %>
                    <tr>
                        <td>#INV-<%= rs.getInt("id") %></td>
                        <td><%= rs.getDate("sale_date") %></td>
                        <td><%= rs.getString("customer_name") %></td>
                        <td style="font-weight: 800;">₹<%= String.format("%,.2f", rs.getDouble("total_amount")) %></td>
                    </tr>
                    <% } con.close(); } catch(Exception e){} %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        const ctx = document.getElementById('emeraldChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: [<%= dayLabels %>],
                datasets: [{
                    label: 'Revenue',
                    data: [<%= dayValues %>],
                    borderColor: '#10b981',
                    fill: true,
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    tension: 0.4
                }]
            },
            options: { responsive: true, maintainAspectRatio: false }
        });
    </script>
</body>
</html>