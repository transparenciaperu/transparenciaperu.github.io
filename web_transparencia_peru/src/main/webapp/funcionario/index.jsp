<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="pe.gob.transparencia.entidades.UsuarioEntidad" %>
<%@ page import="pe.gob.transparencia.entidades.SolicitudAccesoEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.SolicitudAccesoModelo" %>
<%@ page import="pe.gob.transparencia.entidades.DocumentoTransparenciaEntidad" %>
<%@ page import="pe.gob.transparencia.modelo.DocumentoTransparenciaModelo" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="pe.gob.transparencia.util.ConexionBD" %>
<%@ page import="java.util.Date" %>

<%
    // Verificar si el usuario está en sesión y es funcionario
    HttpSession sesion = request.getSession(false);
    if (sesion == null || sesion.getAttribute("usuario") == null || !((UsuarioEntidad) sesion.getAttribute("usuario")).getCodRol().equals("FUNCIONARIO")) {
        // No es funcionario o no está logueado, redirigir al login
        response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
        return;
    }
    UsuarioEntidad usuario = (UsuarioEntidad) sesion.getAttribute("usuario");

    // Obtener ID de la entidad del funcionario
    int entidadFuncionarioId = 0; // Inicializar con 0
    try {
        Connection connTemp = pe.gob.transparencia.util.ConexionBD.getConexion();
        PreparedStatement psTemp = connTemp.prepareStatement(
                "SELECT entidadPublicaId FROM Funcionario WHERE usuarioId = ?");
        psTemp.setInt(1, usuario.getIdUsuario());
        System.out.println("Consultando entidadPublicaId para usuarioId: " + usuario.getIdUsuario());
        ResultSet rsTemp = psTemp.executeQuery();
        if (rsTemp.next()) {
            entidadFuncionarioId = rsTemp.getInt("entidadPublicaId");
            System.out.println("Entidad del funcionario encontrada: ID=" + entidadFuncionarioId);
        } else {
            System.out.println("ALERTA: No se encontró entidad para este usuario");
            // Intentamos obtener información adicional
            Connection connUser = pe.gob.transparencia.util.ConexionBD.getConexion();
            PreparedStatement psUser = connUser.prepareStatement("SELECT * FROM Usuario WHERE id = ?");
            psUser.setInt(1, usuario.getIdUsuario());
            ResultSet rsUser = psUser.executeQuery();
            if (rsUser.next()) {
                System.out.println("Usuario encontrado en base de datos. Nombre: " + rsUser.getString("nombre"));
            } else {
                System.out.println("Usuario NO encontrado en base de datos!");
            }
            rsUser.close();
            psUser.close();
            connUser.close();
        }
        rsTemp.close();
        psTemp.close();
        connTemp.close();
    } catch (Exception e) {
        System.out.println("ERROR obteniendo entidad: " + e.getMessage());
        e.printStackTrace();
    }

    // Si no se encontró entidad, usar entidad 1 como valor predeterminado
    if (entidadFuncionarioId <= 0) {
        entidadFuncionarioId = 1;
        System.out.println("Usando entidad predeterminada: ID=1");
    }

    // === OBTENER DATOS DE SOLICITUDES ===
    // Variables para estadísticas
    int pendientes = 0;
    int enProceso = 0;
    int atendidas = 0;
    int porVencer = 0;
    int totalSolicitudes = 0;

    // Lista de solicitudes recientes para mostrar
    List<SolicitudAccesoEntidad> solicitudesRecientes = new ArrayList<>();

    // Calcular días para vencer (10 días hábiles es el límite estándar)
    final long DIAS_LIMITE = 10;

    try {
        System.out.println("=== USANDO MÉTODO DE CONTEO IDÉNTICO A solicitudes.jsp ===");

        // Obtener todas las solicitudes sin filtros, igual que en solicitudes.jsp
        SolicitudAccesoModelo modelo = new SolicitudAccesoModelo();
        List<SolicitudAccesoEntidad> solicitudes = modelo.listarSolicitudes();
        System.out.println("Total de solicitudes obtenidas: " + solicitudes.size());

        // Imprimir todas las solicitudes para depuración
        System.out.println("Solicitudes encontradas:");
        for (SolicitudAccesoEntidad sol : solicitudes) {
            System.out.println("ID: " + sol.getId() +
                    " | Estado: " + sol.getEstadoSolicitudId() +
                    " | EntidadID: " + sol.getEntidadPublicaId());
        }

        // Contar por estado exactamente igual que en solicitudes.jsp
        for (SolicitudAccesoEntidad sol : solicitudes) {
            // Contar por estado
            switch (sol.getEstadoSolicitudId()) {
                case 1:
                    pendientes++;
                    System.out.println("Encontrada solicitud PENDIENTE: ID=" + sol.getId());
                    break; // Pendiente
                case 2:
                    enProceso++;
                    break; // En proceso
                case 3:
                    atendidas++;
                    break; // Atendida
            }

            // Verificar si está por vencer (3 días o menos)
            if (sol.getEstadoSolicitudId() == 1 || sol.getEstadoSolicitudId() == 2) {
                java.util.Date fechaSolicitud = sol.getFechaSolicitud();
                java.util.Date hoy = new java.util.Date();
                long diferenciaDias = TimeUnit.DAYS.convert(hoy.getTime() - fechaSolicitud.getTime(), TimeUnit.MILLISECONDS);

                if (DIAS_LIMITE - diferenciaDias <= 3 && diferenciaDias < DIAS_LIMITE) {
                    porVencer++;
                }
            }

            // Guardar solicitudes para mostrar (sólo las de la entidad del funcionario)
            if (sol.getEntidadPublicaId() == entidadFuncionarioId && solicitudesRecientes.size() < 5) {
                solicitudesRecientes.add(sol);
            }
        }

        System.out.println("RESULTADO DEL CONTEO:");
        System.out.println("Pendientes: " + pendientes);
        System.out.println("En proceso: " + enProceso);
        System.out.println("Atendidas: " + atendidas);
        System.out.println("Por vencer: " + porVencer);

        // Ordenar las solicitudes por fecha (más recientes primero)
        if (!solicitudesRecientes.isEmpty()) {
            Collections.sort(solicitudesRecientes, new Comparator<SolicitudAccesoEntidad>() {
                @Override
                public int compare(SolicitudAccesoEntidad o1, SolicitudAccesoEntidad o2) {
                    if (o1.getFechaSolicitud() == null || o2.getFechaSolicitud() == null) {
                        return 0;
                    }
                    return o2.getFechaSolicitud().compareTo(o1.getFechaSolicitud());
                }
            });
        }

        totalSolicitudes = pendientes + enProceso + atendidas;

    } catch (Exception e) {
        System.out.println("ERROR en conteo de solicitudes: " + e.getMessage());
        e.printStackTrace();
    }

    // === OBTENER DATOS DE DOCUMENTOS DE TRANSPARENCIA ===
    int totalDocumentos = 0;
    int documentosPendientes = 0;
    int documentosPublicados = 0;

    // Lista de documentos recientes
    List<DocumentoTransparenciaEntidad> documentosRecientes = new ArrayList<>();

    // Mapa para estadísticas por categoría
    Map<String, Integer> documentosPorCategoria = new HashMap<>();

    try {
        DocumentoTransparenciaModelo documentoModelo = new DocumentoTransparenciaModelo();
        // Listar documentos - como este método podría no existir, usamos una alternativa
        List<DocumentoTransparenciaEntidad> todosDocumentos = new ArrayList<>();

        // Obtenemos documentos por categorías individuales
        todosDocumentos.addAll(documentoModelo.listarPorCategoria("datos-generales"));
        todosDocumentos.addAll(documentoModelo.listarPorCategoria("planeamiento"));
        todosDocumentos.addAll(documentoModelo.listarPorCategoria("presupuesto"));
        todosDocumentos.addAll(documentoModelo.listarPorCategoria("proyectos"));
        todosDocumentos.addAll(documentoModelo.listarPorCategoria("contrataciones"));
        todosDocumentos.addAll(documentoModelo.listarPorCategoria("personal"));

        // Inicializar categorías
        documentosPorCategoria.put("datos-generales", 0);
        documentosPorCategoria.put("planeamiento", 0);
        documentosPorCategoria.put("presupuesto", 0);
        documentosPorCategoria.put("proyectos", 0);
        documentosPorCategoria.put("contrataciones", 0);
        documentosPorCategoria.put("personal", 0);

        // Filtrar por entidad del funcionario y contar
        for (DocumentoTransparenciaEntidad doc : todosDocumentos) {
            if (doc.getEntidadPublicaId() == entidadFuncionarioId) {
                // Contar total
                totalDocumentos++;

                // Contar por estado
                if (doc.getEstado().equals("Publicado")) {
                    documentosPublicados++;
                } else {
                    documentosPendientes++;
                }

                // Contar por categoría
                if (documentosPorCategoria.containsKey(doc.getCategoria())) {
                    documentosPorCategoria.put(doc.getCategoria(),
                            documentosPorCategoria.get(doc.getCategoria()) + 1);
                }

                // Guardar para mostrar en el panel (solo las primeras 5)
                if (documentosRecientes.size() < 5) {
                    documentosRecientes.add(doc);
                }
            }
        }

        // Ordenar los documentos por fecha (más recientes primero)
        Collections.sort(documentosRecientes, new Comparator<DocumentoTransparenciaEntidad>() {
            @Override
            public int compare(DocumentoTransparenciaEntidad o1, DocumentoTransparenciaEntidad o2) {
                if (o1.getFechaPublicacion() == null || o2.getFechaPublicacion() == null) {
                    return 0;
                }
                return o2.getFechaPublicacion().compareTo(o1.getFechaPublicacion());
            }
        });

    } catch (Exception e) {
        e.printStackTrace();
    }

    // Formato para fechas
    SimpleDateFormat formatoFecha = new SimpleDateFormat("dd/MM/yyyy");

    // Obtener datos para el gráfico de solicitudes mensuales
    Map<String, Integer> datosSolicitudesMensuales = new LinkedHashMap<>();
    String[] meses = {"Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"};

    try {
        int anioActual = Calendar.getInstance().get(Calendar.YEAR);

        // Inicializar todos los meses con 0
        for (String mes : meses) {
            datosSolicitudesMensuales.put(mes, 0);
        }

        // Llenar con datos reales
        Connection conn = pe.gob.transparencia.util.ConexionBD.getConexion();
        String sql = "SELECT MONTH(fechaSolicitud) as mes, COUNT(*) as total FROM SolicitudAcceso " +
                "WHERE entidadPublicaId = ? AND YEAR(fechaSolicitud) = ? " +
                "GROUP BY MONTH(fechaSolicitud) ORDER BY mes";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, entidadFuncionarioId);
        ps.setInt(2, anioActual);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            int mes = rs.getInt("mes");
            int total = rs.getInt("total");

            if (mes > 0 && mes <= 12) {
                datosSolicitudesMensuales.put(meses[mes - 1], total);
            }
        }

        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    // Convertir datos del gráfico a formato JSON para JavaScript
    StringBuilder labelsJSON = new StringBuilder("[");
    StringBuilder dataJSON = new StringBuilder("[");

    boolean first = true;
    for (Map.Entry<String, Integer> entry : datosSolicitudesMensuales.entrySet()) {
        if (!first) {
            labelsJSON.append(", ");
            dataJSON.append(", ");
        }
        labelsJSON.append("'").append(entry.getKey()).append("'");
        dataJSON.append(entry.getValue());
        first = false;
    }

    labelsJSON.append("]");
    dataJSON.append("]");

    // Verificar si hay mensajes en la sesión
    String mensaje = (String) session.getAttribute("mensaje");
    String tipoMensaje = (String) session.getAttribute("tipoMensaje");

    // Eliminar mensajes de la sesión después de obtenerlos
    if (mensaje != null) {
        session.removeAttribute("mensaje");
        session.removeAttribute("tipoMensaje");
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Portal de Transparencia Perú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/funcionario.css">
    <style>
        :root {
            --theme-primary: #3867d6;
            --theme-secondary: #20bf6b;
            --theme-warning: #f7b731;
            --theme-danger: #fc5c65;
            --theme-info: #45aaf2;
        }

        .dashboard-header {
            background: linear-gradient(135deg, #3867d6 0%, #4b7bec 100%);
            color: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }

        .dashboard-header::before {
            content: '';
            position: absolute;
            top: -40px;
            right: -40px;
            width: 200px;
            height: 200px;
            border-radius: 100%;
            background-color: rgba(255, 255, 255, 0.1);
        }

        .dashboard-header::after {
            content: '';
            position: absolute;
            bottom: -60px;
            left: 40px;
            width: 150px;
            height: 150px;
            border-radius: 100%;
            background-color: rgba(255, 255, 255, 0.05);
        }

        .stat-card {
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
            height: 100%;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-card .card-body {
            padding: 1.5rem;
        }

        .stat-card .title {
            font-size: 0.875rem;
            color: #718096;
            font-weight: 500;
        }

        .stat-card .value {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-icon {
            font-size: 3rem;
            opacity: 0.8;
            color: var(--theme-primary);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100%;
        }

        .warning-accent {
            border-left: 5px solid var(--theme-warning);
        }

        .primary-accent {
            border-left: 5px solid var(--theme-primary);
        }

        .success-accent {
            border-left: 5px solid var(--theme-secondary);
        }

        .danger-accent {
            border-left: 5px solid var(--theme-danger);
        }

        .secondary-accent {
            border-left: 5px solid var(--theme-info);
        }

        .chart-container {
            position: relative;
            height: 300px;
            margin: 0 auto;
        }

        .recent-item {
            padding: 0.75rem;
            border-radius: 8px;
            transition: background-color 0.2s;
        }

        .recent-item:hover {
            background-color: #f7fafc;
        }

        .recent-icon {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            font-size: 1.25rem;
        }

        .recent-icon.doc {
            background-color: rgba(69, 170, 242, 0.2);
            color: #45aaf2;
        }

        .recent-icon.sol {
            background-color: rgba(32, 191, 107, 0.2);
            color: #20bf6b;
        }

        .badge-soft-warning {
            background-color: rgba(247, 183, 49, 0.2);
            color: #f7b731;
        }

        .badge-soft-primary {
            background-color: rgba(56, 103, 214, 0.2);
            color: #3867d6;
        }

        .badge-soft-success {
            background-color: rgba(32, 191, 107, 0.2);
            color: #20bf6b;
        }

        .badge-soft-danger {
            background-color: rgba(252, 92, 101, 0.2);
            color: #fc5c65;
        }

        .welcome-banner {
            background: linear-gradient(135deg, #3867d6 0%, #4b7bec 100%);
            color: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            position: relative;
            overflow: hidden;
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
        }

        .card .card-header {
            background-color: transparent;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            font-weight: 600;
        }

        .activity-item {
            padding: 1rem;
            border-left: 3px solid transparent;
            margin-bottom: 0.5rem;
            border-radius: 0 8px 8px 0;
            transition: all 0.2s;
        }

        .activity-item:hover {
            background-color: #f7fafc;
            border-left-color: var(--theme-primary);
        }

        .activity-icon {
            width: 36px;
            height: 36px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background-color: #e2e8f0;
            margin-right: 1rem;
        }

        .activity-icon.add {
            background-color: rgba(32, 191, 107, 0.2);
            color: #20bf6b;
        }

        .activity-icon.edit {
            background-color: rgba(56, 103, 214, 0.2);
            color: #3867d6;
        }

        .activity-icon.delete {
            background-color: rgba(252, 92, 101, 0.2);
            color: #fc5c65;
        }

        .activity-icon.view {
            background-color: rgba(69, 170, 242, 0.2);
            color: #45aaf2;
        }

        .activity-content {
            flex-grow: 1;
        }

        .activity-time {
            color: #718096;
            font-size: 0.875rem;
        }

        .category-pill {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 500;
            display: inline-block;
        }

        .category-datos-generales {
            background-color: rgba(69, 170, 242, 0.2);
            color: #45aaf2;
        }

        .category-planeamiento {
            background-color: rgba(32, 191, 107, 0.2);
            color: #20bf6b;
        }

        .category-presupuesto {
            background-color: rgba(247, 183, 49, 0.2);
            color: #f7b731;
        }

        .category-proyectos {
            background-color: rgba(165, 94, 234, 0.2);
            color: #a55eea;
        }

        .category-contrataciones {
            background-color: rgba(56, 103, 214, 0.2);
            color: #3867d6;
        }

        .category-personal {
            background-color: rgba(252, 92, 101, 0.2);
            color: #fc5c65;
        }
    </style>
</head>
<body class="funcionario-theme">
<!-- Navbar superior -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Portal de Transparencia | Panel de Control</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
                aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button"
                       data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-person-circle me-1"></i><%= usuario.getNombreCompleto() %>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="#"><i class="bi bi-person me-1"></i> Perfil</a></li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <li><a class="dropdown-item"
                               href="<%= request.getContextPath() %>/autenticacion.do?accion=cerrar"><i
                                class="bi bi-box-arrow-right me-1"></i> Cerrar Sesión</a></li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
            <div class="sidebar-sticky pt-3">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="<%= request.getContextPath() %>/funcionario/index.jsp">
                            <i class="bi bi-house me-1"></i> Inicio
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/funcionario/transparencia.jsp">
                            <i class="bi bi-file-earmark-text me-1"></i> Gestión de Transparencia
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="<%= request.getContextPath() %>/funcionario/solicitudes.jsp">
                            <i class="bi bi-envelope-open me-1"></i> Solicitudes de Información
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Contenido principal -->
        <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
            <!-- Banner de bienvenida -->
            <div class="welcome-banner fade-in mt-4 mb-4">
                <div class="row">
                    <div class="col-lg-8">
                        <h1>Bienvenido(a), <%= usuario.getNombreCompleto().split(" ")[0] %>
                        </h1>
                        <p class="mb-4">Acceda a todas las herramientas para gestionar las solicitudes de transparencia
                            y la información pública de su entidad.</p>
                        <div class="d-grid gap-2 d-md-flex">
                            <a href="solicitudes.jsp" class="btn btn-light btn-lg px-4 me-md-2">
                                <i class="bi bi-envelope-open me-2"></i>Gestionar Solicitudes
                            </a>
                            <a href="transparencia.jsp" class="btn btn-outline-light btn-lg px-4">
                                <i class="bi bi-file-earmark-text me-2"></i>Gestionar Documentos
                            </a>
                        </div>
                    </div>
                    <div class="col-lg-4 d-flex flex-column justify-content-center align-items-center">
                        <i class="bi bi-clipboard-data" style="font-size: 6rem; opacity: 0.5;"></i>
                        <button id="btnRefrescar" class="btn btn-outline-light mt-3">
                            <i class="bi bi-arrow-clockwise me-1"></i> Actualizar datos
                        </button>
                    </div>
                </div>
            </div>

            <% if (mensaje != null) { %>
            <div class="alert alert-<%= tipoMensaje != null ? tipoMensaje : "info" %> fade-in alert-dismissible fade show"
                 role="alert">
                <i class="bi bi-info-circle me-2"></i> <%= mensaje %>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% } %>

            <!-- Tarjetas de estadísticas -->
            <div class="row mb-4">
                <div class="col-md-3 mb-4">
                    <div class="card stat-card warning-accent fade-in">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <div class="title">Solicitudes Pendientes</div>
                                    <div class="value"><%= pendientes %>
                                    </div>
                                    <p class="card-text">Solicitudes de información que requieren su atención.</p>
                                </div>
                                <div class="col-4">
                                    <i class="bi bi-envelope-exclamation stat-icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3 mb-4">
                    <div class="card stat-card danger-accent fade-in">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <div class="title">Solicitudes por Vencer</div>
                                    <div class="value"><%= porVencer %>
                                    </div>
                                    <p class="card-text">Solicitudes que vencen en los próximos 3 días.</p>
                                </div>
                                <div class="col-4">
                                    <i class="bi bi-alarm stat-icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3 mb-4">
                    <div class="card stat-card success-accent fade-in">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <div class="title">Solicitudes Atendidas</div>
                                    <div class="value"><%= atendidas %>
                                    </div>
                                    <p class="card-text">Solicitudes procesadas correctamente.</p>
                                </div>
                                <div class="col-4">
                                    <i class="bi bi-check-circle stat-icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-3 mb-4">
                    <div class="card stat-card secondary-accent fade-in">
                        <div class="card-body">
                            <div class="row">
                                <div class="col-8">
                                    <div class="title">Documentos de Transparencia</div>
                                    <div class="value"><%= totalDocumentos %>
                                    </div>
                                    <p class="card-text">Documentos publicados por su entidad.</p>
                                </div>
                                <div class="col-4">
                                    <i class="bi bi-file-earmark-text stat-icon"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-lg-8">
                    <!-- Gráfico de solicitudes por mes -->
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Solicitudes por Mes</h6>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-outline-primary dropdown-toggle" type="button"
                                        id="chartPeriodDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                    Este Año
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="chartPeriodDropdown">
                                    <li><a class="dropdown-item" href="#">Este Mes</a></li>
                                    <li><a class="dropdown-item" href="#">Este Año</a></li>
                                    <li><a class="dropdown-item" href="#">Todo el Tiempo</a></li>
                                </ul>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="solicitudesChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Tabla de solicitudes recientes -->
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3 d-flex justify-content-between align-items-center">
                            <h6 class="m-0 font-weight-bold">Solicitudes Recientes</h6>
                            <a href="solicitudes.jsp" class="btn btn-sm btn-outline-primary">
                                Ver Todas <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                    <tr>
                                        <th>Solicitante</th>
                                        <th>Información Solicitada</th>
                                        <th>Fecha</th>
                                        <th>Estado</th>
                                        <th>Acción</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <% if (solicitudesRecientes.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" class="text-center py-4">No hay solicitudes registradas para su
                                            entidad.
                                        </td>
                                    </tr>
                                    <% } else {
                                        for (SolicitudAccesoEntidad solicitud : solicitudesRecientes) {
                                            String badgeClass = "";
                                            String estado = "";

                                            switch (solicitud.getEstadoSolicitudId()) {
                                                case 1:
                                                    badgeClass = "bg-warning text-dark";
                                                    estado = "Pendiente";
                                                    break;
                                                case 2:
                                                    badgeClass = "bg-primary";
                                                    estado = "En Proceso";
                                                    break;
                                                case 3:
                                                    badgeClass = "bg-success";
                                                    estado = "Atendida";
                                                    break;
                                                default:
                                                    badgeClass = "bg-secondary";
                                                    estado = "Otro";
                                            }
                                    %>
                                    <tr>
                                        <td><%= solicitud.getCiudadano() != null ? solicitud.getCiudadano().getNombreCompleto() : "Ciudadano no especificado" %>
                                        </td>
                                        <td><%= solicitud.getDescripcion().length() > 50 ? solicitud.getDescripcion().substring(0, 47) + "..." : solicitud.getDescripcion() %>
                                        </td>
                                        <td><%= solicitud.getFechaSolicitud() != null ? formatoFecha.format(solicitud.getFechaSolicitud()) : "N/A" %>
                                        </td>
                                        <td><span class="badge <%= badgeClass %>"><%= estado %></span></td>
                                        <td>
                                            <a href="<%= request.getContextPath() %>/solicitud.do?accion=detalle&id=<%= solicitud.getId() %>"
                                               class="btn btn-sm btn-primary">
                                                <i class="bi bi-eye"></i> Ver
                                            </a>
                                        </td>
                                    </tr>
                                    <%
                                            }
                                        }
                                    %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <!-- Estado de solicitudes -->
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Estado de Solicitudes</h6>
                        </div>
                        <div class="card-body">
                            <div class="chart-container" style="height: 200px;">
                                <canvas id="estadoSolicitudesChart"></canvas>
                            </div>

                            <div class="mt-4">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span>Pendientes</span>
                                    <span class="badge bg-warning text-dark"><%= pendientes %></span>
                                </div>
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar bg-warning" role="progressbar"
                                         style="width: <%= totalSolicitudes > 0 ? 100.0 * pendientes / totalSolicitudes : 0 %>%"
                                         aria-valuenow="<%= pendientes %>" aria-valuemin="0"
                                         aria-valuemax="<%= totalSolicitudes %>"></div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span>En proceso</span>
                                    <span class="badge bg-primary"><%= enProceso %></span>
                                </div>
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar bg-primary" role="progressbar"
                                         style="width: <%= totalSolicitudes > 0 ? 100.0 * enProceso / totalSolicitudes : 0 %>%"
                                         aria-valuenow="<%= enProceso %>" aria-valuemin="0"
                                         aria-valuemax="<%= totalSolicitudes %>"></div>
                                </div>

                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <span>Atendidas</span>
                                    <span class="badge bg-success"><%= atendidas %></span>
                                </div>
                                <div class="progress mb-3" style="height: 8px;">
                                    <div class="progress-bar bg-success" role="progressbar"
                                         style="width: <%= totalSolicitudes > 0 ? 100.0 * atendidas / totalSolicitudes : 0 %>%"
                                         aria-valuenow="<%= atendidas %>" aria-valuemin="0"
                                         aria-valuemax="<%= totalSolicitudes %>"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Documentos por categoría -->
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Documentos por Categoría</h6>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="category-pill category-datos-generales">Datos Generales</span>
                                <span class="badge bg-light text-dark"><%= documentosPorCategoria.get("datos-generales") %></span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="category-pill category-planeamiento">Planeamiento</span>
                                <span class="badge bg-light text-dark"><%= documentosPorCategoria.get("planeamiento") %></span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="category-pill category-presupuesto">Presupuesto</span>
                                <span class="badge bg-light text-dark"><%= documentosPorCategoria.get("presupuesto") %></span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="category-pill category-proyectos">Proyectos</span>
                                <span class="badge bg-light text-dark"><%= documentosPorCategoria.get("proyectos") %></span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="category-pill category-contrataciones">Contrataciones</span>
                                <span class="badge bg-light text-dark"><%= documentosPorCategoria.get("contrataciones") %></span>
                            </div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="category-pill category-personal">Personal</span>
                                <span class="badge bg-light text-dark"><%= documentosPorCategoria.get("personal") %></span>
                            </div>

                            <div class="text-center mt-4">
                                <a href="transparencia.jsp" class="btn btn-primary">
                                    <i class="bi bi-file-plus me-1"></i> Publicar Documento
                                </a>
                            </div>
                        </div>
                    </div>

                    <!-- Documentos recientes -->
                    <div class="card shadow mb-4 fade-in">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold">Documentos Recientes</h6>
                        </div>
                        <div class="card-body p-0">
                            <ul class="list-group list-group-flush">
                                <% if (documentosRecientes.isEmpty()) { %>
                                <li class="list-group-item text-center py-4">
                                    No hay documentos publicados por su entidad.
                                </li>
                                <% } else {
                                    for (DocumentoTransparenciaEntidad doc : documentosRecientes) {
                                        String categoriaClass = "";
                                        switch (doc.getCategoria()) {
                                            case "datos-generales":
                                                categoriaClass = "category-datos-generales";
                                                break;
                                            case "planeamiento":
                                                categoriaClass = "category-planeamiento";
                                                break;
                                            case "presupuesto":
                                                categoriaClass = "category-presupuesto";
                                                break;
                                            case "proyectos":
                                                categoriaClass = "category-proyectos";
                                                break;
                                            case "contrataciones":
                                                categoriaClass = "category-contrataciones";
                                                break;
                                            case "personal":
                                                categoriaClass = "category-personal";
                                                break;
                                            default:
                                                categoriaClass = "";
                                                break;
                                        }
                                %>
                                <li class="list-group-item p-3">
                                    <div class="d-flex align-items-center">
                                        <div class="recent-icon doc me-3">
                                            <i class="bi bi-file-earmark-text"></i>
                                        </div>
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <h6 class="mb-0 text-truncate"
                                                    style="max-width: 180px;"><%= doc.getTitulo() %>
                                                </h6>
                                                <small class="text-muted"><%= doc.getFechaPublicacion() != null ? formatoFecha.format(doc.getFechaPublicacion()) : "N/A" %>
                                                </small>
                                            </div>
                                            <div>
                                                    <span class="category-pill <%= categoriaClass %>"
                                                          style="font-size: 0.7rem;">
                                                        <%= doc.getCategoria().replace("-", " ").toUpperCase() %>
                                                    </span>
                                            </div>
                                        </div>
                                    </div>
                                </li>
                                <%
                                        }
                                    }
                                %>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>
    // Prevenir caché del navegador
    window.addEventListener('pageshow', function (event) {
        if (event.persisted || (window.performance && window.performance.navigation.type === 2)) {
            window.location.reload(true);
        }
    });

    $(document).ready(function () {
        // Recargar la página para actualizar datos
        $('#btnRefrescar').on('click', function () {
            // Mostrar indicador de carga
            $(this).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Actualizando...');
            $(this).prop('disabled', true);

            // Recargar la página actual sin caché
            window.location.href = window.location.href + '?nocache=' + new Date().getTime();
        });

        // Auto-recargar cada 60 segundos (1 minuto)
        setTimeout(function () {
            window.location.href = window.location.href + '?nocache=' + new Date().getTime();
        }, 60000); // 60 segundos

        // Gráfico de solicitudes por mes
        var ctxSolicitudes = document.getElementById('solicitudesChart').getContext('2d');
        var solicitudesChart = new Chart(ctxSolicitudes, {
            type: 'line',
            data: {
                labels: <%= labelsJSON.toString() %>,
                datasets: [{
                    label: 'Solicitudes Recibidas',
                    data: <%= dataJSON.toString() %>,
                    backgroundColor: 'rgba(56, 103, 214, 0.1)',
                    borderColor: '#3867d6',
                    borderWidth: 2,
                    tension: 0.3,
                    fill: true,
                    pointBackgroundColor: '#3867d6',
                    pointRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        mode: 'index',
                        intersect: false,
                        callbacks: {
                            label: function (context) {
                                return context.dataset.label + ': ' + context.parsed.y + ' solicitudes';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        },
                        grid: {
                            drawBorder: false
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });

        // Gráfico circular de estados de solicitudes
        var ctxEstados = document.getElementById('estadoSolicitudesChart').getContext('2d');
        var estadosChart = new Chart(ctxEstados, {
            type: 'doughnut',
            data: {
                labels: ['Pendientes', 'En Proceso', 'Atendidas'],
                datasets: [{
                    data: [<%= pendientes %>, <%= enProceso %>, <%= atendidas %>],
                    backgroundColor: [
                        '#f7b731', // Naranja para pendientes
                        '#3867d6', // Azul para en proceso
                        '#20bf6b'  // Verde para atendidas
                    ],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '70%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            usePointStyle: true,
                            padding: 20
                        }
                    }
                }
            }
        });

        // Animaciones en scroll
        const fadeElems = document.querySelectorAll('.fade-in');

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        });

        fadeElems.forEach(elem => {
            elem.style.opacity = '0';
            elem.style.transform = 'translateY(20px)';
            elem.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
            observer.observe(elem);
        });
    });
</script>
</body>
</html>