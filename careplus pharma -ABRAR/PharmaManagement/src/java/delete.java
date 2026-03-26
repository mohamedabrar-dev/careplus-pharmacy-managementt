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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(urlPatterns = {"/delete"})
public class delete extends HttpServlet {

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
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            Connection con = new dbconfig().getConnection();
            // Check if medicine already used in sales
            PreparedStatement check = con.prepareStatement(
                "SELECT medicine_id FROM sales_items WHERE medicine_id=?"
            );
            check.setInt(1, id);
            ResultSet rs = check.executeQuery();
            if (rs.next()) {
                response.sendRedirect("inventory.jsp?msg=used");
            } else {
                PreparedStatement del = con.prepareStatement(
                    "DELETE FROM medicines WHERE id=?"
                );
                del.setInt(1, id);
                del.executeUpdate();
                response.sendRedirect("inventory.jsp?msg=deleted");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("inventory.jsp?msg=error");
        }
    }
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Delete medicine safely";
    }// </editor-fold>
}
