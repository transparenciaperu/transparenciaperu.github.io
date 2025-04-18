<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal de Transparencia Perú</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-SgOJa3DmI69IUzQ2PVdRZhwQ+dy64/BUtbMJw1MZ8t5HZApcHrRKUc4W0kG879m7" crossorigin="anonymous">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Montserrat:wght@400;500;600;700&display=swap"
          rel="stylesheet">
    <style>
        :root {
            --primary-red: #D91023;
            --primary-white: #FFFFFF;
            --dark-text: #333333;
            --secondary-blue: #1e3d59;
            --accent-gold: #FFD166;
            --light-gray: #f8f9fa;
        }

        body {
            font-family: 'Roboto', sans-serif;
            color: var(--dark-text);
        }

        .navbar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
        }

        h1, h2, h3, h4, h5 {
            font-family: 'Montserrat', sans-serif;
        }

        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('https://images.unsplash.com/photo-1531968455953-d48423fe679f?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 8rem 0;
            position: relative;
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

        .feature-card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            margin-bottom: 2rem;
            overflow: hidden;
            height: 100%;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }

        .feature-icon {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            color: var(--primary-red);
        }

        .card-img-overlay {
            background: linear-gradient(to top, rgba(0, 0, 0, 0.8) 0%, rgba(0, 0, 0, 0.1) 100%);
        }

        .btn-primary {
            background-color: var(--primary-red);
            border-color: var(--primary-red);
        }

        .btn-primary:hover {
            background-color: #b80d1e;
            border-color: #b80d1e;
        }

        .btn-outline-light:hover {
            background-color: var(--primary-red);
            border-color: var(--primary-red);
        }

        .nav-link {
            font-weight: 500;
            color: var(--dark-text);
        }

        .navbar {
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .navbar-nav .nav-link:hover {
            color: var(--primary-red);
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

        footer {
            background-color: var(--secondary-blue);
            color: white;
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

        .bg-peru-red {
            background-color: var(--primary-red);
        }

        .bg-peru-blue {
            background-color: var(--secondary-blue);
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

        .stats-block {
            padding: 2rem;
            text-align: center;
            background-color: var(--light-gray);
            border-radius: 10px;
        }

        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary-red);
            margin-bottom: 0;
        }

        .divider-vertical {
            width: 2px;
            background-color: rgba(0, 0, 0, 0.1);
            height: 50px;
        }
    </style>
</head>
<body>    <!-- Ribbon -->
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

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top py-3">
    <div class="container">
        <!-- Logo y marca -->
        <a class="navbar-brand d-flex align-items-center" href="#">
            <img src="https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/1845b901-cb25-481e-b9ec-c74e9a76936c/d5p73lk-f9b20a75-359d-49d3-8aaa-216d1e2cee27.jpg/v1/fill/w_888,h_900,q_70,strp/escudo_nacional_del_peru_by_esantillansalas_d5p73lk-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9OTEyIiwicGF0aCI6IlwvZlwvMTg0NWI5MDEtY2IyNS00ODFlLWI5ZWMtYzc0ZTlhNzY5MzZjXC9kNXA3M2xrLWY5YjIwYTc1LTM1OWQtNDlkMy04YWFhLTIxNmQxZTJjZWUyNy5qcGciLCJ3aWR0aCI6Ijw9OTAwIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmltYWdlLm9wZXJhdGlvbnMiXX0.rMjvedadAetkHJWCNFhhwRyFLJ9Gz7XCxAZ9hVRVAs8"
                 alt="Escudo de Perú" class="escudo-peru">
            <span class="d-flex flex-column">
                    <strong class="fs-4">Portal de Transparencia</strong>
                    <small class="text-danger fs-6">Gobierno del Perú</small>
                </span>
        </a>

        <!-- Botón de hamburguesa para móviles -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <!-- Contenido colapsable -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Menú de navegación con Ciudadano integrado como un elemento más del menú -->
            <ul class="navbar-nav w-100 justify-content-center">
                <li class="nav-item mx-1">
                    <a class="nav-link active fw-bold px-3 py-2 rounded-3 d-flex align-items-center" href="#">
                        <i class="fas fa-home me-2"></i><span>Inicio</span>
                    </a>
                </li>
                <li class="nav-item mx-1 dropdown">
                    <a class="nav-link dropdown-toggle px-3 py-2 rounded-3 d-flex align-items-center" href="#"
                       id="presupuestoDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="fas fa-chart-pie me-2"></i><span>Presupuesto</span>
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="presupuestoDropdown">
                        <li><a class="dropdown-item" href="#presupuesto">Ver Presupuesto Público</a></li>
                        <li><a class="dropdown-item" href="#">Ejecución Presupuestal</a></li>
                        <li><a class="dropdown-item" href="#">Proyectos de Inversión</a></li>
                    </ul>
                </li>
                <li class="nav-item mx-1">
                    <a class="nav-link px-3 py-2 rounded-3 d-flex align-items-center" href="#acceso">
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
                        <li><a class="dropdown-item" href="#"><i class="fas fa-user-plus me-2"></i>Registrarse</a></li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item" href="#"><i class="fas fa-question-circle me-2"></i>Ayuda</a></li>
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
                               placeholder="¿Qué información buscas? Ejemplo: presupuesto, solicitudes, entidades..."
                               aria-label="Search"
                               id="searchInput">
                        <button class="btn btn-danger border-start-0"
                                style="border-top-right-radius: 20px; border-bottom-right-radius: 20px;">
                            Buscar
                        </button>
                    </div>
                    <div class="search-tags d-none d-md-flex justify-content-center mt-2">
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>Presupuesto 2025</span>
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>MEF</span>
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>Solicitudes</span>
                        <span class="badge bg-light text-dark mx-1" style="cursor: pointer;"><i
                                class="fas fa-tag me-1"></i>Ley 27806</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Añadir script para la funcionalidad del buscador -->
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const searchBtn = document.getElementById('searchBtn');
        const searchPopup = document.querySelector('.search-popup');

        searchBtn.addEventListener('click', function () {
            searchPopup.classList.toggle('d-none');
        });

        // Cerrar al hacer clic fuera
        document.addEventListener('click', function (event) {
            if (!searchBtn.contains(event.target) && !searchPopup.contains(event.target)) {
                searchPopup.classList.add('d-none');
            }
        });

        // Añadir efecto hover a los elementos del menú
        const navItems = document.querySelectorAll('.navbar-nav .nav-link');
        navItems.forEach(item => {
            item.addEventListener('mouseenter', function () {
                if (!this.classList.contains('active')) {
                    this.style.backgroundColor = 'rgba(217, 16, 35, 0.1)';
                }
            });

            item.addEventListener('mouseleave', function () {
                if (!this.classList.contains('active')) {
                    this.style.backgroundColor = '';
                }
            });
        });
    });
