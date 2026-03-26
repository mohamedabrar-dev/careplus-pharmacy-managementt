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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(urlPatterns = {"/editmedicine"})
public class editmedicine extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out = response.getWriter();
        try {
            Connection con = new dbconfig().getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE medicines SET name=?, generic_name=?, category=?, manufacturer=?, price=?, stock=?, unit=?, expiry_date=? WHERE id=?"
            );
            ps.setString(1, request.getParameter("name"));
            ps.setString(2, request.getParameter("generic_name"));
            ps.setString(3, request.getParameter("category"));
            ps.setString(4, request.getParameter("manufacturer"));
            ps.setDouble(5, Double.parseDouble(request.getParameter("price")));
            ps.setInt(6, Integer.parseInt(request.getParameter("stock")));
            ps.setString(7, request.getParameter("unit"));
            ps.setDate(8, java.sql.Date.valueOf(request.getParameter("expiry_date")));
            ps.setInt(9, Integer.parseInt(request.getParameter("id")));
            ps.executeUpdate();
            response.sendRedirect("inventory.jsp");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
        return "Short description";
    }// </editor-fold>

}
