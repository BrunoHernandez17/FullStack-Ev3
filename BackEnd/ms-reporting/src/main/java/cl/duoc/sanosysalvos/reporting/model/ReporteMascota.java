package cl.duoc.sanosysalvos.reporting.model;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

@Document(collection = "reportes_mascotas")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ReporteMascota {

    @Id
    private String id;

    @NotBlank(message = "El tipo de animal es obligatorio")
    private String tipoAnimal;

    @NotBlank(message = "La descripción no puede estar vacía")
    private String descripcion;

    private Long ubicacionId;

    private Long usuarioId;

    private String estado = "ACTIVO";

    private String nombreMascota;

    private String tamano;

    private String foto;

    private Double mapX;

    private Double mapY;

    private String fechaRegistro;
}
