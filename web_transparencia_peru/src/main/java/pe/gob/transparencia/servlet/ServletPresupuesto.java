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

        // Obtener presupuestos del nivel nacional por años
        List<Map<String, Object>> datosPorAnio = modelo.obtenerPresupuestosPorNivelYAnio(1);
        request.setAttribute("datosPorAnio", datosPorAnio);

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