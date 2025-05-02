package pe.gob.transparencia.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import pe.gob.transparencia.entidades.UsuarioEntidad;

import java.io.IOException;

@WebFilter(filterName = "FuncionarioFilter", urlPatterns = {"/funcionario/*"})
public class FuncionarioFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        boolean isLoggedIn = (session != null && session.getAttribute("usuario") != null);
        boolean isFuncionario = false;

        if (isLoggedIn) {
            UsuarioEntidad usuario = (UsuarioEntidad) session.getAttribute("usuario");
            isFuncionario = "FUNCIONARIO".equals(usuario.getCodRol());
        }

        if (isLoggedIn && isFuncionario) {
            // El usuario es funcionario, permitir el acceso
            chain.doFilter(request, response);
        } else {
            // No hay usuario en sesión o no es funcionario, redirigir al login
            req.setAttribute("mensajeErrorFuncionario", "No tiene permisos para acceder a esta área");
            res.sendRedirect(req.getContextPath() + "/login_unificado.jsp");
            return;
        }
    }

    @Override
    public void destroy() {
    }
}