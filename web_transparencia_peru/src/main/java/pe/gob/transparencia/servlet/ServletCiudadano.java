package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.gob.transparencia.dao.DAOFactory;
import pe.gob.transparencia.entidades.CiudadanoEntidad;
import pe.gob.transparencia.modelo.CiudadanoModelo;

import java.io.IOException;

@WebServlet(name = "ServletCiudadano", urlPatterns = {"/ciudadano"})
public class ServletCiudadano extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion != null && accion.equals("cerrar")) {
            // Cerrar sesión de ciudadano
            HttpSession session = request.getSession();
            session.invalidate();
            // Crear nueva sesión para mensaje
            session = request.getSession();
            session.setAttribute("mensaje", "Sesión cerrada correctamente");
            response.sendRedirect("index.jsp");
            return;
        } else if (accion != null && accion.equals("perfil")) {
            // Mostrar perfil de ciudadano
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("ciudadano") != null) {
                request.getRequestDispatcher("ciudadano/perfil.jsp").forward(request, response);
                return;
            }
        } else if (accion != null && accion.equals("solicitudes")) {
            // Mostrar solicitudes del ciudadano
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("ciudadano") != null) {
                request.getRequestDispatcher("ciudadano/solicitudes.jsp").forward(request, response);
                return;
            }
        } else if (accion != null && accion.equals("nueva_solicitud")) {
            // Formulario de nueva solicitud
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("ciudadano") != null) {
                request.getRequestDispatcher("ciudadano/nueva_solicitud.jsp").forward(request, response);
                return;
            }
        }

        // En caso de no estar logueado, redirigir al login
        request.getSession().setAttribute("mensaje", "Debe iniciar sesión para realizar esta acción");
        response.sendRedirect("login_ciudadano.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion != null && accion.equals("login")) {
            // Procesar login de ciudadano
            String correo = request.getParameter("correo");
            String password = request.getParameter("password");

            // Validar datos
            if (correo == null || correo.isEmpty() || password == null || password.isEmpty()) {
                request.setAttribute("mensaje", "Debe ingresar correo y contraseña");
                request.getRequestDispatcher("login_ciudadano.jsp").forward(request, response);
                return;
            }

            // Autenticar ciudadano (buscamos por correo y password)
            CiudadanoModelo modelo = new CiudadanoModelo();
            CiudadanoEntidad ciudadano = modelo.buscarPorCredenciales(correo, password);

            if (ciudadano != null) {
                // Ciudadano autenticado, crear sesión
                HttpSession session = request.getSession();
                session.setAttribute("ciudadano", ciudadano);

                // Redirigir al panel de ciudadano
                response.sendRedirect("ciudadano/index.jsp");
            } else {
                // Ciudadano no autenticado
                request.setAttribute("mensaje", "Correo o contraseña incorrectos");
                request.getRequestDispatcher("login_ciudadano.jsp").forward(request, response);
            }
        } else if (accion != null && accion.equals("registro")) {
            // Procesar registro de nuevo ciudadano
            String nombres = request.getParameter("nombres");
            String apellidos = request.getParameter("apellidos");
            String dni = request.getParameter("dni");
            String correo = request.getParameter("correo");
            String telefono = request.getParameter("telefono");
            String direccion = request.getParameter("direccion");
            String password = request.getParameter("password"); // Se usará para autenticar en el futuro

            // Validar datos mínimos
            if (nombres == null || nombres.isEmpty() ||
                    apellidos == null || apellidos.isEmpty() ||
                    dni == null || dni.isEmpty() ||
                    correo == null || correo.isEmpty() ||
                    password == null || password.isEmpty()) {

                request.setAttribute("mensaje", "Todos los campos son obligatorios");
                request.getRequestDispatcher("registro_ciudadano.jsp").forward(request, response);
                return;
            }

            // Registrar nuevo ciudadano
            CiudadanoModelo modelo = new CiudadanoModelo();
            int resultado = modelo.registrarCiudadano(nombres, apellidos, dni, correo, telefono, direccion, password);

            if (resultado > 0) {
                // Registro exitoso
                HttpSession session = request.getSession();
                session.setAttribute("mensaje", "Registro exitoso, ahora puede iniciar sesión");
                response.sendRedirect("login_ciudadano.jsp");
            } else {
                // Error en el registro
                request.setAttribute("mensaje", "Error al registrar. El correo o DNI ya podría estar registrado.");
                request.getRequestDispatcher("registro_ciudadano.jsp").forward(request, response);
            }
        } else {
            // Acción no reconocida
            response.sendRedirect("login_ciudadano.jsp");
        }
    }
}