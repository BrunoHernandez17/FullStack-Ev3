package cl.duoc.sanosysalvos.reporting.controller;

import cl.duoc.sanosysalvos.reporting.model.ReporteMascota;
import cl.duoc.sanosysalvos.reporting.service.ReporteService;
import jakarta.validation.Valid;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;

@RestController
@RequestMapping("/api/reportes")
@RequiredArgsConstructor
@Tag(name = "Reportes", description = "Endpoints para la gestión de reportes de incidentes de vecinos")
public class ReporteController {

    private final ReporteService reporteService;

    @PostMapping
    @Operation(summary = "Crear un nuevo reporte", description = "Registra un nuevo reporte en el sistema (por ejemplo, reportes de mascotas perdidas/encontradas).")
    public ResponseEntity<ReporteMascota> crearReporte(@Valid @RequestBody ReporteMascota reporteMascota) {
        ReporteMascota reporteCreado = reporteService.crearReporte(reporteMascota);
        return ResponseEntity.status(HttpStatus.CREATED).body(reporteCreado);
    }

    @GetMapping
    @Operation(summary = "Listar todos los reportes", description = "Retorna la lista completa de reportes de incidentes registrados en el sistema.")
    public ResponseEntity<List<ReporteMascota>> listarReportes() {
        return ResponseEntity.ok(reporteService.listarReportes());
    }

    @PutMapping("/{id}")
    @Operation(summary = "Actualizar un reporte", description = "Actualiza los datos de un reporte existente mediante su identificador único (ID).")
    public ResponseEntity<ReporteMascota> actualizarReporte(@PathVariable String id, @Valid @RequestBody ReporteMascota reporteMascota) {
        ReporteMascota reporteActualizado = reporteService.actualizarReporte(id, reporteMascota);
        return ResponseEntity.ok(reporteActualizado);
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Eliminar un reporte", description = "Elimina permanentemente un reporte del sistema a partir de su ID.")
    public ResponseEntity<Void> eliminarReporte(@PathVariable String id) {
        reporteService.eliminarReporte(id);
        return ResponseEntity.noContent().build();
    }
}
