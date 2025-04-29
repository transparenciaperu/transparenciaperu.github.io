<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Acceso a la Información | Portal de Transparencia Perú</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome para iconos -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Montserrat:wght@400;500;600;700&display=swap"
          rel="stylesheet">
    <!-- Animate.css para animaciones -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <style>
        :root {
            --primary-red: #D91023;
            --primary-white: #FFFFFF;
            --dark-text: #333333;
            --secondary-blue: #1e3d59;
            --accent-gold: #FFD166;
            --light-gray: #f8f9fa;
            --success-color: #2ecc71;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --info-color: #3498db;
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            color: var(--dark-text);
            background-color: #f5f7fa;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Montserrat', sans-serif;
        }

        .navbar {
            background-color: #fff;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .navbar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            color: var(--dark-text) !important;
        }
        
        .nav-link {
            font-weight: 500;
            color: var(--dark-text) !important;
        }
        
        .nav-link:hover {
            color: var(--primary-red) !important;
        }

        .nav-link.active {
            font-weight: bold;
        }
        
        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://cdn.www.gob.pe/uploads/document/file/217267/TRANSPARENCIA.jpg');
            background-position: center;
            background-size: cover;
            color: white;
            padding: 8rem 0;
            position: relative;
            margin-bottom: 2rem;
            border-radius: 0 0 1rem 1rem;
        }

        .hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, rgba(217, 16, 35, 0.8) 0%, rgba(30, 61, 89, 0.8) 100%);
            opacity: 0.7;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }
        
        .card-header {
            background-color: var(--primary-red);
            color: white;
            border-radius: 10px 10px 0 0 !important;
            padding: 1rem 1.5rem;
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
        }
        
        .info-box {
            background-color: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .info-box-title {
            color: var(--primary-red);
            font-weight: 600;
            margin-bottom: 1rem;
            font-family: 'Montserrat', sans-serif;
        }
        
        .step-box {
            position: relative;
            padding: 1.5rem;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0.25rem 1rem rgba(0, 0, 0, 0.08);
            margin-bottom: 2rem;
            transition: transform 0.3s;
        }
        
        .step-box:hover {
            transform: translateY(-5px);
        }
        
        .step-number {
            position: absolute;
            top: -15px;
            left: 20px;
            width: 40px;
            height: 40px;
            background: var(--primary-red);
            color: white;
            font-weight: bold;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2;
        }
        
        .step-icon {
            width: 60px;
            height: 60px;
            background: rgba(217, 16, 35, 0.1);
            color: var(--primary-red);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }
        
        .btn-primary {
            background-color: var(--primary-red);
            border-color: var(--primary-red);
            box-shadow: 0 4px 6px rgba(217, 16, 35, 0.2);
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            background-color: #b80d1e;
            border-color: #b80d1e;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(217, 16, 35, 0.3);
        }
        
        .btn-outline-primary {
            color: var(--primary-red);
            border-color: var(--primary-red);
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary-red);
            color: white;
        }
        
        .form-control:focus {
            border-color: #e03c47;
            box-shadow: 0 0 0 0.25rem rgba(217, 16, 35, 0.25);
        }
        
        .footer {
            background-color: var(--secondary-blue);
            color: white;
            padding: 2rem 0;
            margin-top: 3rem;
        }
        
        .footer a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
        }
        
        .footer a:hover {
            color: white;
            text-decoration: underline;
        }
        
        .timeline {
            position: relative;
            max-width: 900px;
            margin: 0 auto;
            margin-top: 3rem;
        }
        
        .timeline::after {
            content: '';
            position: absolute;
            width: 6px;
            background-color: #e0e0e0;
            top: 0;
            bottom: 0;
            left: 50%;
            margin-left: -3px;
            border-radius: 10px;
        }
        
        .timeline-item {
            padding: 10px 40px;
            position: relative;
            width: 50%;
            box-sizing: border-box;
        }
        
        .timeline-item::after {
            content: '';
            position: absolute;
            width: 25px;
            height: 25px;
            right: -12px;
            background-color: white;
            border: 4px solid var(--primary-red);
            top: 15px;
            border-radius: 50%;
            z-index: 1;
        }
        
        .left {
            left: 0;
        }
        
        .right {
            left: 50%;
        }
        
        .right::after {
            left: -13px;
        }
        
        .timeline-content {
            padding: 20px 30px;
            background-color: white;
            position: relative;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        .timeline-content::after {
            content: '';
            position: absolute;
            border-width: 10px;
            border-style: solid;
            top: 14px;
        }
        
        .left .timeline-content::after {
            border-color: transparent transparent transparent white;
            right: -19px;
        }
        
        .right .timeline-content::after {
            border-color: transparent white transparent transparent;
            left: -19px;
        }
        
        /* Status badges for solicitudes */
        .status-badge {
            display: inline-block;
            padding: 0.35em 0.65em;
            font-size: 0.85em;
            font-weight: 700;
            line-height: 1;
            text-align: center;
            white-space: nowrap;
            vertical-align: baseline;
            border-radius: 0.35rem;
        }
        
        .status-pendiente {
            background-color: var(--warning-color);
            color: white;
        }
        
        .status-en-proceso {
            background-color: var(--info-color);
            color: white;
        }
        
        .status-completada {
            background-color: var(--success-color);
            color: white;
        }
        
        .status-rechazada {
            background-color: var(--danger-color);
            color: white;
        }
        
        /* Animaciones */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translate3d(0, 20px, 0);
            }
            to {
                opacity: 1;
                transform: translate3d(0, 0, 0);
            }
        }
        
        .animate-fadeInUp {
            animation: fadeInUp 0.6s ease-out forwards;
        }

        .section-title {
            position: relative;
            margin-bottom: 3rem;
            font-weight: 700;
        }

        .section-title:after {
            content: '';
            position: absolute;
            width: 70px;
            height: 4px;
            background-color: var(--primary-red);
            bottom: -15px;
            left: 0;
        }

        .section-title.text-center:after {
            left: 50%;
            transform: translateX(-50%);
        }

        .social-icon {
            font-size: 1.5rem;
            margin-right: 1rem;
            color: white;
            transition: transform 0.3s ease;
        }

        .social-icon:hover {
            transform: translateY(-5px);
            color: var(--accent-gold);
        }

        .escudo-peru {
            height: 50px;
            margin-right: 10px;
        }

        .ribbon {
            background-color: var(--primary-red);
            color: white;
            padding: 0.5rem 0;
            font-size: 0.9rem;
        }

        /* Ajustes para dispositivos pequeños */
        @media screen and (max-width: 768px) {
            .timeline::after {
                left: 31px;
            }
            .timeline-item {
                width: 100%;
                padding-left: 70px;
                padding-right: 25px;
            }
            .timeline-item::after {
                left: 18px;
            }
            .left::after, .right::after {
                left: 18px;
            }
            .right {
                left: 0%;
            }
            .left .timeline-content::after, .right .timeline-content::after {
                border-color: transparent white transparent transparent;
                left: -19px;
            }
        }
    </style>
