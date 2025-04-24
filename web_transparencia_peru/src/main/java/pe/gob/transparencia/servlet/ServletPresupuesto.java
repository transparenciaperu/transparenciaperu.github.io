package pe.gob.transparencia.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import pe.gob.transparencia.entidades.PresupuestoEntidad;
import pe.gob.transparencia.modelo.PresupuestoModelo;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

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
        request.setAttribute("presupuestos", presupuestos);
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
}
