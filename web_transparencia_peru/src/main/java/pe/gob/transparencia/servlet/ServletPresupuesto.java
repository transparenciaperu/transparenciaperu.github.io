package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.entidades.PresupuestoEntidad;
import pe.gob.transparencia.entidades.RegionEntidad;
import pe.gob.transparencia.modelo.EntidadPublicaModelo;
import pe.gob.transparencia.modelo.PresupuestoModelo;
import pe.gob.transparencia.modelo.RegionModelo;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Servlet para gestionar toda la información relacionada con presupuestos públicos.
 * Este servlet ha sido reestructurado para centrarse en los tres niveles de gobierno:
 * Nacional, Regional y Municipal.
 */
@WebServlet(name = "ServletPresupuesto", urlPatterns = {"/ServletPresupuesto"})
public class ServletPresupuesto extends HttpServlet {
    private final PresupuestoModelo modelo = new PresupuestoModelo();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "listar";
        }

        try {
            switch (accion) {
                case "listar":
                    listarPresupuestos(request, response);
                    break;
                case "detalle":
                    mostrarDetallePresupuesto(request, response);
                    break;
                case "formNuevo":
                    mostrarFormularioNuevo(request, response);
                    break;
                case "formEditar":
                    mostrarFormularioEditar(request, response);
                    break;
                case "anual":
                    filtrarPorAnio(request, response);
                    break;
                case "nacional":
                    mostrarPresupuestoNacional(request, response);
                    break;
                case "regional":
                    mostrarPresupuestoRegional(request, response);
                    break;
                case "municipal":
                    mostrarPresupuestoMunicipal(request, response);
                    break;
                default:
                    listarPresupuestos(request, response);
            }
        } catch (Exception e) {
            System.out.println("Error general en ServletPresupuesto: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Ha ocurrido un error al procesar su solicitud");
            request.getRequestDispatcher("presupuesto.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        try {
            switch (accion) {
                case "registrar":
                    registrarPresupuesto(request, response);
                    break;
                case "actualizar":
                    actualizarPresupuesto(request, response);
                    break;
                case "eliminar":
                    eliminarPresupuesto(request, response);
                    break;
                default:
                    response.sendRedirect("presupuesto.jsp");
            }
        } catch (Exception e) {
            System.out.println("Error general en ServletPresupuesto (POST): " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Ha ocurrido un error al procesar su solicitud");
            request.getRequestDispatcher("presupuesto.jsp").forward(request, response);
        }
    }

    /**
     * Método para listar todos los presupuestos mostrando estadísticas por nivel de gobierno
     */
    private void listarPresupuestos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener estadísticas por nivel de gobierno para el año actual
        List<Map<String, Object>> estadisticas = modelo.obtenerEstadisticasPorNivel(2024);
        request.setAttribute("estadisticas", estadisticas);

        // Obtener datos de evolución anual del presupuesto
        List<Map<String, Object>> evolucionAnual = modelo.obtenerEvolucionAnual();
        request.setAttribute("evolucionAnual", evolucionAnual);

        // Cargar datos de proyectos importantes
        List<Map<String, Object>> datosProyectos = modelo.obtenerDatosProyectos();
        request.setAttribute("datosProyectos", datosProyectos);

        request.getRequestDispatcher("presupuesto.jsp").forward(request, response);
    }

    /**
     * Método para mostrar detalles de un presupuesto específico
     */
    private void mostrarDetallePresupuesto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        PresupuestoEntidad presupuesto = modelo.obtenerPresupuesto(id);
        request.setAttribute("presupuesto", presupuesto);
        request.getRequestDispatcher("detalle-presupuesto.jsp").forward(request, response);
    }

    /**
     * Método para mostrar formulario para nuevo presupuesto
     */
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("form-presupuesto.jsp").forward(request, response);
    }

    /**
     * Método para mostrar formulario para editar un presupuesto
     */
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        PresupuestoEntidad presupuesto = modelo.obtenerPresupuesto(id);
        request.setAttribute("presupuesto", presupuesto);
        request.getRequestDispatcher("form-presupuesto.jsp").forward(request, response);
    }

    /**
     * Método para registrar un nuevo presupuesto
     */
    private void registrarPresupuesto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int anio = Integer.parseInt(request.getParameter("anio"));
        BigDecimal montoTotal = new BigDecimal(request.getParameter("montoTotal"));
        int entidadPublicaId = Integer.parseInt(request.getParameter("entidadPublicaId"));

        PresupuestoEntidad presupuesto = new PresupuestoEntidad();
        presupuesto.setAnio(anio);
        presupuesto.setMontoTotal(montoTotal);
        presupuesto.setEntidadPublicaId(entidadPublicaId);

        modelo.registrarPresupuesto(presupuesto);
        response.sendRedirect("ServletPresupuesto?accion=listar");
    }

    /**
     * Método para actualizar un presupuesto existente
     */
    private void actualizarPresupuesto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        int anio = Integer.parseInt(request.getParameter("anio"));
        BigDecimal montoTotal = new BigDecimal(request.getParameter("montoTotal"));
        int entidadPublicaId = Integer.parseInt(request.getParameter("entidadPublicaId"));

        PresupuestoEntidad presupuesto = new PresupuestoEntidad();
        presupuesto.setId(id);
        presupuesto.setAnio(anio);
        presupuesto.setMontoTotal(montoTotal);
        presupuesto.setEntidadPublicaId(entidadPublicaId);

        modelo.actualizarPresupuesto(presupuesto);
        response.sendRedirect("ServletPresupuesto?accion=listar");
    }

    /**
     * Método para eliminar un presupuesto
     */
    private void eliminarPresupuesto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        modelo.eliminarPresupuesto(id);
        response.sendRedirect("ServletPresupuesto?accion=listar");
    }

    /**
     * Método para filtrar presupuestos por año
     */
    private void filtrarPorAnio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Procesar parámetros de filtro si existen
        String anioStr = request.getParameter("anio");
        int anio = 2024; // Año por defecto

        if (anioStr != null && !anioStr.isEmpty()) {
            try {
                anio = Integer.parseInt(anioStr);
            } catch (NumberFormatException e) {
                System.out.println("Error al parsear el año: " + e.getMessage());
            }
        }

        request.setAttribute("anioSeleccionado", anio);

        // Obtener estadísticas por nivel de gobierno para el año seleccionado
        List<Map<String, Object>> estadisticas = modelo.obtenerEstadisticasPorNivel(anio);
        request.setAttribute("estadisticas", estadisticas);

        // Obtener presupuestos del año seleccionado
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestosPorAnio(anio);
        request.setAttribute("presupuestos", presupuestos);

        // Obtener datos de evolución anual desde la base de datos
        List<Map<String, Object>> evolucionAnual = modelo.obtenerEvolucionAnual();
        request.setAttribute("evolucionAnual", evolucionAnual);

        // Redirigir a la página correspondiente
        request.getRequestDispatcher("presupuesto-anual.jsp").forward(request, response);
    }

    /**
     * Método para mostrar presupuesto a nivel nacional
     */
    private void mostrarPresupuestoNacional(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener estadísticas por nivel de gobierno
        List<Map<String, Object>> estadisticas = modelo.obtenerEstadisticasPorNivel(2024);
        request.setAttribute("estadisticas", estadisticas);

        // Obtener presupuestos de entidades nacionales
        EntidadPublicaModelo entidadModelo = new EntidadPublicaModelo();
        List<EntidadPublicaEntidad> entidadesNacionales = entidadModelo.listarPorNivel(1); // 1 = Nacional
        request.setAttribute("entidades", entidadesNacionales);
        request.setAttribute("cantidadEntidades", entidadesNacionales.size());

        // Obtener presupuestos del nivel nacional por años
        List<Map<String, Object>> datosPorAnio = modelo.obtenerPresupuestosPorNivelYAnio(1);
        request.setAttribute("datosPorAnio", datosPorAnio);

        // Obtener proyectos del nivel nacional
        List<Map<String, Object>> proyectos = modelo.obtenerDatosProyectosNacionales();
        request.setAttribute("proyectos", proyectos);
        request.setAttribute("proyectosDestacados", proyectos); // Para el gráfico

        // Contar proyectos en ejecución
        int proyectosEnEjecucion = 0;
        for (Map<String, Object> proyecto : proyectos) {
            String estado = (String) proyecto.get("estado");
            if ("En ejecución".equalsIgnoreCase(estado)) {
                proyectosEnEjecucion++;
            }
        }
        request.setAttribute("cantidadProyectos", proyectosEnEjecucion);

        // Obtener distribución por ministerios
        List<Map<String, Object>> distribucionMinisterios = modelo.obtenerDistribucionPresupuestoMinisterios();
        request.setAttribute("distribucionMinisterios", distribucionMinisterios);

        // Guardar distribución por sectores para el gráfico
        request.setAttribute("distribucionSectores", distribucionMinisterios);

        // Calcular presupuesto total nacional actual y anterior
        BigDecimal presupuestoTotal = modelo.obtenerPresupuestoTotalPorNivel(1, 2024);
        BigDecimal presupuestoAnterior = modelo.obtenerPresupuestoTotalPorNivel(1, 2023);

        request.setAttribute("presupuestoTotal", presupuestoTotal);
        request.setAttribute("anioActual", 2024);
        request.setAttribute("anioAnterior", 2023);

        // Calcular variación porcentual
        BigDecimal variacion = BigDecimal.ZERO;
        if (presupuestoAnterior != null && presupuestoAnterior.doubleValue() > 0) {
            variacion = presupuestoTotal.subtract(presupuestoAnterior)
                    .multiply(new BigDecimal(100))
                    .divide(presupuestoAnterior, 2, BigDecimal.ROUND_HALF_UP);
        }
        request.setAttribute("variacionPresupuesto", variacion);

        // Obtener porcentaje de ejecución
        Double porcentajeEjecucion = modelo.obtenerPorcentajeEjecucionPorNivel(1, 2024);
        request.setAttribute("porcentajeEjecucion", porcentajeEjecucion);

        // Datos de ejecución mensual para gráficos
        List<Map<String, Object>> datosEjecucion = modelo.obtenerEjecucionMensualPorNivel(1);
        request.setAttribute("datosEjecucion", datosEjecucion);

        // Evolución anual para gráficos
        List<Map<String, Object>> evolucionAnualList = modelo.obtenerEvolucionAnual();
        request.setAttribute("evolucionAnual", evolucionAnualList);

        // Datos para tendencias de categorías
        List<Map<String, Object>> categoriasTendencia = new ArrayList<>();
        List<Map<String, Object>> categorias = modelo.obtenerDatosCategorias();

        // Procesar las categorías para incluir datos de tendencia
        for (int i = 0; i < Math.min(5, categorias.size()); i++) {
            Map<String, Object> categoria = categorias.get(i);
            Map<String, Object> categoriaTendencia = new HashMap<>();
            categoriaTendencia.put("nombre", categoria.get("nombre"));

            // Generar valores de tendencia
            List<Double> valores = new ArrayList<>();
            double baseValue = ((Number) categoria.get("porcentaje")).doubleValue();
            for (int año = 2020; año <= 2024; año++) {
                // Variación aleatoria pero consistente basada en el año y nombre
                double variacionPorcentual = (año - 2020) * 0.5;
                if (año % 2 == 0) variacionPorcentual += 1.5;
                else variacionPorcentual -= 0.8;

                valores.add(Math.max(5, Math.min(40, baseValue + variacionPorcentual)));
            }
            categoriaTendencia.put("valores", valores);
            categoriasTendencia.add(categoriaTendencia);
        }
        request.setAttribute("categoriasTendencia", categoriasTendencia);

        // Datos para presupuesto per cápita por región
        List<Map<String, Object>> regionesPerCapita = new ArrayList<>();
        List<RegionEntidad> regiones = new RegionModelo().listar();

        for (RegionEntidad region : regiones) {
            if (regionesPerCapita.size() >= 5) break; // Limitar a 5 regiones

            Map<String, Object> regionData = new HashMap<>();
            regionData.put("nombre", region.getNombre());

            // Obtener presupuesto de la región
            BigDecimal presupuestoRegion = modelo.obtenerPresupuestoTotalPorNivel(2, 2024);

            // Población estimada (en un sistema real vendría de la base de datos)
            int poblacion = 0;
            switch (region.getNombre()) {
                case "Lima":
                    poblacion = 10500000;
                    break;
                case "Arequipa":
                    poblacion = 1500000;
                    break;
                case "Cusco":
                    poblacion = 1300000;
                    break;
                case "La Libertad":
                    poblacion = 2000000;
                    break;
                case "Piura":
                    poblacion = 2100000;
                    break;
                default:
                    poblacion = 1000000;
                    break;
            }

            // Calcular presupuesto per cápita
            double presupuestoPerCapita = 0;
            if (presupuestoRegion != null && poblacion > 0) {
                presupuestoPerCapita = presupuestoRegion.doubleValue() / poblacion;
            }

            regionData.put("presupuestoPerCapita", presupuestoPerCapita);
            regionesPerCapita.add(regionData);
        }
        request.setAttribute("regionesPerCapita", regionesPerCapita);

        // Redirigir a la página correspondiente
        request.getRequestDispatcher("presupuesto-nacional.jsp").forward(request, response);
    }

    /**
     * Método para mostrar presupuesto a nivel regional
     */
    private void mostrarPresupuestoRegional(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener estadísticas por nivel de gobierno
        List<Map<String, Object>> estadisticas = modelo.obtenerEstadisticasPorNivel(2024);
        request.setAttribute("estadisticas", estadisticas);

        // Obtener presupuestos de gobiernos regionales
        EntidadPublicaModelo entidadModelo = new EntidadPublicaModelo();
        List<EntidadPublicaEntidad> entidadesRegionales = entidadModelo.listarPorNivel(2); // 2 = Regional
        request.setAttribute("entidades", entidadesRegionales);

        // Obtener presupuestos del nivel regional por años
        List<Map<String, Object>> datosPorAnio = modelo.obtenerPresupuestosPorNivelYAnio(2);
        request.setAttribute("datosPorAnio", datosPorAnio);

        // Obtener regiones para filtrar
        RegionModelo regionModelo = new RegionModelo();
        List<RegionEntidad> regiones = regionModelo.listar();
        request.setAttribute("regiones", regiones);

        // Obtener top 5 regiones con mayor presupuesto
        List<Map<String, Object>> topRegiones = new ArrayList<>();

        // Para cada región, determinar su presupuesto y agregar al listado
        for (RegionEntidad region : regiones) {
            // Si ya tenemos 5 regiones, salimos del bucle
            if (topRegiones.size() >= 5) break;

            Map<String, Object> regionData = new HashMap<>();
            regionData.put("nombre", region.getNombre());

            // Determinar el presupuesto (en un sistema real vendría de la base de datos)
            // Aquí usamos el presupuesto regional general como aproximación
            BigDecimal presupuestoRegional = modelo.obtenerPresupuestoTotalPorNivel(2, 2024);

            // Ajustar el valor basado en un factor para simular diferentes presupuestos
            // En un sistema real, estos datos vendrían de una consulta específica por región
            double factor = 1.0;
            switch (region.getNombre()) {
                case "Lima":
                    factor = 1.5;
                    break;
                case "Arequipa":
                    factor = 0.95;
                    break;
                case "Cusco":
                    factor = 0.85;
                    break;
                case "La Libertad":
                    factor = 0.78;
                    break;
                case "Piura":
                    factor = 0.65;
                    break;
                default:
                    factor = 0.5;
                    break;
            }

            BigDecimal presupuestoRegionAjustado = presupuestoRegional.multiply(new BigDecimal(factor));
            regionData.put("presupuesto", presupuestoRegionAjustado);

            topRegiones.add(regionData);
        }

        // Ordenar las regiones por presupuesto de mayor a menor
        topRegiones.sort((r1, r2) -> {
            BigDecimal p1 = (BigDecimal) r1.get("presupuesto");
            BigDecimal p2 = (BigDecimal) r2.get("presupuesto");
            return p2.compareTo(p1); // Orden descendente
        });

        // Limitar a solo 5 regiones
        if (topRegiones.size() > 5) {
            topRegiones = topRegiones.subList(0, 5);
        }

        request.setAttribute("topRegiones", topRegiones);

        // Redirigir a la página correspondiente
        request.getRequestDispatcher("presupuesto-regional.jsp").forward(request, response);
    }

    /**
     * Método para mostrar presupuesto a nivel municipal
     */
    private void mostrarPresupuestoMunicipal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Obtener estadísticas por nivel de gobierno
        List<Map<String, Object>> estadisticas = modelo.obtenerEstadisticasPorNivel(2024);
        request.setAttribute("estadisticas", estadisticas);

        // Obtener presupuestos de municipalidades
        EntidadPublicaModelo entidadModelo = new EntidadPublicaModelo();
        List<EntidadPublicaEntidad> entidadesMunicipales = entidadModelo.listarPorNivel(3); // 3 = Municipal
        request.setAttribute("entidades", entidadesMunicipales);

        // Obtener presupuestos del nivel municipal por años
        List<Map<String, Object>> datosPorAnio = modelo.obtenerPresupuestosPorNivelYAnio(3);
        request.setAttribute("datosPorAnio", datosPorAnio);

        // Obtener regiones para filtrar
        RegionModelo regionModelo = new RegionModelo();
        List<RegionEntidad> regiones = regionModelo.listar();
        request.setAttribute("regiones", regiones);

        // Redirigir a la página correspondiente
        request.getRequestDispatcher("presupuesto-municipal.jsp").forward(request, response);
    }
}