</head>
<body>
<!-- Ribbon -->
<div class="ribbon">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <i class="fas fa-calendar-alt me-2"></i> Portal actualizado: Abril 2025
            </div>
            <div>
                <a href="#" class="text-white me-3 text-decoration-none"><i class="fas fa-question-circle me-1"></i>
                    Ayuda</a>
                <a href="#" class="text-white text-decoration-none"><i class="fas fa-universal-access me-1"></i>
                    Accesibilidad</a>
            </div>
        </div>
    </div>
</div>

<!-- Barra de navegación -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top py-3">
        <div class="container">
            <!-- Logo y marca -->
            <a class="navbar-brand d-flex align-items-center" href="index.jsp">
                <img src="https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/1845b901-cb25-481e-b9ec-c74e9a76936c/d5p73lk-f9b20a75-359d-49d3-8aaa-216d1e2cee27.jpg/v1/fill/w_888,h_900,q_70,strp/escudo_nacional_del_peru_by_esantillansalas_d5p73lk-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9OTEyIiwicGF0aCI6IlwvZlwvMTg0NWI5MDEtY2IyNS00ODFlLWI5ZWMtYzc0ZTlhNzY5MzZjXC9kNXA3M2xrLWY5YjIwYTc1LTM1OWQtNDlkMy04YWFhLTIxNmQxZTJjZWUyNy5qcGciLCJ3aWR0aCI6Ijw9OTAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.rMjvedadAetkHJWCNFhhwRyFLJ9Gz7XCxAZ9hVRVAs8"
                     alt="Escudo de Perú" class="escudo-peru">
                <span class="d-flex flex-column">
                    <strong class="fs-4">Portal de Transparencia</strong>
                    <small class="text-danger fs-6">Gobierno del Perú</small>
                </span>
            </a>

            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav w-100 justify-content-center">
                    <li class="nav-item mx-1">
                        <a class="nav-link px-3 py-2 rounded-3 d-flex align-items-center" href="index.jsp">
                            <i class="fas fa-home me-2"></i><span>Inicio</span>
                        </a>
                    </li>
                    <li class="nav-item mx-1 dropdown">
                        <a class="nav-link dropdown-toggle px-3 py-2 rounded-3 d-flex align-items-center" href="#"
                           id="presupuestoDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-chart-pie me-2"></i><span>Presupuesto</span>
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="presupuestoDropdown">
                            <li><a class="dropdown-item" href="ServletPresupuesto">Ver Presupuesto Público</a></li>
                            <li><a class="dropdown-item" href="#">Ejecución Presupuestal</a></li>
                            <li><a class="dropdown-item" href="#">Proyectos de Inversión</a></li>
                        </ul>
                    </li>
                    <li class="nav-item mx-1">
                        <a class="nav-link active fw-bold px-3 py-2 rounded-3 d-flex align-items-center"
                           href="ServletSolicitudAcceso">
                            <i class="fas fa-file-alt me-2"></i><span>Información</span>
                        </a>
                    </li>
                    <li class="nav-item mx-1 dropdown">
                        <a class="nav-link dropdown-toggle px-3 py-2 rounded-3 d-flex align-items-center" href="#"
                           id="entidadesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-building me-2"></i><span>Entidades</span>
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="entidadesDropdown">
                            <li><a class="dropdown-item" href="#">Directorio</a></li>
                            <li><a class="dropdown-item" href="#">Ministerios</a></li>
                            <li><a class="dropdown-item" href="#">Gobiernos Regionales</a></li>
                            <li><a class="dropdown-item" href="#">Municipalidades</a></li>
                        </ul>
                    </li>
                    <li class="nav-item mx-1">
                        <a class="nav-link px-3 py-2 rounded-3 d-flex align-items-center" href="#">
                            <i class="fas fa-database me-2"></i><span>Datos</span>
                        </a>
                    </li>
                    <li class="nav-item mx-1 dropdown ms-lg-auto">
                        <a class="nav-link dropdown-toggle px-3 py-2 rounded-3 d-flex align-items-center text-danger"
                           href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="fas fa-user-circle me-2"></i><span>Ciudadano</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="#"><i class="fas fa-sign-in-alt me-2"></i>Iniciar Sesión</a>
                            </li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-user-plus me-2"></i>Registrarse</a>
                            </li>
                            <li>
                                <hr class="dropdown-divider">
                            </li>
                            <li><a class="dropdown-item" href="#"><i class="fas fa-question-circle me-2"></i>Ayuda</a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Barra de búsqueda independiente -->
    <div class="bg-light py-3 border-bottom">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="search-container position-relative w-100">
                        <div class="input-group">
                                <span class="input-group-text border-end-0 bg-white"
                                      style="border-top-left-radius: 20px; border-bottom-left-radius: 20px;">
                                    <i class="fas fa-search text-danger"></i>
                                </span>
                            <input class="form-control border-start-0 border-end-0 shadow-sm"
                                   type="search"
                                   placeholder="Buscar solicitudes de acceso..."
                                   aria-label="Search"
                                   id="searchInput">
                            <button class="btn btn-danger border-start-0"
                                    style="border-top-right-radius: 20px; border-bottom-right-radius: 20px;">
                                Buscar
                            </button>
                        </div>
                        <div class="search-tags d-none d-md-flex justify-content-center mt-2">
                            <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                    class="fas fa-tag me-1"></i>Solicitudes</span>
                            <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                    class="fas fa-tag me-1"></i>Ley 27806</span>
                            <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                    class="fas fa-tag me-1"></i>Formularios</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Hero Section -->
    <div class="hero-section">
        <div class="hero-overlay"></div>
        <div class="container position-relative">
            <div class="row align-items-center">
                <div class="col-lg-7">
                    <h1 class="display-5 fw-bold mb-3">Acceso a la Información Pública</h1>
                    <p class="lead">Solicita, gestiona y recibe información pública de forma simple, segura y transparente. Ejerciendo tu derecho ciudadano con solo unos clics.</p>
                    <div class="d-flex gap-2 mt-4">
                        <a href="#solicitar" class="btn btn-light btn-lg px-4">
                            <i class="fas fa-file-alt me-2"></i> Solicitar información
                        </a>
                        <a href="#seguimiento" class="btn btn-outline-light btn-lg px-4">
                            <i class="fas fa-search me-2"></i> Seguimiento
                        </a>
                    </div>
                </div>
                <div class="col-lg-5 d-none d-lg-block">
                    <img src="assets/img/access-info.svg" class="img-fluid" alt="Acceso a la Información">
                </div>
            </div>
        </div>
    </div>

    <!-- Contenido Principal -->
    <div class="container">
        <div class="row">
            <div class="col-lg-8">
                <!-- Sección: Proceso Simplificado -->
                <div class="info-box">
                    <h3 class="info-box-title">¿Cómo funciona?</h3>
                    <p class="mb-4">El proceso para solicitar información pública es simple y está diseñado para garantizar que obtengas la información que necesitas de manera eficiente y segura:</p>
                    
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="step-box">
                                <div class="step-number">1</div>
                                <div class="step-icon mx-auto">
                                    <i class="fas fa-user-plus"></i>
                                </div>
                                <h5 class="text-center">Regístrate</h5>
                                <p class="text-center">Crea una cuenta con tus datos personales para acceder al sistema.</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="step-box">
                                <div class="step-number">2</div>
                                <div class="step-icon mx-auto">
                                    <i class="fas fa-file-alt"></i>
                                </div>
                                <h5 class="text-center">Completa el formulario</h5>
                                <p class="text-center">Indica la entidad y describe claramente la información que necesitas.</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="step-box">
                                <div class="step-number">3</div>
                                <div class="step-icon mx-auto">
                                    <i class="fas fa-search"></i>
                                </div>
                                <h5 class="text-center">Seguimiento</h5>
                                <p class="text-center">Monitorea el estado de tu solicitud en tiempo real mediante tu panel personal.</p>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="step-box">
                                <div class="step-number">4</div>
                                <div class="step-icon mx-auto">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <h5 class="text-center">Recibe respuesta</h5>
                                <p class="text-center">Obtén la información solicitada de manera digital, segura y verificable.</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Formulario de Solicitud -->
                <div class="card animate-fadeInUp" id="solicitar">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-file-alt me-2"></i> Nueva Solicitud de Acceso</h4>
                    </div>
                    <div class="card-body">
                        <form action="ServletSolicitudAcceso" method="post">
                            <input type="hidden" name="accion" value="registrar">
                            
                            <div class="row g-3">
                                <!-- Si no está logueado, mostrar campos de datos personales -->
                                <div class="col-md-6">
                                    <label for="nombres" class="form-label">Nombres</label>
                                    <input type="text" class="form-control" id="nombres" name="nombres" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="apellidos" class="form-label">Apellidos</label>
                                    <input type="text" class="form-control" id="apellidos" name="apellidos" required>
                                </div>
                                <div class="col-md-6">
                                    <label for="dni" class="form-label">DNI</label>
                                    <input type="text" class="form-control" id="dni" name="dni" pattern="[0-9]{8}" maxlength="8" required>
                                    <div class="form-text">Ingrese su número de DNI (8 dígitos)</div>
                                </div>
                                <div class="col-md-6">
                                    <label for="correo" class="form-label">Correo Electrónico</label>
                                    <input type="email" class="form-control" id="correo" name="correo" required>
                                </div>
                                
                                <div class="col-md-6">
                                    <label for="tipoSolicitudId" class="form-label">Tipo de Información</label>
                                    <select class="form-select" id="tipoSolicitudId" name="tipoSolicitudId" required>
                                        <option value="" selected disabled>Seleccione una opción</option>
                                        <option value="1">Información Presupuestal</option>
                                        <option value="2">Proyectos y Obras Públicas</option>
                                        <option value="3">Contrataciones y Adquisiciones</option>
                                        <option value="4">Personal y Remuneraciones</option>
                                        <option value="5">Normativa y Resoluciones</option>
                                        <option value="6">Otros</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="entidad" class="form-label">Entidad Pública</label>
                                    <select class="form-select" id="entidad" name="entidad" required>
                                        <option value="" selected disabled>Seleccione una entidad</option>
                                        <option value="1">Ministerio de Economía y Finanzas</option>
                                        <option value="2">Ministerio de Educación</option>
                                        <option value="3">Ministerio de Salud</option>
                                        <option value="4">Ministerio de Transportes y Comunicaciones</option>
                                        <option value="5">Ministerio del Interior</option>
                                        <option value="6">Municipalidad de Lima</option>
                                        <option value="7">Gobierno Regional de Lima</option>
                                        <!-- Más opciones -->
                                    </select>
                                </div>
                                
                                <div class="col-12">
                                    <label for="descripcion" class="form-label">Descripción de la Información Solicitada</label>
                                    <textarea class="form-control" id="descripcion" name="descripcion" rows="5" required placeholder="Describa de manera clara y precisa la información que solicita..."></textarea>
                                    <div class="form-text">Sea específico para ayudarnos a procesar su solicitud más rápido.</div>
                                </div>
                                
                                <div class="col-12">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="terminos" required>
                                        <label class="form-check-label" for="terminos">
                                            Acepto los términos y condiciones y la política de privacidad
                                        </label>
                                    </div>
                                </div>
                                
                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn btn-primary px-4 py-2">
                                        <i class="fas fa-paper-plane me-2"></i> Enviar Solicitud
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                
                <!-- Seguimiento de Solicitudes -->
                <div class="card animate-fadeInUp mt-4" id="seguimiento">
                    <div class="card-header">
                        <h4 class="mb-0"><i class="fas fa-search me-2"></i> Seguimiento de Solicitudes</h4>
                    </div>
                    <div class="card-body">
                        <div class="row mb-4">
                            <div class="col-md-8">
                                <form action="ServletSolicitudAcceso" method="get" class="d-flex gap-2">
                                    <input type="hidden" name="accion" value="buscar">
                                    <input type="text" class="form-control" placeholder="Ingrese el código de su solicitud" name="codigo">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search"></i>
                                    </button>
                                </form>
                            </div>
                            <div class="col-md-4 text-md-end">
                                <a href="ServletSolicitudAcceso?accion=misSolicitudes" class="btn btn-outline-primary">
                                    <i class="fas fa-list me-1"></i> Ver Mis Solicitudes
                                </a>
                            </div>
                        </div>

                        <!-- Mostrar solicitudes de la base de datos -->
                        <c:if test="${not empty solicitudes}">
                            <c:forEach var="solicitud" items="${solicitudes}" varStatus="status">
                                <div class="info-box animate-fadeInUp mb-3">
                                    <div class="row align-items-center">
                                        <div class="col-md-6">
                                            <h5 class="info-box-title mb-2">Solicitud #SOL${solicitud.id}</h5>
                                            <p class="mb-2">
                                                <strong>Fecha:</strong> <fmt:formatDate
                                                    value="${solicitud.fechaSolicitud}" pattern="dd/MM/yyyy"/><br>
                                                <strong>Tipo:</strong> ${solicitud.tipoSolicitud.nombre}<br>
                                                <strong>Solicitante:</strong> ${solicitud.ciudadano.nombres} ${solicitud.ciudadano.apellidos}
                                            </p>
                                        </div>
                                        <div class="col-md-3 text-md-center">
                                            <c:choose>
                                                <c:when test="${solicitud.estadoSolicitud.id == 1}">
                                                    <span class="status-badge status-pendiente">Pendiente</span>
                                                </c:when>
                                                <c:when test="${solicitud.estadoSolicitud.id == 2}">
                                                    <span class="status-badge status-en-proceso">En Proceso</span>
                                                </c:when>
                                                <c:when test="${solicitud.estadoSolicitud.id == 3}">
                                                    <span class="status-badge status-completada">Atendida</span>
                                                </c:when>
                                                <c:when test="${solicitud.estadoSolicitud.id == 4}">
                                                    <span class="status-badge status-rechazada">Observada</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-rechazada">Rechazada</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="col-md-3 text-md-end">
                                            <a href="ServletSolicitudAcceso?accion=detalle&id=${solicitud.id}"
                                               class="btn btn-sm btn-primary">
                                                <i class="fas fa-eye me-1"></i> Ver Detalles
                                            </a>
                                        </div>
                                    </div>

                                    <!-- Mostrar descripción truncada -->
                                    <div class="mt-3">
                                        <h6>Descripción</h6>
                                        <p>${fn:substring(solicitud.descripcion, 0, 150)}${fn:length(solicitud.descripcion) > 150 ? '...' : ''}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>

                        <!-- Si no hay solicitudes o no está logueado, mostrar ejemplo -->
                        <c:if test="${empty solicitudes}">
                            <div class="info-box animate-fadeInUp">
                                <div class="row align-items-center">
                                    <div class="col-md-12 text-center">
                                        <div class="alert alert-warning">
                                            <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                                            <h4>No hay datos disponibles</h4>
                                            <p>No se pudieron cargar los datos de solicitudes. Por favor, inténtelo de
                                                nuevo más tarde o inicie sesión para ver sus solicitudes.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Información sobre derechos -->
                <div class="info-box animate-fadeInUp">
                    <h4 class="info-box-title">Tu Derecho a Saber</h4>
                    <p>El acceso a la información pública es un derecho fundamental reconocido por la Constitución Política del Perú y regulado por la Ley Nº 27806.</p>
                    <ul class="mb-0">
                        <li>Derecho a solicitar información sin expresión de causa</li>
                        <li>Plazo máximo de respuesta: 10 días hábiles (prorrogable)</li>
                        <li>La información es gratuita (salvo costos de reproducción)</li>
                        <li>Derecho a recibir información completa, cierta y actualizada</li>
                    </ul>
                </div>
                
                <!-- Estadísticas -->
                <div class="card animate-fadeInUp">
                    <div class="card-header">
                        <h5 class="mb-0">Estadísticas</h5>
                    </div>
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3">
                                <i class="fas fa-file-alt fa-2x text-primary"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Solicitudes este año</h6>
                                <h4 class="mb-0">
                                    <c:choose>
                                        <c:when test="${empty solicitudesTotal}">
                                            <span class="text-danger">No disponible</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${fn:length(solicitudesTotal)}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </h4>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3">
                                <i class="fas fa-check-circle fa-2x text-success"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Tasa de respuesta</h6>
                                <h4 class="mb-0">
                                    <c:choose>
                                        <c:when test="${empty solicitudesTotal}">
                                            <span class="text-danger">No disponible</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="solicitudesRespondidas" value="0"/>
                                            <c:forEach var="solicitud" items="${solicitudesTotal}">
                                                <c:if test="${solicitud.estadoSolicitudId == 3}">
                                                    <c:set var="solicitudesRespondidas"
                                                           value="${solicitudesRespondidas + 1}"/>
                                                </c:if>
                                            </c:forEach>
                                            <fmt:formatNumber
                                                    value="${solicitudesRespondidas / fn:length(solicitudesTotal) * 100}"
                                                    pattern="#,##0.0"/>%
                                        </c:otherwise>
                                    </c:choose>
                                </h4>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3">
                                <i class="fas fa-clock fa-2x text-warning"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Tiempo promedio</h6>
                                <h4 class="mb-0">
                                    <c:choose>
                                        <c:when test="${empty solicitudesTotal || tiempoPromedioAtencion <= 0}">
                                            <span class="text-danger">No disponible</span>
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${tiempoPromedioAtencion}" pattern="#,##0.0"/> días
                                        </c:otherwise>
                                    </c:choose>
                                </h4>
                            </div>
                        </div>
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <i class="fas fa-building fa-2x text-info"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Entidades participantes</h6>
                                <h4 class="mb-0">
                                    <c:choose>
                                        <c:when test="${empty solicitudesTotal || totalEntidadesParticipantes <= 0}">
                                            <span class="text-danger">No disponible</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${totalEntidadesParticipantes}"/>
                                        </c:otherwise>
                                    </c:choose>
                                </h4>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Preguntas Frecuentes -->
                <div class="card animate-fadeInUp mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">Preguntas Frecuentes</h5>
                    </div>
                    <div class="card-body">
                        <div class="accordion" id="accordionFAQ">
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingOne">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
                                        ¿Qué información puedo solicitar?
                                    </button>
                                </h2>
                                <div id="collapseOne" class="accordion-collapse collapse" aria-labelledby="headingOne" data-bs-parent="#accordionFAQ">
                                    <div class="accordion-body">
                                        Puede solicitar cualquier información creada, obtenida, en posesión o bajo control de las entidades públicas, con las excepciones previstas por ley (seguridad nacional, procesos en curso, datos personales sensibles, etc).
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingTwo">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo">
                                        ¿Cuánto tiempo tarda el proceso?
                                    </button>
                                </h2>
                                <div id="collapseTwo" class="accordion-collapse collapse" aria-labelledby="headingTwo" data-bs-parent="#accordionFAQ">
                                    <div class="accordion-body">
                                        La entidad tiene un plazo máximo de 10 días hábiles para atender su solicitud, prorrogables por 5 días adicionales en casos excepcionales debidamente fundamentados.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingThree">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree">
                                        ¿Qué hacer si no recibo respuesta?
                                    </button>
                                </h2>
                                <div id="collapseThree" class="accordion-collapse collapse" aria-labelledby="headingThree" data-bs-parent="#accordionFAQ">
                                    <div class="accordion-body">
                                        Si no recibe respuesta en el plazo establecido, puede interponer un recurso de apelación ante la Autoridad Nacional de Transparencia o presentar una demanda de Hábeas Data ante el Poder Judicial.
                                    </div>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <h2 class="accordion-header" id="headingFour">
                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour">
                                        ¿La información tiene algún costo?
                                    </button>
                                </h2>
                                <div id="collapseFour" class="accordion-collapse collapse" aria-labelledby="headingFour" data-bs-parent="#accordionFAQ">
                                    <div class="accordion-body">
                                        El acceso a la información pública es gratuito. Solo se puede cobrar el costo de reproducción (copias, impresión, etc.). La información digital entregada por medios electrónicos no tiene costo.
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Contacto de ayuda -->
                <div class="info-box animate-fadeInUp mt-4">
                    <h5 class="info-box-title">¿Necesitas ayuda?</h5>
                    <p>Si tienes dudas sobre cómo solicitar información o problemas con el proceso, nuestro equipo está listo para ayudarte.</p>
                    <div class="d-grid gap-2">
                        <a href="#" class="btn btn-outline-primary">
                            <i class="fas fa-headset me-2"></i> Chat en vivo
                        </a>
                        <a href="mailto:transparencia@gob.pe" class="btn btn-outline-primary">
                            <i class="fas fa-envelope me-2"></i> transparencia@gob.pe
                        </a>
                        <a href="tel:+5113115930" class="btn btn-outline-primary">
                            <i class="fas fa-phone me-2"></i> (01) 311-5930
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row g-4">
                <div class="col-lg-4 mb-4 mb-lg-0">
                    <h5 class="mb-4 text-white">Portal de Transparencia Perú</h5>
                    <p class="text-white-50">Una iniciativa del Estado Peruano para promover la transparencia y el
                        acceso a
                        la información pública según la Ley 27806.</p>
                    <div class="mt-4">
                        <a href="#" class="social-icon"><i class="fab fa-facebook"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-youtube"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-2 mb-4 mb-lg-0">
                    <h6 class="text-white mb-4">Enlaces Rápidos</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2"><a href="index.jsp" class="text-white-50 text-decoration-none">Inicio</a></li>
                        <li class="mb-2"><a href="ServletPresupuesto" class="text-white-50 text-decoration-none">Presupuesto
                            Público</a></li>
                        <li class="mb-2"><a href="ServletSolicitudAcceso" class="text-white-50 text-decoration-none">Acceso
                            a la Información</a>
                        </li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Entidades</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Datos Abiertos</a></li>
                    </ul>
                </div>
                <div class="col-sm-6 col-lg-3 mb-4 mb-lg-0">
                    <h6 class="text-white mb-4">Recursos</h6>
                    <ul class="list-unstyled mb-0">
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Preguntas Frecuentes</a>
                        </li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Guía del Usuario</a>
                        </li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Ley de Transparencia</a>
                        </li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Procedimientos</a></li>
                        <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Formatos</a></li>
                    </ul>
                </div>
                <div class="col-lg-3">
                    <h6 class="text-white mb-4">Contacto</h6>
                    <ul class="list-unstyled text-white-50">
                        <li class="mb-2"><i class="fas fa-map-marker-alt me-2"></i> Jr. Carabaya Cdra. 1 s/n, Lima, Perú
                        </li>
                        <li class="mb-2"><i class="fas fa-phone me-2"></i> (511) 311-5930</li>
                        <li class="mb-2"><i class="fas fa-envelope me-2"></i> transparencia@peru.gob.pe</li>
                    </ul>
                </div>
            </div>
            <hr class="mt-4 mb-3" style="border-color: rgba(255,255,255,0.1)">
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <p class="small text-white-50 mb-md-0">&copy; 2025 Portal de Transparencia Perú. Todos los derechos
                        reservados.</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <a href="#" class="text-white-50 text-decoration-none small me-3">Términos y Condiciones</a>
                    <a href="#" class="text-white-50 text-decoration-none small me-3">Política de Privacidad</a>
                    <a href="#" class="text-white-50 text-decoration-none small">Accesibilidad</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Animación al hacer scroll
            const animateElements = document.querySelectorAll('.animate-fadeInUp');
            
            function checkIfInView() {
                animateElements.forEach(element => {
                    const elementTop = element.getBoundingClientRect().top;
                    const elementVisible = 150;
                    
                    if (elementTop < window.innerHeight - elementVisible) {
                        element.classList.add('animate__animated', 'animate__fadeInUp');
                    }
                });
            }
            
            window.addEventListener('scroll', checkIfInView);
            checkIfInView(); // Verificar elementos visibles al cargar la página
            
            // Inicialización para más funcionalidades
        });
    </script>
</body>
</html>
