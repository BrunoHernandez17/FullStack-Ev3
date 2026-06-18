package cl.duoc.sanosysalvos.reporting.repository;

import cl.duoc.sanosysalvos.reporting.model.Mensaje;
import org.springframework.data.mongodb.repository.MongoRepository;
import java.util.List;

public interface MensajeRepository extends MongoRepository<Mensaje, String> {
    List<Mensaje> findByEmisorIdOrReceptorId(Long emisorId, Long receptorId);
}
