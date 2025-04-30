package pe.gob.transparencia.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.gob.transparencia.entidades.CiudadanoEntidad;

import java.io.IOException;

@WebFilter(filterName = "CiudadanoFilter", urlPatterns = {"/ciudadano/*"})
public class CiudadanoFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("ciudadano") != null);

        if (isLoggedIn) {
            // El ciudadano está logueado, permitir el acceso
            chain.doFilter(request, response);
        } else {
            // No está logueado, redirigir al login de ciudadano
            // En lugar de pasar el error como parámetro URL, usar una sesión flash
            req.getSession().setAttribute("mensaje", "Debe iniciar sesión para acceder a esta área");
            res.sendRedirect(req.getContextPath() + "/login_ciudadano.jsp");
        }
    }

    @Override
    public void destroy() {
    }
}