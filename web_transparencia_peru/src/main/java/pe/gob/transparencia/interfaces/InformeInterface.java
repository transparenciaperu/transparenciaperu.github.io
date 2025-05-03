package pe.gob.transparencia.interfaces;

import pe.gob.transparencia.entidades.InformeEntidad;

import java.util.List;

public interface InformeInterface {
    InformeEntidad buscarPorId(int id);

    List<InformeEntidad> listarInformes();

    List<InformeEntidad> listarInformesPorTipo(String tipo);

    List<InformeEntidad> listarInformesPorAnio(int anio);

    List<InformeEntidad> listarInformesPorNivelGobierno(String nivelGobierno);

    int registrarInforme(InformeEntidad informe);

    int actualizarInforme(InformeEntidad informe);

    int eliminarInforme(int id);
}