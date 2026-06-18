package cl.duoc.sanosysalvos.reporting.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "mensajes_chat")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Mensaje {
    @Id
    private String id;
    private Long emisorId;
    private String emisorNombre;
    private Long receptorId;
    private String receptorNombre;
    private String texto;
    private String fechaRegistro;
}
