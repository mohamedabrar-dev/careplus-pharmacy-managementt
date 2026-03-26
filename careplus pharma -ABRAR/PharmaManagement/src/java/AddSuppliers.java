/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import com.pharma.config.dbconfig;
import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SupplierServlet")
public class AddSuppliers extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            try {
                String name = request.getParameter("supplier_name");
                String contact = request.getParameter("contact_person");
                String phone = request.getParameter("phone");
                String email = request.getParameter("email");
                String address = request.getParameter("address");

                Connection con = new dbconfig().getConnection();

                PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO suppliers (supplier_name, contact_person, phone, email, address) VALUES (?,?,?,?,?)"
                );

                ps.setString(1, name);
                ps.setString(2, contact);
                ps.setString(3, phone);
                ps.setString(4, email);
                ps.setString(5, address);

                ps.executeUpdate();

                response.sendRedirect("suppliers.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error: " + e.getMessage());
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));

                Connection con = new dbconfig().getConnection();

                PreparedStatement ps = con.prepareStatement(
                    "DELETE FROM suppliers WHERE supplier_id=?"
                );

                ps.setInt(1, id);
                ps.executeUpdate();

                response.sendRedirect("suppliers.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Cannot delete supplier. It may be linked.");
            }
        }
    }
}
