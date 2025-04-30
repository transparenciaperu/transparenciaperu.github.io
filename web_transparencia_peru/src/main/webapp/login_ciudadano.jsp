<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso Ciudadano - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
        }

        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 20px;
            border-radius: 8px;
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .header-logo {
            text-align: center;
            margin-bottom: 25px;
        }

        .header-logo img {
            max-width: 80px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="login-container">
        <div class="header-logo">
            <img src="assets/img/escudo-peru.png" alt="Escudo de Perú"
                 onerror="this.src='https://www.gob.pe/assets/escudo-af8270af12c1a9bf7f46ca9441eb9116df71ed4e197a4bbd0f87546d246a6f01.svg';">
            <h4>Portal de Transparencia</h4>
            <p class="text-muted">Acceso Ciudadano</p>
        </div>

        <%
            // Recuperar mensaje de sesión y eliminarlo
            String mensajeSesion = (String) session.getAttribute("mensaje");
            if (mensajeSesion != null) {
                session.removeAttribute("mensaje");
        %>
        <div class="alert alert-danger" role="alert">
            <%= mensajeSesion %>
        </div>
        <% } %>

        <% if (request.getAttribute("mensaje") != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= request.getAttribute("mensaje") %>
        </div>
        <% } %>

        <% if (request.getParameter("mensaje") != null) { %>
        <div class="alert alert-success" role="alert">
            <%= request.getParameter("mensaje") %>
        </div>
        <% } %>

        <form action="ciudadano" method="post">
            <input type="hidden" name="accion" value="login">

            <div class="mb-3">
                <label for="correo" class="form-label">Correo electrónico</label>
                <input type="email" class="form-control" id="correo" name="correo" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Contraseña</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">Iniciar Sesión</button>
            </div>
        </form>

        <div class="mt-4 text-center">
            <p>¿No tiene cuenta? <a href="registro_ciudadano.jsp">Regístrese aquí</a></p>
            <a href="index.jsp">Volver al portal público</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>