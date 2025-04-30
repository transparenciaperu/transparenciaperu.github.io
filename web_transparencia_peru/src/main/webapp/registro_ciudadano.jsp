<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Ciudadano - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
        }

        .registro-container {
            max-width: 600px;
            margin: 50px auto;
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
    <div class="registro-container">
        <div class="header-logo">
            <img src="assets/img/escudo-peru.png" alt="Escudo de Perú"
                 onerror="this.src='https://www.gob.pe/assets/escudo-af8270af12c1a9bf7f46ca9441eb9116df71ed4e197a4bbd0f87546d246a6f01.svg';">
            <h4>Portal de Transparencia</h4>
            <p class="text-muted">Registro de Ciudadano</p>
        </div>

        <% if (request.getAttribute("mensaje") != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= request.getAttribute("mensaje") %>
        </div>
        <% } %>

        <form action="ciudadano" method="post">
            <input type="hidden" name="accion" value="registro">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="nombres" class="form-label">Nombres</label>
                    <input type="text" class="form-control" id="nombres" name="nombres" required>
                </div>
                <div class="col-md-6">
                    <label for="apellidos" class="form-label">Apellidos</label>
                    <input type="text" class="form-control" id="apellidos" name="apellidos" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="dni" class="form-label">DNI</label>
                    <input type="text" class="form-control" id="dni" name="dni" required maxlength="8"
                           pattern="[0-9]{8}">
                    <div class="form-text">Ingrese su DNI de 8 dígitos sin espacios ni guiones</div>
                </div>
                <div class="col-md-6">
                    <label for="correo" class="form-label">Correo Electrónico</label>
                    <input type="email" class="form-control" id="correo" name="correo" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="telefono" class="form-label">Teléfono</label>
                    <input type="tel" class="form-control" id="telefono" name="telefono">
                </div>
                <div class="col-md-6">
                    <label for="password" class="form-label">Contraseña</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
            </div>

            <div class="mb-3">
                <label for="direccion" class="form-label">Dirección</label>
                <textarea class="form-control" id="direccion" name="direccion" rows="2"></textarea>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary">Registrarse</button>
            </div>
        </form>

        <div class="mt-4 text-center">
            <p>¿Ya tiene cuenta? <a href="login_ciudadano.jsp">Inicie sesión aquí</a></p>
            <a href="index.jsp">Volver al portal público</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>