package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet de inicialización para establecer la estructura de la base de datos
 */
@WebServlet(name = "InicializacionServlet", urlPatterns = {"/inicializacion"})
public class InicializacionServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("InicializacionServlet inicializado");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Estado del Sistema</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet de Inicialización</h1>");
            out.println("<p>El sistema está inicializado correctamente.</p>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}