package cl.duoc.sanosysalvos.geolocation.controller;

import cl.duoc.sanosysalvos.geolocation.model.Ubicacion;
import cl.duoc.sanosysalvos.geolocation.repository.UbicacionRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/geo")
@RequiredArgsConstructor
public class UbicacionController {

    private final UbicacionRepository ubicacionRepository;

    @PostMapping("/ubicar")
    public ResponseEntity<Ubicacion> ubicar(@RequestBody Ubicacion ubicacion) {
        Ubicacion ubicacionGuardada = ubicacionRepository.save(ubicacion);
        return ResponseEntity.status(HttpStatus.CREATED).body(ubicacionGuardada);
    }

    @GetMapping("/historial")
    public ResponseEntity<List<Ubicacion>> historial() {
        return ResponseEntity.ok(ubicacionRepository.findAll());
    }
}