</script>

<!-- Hero Section -->
<section class="hero-section position-relative">
    <div class="hero-overlay"></div>
    <div class="container position-relative">
        <div class="row">
            <div class="col-md-8">
                <h1 class="display-4 fw-bold mb-4">Transparencia al servicio del ciudadano</h1>
                <p class="lead mb-5">El Portal de Transparencia Perú es una plataforma que promueve el acceso a la
                    información pública y la rendición de cuentas, fortaleciendo la democracia y el derecho a saber de
                    todos los peruanos.</p>
                <div class="d-flex flex-wrap gap-2">
                    <a href="#presupuesto" class="btn btn-primary btn-lg px-4 me-md-2">Ver Presupuesto Público</a>
                    <a href="#acceso" class="btn btn-outline-light btn-lg px-4">Solicitar Información</a>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Stats Section -->
<section class="py-5 bg-light">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="row g-4 text-center">
                    <div class="col-md-4">
                        <div class="stats-block">
                            <i class="fas fa-landmark mb-3 text-primary fa-2x"></i>
                            <p class="stats-number" data-count="2500">2,500+</p>
                            <p class="text-muted mb-0">Entidades Públicas</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stats-block">
                            <i class="fas fa-file-invoice-dollar mb-3 text-primary fa-2x"></i>
                            <p class="stats-number" data-count="180">S/. 180 mil millones</p>
                            <p class="text-muted mb-0">Presupuesto Anual</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="stats-block">
                            <i class="fas fa-users mb-3 text-primary fa-2x"></i>
                            <p class="stats-number" data-count="120000">120,000+</p>
                            <p class="text-muted mb-0">Solicitudes Atendidas</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Main Features -->
