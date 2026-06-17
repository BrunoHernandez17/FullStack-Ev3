package cl.duoc.sanosysalvos.reporting.repository;

import cl.duoc.sanosysalvos.reporting.model.ReporteMascota;
import org.springframework.data.mongodb.repository.MongoRepository;

public interface ReporteRepository extends MongoRepository<ReporteMascota, String> {
}
