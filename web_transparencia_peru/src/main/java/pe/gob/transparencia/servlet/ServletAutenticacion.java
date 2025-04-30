package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.gob.transparencia.dao.DAOFactory;
import pe.gob.transparencia.entidades.UsuarioEntidad;
import pe.gob.transparencia.interfaces.UsuarioInterface;

import java.io.IOException;

@WebServlet(name = "ServletAutenticacion", urlPatterns = {"/autenticacion"})
public class ServletAutenticacion extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion != null && accion.equals("cerrar")) {
            // Cerrar sesión
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect("login.jsp?mensaje=Sesión cerrada correctamente");
            return;
        }

        // En caso de no especificar acción, redirigir al login
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion != null && accion.equals("login")) {
            // Procesar login
            String usuario = request.getParameter("usuario");
            String clave = request.getParameter("clave");

            // Validar datos
            if (usuario == null || usuario.isEmpty() || clave == null || clave.isEmpty()) {
                request.setAttribute("mensaje", "Debe ingresar usuario y clave");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }

            // Autenticar usuario
            DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
            UsuarioInterface dao = daoFactory.getUsuarioDAO();

            UsuarioEntidad user = dao.autenticar(usuario, clave);

            if (user != null) {
                // Usuario autenticado, crear sesión
                HttpSession session = request.getSession();
                session.setAttribute("usuario", user);

                // Redirigir según el rol
                switch (user.getCodRol()) {
                    case "ADMIN":
                        response.sendRedirect("admin/index.jsp");
                        break;
                    case "FUNCIONARIO":
                        response.sendRedirect("funcionario/index.jsp");
                        break;
                    default:
                        // Rol no reconocido
                        request.setAttribute("mensaje", "No tiene permisos para acceder al sistema");
                        request.getRequestDispatcher("login.jsp").forward(request, response);
                        break;
                }
            } else {
                // Usuario no autenticado
                request.setAttribute("mensaje", "Usuario o clave incorrectos");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            // Acción no reconocida
            response.sendRedirect("login.jsp");
        }
    }
}