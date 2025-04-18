# Portal de Transparencia Perú

## Información del Proyecto

**Portal de Transparencia Perú** es una plataforma web desarrollada para facilitar el acceso a la información pública y promover la transparencia en la gestión pública del Perú. Este proyecto busca implementar un portal web intuitivo, funcional y amigable que permita a los ciudadanos acceder a información sobre presupuesto público y realizar solicitudes de acceso a la información de manera sencilla.

### Equipo de Desarrollo

- **OLIVARES BENDEZU, JESSICA GLORIA**
- **DE LA CRUZ LOPEZ, KELLY**
- **VALDIVIA CANO, ANDRE**
- **LEON SALAZAR, DANIEL ANGEL** (Coordinador de Grupo)

### Información Académica

- **Curso**: Lenguaje de Programación I (4688)
- **Docente**: ERICK ROKY SHUPINGAHUA ACHO
- **Ciclo**: Módulo I - Ciclo III

## Descripción del Proyecto

En vista de facilitar la gestión de trámites y el acceso a la información pública, este proyecto busca implementar un portal de transparencia funcional e intuitivo que permita al ciudadano acceder a información pública y datos sobre presupuesto de manera sencilla y entendible, contrarrestando la opacidad en la gestión de proyectos locales en nuestro país.

## Problemática

A pesar de los esfuerzos del gobierno nacional para implementar portales de transparencia estandarizados, muchos gobiernos regionales y locales no han migrado su información a plataformas como GOB.PE o el Portal de Transparencia Estándar (PTE). Según la Defensoría del Pueblo (2023), solo 802 entidades públicas cuentan con dominio GOB.PE, mientras que en el Perú existen 26 gobiernos regionales, 196 municipalidades provinciales y 1694 municipalidades distritales.

La información disponible en muchos portales de transparencia es:
- Desactualizada
- Incompleta
- Poco comprensible para el ciudadano común

Este proyecto se enfoca en dos rubros específicos que la Autoridad Nacional de Transparencia y Acceso a la Información Pública (ANTAIP) exige:
1. **Presupuesto Público**
2. **Acceso a la Información**

## Objetivos

- Desarrollar una plataforma amigable e intuitiva para obtener información sobre presupuesto público
- Implementar un formulario virtual que permita solicitar información conforme a la Ley 27806
- Mejorar la experiencia de usuario (UX/UI) para facilitar el acceso a la información
- Promover la transparencia y rendición de cuentas en las entidades públicas

## Tecnologías Utilizadas

- **Backend**: Java (JDK 21)
- **Frontend**: HTML5, CSS3, JavaScript, Bootstrap 5
- **Arquitectura**: MVC (Modelo-Vista-Controlador)
- **Patrones de Diseño**: DAO (Data Access Object)
- **Servidor Web**: Jakarta EE
- **Base de Datos**: Por implementar
- **Control de Versiones**: Git

## Estructura del Proyecto

```
web_transparencia_peru/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── pe/
│   │   │       └── gob/
│   │   │           └── transparencia/
│   │   │               ├── dao/         # Acceso a datos
│   │   │               ├── db/          # Configuración de base de datos
│   │   │               ├── entidades/   # Modelos y entidades
│   │   │               ├── interfaces/  # Interfaces del sistema
│   │   │               ├── modelo/      # Lógica de negocio
│   │   │               └── servlet/     # Controladores
│   │   ├── resources/  # Recursos de la aplicación
│   │   └── webapp/     # Archivos web (vistas)
│   └── test/           # Pruebas unitarias
└── pom.xml             # Configuración de Maven
```

## Instalación y Configuración

1. Clone el repositorio:
   ```bash
   git clone https://github.com/transparenciaperu/transparenciaperu.github.io.git
   ```

2. Navegue al directorio del proyecto:
   ```bash
   cd transparenciaperu.github.io/web_transparencia_peru
   ```

3. Compile el proyecto usando Maven:
   ```bash
   ./mvnw clean install
   ```

4. Ejecute el proyecto en un servidor web compatible con Jakarta EE

## Contribución

Si desea contribuir a este proyecto, por favor siga estos pasos:

1. Haga un fork del repositorio
2. Cree una nueva rama (`git checkout -b feature/nueva-funcionalidad`)
3. Realice sus cambios y haga commit (`git commit -m 'Agregar nueva funcionalidad'`)
4. Envíe sus cambios (`git push origin feature/nueva-funcionalidad`)
5. Abra un Pull Request

## Licencia

Este proyecto está bajo la Licencia Apache 2.0 - vea el archivo [LICENSE](LICENSE) para más detalles.
