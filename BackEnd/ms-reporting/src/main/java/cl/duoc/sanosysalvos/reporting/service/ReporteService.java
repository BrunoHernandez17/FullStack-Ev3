package cl.duoc.sanosysalvos.reporting.service;

import cl.duoc.sanosysalvos.reporting.model.ReporteMascota;
import java.util.List;

import cl.duoc.sanosysalvos.reporting.model.Comentario;

public interface ReporteService {

    ReporteMascota crearReporte(ReporteMascota reporteMascota);

    List<ReporteMascota> listarReportes();

    ReporteMascota actualizarReporte(String id, ReporteMascota reporteMascota);

    void eliminarReporte(String id);

    ReporteMascota agregarComentario(String id, Comentario comentario);
}

