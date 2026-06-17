package cl.duoc.sanosysalvos.reporting.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("API de Reportes - Sanos y Salvos")
                        .version("1.0.0")
                        .description("Servicios para la generación de reportes de incidentes, emergencias de vecinos y estadísticas de seguridad."));
    }
}
