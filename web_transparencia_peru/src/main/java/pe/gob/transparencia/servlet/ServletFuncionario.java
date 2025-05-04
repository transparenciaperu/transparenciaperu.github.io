package pe.gob.transparencia.servlet;

import pe.gob.transparencia.entidades.DocumentoTransparenciaEntidad;
import pe.gob.transparencia.entidades.EntidadPublicaEntidad;
import pe.gob.transparencia.entidades.UsuarioEntidad;
import pe.gob.transparencia.modelo.DocumentoTransparenciaModelo;
import pe.gob.transparencia.modelo.EntidadPublicaModelo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet para gestionar las operaciones de los funcionarios
 */
@WebServlet(name = "ServletFuncionario", urlPatterns = {"/funcionario.do"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
public class ServletFuncionario extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "uploads/documentos";

    /**
     * Maneja solicitudes GET al servlet
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");
        String formato = request.getParameter("format");

        if (accion == null) {
            accion = "listar";
        }

        switch (accion) {
            case "verDocumento":
                verDocumento(request, response);
                break;
            case "listarDocumentos":
                listarDocumentos(request, response, formato);
                break;
            case "listarPorCategoria":
                listarPorCategoria(request, response, formato);
                break;
            default:
                listarDocumentos(request, response, formato);
                break;
        }
    }

    /**
     * Maneja solicitudes POST al servlet
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String accion = request.getParameter("accion");

        switch (accion) {
            case "publicarDocumento":
                publicarDocumento(request, response);
                break;
            case "editarDocumento":
                editarDocumento(request, response);
                break;
            case "eliminarDocumento":
                eliminarDocumento(request, response);
                break;
            default:
                response.sendRedirect("funcionario/transparencia.jsp");
                break;
        }
    }

    /**
     * Ver detalles de un documento específico
     */
    private void verDocumento(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        DocumentoTransparenciaModelo modelo = new DocumentoTransparenciaModelo();
        DocumentoTransparenciaEntidad documento = modelo.obtenerPorId(id);

        // Verificar si se solicita formato JSON
        String formato = request.getParameter("format");
        if ("json".equals(formato)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();

            if (documento != null) {
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"id\":").append(documento.getId()).append(",");
                json.append("\"titulo\":\"").append(escapeJsonString(documento.getTitulo())).append("\",");
                json.append("\"descripcion\":\"").append(escapeJsonString(documento.getDescripcion())).append("\",");
                json.append("\"categoria\":\"").append(escapeJsonString(documento.getCategoria())).append("\",");
                json.append("\"periodoReferencia\":\"").append(escapeJsonString(documento.getPeriodoReferencia())).append("\",");

                // Formatear fechas para JSON
                if (documento.getFechaPublicacion() != null) {
                    json.append("\"fechaPublicacion\":\"")
                            .append(new SimpleDateFormat("yyyy-MM-dd").format(documento.getFechaPublicacion()))
                            .append("\",");
                }
                if (documento.getFechaActualizacion() != null) {
                    json.append("\"fechaActualizacion\":\"")
                            .append(new SimpleDateFormat("yyyy-MM-dd").format(documento.getFechaActualizacion()))
                            .append("\",");
                }

                json.append("\"rutaArchivo\":\"").append(escapeJsonString(documento.getRutaArchivo())).append("\",");
                json.append("\"tipoArchivo\":\"").append(escapeJsonString(documento.getTipoArchivo())).append("\",");
                json.append("\"estado\":\"").append(escapeJsonString(documento.getEstado())).append("\",");
                json.append("\"usuarioId\":").append(documento.getUsuarioId()).append(",");
                json.append("\"entidadPublicaId\":").append(documento.getEntidadPublicaId()).append(",");
                json.append("\"nombreUsuario\":\"").append(escapeJsonString(documento.getNombreUsuario())).append("\",");
                json.append("\"nombreEntidad\":\"").append(escapeJsonString(documento.getNombreEntidad())).append("\"");
                json.append("}");

                out.println(json.toString());
            } else {
                out.println("{}"); // JSON vacío
            }
        } else {
            // Formato HTML (vista JSP)
            if (documento != null) {
                request.setAttribute("documento", documento);
                request.getRequestDispatcher("funcionario/ver_documento.jsp").forward(request, response);
            } else {
                response.sendRedirect("funcionario/transparencia.jsp?error=documento_no_encontrado");
            }
        }
    }

    /**
     * Listar todos los documentos de transparencia
     */
    private void listarDocumentos(HttpServletRequest request, HttpServletResponse response, String formato) throws ServletException, IOException {
        DocumentoTransparenciaModelo modelo = new DocumentoTransparenciaModelo();
        List<DocumentoTransparenciaEntidad> documentos = modelo.listar();

        if ("json".equals(formato)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");

            for (int i = 0; i < documentos.size(); i++) {
                DocumentoTransparenciaEntidad documento = documentos.get(i);
                jsonBuilder.append("{");

                jsonBuilder.append("\"id\":").append(documento.getId()).append(",");
                jsonBuilder.append("\"titulo\":\"").append(escapeJsonString(documento.getTitulo())).append("\",");
                jsonBuilder.append("\"descripcion\":\"").append(escapeJsonString(documento.getDescripcion())).append("\",");
                jsonBuilder.append("\"categoria\":\"").append(escapeJsonString(documento.getCategoria())).append("\",");
                jsonBuilder.append("\"periodoReferencia\":\"").append(escapeJsonString(documento.getPeriodoReferencia())).append("\",");

                // Formatear fechas para JSON
                if (documento.getFechaPublicacion() != null) {
                    jsonBuilder.append("\"fechaPublicacion\":\"")
                            .append(new SimpleDateFormat("yyyy-MM-dd").format(documento.getFechaPublicacion()))
                            .append("\",");
                }
                if (documento.getFechaActualizacion() != null) {
                    jsonBuilder.append("\"fechaActualizacion\":\"")
                            .append(new SimpleDateFormat("yyyy-MM-dd").format(documento.getFechaActualizacion()))
                            .append("\",");
                }

                jsonBuilder.append("\"rutaArchivo\":\"").append(escapeJsonString(documento.getRutaArchivo())).append("\",");
                jsonBuilder.append("\"tipoArchivo\":\"").append(escapeJsonString(documento.getTipoArchivo())).append("\",");
                jsonBuilder.append("\"estado\":\"").append(escapeJsonString(documento.getEstado())).append("\",");
                jsonBuilder.append("\"usuarioId\":").append(documento.getUsuarioId()).append(",");
                jsonBuilder.append("\"entidadPublicaId\":").append(documento.getEntidadPublicaId()).append(",");
                jsonBuilder.append("\"nombreUsuario\":\"").append(escapeJsonString(documento.getNombreUsuario())).append("\",");
                jsonBuilder.append("\"nombreEntidad\":\"").append(escapeJsonString(documento.getNombreEntidad())).append("\"");

                jsonBuilder.append("}");
                if (i < documentos.size() - 1) {
                    jsonBuilder.append(",");
                }
            }

            jsonBuilder.append("]");
            out.println(jsonBuilder.toString());
        } else {
            request.setAttribute("documentos", documentos);
            request.getRequestDispatcher("funcionario/transparencia.jsp").forward(request, response);
        }
    }

    /**
     * Listar documentos por categoría
     */
    private void listarPorCategoria(HttpServletRequest request, HttpServletResponse response, String formato) throws ServletException, IOException {
        String categoria = request.getParameter("categoria");
        DocumentoTransparenciaModelo modelo = new DocumentoTransparenciaModelo();
        List<DocumentoTransparenciaEntidad> documentos = modelo.listarPorCategoria(categoria);

        if ("json".equals(formato)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            PrintWriter out = response.getWriter();
            StringBuilder jsonBuilder = new StringBuilder();
            jsonBuilder.append("[");

            for (int i = 0; i < documentos.size(); i++) {
                DocumentoTransparenciaEntidad documento = documentos.get(i);
                jsonBuilder.append("{");

                jsonBuilder.append("\"id\":").append(documento.getId()).append(",");
                jsonBuilder.append("\"titulo\":\"").append(escapeJsonString(documento.getTitulo())).append("\",");
                jsonBuilder.append("\"descripcion\":\"").append(escapeJsonString(documento.getDescripcion())).append("\",");
                jsonBuilder.append("\"categoria\":\"").append(escapeJsonString(documento.getCategoria())).append("\",");
                jsonBuilder.append("\"periodoReferencia\":\"").append(escapeJsonString(documento.getPeriodoReferencia())).append("\",");

                // Formatear fechas para JSON
                if (documento.getFechaPublicacion() != null) {
                    jsonBuilder.append("\"fechaPublicacion\":\"")
                            .append(new SimpleDateFormat("yyyy-MM-dd").format(documento.getFechaPublicacion()))
                            .append("\",");
                }
                if (documento.getFechaActualizacion() != null) {
                    jsonBuilder.append("\"fechaActualizacion\":\"")
                            .append(new SimpleDateFormat("yyyy-MM-dd").format(documento.getFechaActualizacion()))
                            .append("\",");
                }

                jsonBuilder.append("\"rutaArchivo\":\"").append(escapeJsonString(documento.getRutaArchivo())).append("\",");
                jsonBuilder.append("\"tipoArchivo\":\"").append(escapeJsonString(documento.getTipoArchivo())).append("\",");
                jsonBuilder.append("\"estado\":\"").append(escapeJsonString(documento.getEstado())).append("\",");
                jsonBuilder.append("\"usuarioId\":").append(documento.getUsuarioId()).append(",");
                jsonBuilder.append("\"entidadPublicaId\":").append(documento.getEntidadPublicaId()).append(",");
                jsonBuilder.append("\"nombreUsuario\":\"").append(escapeJsonString(documento.getNombreUsuario())).append("\",");
                jsonBuilder.append("\"nombreEntidad\":\"").append(escapeJsonString(documento.getNombreEntidad())).append("\"");

                jsonBuilder.append("}");
                if (i < documentos.size() - 1) {
                    jsonBuilder.append(",");
                }
            }

            jsonBuilder.append("]");
            out.println(jsonBuilder.toString());
        } else {
            request.setAttribute("documentos", documentos);
            request.setAttribute("categoriaActual", categoria);
            request.getRequestDispatcher("funcionario/transparencia.jsp").forward(request, response);
        }
    }

    /**
     * Publicar un nuevo documento de transparencia
     */
    private void publicarDocumento(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Obtener el usuario actual desde la sesión
            UsuarioEntidad usuario = (UsuarioEntidad) request.getSession().getAttribute("usuario");
            if (usuario == null) {
                response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
                return;
            }

            // Obtener los datos del formulario
            String titulo = request.getParameter("tituloDocumento");
            String descripcion = request.getParameter("descripcionDocumento");
            String categoria = request.getParameter("categoriaDocumento");
            String periodoReferencia = request.getParameter("periodoReferencia");
            String fechaPublicacionStr = request.getParameter("fechaPublicacion");
            String estado = request.getParameter("publicarInmediatamente") != null ? "Publicado" : "Borrador";

            // Convertir fecha
            Date fechaPublicacion = null;
            try {
                fechaPublicacion = new SimpleDateFormat("yyyy-MM-dd").parse(fechaPublicacionStr);
            } catch (Exception e) {
                fechaPublicacion = new Date(); // Si hay error, usar fecha actual
            }

            // Manejar la subida de archivo
            Part filePart = request.getPart("archivoDocumento");
            String fileName = getSubmittedFileName(filePart);
            String tipoArchivo = filePart.getContentType();

            // Crear directorio si no existe
            String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // Generar nombre único para archivo
            String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

            // Guardar archivo
            String filePath = uploadPath + File.separator + uniqueFileName;
            filePart.write(filePath);

            // Crear el objeto DocumentoTransparencia
            DocumentoTransparenciaEntidad documento = new DocumentoTransparenciaEntidad();
            documento.setTitulo(titulo);
            documento.setDescripcion(descripcion);
            documento.setCategoria(categoria);
            documento.setPeriodoReferencia(periodoReferencia);
            documento.setFechaPublicacion(fechaPublicacion);
            documento.setRutaArchivo(UPLOAD_DIRECTORY + "/" + uniqueFileName);
            documento.setTipoArchivo(tipoArchivo);
            documento.setEstado(estado);
            documento.setUsuarioId(usuario.getId());

            // Obtener la entidad pública asociada al usuario (por ahora usamos la primera disponible)
            EntidadPublicaModelo modeloEntidad = new EntidadPublicaModelo();
            List<EntidadPublicaEntidad> entidades = modeloEntidad.listarEntidades();
            if (!entidades.isEmpty()) {
                documento.setEntidadPublicaId(entidades.get(0).getId());
            } else {
                documento.setEntidadPublicaId(1); // Valor por defecto
            }

            // Registrar en la base de datos
            DocumentoTransparenciaModelo modelo = new DocumentoTransparenciaModelo();
            int resultado = modelo.registrar(documento);

            if (resultado > 0) {
                request.getSession().setAttribute("mensaje", "Documento publicado exitosamente.");
                request.getSession().setAttribute("tipoMensaje", "success");
            } else {
                request.getSession().setAttribute("mensaje", "Error al publicar el documento.");
                request.getSession().setAttribute("tipoMensaje", "danger");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error inesperado: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/funcionario/transparencia.jsp");
    }

    /**
     * Editar un documento existente
     */
    private void editarDocumento(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Obtener el usuario actual desde la sesión
            UsuarioEntidad usuario = (UsuarioEntidad) request.getSession().getAttribute("usuario");
            if (usuario == null) {
                response.sendRedirect(request.getContextPath() + "/login_unificado.jsp");
                return;
            }

            // Obtener id del documento a editar
            int documentoId = Integer.parseInt(request.getParameter("documentoId"));

            // Obtener el documento actual
            DocumentoTransparenciaModelo modelo = new DocumentoTransparenciaModelo();
            DocumentoTransparenciaEntidad documentoExistente = modelo.obtenerPorId(documentoId);

            if (documentoExistente == null) {
                request.getSession().setAttribute("mensaje", "Documento no encontrado.");
                request.getSession().setAttribute("tipoMensaje", "danger");
                response.sendRedirect(request.getContextPath() + "/funcionario/transparencia.jsp");
                return;
            }

            // Obtener los datos del formulario
            String titulo = request.getParameter("tituloDocumento");
            String descripcion = request.getParameter("descripcionDocumento");
            String categoria = request.getParameter("categoriaDocumento");
            String periodoReferencia = request.getParameter("periodoReferencia");
            String fechaPublicacionStr = request.getParameter("fechaPublicacion");
            String estado = request.getParameter("estadoDocumento") != null ? "Publicado" : "Borrador";

            // Convertir fecha
            Date fechaPublicacion;
            try {
                fechaPublicacion = new SimpleDateFormat("yyyy-MM-dd").parse(fechaPublicacionStr);
            } catch (Exception e) {
                fechaPublicacion = new Date();
            }

            // Actualizar los datos básicos
            documentoExistente.setTitulo(titulo);
            documentoExistente.setDescripcion(descripcion);
            documentoExistente.setCategoria(categoria);
            documentoExistente.setPeriodoReferencia(periodoReferencia);
            documentoExistente.setFechaPublicacion(fechaPublicacion);
            documentoExistente.setEstado(estado);
            documentoExistente.setFechaActualizacion(new Date());

            // Verificar si hay un nuevo archivo
            Part filePart = request.getPart("archivoDocumento");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = getSubmittedFileName(filePart);
                String tipoArchivo = filePart.getContentType();

                // Crear directorio si no existe
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();

                // Generar nombre único para archivo
                String uniqueFileName = System.currentTimeMillis() + "_" + fileName;

                // Guardar archivo
                String filePath = uploadPath + File.separator + uniqueFileName;
                filePart.write(filePath);

                // Actualizar ruta y tipo de archivo
                documentoExistente.setRutaArchivo(UPLOAD_DIRECTORY + "/" + uniqueFileName);
                documentoExistente.setTipoArchivo(tipoArchivo);
            }

            // Actualizar en la base de datos
            int resultado = modelo.actualizar(documentoExistente);

            if (resultado > 0) {
                request.getSession().setAttribute("mensaje", "Documento actualizado exitosamente.");
                request.getSession().setAttribute("tipoMensaje", "success");
            } else {
                request.getSession().setAttribute("mensaje", "Error al actualizar el documento.");
                request.getSession().setAttribute("tipoMensaje", "danger");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error inesperado: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/funcionario/transparencia.jsp");
    }

    /**
     * Eliminar un documento
     */
    private void eliminarDocumento(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int documentoId = Integer.parseInt(request.getParameter("id"));

            DocumentoTransparenciaModelo modelo = new DocumentoTransparenciaModelo();
            DocumentoTransparenciaEntidad documento = modelo.obtenerPorId(documentoId);

            if (documento != null) {
                // Eliminar archivo físico si existe
                String rutaArchivo = documento.getRutaArchivo();
                if (rutaArchivo != null && !rutaArchivo.isEmpty()) {
                    String fullPath = getServletContext().getRealPath("") + File.separator + rutaArchivo;
                    File file = new File(fullPath);
                    if (file.exists()) {
                        file.delete();
                    }
                }

                // Eliminar registro de la base de datos
                int resultado = modelo.eliminar(documentoId);

                if (resultado > 0) {
                    request.getSession().setAttribute("mensaje", "Documento eliminado exitosamente.");
                    request.getSession().setAttribute("tipoMensaje", "success");
                } else {
                    request.getSession().setAttribute("mensaje", "Error al eliminar el documento.");
                    request.getSession().setAttribute("tipoMensaje", "danger");
                }
            } else {
                request.getSession().setAttribute("mensaje", "Documento no encontrado.");
                request.getSession().setAttribute("tipoMensaje", "warning");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("mensaje", "Error inesperado: " + e.getMessage());
            request.getSession().setAttribute("tipoMensaje", "danger");
        }

        response.sendRedirect(request.getContextPath() + "/funcionario/transparencia.jsp");
    }

    /**
     * Obtiene el nombre del archivo subido
     */
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return "unknown";
    }

    /**
     * Escapa caracteres especiales para JSON
     */
    private String escapeJsonString(String input) {
        if (input == null) return "";

        String result = input
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");

        return result;
    }
}