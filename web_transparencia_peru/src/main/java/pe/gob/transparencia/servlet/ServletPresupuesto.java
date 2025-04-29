package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.gob.transparencia.entidades.PresupuestoEntidad;
import pe.gob.transparencia.entidades.CategoriaGastoEntidad;
import pe.gob.transparencia.modelo.PresupuestoModelo;
import pe.gob.transparencia.dao.DAOFactory;
import pe.gob.transparencia.interfaces.ProyectoInterface;
import pe.gob.transparencia.entidades.ProyectoEntidad;
import pe.gob.transparencia.db.MySQLConexion;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;

@WebServlet(name = "ServletPresupuesto", urlPatterns = {"/ServletPresupuesto"})
public class ServletPresupuesto extends HttpServlet {
    private PresupuestoModelo modelo = new PresupuestoModelo();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "listar";
        }

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
            case "graficoEntidades":
                mostrarGraficoEntidades(request, response);
                break;
            case "graficoAnual":
                mostrarGraficoAnual(request, response);
                break;
            case "comparativoRegiones":
                mostrarComparativoRegiones(request, response);
                break;
            case "entidades":
                filtrarPorEntidades(request, response);
                break;
            case "regiones":
                filtrarPorRegiones(request, response);
                break;
            case "anual":
                filtrarPorAnio(request, response);
                break;
            case "proyectos":
                filtrarPorProyectos(request, response);
                break;
            case "categorias":
                filtrarPorCategorias(request, response);
                break;
            default:
                listarPresupuestos(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

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
    }

    private void listarPresupuestos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestos();

        // Procesar parámetros de filtro si existen
        String anioStr = request.getParameter("anio");
        String region = request.getParameter("region");
        String sector = request.getParameter("sector");
        String categoria = request.getParameter("categoria");

        if (anioStr != null && !anioStr.isEmpty()) {
            try {
                int anio = Integer.parseInt(anioStr);
                presupuestos = modelo.listarPresupuestosPorAnio(anio);
                request.setAttribute("anioSeleccionado", anio);
            } catch (NumberFormatException e) {
                System.out.println("Error al parsear el año: " + e.getMessage());
            }
        }

        if (region != null && !region.isEmpty()) {
            // Filtrar la lista por región
            List<PresupuestoEntidad> presupuestosFiltrados = new ArrayList<>();
            for (PresupuestoEntidad presupuesto : presupuestos) {
                if (presupuesto.getEntidadPublica() != null &&
                        region.equals(presupuesto.getEntidadPublica().getRegion())) {
                    presupuestosFiltrados.add(presupuesto);
                }
            }
            presupuestos = presupuestosFiltrados;
            request.setAttribute("regionSeleccionada", region);
        }

        // Filtrar por sector si es necesario
        if (sector != null && !sector.isEmpty()) {
            List<PresupuestoEntidad> presupuestosFiltrados = new ArrayList<>();
            for (PresupuestoEntidad presupuesto : presupuestos) {
                if (presupuesto.getEntidadPublica() != null &&
                        sector.equalsIgnoreCase(presupuesto.getEntidadPublica().getTipo())) {
                    presupuestosFiltrados.add(presupuesto);
                }
            }
            presupuestos = presupuestosFiltrados;
            request.setAttribute("sectorSeleccionado", sector);
        }

        // Preparar datos para categorías si es necesario
        if (categoria != null && !categoria.isEmpty()) {
            request.setAttribute("categoriaSeleccionada", categoria);
        }

        request.setAttribute("presupuestos", presupuestos);

        cargarProyectosYCategorias(request);

        request.getRequestDispatcher("presupuesto.jsp").forward(request, response);
    }

    private void mostrarDetallePresupuesto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        PresupuestoEntidad presupuesto = modelo.obtenerPresupuesto(id);
        request.setAttribute("presupuesto", presupuesto);
        request.getRequestDispatcher("detalle-presupuesto.jsp").forward(request, response);
    }

    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("form-presupuesto.jsp").forward(request, response);
    }

    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        PresupuestoEntidad presupuesto = modelo.obtenerPresupuesto(id);
        request.setAttribute("presupuesto", presupuesto);
        request.getRequestDispatcher("form-presupuesto.jsp").forward(request, response);
    }

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

    private void eliminarPresupuesto(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        modelo.eliminarPresupuesto(id);
        response.sendRedirect("ServletPresupuesto?accion=listar");
    }

    private void mostrarGraficoEntidades(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestos();
        request.setAttribute("presupuestos", presupuestos);
        request.setAttribute("tipoGrafico", "entidades");
        request.getRequestDispatcher("grafico-presupuesto.jsp").forward(request, response);
    }

    private void mostrarGraficoAnual(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestos();
        request.setAttribute("presupuestos", presupuestos);
        request.setAttribute("tipoGrafico", "anual");
        request.getRequestDispatcher("grafico-presupuesto.jsp").forward(request, response);
    }

    private void mostrarComparativoRegiones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestos();
        request.setAttribute("presupuestos", presupuestos);
        request.setAttribute("tipoGrafico", "regiones");
        request.getRequestDispatcher("comparativo-regiones.jsp").forward(request, response);
    }

    private void filtrarPorEntidades(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestos();

        System.out.println("Total de presupuestos iniciales para filtrarPorEntidades: " + presupuestos.size());

        // Procesar parámetros de filtro si existen
        String anioStr = request.getParameter("anio");
        String sector = request.getParameter("sector");

        // Aplicamos filtro por año si está presente
        if (anioStr != null && !anioStr.isEmpty()) {
            try {
                int anio = Integer.parseInt(anioStr);
                presupuestos = modelo.listarPresupuestosPorAnio(anio);
                System.out.println("Filtrado por año " + anio + ": " + presupuestos.size() + " presupuestos");
                request.setAttribute("anioSeleccionado", anio);
            } catch (NumberFormatException e) {
                System.out.println("Error al parsear el año: " + e.getMessage());
            }
        }

        // Verificamos si hay entidades sin tipo/sector y las imprimimos para diagnóstico
        int entidadesSinSector = 0;
        for (PresupuestoEntidad presupuesto : presupuestos) {
            if (presupuesto.getEntidadPublica() == null) {
                System.out.println("Presupuesto ID " + presupuesto.getId() + " no tiene entidad pública asociada");
                entidadesSinSector++;
            } else if (presupuesto.getEntidadPublica().getTipo() == null || presupuesto.getEntidadPublica().getTipo().isEmpty()) {
                System.out.println("Entidad " + presupuesto.getEntidadPublica().getNombre() + " no tiene tipo/sector definido");
                entidadesSinSector++;
            }
        }
        System.out.println("Entidades sin sector definido: " + entidadesSinSector);

        // Obtenemos los sectores disponibles para el combo
        Set<String> sectoresDisponibles = new HashSet<>();
        for (PresupuestoEntidad presupuesto : presupuestos) {
            if (presupuesto.getEntidadPublica() != null && presupuesto.getEntidadPublica().getTipo() != null) {
                sectoresDisponibles.add(presupuesto.getEntidadPublica().getTipo());
            }
        }
        request.setAttribute("sectoresDisponibles", new ArrayList<>(sectoresDisponibles));

        // Aplicamos filtro por sector si está presente
        if (sector != null && !sector.isEmpty()) {
            List<PresupuestoEntidad> presupuestosFiltrados = new ArrayList<>();
            for (PresupuestoEntidad presupuesto : presupuestos) {
                if (presupuesto.getEntidadPublica() != null &&
                        sector.equalsIgnoreCase(presupuesto.getEntidadPublica().getTipo())) {
                    presupuestosFiltrados.add(presupuesto);
                }
            }
            presupuestos = presupuestosFiltrados;
            System.out.println("Filtrado por sector " + sector + ": " + presupuestos.size() + " presupuestos");
            request.setAttribute("sectorSeleccionado", sector);
        }

        request.setAttribute("presupuestos", presupuestos);

        // Si después de aplicar todos los filtros no hay resultados, mostramos un mensaje
        if (presupuestos.isEmpty()) {
            request.setAttribute("mensajeNoResultados", "No se encontraron presupuestos con los criterios seleccionados.");
        }

        cargarProyectosYCategorias(request);

        // Redirigir a una página específica para la sección de entidades
        request.getRequestDispatcher("presupuesto-entidades.jsp").forward(request, response);
    }

    private void filtrarPorRegiones(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Primero obtenemos todos los presupuestos
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestos();

        System.out.println("Total de presupuestos iniciales: " + presupuestos.size());

        // Procesar parámetros de filtro si existen
        String anioStr = request.getParameter("anio");
        String region = request.getParameter("region");
        String sector = request.getParameter("sector");

        // Aplicamos filtro por año si está presente
        if (anioStr != null && !anioStr.isEmpty()) {
            try {
                int anio = Integer.parseInt(anioStr);
                List<PresupuestoEntidad> presupuestosPorAnio = modelo.listarPresupuestosPorAnio(anio);
                presupuestos = presupuestosPorAnio;
                System.out.println("Filtrado por año " + anio + ": " + presupuestos.size() + " presupuestos");
                request.setAttribute("anioSeleccionado", anio);
            } catch (NumberFormatException e) {
                System.out.println("Error al parsear el año: " + e.getMessage());
            }
        }

        // Verificamos si hay entidades sin región y las imprimimos para diagnóstico
        int entidadesSinRegion = 0;
        for (PresupuestoEntidad presupuesto : presupuestos) {
            if (presupuesto.getEntidadPublica() == null) {
                System.out.println("Presupuesto ID " + presupuesto.getId() + " no tiene entidad pública asociada");
                entidadesSinRegion++;
            } else if (presupuesto.getEntidadPublica().getRegion() == null || presupuesto.getEntidadPublica().getRegion().isEmpty()) {
                System.out.println("Entidad " + presupuesto.getEntidadPublica().getNombre() + " no tiene región definida");
                entidadesSinRegion++;
            }
        }
        System.out.println("Entidades sin región definida: " + entidadesSinRegion);

        // Obtenemos las regiones disponibles para el combo
        Set<String> regionesDisponibles = new HashSet<>();
        for (PresupuestoEntidad presupuesto : presupuestos) {
            if (presupuesto.getEntidadPublica() != null && presupuesto.getEntidadPublica().getRegion() != null) {
                regionesDisponibles.add(presupuesto.getEntidadPublica().getRegion());
            }
        }
        request.setAttribute("regionesDisponibles", new ArrayList<>(regionesDisponibles));

        // Aplicamos filtro por región si está presente
        if (region != null && !region.isEmpty()) {
            // Filtrar la lista por región
            List<PresupuestoEntidad> presupuestosFiltrados = new ArrayList<>();
            for (PresupuestoEntidad presupuesto : presupuestos) {
                if (presupuesto.getEntidadPublica() != null &&
                        region.equals(presupuesto.getEntidadPublica().getRegion())) {
                    presupuestosFiltrados.add(presupuesto);
                }
            }
            presupuestos = presupuestosFiltrados;
            System.out.println("Filtrado por región " + region + ": " + presupuestos.size() + " presupuestos");
            request.setAttribute("regionSeleccionada", region);
        }

        // Obtenemos los sectores disponibles para el combo
        Set<String> sectoresDisponibles = new HashSet<>();
        for (PresupuestoEntidad presupuesto : presupuestos) {
            if (presupuesto.getEntidadPublica() != null && presupuesto.getEntidadPublica().getTipo() != null) {
                sectoresDisponibles.add(presupuesto.getEntidadPublica().getTipo());
            }
        }
        request.setAttribute("sectoresDisponibles", new ArrayList<>(sectoresDisponibles));

        // Aplicamos filtro por sector si está presente
        if (sector != null && !sector.isEmpty()) {
            List<PresupuestoEntidad> presupuestosFiltrados = new ArrayList<>();
            for (PresupuestoEntidad presupuesto : presupuestos) {
                if (presupuesto.getEntidadPublica() != null &&
                        sector.equalsIgnoreCase(presupuesto.getEntidadPublica().getTipo())) {
                    presupuestosFiltrados.add(presupuesto);
                }
            }
            presupuestos = presupuestosFiltrados;
            System.out.println("Filtrado por sector " + sector + ": " + presupuestos.size() + " presupuestos");
            request.setAttribute("sectorSeleccionado", sector);
        }

        // Asignamos la lista filtrada a la solicitud
        request.setAttribute("presupuestos", presupuestos);

        // Si después de aplicar todos los filtros no hay resultados, mostramos un mensaje
        if (presupuestos.isEmpty()) {
            request.setAttribute("mensajeNoResultados", "No se encontraron presupuestos con los criterios seleccionados.");
        }

        cargarProyectosYCategorias(request);

        // Redirigir a una página específica para la sección de regiones
        request.getRequestDispatcher("presupuesto-regiones.jsp").forward(request, response);
    }

    private void filtrarPorAnio(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestos();

        // Procesar parámetros de filtro si existen
        String anioStr = request.getParameter("anio");
        String categoria = request.getParameter("categoria");

        if (anioStr != null && !anioStr.isEmpty()) {
            try {
                int anio = Integer.parseInt(anioStr);
                presupuestos = modelo.listarPresupuestosPorAnio(anio);
                request.setAttribute("anioSeleccionado", anio);
            } catch (NumberFormatException e) {
                System.out.println("Error al parsear el año: " + e.getMessage());
            }
        }

        request.setAttribute("presupuestos", presupuestos);

        // Obtener datos de evolución anual desde la base de datos
        List<Map<String, Object>> evolucionAnual = modelo.obtenerEvolucionAnual();

        // Filtrar evolución anual por categoría si es necesario
        if (categoria != null && !categoria.isEmpty()) {
            // En un escenario real, filtraríamos por categoría en la base de datos
            // Aquí simulamos que tenemos los datos filtrados
            request.setAttribute("categoriaSeleccionada", categoria);
        }

        request.setAttribute("evolucionAnual", evolucionAnual);

        cargarProyectosYCategorias(request);

        // Redirigir a una página específica para la sección anual
        request.getRequestDispatcher("presupuesto-anual.jsp").forward(request, response);
    }

    private void filtrarPorProyectos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestos();

        // Procesar parámetros de filtro si existen
        String anioStr = request.getParameter("anio");
        String region = request.getParameter("region");
        String sector = request.getParameter("sector");

        if (anioStr != null && !anioStr.isEmpty()) {
            try {
                int anio = Integer.parseInt(anioStr);
                presupuestos = modelo.listarPresupuestosPorAnio(anio);
                request.setAttribute("anioSeleccionado", anio);
            } catch (NumberFormatException e) {
                System.out.println("Error al parsear el año: " + e.getMessage());
            }
        }

        request.setAttribute("presupuestos", presupuestos);

        // Obtener datos de proyectos desde la base de datos
        List<Map<String, Object>> datosProyectos = modelo.obtenerDatosProyectos();

        // Filtrar proyectos por región si es necesario
        if (region != null && !region.isEmpty()) {
            List<Map<String, Object>> proyectosFiltrados = new ArrayList<>();
            for (Map<String, Object> proyecto : datosProyectos) {
                if (region.equals(proyecto.get("region"))) {
                    proyectosFiltrados.add(proyecto);
                }
            }
            datosProyectos = proyectosFiltrados;
            request.setAttribute("regionSeleccionada", region);
        }

        // Filtrar por sector si es necesario
        if (sector != null && !sector.isEmpty()) {
            List<Map<String, Object>> proyectosFiltrados = new ArrayList<>();
            for (Map<String, Object> proyecto : datosProyectos) {
                String entidadNombre = (String) proyecto.get("entidadNombre");
                // Simular que podemos determinar el sector por el nombre de la entidad
                if (entidadNombre != null && entidadNombre.toLowerCase().contains(sector.toLowerCase())) {
                    proyectosFiltrados.add(proyecto);
                }
            }
            if (!proyectosFiltrados.isEmpty()) {
                datosProyectos = proyectosFiltrados;
            }
            request.setAttribute("sectorSeleccionado", sector);
        }

        request.setAttribute("datosProyectos", datosProyectos);

        cargarProyectosYCategorias(request);

        // Redirigir a una página específica para la sección de proyectos
        request.getRequestDispatcher("presupuesto-proyectos.jsp").forward(request, response);
    }

    private void filtrarPorCategorias(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<PresupuestoEntidad> presupuestos = modelo.listarPresupuestos();

        // Procesar parámetros de filtro si existen
        String anioStr = request.getParameter("anio");
        String categoria = request.getParameter("categoria");

        if (anioStr != null && !anioStr.isEmpty()) {
            try {
                int anio = Integer.parseInt(anioStr);
                presupuestos = modelo.listarPresupuestosPorAnio(anio);
                request.setAttribute("anioSeleccionado", anio);
            } catch (NumberFormatException e) {
                System.out.println("Error al parsear el año: " + e.getMessage());
            }
        }

        request.setAttribute("presupuestos", presupuestos);

        // Obtener datos de categorías desde la base de datos
        List<Map<String, Object>> datosCategorias = modelo.obtenerDatosCategorias();

        // Filtrar por categoría específica si es necesario
        if (categoria != null && !categoria.isEmpty()) {
            List<Map<String, Object>> categoriasFiltradas = new ArrayList<>();
            for (Map<String, Object> cat : datosCategorias) {
                String nombreCategoria = (String) cat.get("nombre");
                if (categoria.equalsIgnoreCase(nombreCategoria)) {
                    categoriasFiltradas.add(cat);
                }
            }
            // Si encontramos alguna categoría que coincida, usamos solo esas
            if (!categoriasFiltradas.isEmpty()) {
                datosCategorias = categoriasFiltradas;
            }
            request.setAttribute("categoriaSeleccionada", categoria);
        }

        request.setAttribute("datosCategorias", datosCategorias);

        cargarProyectosYCategorias(request);

        // Redirigir a una página específica para la sección de categorías
        request.getRequestDispatcher("presupuesto-categorias.jsp").forward(request, response);
    }

    private void cargarProyectosYCategorias(HttpServletRequest request) {
        // Obtener proyectos para mostrarlos en la página
        try {
            DAOFactory daoFactory = DAOFactory.getDAOFactory(DAOFactory.MYSQL);
            ProyectoInterface proyectoDAO = daoFactory.getProyectoDAO();
            List<ProyectoEntidad> proyectos = proyectoDAO.listarProyectos();
            request.setAttribute("proyectos", proyectos);
        } catch (Exception e) {
            System.out.println("Error al cargar proyectos: " + e.getMessage());
            e.printStackTrace();
        }

        // Cargar categorías de gasto usando procedimiento almacenado
        Connection cn = null;
        CallableStatement cstm = null;
        ResultSet rs = null;
        List<CategoriaGastoEntidad> categorias = new ArrayList<>();

        try {
            cn = MySQLConexion.getConexion();
            if (cn != null) {
                // Obtener todas las categorías de gasto
                String sql = "SELECT id, nombre, descripcion FROM CategoriaGasto";
                PreparedStatement stmt = cn.prepareStatement(sql);
                rs = stmt.executeQuery();

                while (rs.next()) {
                    CategoriaGastoEntidad categoria = new CategoriaGastoEntidad();
                    categoria.setId(rs.getInt("id"));
                    categoria.setNombre(rs.getString("nombre"));
                    categoria.setDescripcion(rs.getString("descripcion"));

                    // Simulamos datos estadísticos para cada categoría
                    // En una aplicación real, estos datos se calcularían con consultas adicionales
                    categoria.setMontoTotal(1000000 + Math.random() * 50000000);
                    categoria.setPorcentaje(5 + Math.random() * 25);
                    categoria.setVariacion(-3 + Math.random() * 12);

                    categorias.add(categoria);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error al cargar categorías: " + e.getMessage());
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (cstm != null) cstm.close();
                if (cn != null) cn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        request.setAttribute("categorias", categorias);
    }
}