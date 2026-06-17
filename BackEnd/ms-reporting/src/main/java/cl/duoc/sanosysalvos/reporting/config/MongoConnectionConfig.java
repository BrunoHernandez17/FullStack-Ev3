package cl.duoc.sanosysalvos.reporting.config;

import org.bson.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.core.MongoTemplate;

@Configuration
public class MongoConnectionConfig {

    private static final Logger LOGGER = LoggerFactory.getLogger(MongoConnectionConfig.class);

    @Bean
    public ApplicationRunner mongoConnectionRunner(MongoTemplate mongoTemplate) {
        return args -> {
            int maxRetries = 10;
            int retryCount = 0;
            while (true) {
                try {
                    Document resultado = mongoTemplate.getDb().runCommand(new Document("ping", 1));
                    LOGGER.info(
                            "Conexion MongoDB exitosa: database={}, respuesta={}",
                            mongoTemplate.getDb().getName(),
                            resultado.toJson());
                    break;
                } catch (Exception exception) {
                    retryCount++;
                    if (retryCount >= maxRetries) {
                        LOGGER.error("Error al conectar con MongoDB en ms-reporting despues de " + maxRetries + " intentos", exception);
                        throw new IllegalStateException(
                                "No fue posible conectar ms-reporting a MongoDB. "
                                        + "Verifica REPORTING_MONGODB_URI o que MongoDB este disponible en localhost:27017.",
                                exception);
                    }
                    LOGGER.warn("MongoDB no esta listo. Reintentando conexion en 2 segundos... (Intento {}/{})", retryCount, maxRetries);
                    try {
                        Thread.sleep(2000);
                    } catch (InterruptedException ie) {
                        Thread.currentThread().interrupt();
                        throw new IllegalStateException("Conexion interrumpida", ie);
                    }
                }
            }
        };
    }
}
