<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal de Transparencia Perú - Acceso al Sistema</title>
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

        .login-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 500px;
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

        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }

        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: white;
        }

        .tab-content {
            padding-top: 20px;
        }

        .nav-tabs .nav-link {
            color: var(--dark-color);
            font-weight: 500;
        }

        .nav-tabs .nav-link.active {
            color: var(--primary-color);
            font-weight: 600;
        }

        .form-control:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.25rem rgba(50, 130, 184, 0.25);
        }

        .alert {
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
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

        .login-container h3 {
            color: var(--primary-color);
            margin-bottom: 20px;
            font-weight: 600;
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
    <div class="login-container">
        <div class="text-center mb-4">
            <h2>Acceso al sistema</h2>
            <p class="text-muted">Seleccione el tipo de usuario para iniciar sesión</p>
        </div>

        <!-- Tabs para los diferentes tipos de usuario -->
        <ul class="nav nav-tabs" id="loginTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="ciudadano-tab" data-bs-toggle="tab"
                        data-bs-target="#ciudadano-login"
                        type="button" role="tab" aria-controls="ciudadano-login" aria-selected="true">
                    <i class="fas fa-user"></i> Ciudadano
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="funcionario-tab" data-bs-toggle="tab" data-bs-target="#funcionario-login"
                        type="button" role="tab" aria-controls="funcionario-login" aria-selected="false">
                    <i class="fas fa-user-tie"></i> Funcionario
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="admin-tab" data-bs-toggle="tab" data-bs-target="#admin-login"
                        type="button" role="tab" aria-controls="admin-login" aria-selected="false">
                    <i class="fas fa-user-shield"></i> Administrador
                </button>
            </li>
        </ul>

        <!-- Contenido de las tabs -->
        <div class="tab-content" id="loginTabContent">
            <!-- Login Ciudadano -->
            <div class="tab-pane fade show active" id="ciudadano-login" role="tabpanel" aria-labelledby="ciudadano-tab">
                <h3><i class="fas fa-user"></i> Acceso Ciudadano</h3>

                <% if (request.getAttribute("mensajeError") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("mensajeError") %>
                </div>
                <% } %>

                <form action="ciudadano.do" method="post">
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
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
                        </button>
                    </div>
                    <div class="text-center mt-3">
                        <p>¿No tiene cuenta? <a href="registro_ciudadano.jsp" class="text-decoration-none">Regístrese
                            aquí</a></p>
                    </div>
                </form>
            </div>

            <!-- Login Funcionario -->
            <div class="tab-pane fade" id="funcionario-login" role="tabpanel" aria-labelledby="funcionario-tab">
                <h3><i class="fas fa-user-tie"></i> Acceso Funcionario</h3>

                <% if (request.getAttribute("mensajeErrorFuncionario") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("mensajeErrorFuncionario") %>
                </div>
                <% } %>

                <form action="autenticacion.do" method="post">
                    <input type="hidden" name="accion" value="login">
                    <input type="hidden" name="tipo" value="FUNCIONARIO">
                    <div class="mb-3">
                        <label for="usuario" class="form-label">Usuario</label>
                        <input type="text" class="form-control" id="usuario" name="usuario" required>
                    </div>
                    <div class="mb-3">
                        <label for="clave" class="form-label">Contraseña</label>
                        <input type="password" class="form-control" id="clave" name="clave" required>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
                        </button>
                    </div>
                </form>
            </div>

            <!-- Login Administrador -->
            <div class="tab-pane fade" id="admin-login" role="tabpanel" aria-labelledby="admin-tab">
                <h3><i class="fas fa-user-shield"></i> Acceso Administrador</h3>

                <% if (request.getAttribute("mensajeErrorAdmin") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("mensajeErrorAdmin") %>
                </div>
                <% } %>

                <form action="autenticacion.do" method="post">
                    <input type="hidden" name="accion" value="login">
                    <input type="hidden" name="tipo" value="ADMIN">
                    <div class="mb-3">
                        <label for="usuarioAdmin" class="form-label">Usuario</label>
                        <input type="text" class="form-control" id="usuarioAdmin" name="usuario" required>
                    </div>
                    <div class="mb-3">
                        <label for="claveAdmin" class="form-label">Contraseña</label>
                        <input type="password" class="form-control" id="claveAdmin" name="clave" required>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-sign-in-alt"></i> Iniciar Sesión
                        </button>
                    </div>
                </form>
            </div>
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