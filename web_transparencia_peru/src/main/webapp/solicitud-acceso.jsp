<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
    <!-- Animate.css para animaciones -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <style>
        :root {
            --primary-color: #1a3c8a;
            --secondary-color: #e63946;
            --accent-color: #f1faee;
            --text-color: #1d3557;
            --light-bg: #f8f9fa;
            --success-color: #2ecc71;
            --warning-color: #f39c12;
            --danger-color: #e74c3c;
            --info-color: #3498db;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-color);
            background-color: #f5f7fa;
        }
        
        .navbar {
            background-color: var(--primary-color);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .navbar-brand {
            font-weight: 700;
            color: white !important;
        }
        
        .nav-link {
            color: rgba(255, 255, 255, 0.85) !important;
        }
        
        .nav-link:hover {
            color: white !important;
        }
        
        .hero-section {
            background: linear-gradient(135deg, #1a3c8a 0%, #4361ee 100%);
            color: white;
            padding: 2.5rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 1rem 1rem;
        }
        
        .card {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 1.5rem;
            overflow: hidden;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 1rem 2rem rgba(0, 0, 0, 0.1);
        }
        
        .card-header {
            background-color: var(--primary-color);
            color: white;
            border-radius: 1rem 1rem 0 0 !important;
            padding: 1rem 1.5rem;
        }
        
        .info-box {
            background-color: white;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.05);
        }
        
        .info-box-title {
            color: var(--primary-color);
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .step-box {
            position: relative;
            padding: 1.5rem;
            background: white;
            border-radius: 1rem;
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
            background: var(--primary-color);
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
            background: rgba(26, 60, 138, 0.1);
            color: var(--primary-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            font-size: 1.5rem;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            box-shadow: 0 4px 6px rgba(26, 60, 138, 0.2);
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            background-color: #0f2b6b;
            border-color: #0f2b6b;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(26, 60, 138, 0.3);
        }
        
        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-outline-primary:hover {
            background-color: var(--primary-color);
            color: white;
        }
        
        .form-control:focus {
            border-color: #4d70d9;
            box-shadow: 0 0 0 0.25rem rgba(26, 60, 138, 0.25);
        }
        
        .footer {
            background-color: var(--primary-color);
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
            border: 4px solid var(--primary-color);
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
    <!-- Barra de navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-landmark me-2"></i>
                Portal de Transparencia Perú
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="index.jsp">Inicio</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="ServletPresupuesto">Presupuesto Público</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="ServletSolicitudAcceso">Acceso a la Información</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Datos Abiertos</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Entidades</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#">Contacto</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <div class="hero-section">
        <div class="container">
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
                        
                        <!-- Ejemplo de una solicitud encontrada (dinámica en la implementación real) -->
                        <div class="info-box animate-fadeInUp">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h5 class="info-box-title mb-2">Solicitud #SOL20250342</h5>
                                    <p class="mb-2">
                                        <strong>Fecha:</strong> 15/04/2025<br>
                                        <strong>Tipo:</strong> Proyectos y Obras Públicas<br>
                                        <strong>Entidad:</strong> Ministerio de Transportes y Comunicaciones
                                    </p>
                                </div>
                                <div class="col-md-3 text-md-center">
                                    <span class="status-badge status-en-proceso">En Proceso</span>
                                </div>
                                <div class="col-md-3 text-md-end">
                                    <a href="ServletSolicitudAcceso?accion=detalle&id=1" class="btn btn-sm btn-primary">
                                        <i class="fas fa-eye me-1"></i> Ver Detalles
                                    </a>
                                </div>
                            </div>
                            
                            <!-- Timeline de la solicitud -->
                            <div class="mt-4">
                                <h6 class="mb-3">Historial de la Solicitud</h6>
                                <div class="timeline">
                                    <div class="timeline-item left">
                                        <div class="timeline-content">
                                            <h6>Solicitud Recibida</h6>
                                            <p class="mb-0 small">15/04/2025 - 10:25 am</p>
                                        </div>
                                    </div>
                                    <div class="timeline-item right">
                                        <div class="timeline-content">
                                            <h6>En Revisión</h6>
                                            <p class="mb-0 small">16/04/2025 - 09:15 am</p>
                                        </div>
                                    </div>
                                    <div class="timeline-item left">
                                        <div class="timeline-content">
                                            <h6>En Proceso</h6>
                                            <p class="mb-0 small">18/04/2025 - 14:30 pm</p>
                                        </div>
                                    </div>
                                    <div class="timeline-item right">
                                        <div class="timeline-content">
                                            <h6>Próximo paso: Respuesta</h6>
                                            <p class="mb-0 small">Fecha estimada: 25/04/2025</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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
                                <h4 class="mb-0">12,458</h4>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3">
                                <i class="fas fa-check-circle fa-2x text-success"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Tasa de respuesta</h6>
                                <h4 class="mb-0">92.3%</h4>
                            </div>
                        </div>
                        <div class="d-flex align-items-center mb-3">
                            <div class="me-3">
                                <i class="fas fa-clock fa-2x text-warning"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Tiempo promedio</h6>
                                <h4 class="mb-0">7.2 días</h4>
                            </div>
                        </div>
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <i class="fas fa-building fa-2x text-info"></i>
                            </div>
                            <div>
                                <h6 class="mb-0">Entidades participantes</h6>
                                <h4 class="mb-0">283</h4>
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
            <div class="row">
                <div class="col-md-4 mb-4 mb-md-0">
                    <h5 class="mb-3">Portal de Transparencia Perú</h5>
                    <p>Facilitando el acceso a la información pública para promover la transparencia y participación ciudadana en la gestión pública.</p>
                </div>
                <div class="col-md-2 mb-4 mb-md-0">
                    <h5 class="mb-3">Enlaces</h5>
                    <ul class="list-unstyled">
                        <li><a href="index.jsp">Inicio</a></li>
                        <li><a href="ServletPresupuesto">Presupuesto</a></li>
                        <li><a href="ServletSolicitudAcceso">Solicitudes</a></li>
                        <li><a href="#">Datos Abiertos</a></li>
                    </ul>
                </div>
                <div class="col-md-3 mb-4 mb-md-0">
                    <h5 class="mb-3">Entidades Relacionadas</h5>
                    <ul class="list-unstyled">
                        <li><a href="https://www.gob.pe/mef" target="_blank">Ministerio de Economía</a></li>
                        <li><a href="https://www.gob.pe/pcm" target="_blank">Presidencia del Consejo de Ministros</a></li>
                        <li><a href="https://www.gob.pe/contraloria" target="_blank">Contraloría General</a></li>
                        <li><a href="https://www.gob.pe" target="_blank">Portal del Estado Peruano</a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h5 class="mb-3">Contacto</h5>
                    <address>
                        <i class="fas fa-map-marker-alt me-2"></i> Av. Abancay 251, Lima<br>
                        <i class="fas fa-phone me-2"></i> (01) 311-5930<br>
                        <i class="fas fa-envelope me-2"></i> <a href="mailto:transparencia@gob.pe">transparencia@gob.pe</a>
                    </address>
                </div>
            </div>
            <hr class="mt-4 mb-4" style="border-color: rgba(255,255,255,0.1);">
            <div class="row">
                <div class="col-md-6 text-center text-md-start">
                    <p class="mb-0">&copy; 2025 Portal de Transparencia Perú. Todos los derechos reservados.</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <ul class="list-inline mb-0">
                        <li class="list-inline-item"><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                        <li class="list-inline-item"><a href="#"><i class="fab fa-twitter"></i></a></li>
                        <li class="list-inline-item"><a href="#"><i class="fab fa-youtube"></i></a></li>
                        <li class="list-inline-item"><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                    </ul>
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
