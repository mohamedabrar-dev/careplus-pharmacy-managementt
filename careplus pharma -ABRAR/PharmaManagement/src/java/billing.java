/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.pharma.config.dbconfig;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(urlPatterns = {"/billing"})
public class billing extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
         PrintWriter out = response.getWriter();
      // Get Basic Info
         String customerName = request.getParameter("customer_name");
         String customerPhone = request.getParameter("customer_phone");
         String totalAmount = request.getParameter("total_amount");
      // Get the Arrays of items we just added in the JSP
        String[] medicineIds = request.getParameterValues("med_id");
        String[] quantities = request.getParameterValues("med_qty");
        String[] prices = request.getParameterValues("med_price");
       Connection con = null;
       try {
       con = new dbconfig().getConnection();
       con.setAutoCommit(false); // Start Transaction (Safety first!)
            String saleSql = "INSERT INTO sales(customer_name, customer_phone, total_amount) VALUES (?,?,?)";
            PreparedStatement psSale = con.prepareStatement(saleSql, Statement.RETURN_GENERATED_KEYS);
            psSale.setString(1, customerName);
            psSale.setString(2, customerPhone);
            psSale.setString(3, totalAmount);
            psSale.executeUpdate();
            ResultSet rs = psSale.getGeneratedKeys();
            int saleId = 0;
            if (rs.next()) {
                saleId = rs.getInt(1);
            }
            // ================= 2. PREPARED STATEMENTS =================
            String itemSql = "INSERT INTO sales_items (sale_id, medicine_id, medicine_name, quantity, price) VALUES (?,?,?,?,?)";
            String stockSql = "UPDATE medicines SET stock = stock - ? WHERE id = ?";
            String fetchNameSql = "SELECT name FROM medicines WHERE id=?";

            PreparedStatement psItem = con.prepareStatement(itemSql);
            PreparedStatement psStock = con.prepareStatement(stockSql);
            PreparedStatement psFetch = con.prepareStatement(fetchNameSql);
            // ================= 3. LOOP CART ITEMS =================
            if (medicineIds != null) {
            for (int i = 0; i < medicineIds.length; i++) {

            if (medicineIds[i] == null || medicineIds[i].trim().equals("")) {
            continue; // ✅ skip empty rows safely
        }
            if (quantities[i] == null || quantities[i].trim().equals("")) {
            continue;
        }
          if (prices[i] == null || prices[i].trim().equals("")) {
          continue;
        }
        int medId = Integer.parseInt(medicineIds[i]);
        int qty = Integer.parseInt(quantities[i]);
        double price = Double.parseDouble(prices[i]);

        // 🔍 Fetch medicine name
        psFetch.setInt(1, medId);
        ResultSet rsName = psFetch.executeQuery();
        String medName = "";
        if (rsName.next()) {
            medName = rsName.getString("name");
        }

        // 🧾 Insert item
        psItem.setInt(1, saleId);
        psItem.setInt(2, medId);
        psItem.setString(3, medName);
        psItem.setInt(4, qty);
        psItem.setDouble(5, price);
        psItem.addBatch();

        // 📉 Reduce stock
        psStock.setInt(1, qty);
        psStock.setInt(2, medId);
        psStock.addBatch();
    }

    psItem.executeBatch();
    psStock.executeBatch();
}


            con.commit(); // ✅ Save all changes

          response.sendRedirect("view_bill.jsp?id=" + saleId);
          return;

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {}

            e.printStackTrace();
            out.println("<script>alert('❌ Billing Failed: " + e.getMessage() + "'); window.location='billing.jsp';</script>");
        }
    }


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
    }

