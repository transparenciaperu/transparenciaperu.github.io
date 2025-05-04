package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.DocumentoTransparenciaEntidad;

import java.util.List;

/**
 * Interface que define las operaciones para documentos de transparencia
 */
public interface DocumentoTransparenciaInterface {

    /**
     * Registra un nuevo documento de transparencia
     */
    int registrar(DocumentoTransparenciaEntidad documento);

    /**
     * Actualiza un documento de transparencia existente
     */
    int actualizar(DocumentoTransparenciaEntidad documento);

    /**
     * Elimina un documento de transparencia por su ID
     */
    int eliminar(int id);

    /**
     * Obtiene un documento de transparencia por su ID
     */
    DocumentoTransparenciaEntidad obtenerPorId(int id);

    /**
     * Lista todos los documentos de transparencia
     */
    List<DocumentoTransparenciaEntidad> listar();

    /**
     * Lista documentos de transparencia por categoría
     */
    List<DocumentoTransparenciaEntidad> listarPorCategoria(String categoria);

    /**
     * Lista documentos de transparencia por entidad pública
     */
    List<DocumentoTransparenciaEntidad> listarPorEntidad(int entidadPublicaId);
}