<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Redireccionar al panel principal con un mensaje informativo
    session.setAttribute("mensaje", "La sección 'Entidades Públicas' está en desarrollo. Estará disponible próximamente.");
    response.sendRedirect("index.jsp");
%>