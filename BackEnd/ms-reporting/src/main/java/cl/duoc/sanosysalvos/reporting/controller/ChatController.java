package cl.duoc.sanosysalvos.reporting.controller;

import cl.duoc.sanosysalvos.reporting.model.Mensaje;
import cl.duoc.sanosysalvos.reporting.repository.MensajeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/api/reportes/chat")
@RequiredArgsConstructor
public class ChatController {

    private final MensajeRepository mensajeRepository;

    @PostMapping("/enviar")
    public ResponseEntity<Mensaje> enviarMensaje(@RequestBody Mensaje mensaje) {
        mensaje.setFechaRegistro(LocalDateTime.now().toString());
        Mensaje guardado = mensajeRepository.save(mensaje);
        return ResponseEntity.ok(guardado);
    }

    @GetMapping("/usuario/{id}")
    public ResponseEntity<List<Mensaje>> obtenerMensajesUsuario(@PathVariable Long id) {
        List<Mensaje> mensajes = mensajeRepository.findByEmisorIdOrReceptorId(id, id);
        return ResponseEntity.ok(mensajes);
    }
}
