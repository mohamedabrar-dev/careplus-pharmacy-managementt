<%-- 
    Document   : getMedicinesBySupplier
    Created on : Feb 19, 2026, 12:16:26 PM
    Author     : admin
--%>

<%@ page import="java.sql.*, com.pharma.config.dbconfig" %>
<%
    String sId = request.getParameter("supplier_id");
    
    if(sId != null && !sId.isEmpty()) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            con = new dbconfig().getConnection();
            ps = con.prepareStatement("SELECT id, name FROM medicines WHERE supplier_id = ?");
            ps.setInt(1, Integer.parseInt(sId));
            rs = ps.executeQuery();
            
            out.print("<option value=''>-- Select Medicine --</option>");
            
            boolean found = false;
            while(rs.next()) {
                found = true;
                int medId = rs.getInt("id");
                String medName = rs.getString("name");
                
                // CRITICAL: Combining ID and Name into the value attribute
                out.print("<option value='" + medId + "|" + medName + "'>" + medName + "</option>");
            }
            
            if(!found) {
                out.print("<option value=''>No medicines found for this supplier</option>");
            }
            
        } catch(Exception e) {
            out.print("<option value=''>Error: " + e.getMessage() + "</option>");
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(ps != null) try { ps.close(); } catch(Exception e) {}
            if(con != null) try { con.close(); } catch(Exception e) {}
        }
    }
%>