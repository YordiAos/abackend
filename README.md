# Reto de Automatización QA - BackEnd

Este proyecto contiene una suite de pruebas automatizadas para la API de Usuarios de [ServeRest](https://serverest.dev/) desarrollada utilizando **Karate DSL** y **Java**.

## Estructura del Proyecto

El proyecto sigue una estructura estándar de Maven:

- `src/test/java/serverest/`: Contiene los runners de JUnit.
- `src/test/java/serverest/users/users.feature`: Archivo principal con los escenarios de prueba en Gherkin/Karate DSL.
- `src/test/java/serverest/helpers/DataGenerator.java`: Clase Java de utilidad que usa DataFaker para generar datos aleatorios de prueba.
- `src/test/java/karate-config.js`: Configuración global de Karate (por ejemplo, `baseUrl`).
- `pom.xml`: Configuración de dependencias de Maven.

## Estrategia de Automatización y Patrones

Para este proyecto tomé un par de decisiones para hacer las pruebas más robustas:

1. **Generación de Datos (Faker):** Usé `DataFaker` en la clase `DataGenerator`. Así me evito quemar datos y problemas de colisión (como cuando intentas registrar el mismo email dos veces).
2. **Validación por JSON Schema:** En el `Background` del feature definí un esquema (`userSchema`). Es mucho más limpio validar que toda la estructura de la respuesta cuadre con el esquema, en vez de ir campo por campo.
3. **Manejo de Estado (Setup/Teardown):** En las pruebas que crean o modifican data, guardo el `_id` y al final del escenario hago un DELETE. De esa forma, las pruebas son independientes y no ensucio la base de datos de ServeRest.
4. **Cobertura:** Incluí tanto los flujos ideales (Happy Path) como un par de escenarios negativos (ej. intentar registrar un usuario sin nombre o buscar un ID que no existe).

## Requisitos Previos

- Java Development Kit (JDK) 11 o superior.
- Apache Maven instalado.

## Instrucciones de Configuración y Ejecución

1. Clona el repositorio y navega hasta la carpeta `back`.
2. Para ejecutar la suite completa de pruebas, ejecuta el siguiente comando en la terminal:

```bash
mvn test
```

3. Al finalizar la ejecución, Karate generará un reporte detallado en formato HTML. Puedes encontrarlo en:
`target/karate-reports/karate-summary.html`