<section class="py-5" id="features">
    <div class="container">
        <h2 class="section-title text-center mb-5">Nuestras Principales Funcionalidades</h2>

        <div class="row g-4">
            <!-- Presupuesto Público -->
            <div class="col-lg-6" id="presupuesto">
                <div class="feature-card h-100">
                    <div class="card h-100">
                        <img src="https://images.unsplash.com/photo-1554224155-8d04cb21cd6c?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
                             class="card-img-top" alt="Presupuesto Público" style="height: 250px; object-fit: cover;">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <i class="fas fa-chart-pie me-3 feature-icon"></i>
                                <h3 class="card-title">Presupuesto Público</h3>
                            </div>
                            <p class="card-text">Una plataforma amigable, intuitiva y funcional para obtener información
                                sobre la ejecución del presupuesto público asignado a cada gobierno local por el
                                Ministerio de Economía y Finanzas (MEF).</p>
                            <ul class="list-group list-group-flush mb-4">
                                <li class="list-group-item"><i class="fas fa-check-circle text-success me-2"></i>
                                    Visualización de datos en tiempo real
                                </li>
                                <li class="list-group-item"><i class="fas fa-check-circle text-success me-2"></i>
                                    Comparativas entre regiones y periodos
                                </li>
                                <li class="list-group-item"><i class="fas fa-check-circle text-success me-2"></i>
                                    Desglose por proyectos y categorías
                                </li>
                            </ul>
                            <a href="#" class="btn btn-primary">Explorar Presupuesto <i
                                    class="fas fa-arrow-right ms-2"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Acceso a Información -->
            <div class="col-lg-6" id="acceso">
                <div class="feature-card h-100">
                    <div class="card h-100">
                        <img src="https://cdn.www.gob.pe/uploads/document/file/217267/TRANSPARENCIA.jpg"
                             class="card-img-top" alt="Acceso a la Información"
                             style="height: 250px; object-fit: cover;">
                        <div class="card-body">
                            <div class="d-flex align-items-center mb-3">
                                <i class="fas fa-file-alt me-3 feature-icon"></i>
                                <h3 class="card-title">Acceso a la Información</h3>
                            </div>
                            <p class="card-text">Formulario virtual que permite recabar la información exigida por ley
                                para la identificación del solicitante y su posterior entrega de la información
                                solicitada, conforme a la Ley 27806.</p>
                            <ul class="list-group list-group-flush mb-4">
                                <li class="list-group-item"><i class="fas fa-check-circle text-success me-2"></i>
                                    Proceso simplificado de solicitud
                                </li>
                                <li class="list-group-item"><i class="fas fa-check-circle text-success me-2"></i>
                                    Seguimiento del estado de la solicitud
                                </li>
                                <li class="list-group-item"><i class="fas fa-check-circle text-success me-2"></i>
                                    Respuestas digitales seguras
                                </li>
                            </ul>
                            <a href="#" class="btn btn-primary">Solicitar Información <i
                                    class="fas fa-arrow-right ms-2"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Call to Action -->
<section class="py-5 bg-peru-blue text-white">
    <div class="container py-4">
        <div class="row align-items-center">
            <div class="col-lg-8 mb-4 mb-lg-0">
                <h2 class="mb-3">¿Necesitas más información?</h2>
                <p class="lead mb-0">Conoce cómo acceder a la información pública y ejercer tu derecho ciudadano.</p>
            </div>
            <div class="col-lg-4 text-lg-end">
                <a href="#" class="btn btn-outline-light btn-lg">Guía del Usuario</a>
            </div>
        </div>
    </div>
