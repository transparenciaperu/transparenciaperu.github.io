<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Redirigir al inicio o login según la sesión
    HttpSession sesion = request.getSession(false);
    if (sesion != null) {
        if (sesion.getAttribute("ciudadano") != null) {
            response.sendRedirect("ciudadano/index.jsp");
            return;
        } else if (sesion.getAttribute("usuario") != null) {
            // Obtener el rol del usuario
            pe.gob.transparencia.entidades.UsuarioEntidad usuario =
                    (pe.gob.transparencia.entidades.UsuarioEntidad) sesion.getAttribute("usuario");

            if (usuario != null) {
                if ("ADMIN".equals(usuario.getCodRol())) {
                    response.sendRedirect("admin/index.jsp");
                    return;
                } else if ("FUNCIONARIO".equals(usuario.getCodRol())) {
                    response.sendRedirect("funcionario/index.jsp");
                    return;
                }
            }
        }
    }
    // Si no hay sesión, redirigir al login unificado
    response.sendRedirect("login_unificado.jsp");
%>