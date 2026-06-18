package cl.duoc.sanosysalvos.reporting.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Comentario {
    private String id;
    private String texto;
    private String foto;
    private Long usuarioId;
    private String usuarioNombre;
    private String fechaRegistro;
}
