<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro de Ciudadano - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        :root {
            --primary-color: #0F4C75;
            --secondary-color: #3282B8;
            --accent-color: #BBE1FA;
            --dark-color: #1B262C;
            --light-color: #F8F9FA;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .main-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 20px 0;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .registro-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 800px;
            margin: 50px auto;
        }

        .form-label {
            font-weight: 500;
            color: var(--dark-color);
        }

        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-primary:hover {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
        }

        .form-control:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.25rem rgba(50, 130, 184, 0.25);
        }

        .logo {
            height: 80px;
            margin-right: 15px;
        }

        footer {
            background-color: var(--dark-color);
            color: white;
            padding: 20px 0;
            margin-top: 50px;
        }

        .registro-header {
            border-bottom: 1px solid #e9ecef;
            padding-bottom: 20px;
            margin-bottom: 30px;
        }

        .registro-header h2 {
            color: var(--primary-color);
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<header class="main-header">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <img src="https://www.transparencia.gob.pe/assets/img/escudo.png" alt="Escudo Perú" class="logo">
                <div>
                    <h1 class="fs-3 mb-0">Portal de Transparencia</h1>
                    <p class="fs-5 mb-0">República del Perú</p>
                </div>
            </div>
        </div>
    </div>
</header>

<div class="container">
    <div class="registro-container">
        <div class="text-center registro-header">
            <h2><i class="fas fa-user-plus"></i> Registro de Ciudadano</h2>
            <p class="text-muted">Complete el formulario para crear su cuenta</p>
        </div>

        <% if (request.getAttribute("mensaje") != null) { %>
        <div class="alert alert-danger" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i> <%= request.getAttribute("mensaje") %>
        </div>
        <% } %>

        <form action="ciudadano.do" method="post">
            <input type="hidden" name="accion" value="registro">

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="nombres" class="form-label"><i class="fas fa-user me-2"></i>Nombres</label>
                    <input type="text" class="form-control" id="nombres" name="nombres" required>
                </div>
                <div class="col-md-6">
                    <label for="apellidos" class="form-label"><i class="fas fa-user me-2"></i>Apellidos</label>
                    <input type="text" class="form-control" id="apellidos" name="apellidos" required>
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="dni" class="form-label"><i class="fas fa-id-card me-2"></i>DNI</label>
                    <input type="text" class="form-control" id="dni" name="dni" required maxlength="8"
                           pattern="[0-9]{8}" placeholder="12345678">
                    <div class="form-text">Ingrese su DNI de 8 dígitos sin espacios ni guiones</div>
                </div>
                <div class="col-md-6">
                    <label for="correo" class="form-label"><i class="fas fa-envelope me-2"></i>Correo
                        Electrónico</label>
                    <input type="email" class="form-control" id="correo" name="correo" required
                           placeholder="ejemplo@correo.com">
                </div>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label for="telefono" class="form-label"><i class="fas fa-phone me-2"></i>Teléfono</label>
                    <input type="tel" class="form-control" id="telefono" name="telefono" placeholder="999 888 777">
                </div>
                <div class="col-md-6">
                    <label for="password" class="form-label"><i class="fas fa-lock me-2"></i>Contraseña</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                    <div class="form-text">La contraseña debe tener al menos 6 caracteres</div>
                </div>
            </div>

            <div class="mb-4">
                <label for="direccion" class="form-label"><i class="fas fa-home me-2"></i>Dirección</label>
                <textarea class="form-control" id="direccion" name="direccion" rows="2"
                          placeholder="Av. Principal 123, Distrito, Provincia"></textarea>
            </div>

            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="terminos" required>
                <label class="form-check-label" for="terminos">
                    Acepto los <a href="#" class="text-decoration-none">términos y condiciones</a> y la <a href="#"
                                                                                                           class="text-decoration-none">política
                    de privacidad</a>
                </label>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-primary btn-lg">
                    <i class="fas fa-user-plus me-2"></i> Crear Cuenta
                </button>
            </div>
        </form>

        <div class="text-center mt-4 pt-3 border-top">
            <p>¿Ya tiene cuenta? <a href="login_unificado.jsp" class="text-decoration-none">Inicie sesión aquí</a>
            </p>
            <a href="index.jsp" class="btn btn-outline-secondary mt-2">
                <i class="fas fa-arrow-left me-2"></i> Volver al portal público
            </a>
        </div>
    </div>
</div>

<footer class="mt-auto">
    <div class="container">
        <div class="row">
            <div class="col-md-6">
                <p>© <%= java.time.Year.now().getValue() %> Portal de Transparencia Perú</p>
            </div>
            <div class="col-md-6 text-md-end">
                <p>República del Perú</p>
            </div>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>