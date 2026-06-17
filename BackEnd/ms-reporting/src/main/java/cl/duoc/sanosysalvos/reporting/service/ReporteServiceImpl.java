package cl.duoc.sanosysalvos.reporting.service;

import cl.duoc.sanosysalvos.reporting.model.ReporteMascota;
import cl.duoc.sanosysalvos.reporting.repository.ReporteRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ReporteServiceImpl implements ReporteService {

    private final ReporteRepository reporteRepository;

    @Override
    public ReporteMascota crearReporte(ReporteMascota reporteMascota) {
        if (reporteMascota.getEstado() == null || reporteMascota.getEstado().isBlank()) {
            reporteMascota.setEstado("ACTIVO");
        }
        return reporteRepository.save(reporteMascota);
    }

    @Override
    public List<ReporteMascota> listarReportes() {
        return reporteRepository.findAll();
    }

    @Override
    public ReporteMascota actualizarReporte(String id, ReporteMascota reporteMascota) {
        ReporteMascota existente = reporteRepository.findById(id)
                .orElseThrow(() -> new org.springframework.web.server.ResponseStatusException(
                        org.springframework.http.HttpStatus.NOT_FOUND, "Reporte no encontrado con id: " + id));
        
        existente.setTipoAnimal(reporteMascota.getTipoAnimal());
        existente.setDescripcion(reporteMascota.getDescripcion());
        existente.setUbicacionId(reporteMascota.getUbicacionId());
        existente.setUsuarioId(reporteMascota.getUsuarioId());
        existente.setEstado(reporteMascota.getEstado());
        existente.setNombreMascota(reporteMascota.getNombreMascota());
        existente.setTamano(reporteMascota.getTamano());
        existente.setFoto(reporteMascota.getFoto());
        existente.setMapX(reporteMascota.getMapX());
        existente.setMapY(reporteMascota.getMapY());
        existente.setFechaRegistro(reporteMascota.getFechaRegistro());
        
        return reporteRepository.save(existente);
    }

    @Override
    public void eliminarReporte(String id) {
        if (!reporteRepository.existsById(id)) {
            throw new org.springframework.web.server.ResponseStatusException(
                    org.springframework.http.HttpStatus.NOT_FOUND, "Reporte no encontrado con id: " + id);
        }
        reporteRepository.deleteById(id);
    }
}