</section>

<!-- Entidades Destacadas -->
<section class="py-5">
    <div class="container">
        <h2 class="section-title mb-5">Entidades Destacadas</h2>
        <div class="row row-cols-2 row-cols-md-3 row-cols-lg-6 g-4">
            <div class="col">
                <div class="card h-100 text-center p-3 border-0 shadow-sm">
                    <img src="https://yt3.googleusercontent.com/GYD7rtlyVQIzYG5kfM-EDlcsWJIINfE9m7F1eH7tm__69YlOlCCqAFkOnsFyrOzRTx_GYpSe=s900-c-k-c0x00ffffff-no-rj"
                         class="card-img-top mx-auto" alt="MVCS"
                         style="height: 80px; width: auto; object-fit: contain;">
                    <div class="card-body p-0 pt-3">
                        <h6 class="card-title mb-0">Ministerio de Vivienda</h6>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100 text-center p-3 border-0 shadow-sm">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS73DJzi8mJrTNcpHW-zD7a4iKxrJdhKC8P-w&s"
                         class="card-img-top mx-auto" alt="MEF" style="height: 80px; width: auto; object-fit: contain;">
                    <div class="card-body p-0 pt-3">
                        <h6 class="card-title mb-0">Ministerio de Economía</h6>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100 text-center p-3 border-0 shadow-sm">
                    <img src="https://sni.org.pe/wp-content/uploads/2018/05/PRODUCE-800x400.png"
                         class="card-img-top mx-auto" alt="PRODUCE"
                         style="height: 80px; width: auto; object-fit: contain;">
                    <div class="card-body p-0 pt-3">
                        <h6 class="card-title mb-0">Ministerio de Producción</h6>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100 text-center p-3 border-0 shadow-sm">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSv6iE1r5iK9bZ4Jj4H8f-NetLJGUlTq9ZWIw&s"
                         class="card-img-top mx-auto" alt="MINJUS"
                         style="height: 80px; width: auto; object-fit: contain;">
                    <div class="card-body p-0 pt-3">
                        <h6 class="card-title mb-0">Ministerio de Justicia</h6>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100 text-center p-3 border-0 shadow-sm">
                    <img src="https://sindicatodevida.org.pe/wp-content/uploads/2017/12/logo-PCM-squared.gif"
                         class="card-img-top mx-auto" alt="PCM" style="height: 80px; width: auto; object-fit: contain;">
                    <div class="card-body p-0 pt-3">
                        <h6 class="card-title mb-0">Presidencia del Consejo de Ministros</h6>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100 text-center p-3 border-0 shadow-sm">
                    <img src="https://yt3.ggpht.com/a/AATXAJxEvdZfy36EXnQQ5Gc6fSC_fVWRwovTouCllQ=s900-c-k-c0xffffffff-no-rj-mo"
                         class="card-img-top mx-auto" alt="Congreso"
                         style="height: 80px; width: auto; object-fit: contain;">
                    <div class="card-body p-0 pt-3">
                        <h6 class="card-title mb-0">Congreso de la República</h6>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Footer -->
<footer class="pt-5 pb-4">
    <div class="container">
        <div class="row g-4">
            <div class="col-lg-4 mb-4 mb-lg-0">
                <h5 class="mb-4 text-white">Portal de Transparencia Perú</h5>
                <p class="text-white-50">Una iniciativa del Estado Peruano para promover la transparencia y el acceso a
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
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Inicio</a></li>
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Presupuesto Público</a></li>
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Acceso a la Información</a>
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
                    <li class="mb-2"><a href="#" class="text-white-50 text-decoration-none">Guía del Usuario</a></li>
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

<!-- Bootstrap 5 JavaScript Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.5/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-k6d4wzSIapyDyv1kpU366/PK5hCdSbCRGRCMv+eplOQJWyd1fbcAu9OCUj5zNLiq"
        crossorigin="anonymous"></script>
</body>
</html>