package cl.duoc.sanosysalvos.reporting.service;

import cl.duoc.sanosysalvos.reporting.model.ReporteMascota;
import java.util.List;

public interface ReporteService {

    ReporteMascota crearReporte(ReporteMascota reporteMascota);

    List<ReporteMascota> listarReportes();

    ReporteMascota actualizarReporte(String id, ReporteMascota reporteMascota);

    void eliminarReporte(String id);
}
