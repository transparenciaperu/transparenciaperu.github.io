package pe.gob.transparencia.listeners;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import pe.gob.transparencia.db.DatabaseInit;

/**
 * Listener que se ejecuta al iniciar y detener la aplicación
 */
@WebListener
public class AppInitializer implements ServletContextListener {

    /**
     * Se ejecuta cuando la aplicación se inicia
     */
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("========== INICIANDO APLICACIÓN PORTAL DE TRANSPARENCIA ==========");

        try {
            // Inicializar estructura de base de datos
            System.out.println("Inicializando estructura de base de datos...");
            DatabaseInit.init();

            // Imprimir información de usuarios para depuración
            System.out.println("Imprimiendo información de usuarios...");
            DatabaseInit.imprimirInformacionUsuarios();

        } catch (Exception e) {
            System.out.println("Error durante la inicialización de la aplicación: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("========== APLICACIÓN INICIALIZADA CORRECTAMENTE ==========");
    }

    /**
     * Se ejecuta cuando la aplicación se detiene
     */
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("========== DETENIENDO APLICACIÓN PORTAL DE TRANSPARENCIA ==========");
    }
}