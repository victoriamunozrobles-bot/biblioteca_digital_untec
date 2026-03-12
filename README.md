# 📚 Biblioteca Digital UNTEC

Un sistema web robusto e intuitivo diseñado para gestionar el catálogo y los préstamos de una biblioteca institucional. Construido bajo la arquitectura Modelo-Vista-Controlador (MVC), ofrece una experiencia fluida tanto para los estudiantes que buscan literatura como para los administradores que controlan el inventario.

## ✨ 1. Funcionalidad de la Aplicación

La aplicación permite la gestión integral del ciclo de vida de los préstamos literarios mediante las siguientes funciones clave:

* **Catálogo Interactivo**: Visualización de libros con disponibilidad en tiempo real.
* **Búsqueda Dinámica**: Motor de búsqueda filtrado por título, autor, género o año de publicación.
* **Gestión de Inventario**: Descuento y suma automática de los ejemplares disponibles al realizar o devolver un préstamo.
* **Detalles en Tiempo Real (AJAX)**: Visualización de sinopsis, portada, editorial y recomendaciones del mismo género a través de un modal sin recargar la página.
* **Gestión de Perfiles**: Paneles personalizados que muestran métricas de lectura (para estudiantes) o agendas operativas (para administradores).

## 👥 2. Separación de Roles de Usuario

El sistema distingue las operaciones mediante un control de acceso basado en roles (RBAC):

* **Estudiante (Usuario Normal)**:
  * Puede explorar el catálogo y ver el detalle completo de los libros.
  * Puede solicitar préstamos definiendo una fecha de entrega.
  * Tiene acceso a un historial de lectura y a la gestión de sus devoluciones activas.
* **Trabajador / Administrador**:
  * Requiere una contraseña especial de autorización (`admin123`) para registrarse.
  * Tiene control total sobre el CRUD (Crear, Leer, Actualizar, Eliminar) del catálogo de libros.
  * Puede asignar préstamos manualmente a estudiantes de forma rápida.
  * Visualiza una "Agenda Operativa" para terminar procesos de préstamo y enviar recordatorios ficticios.

## 💻 3. Stack de Tecnologías

* **Java (Jakarta EE)**: Lenguaje principal del backend encargado de la lógica de negocio a través de Servlets.
* **JSP (JavaServer Pages) & JSTL**: Utilizado para la renderización dinámica del HTML en el servidor, inyectando los datos de Java directamente en la vista.
* **JDBC (Java Database Connectivity)**: Tecnología estándar de Java utilizada en los DAO para la comunicación directa y segura con la base de datos.
* **HTML5, CSS3 y Bootstrap 5**: Conforman el diseño del frontend, garantizando interfaces modernas, en tema oscuro (`data-bs-theme="dark"`) y 100% responsivas.
* **JavaScript (Fetch API)**: Utilizado para peticiones asíncronas, permitiendo cargar detalles de libros en ventanas emergentes sin refrescar la página entera.
* **MariaDB / MySQL**: Motor de base de datos relacional elegido para la persistencia de datos.

## 🗄️ 4. Base de Datos y Modelo

El sistema utiliza una base de datos relacional estructurada en tres entidades principales:

1. **Tabla `usuarios`**: Almacena credenciales, datos personales, roles (ADMIN/USUARIO) y detalles específicos como carrera o cargo.
2. **Tabla `libros`**: Contiene la información bibliográfica (título, autor, género, editorial, ISBN autogenerado) y recursos gráficos (URL de portada, sinopsis). Administra dos contadores vitales: `ejemplares_totales` y `ejemplares_disponibles`.
3. **Tabla `prestamos`**: Funciona como tabla transaccional uniendo Usuarios y Libros. Registra las fechas de solicitud, entrega y devolución, así como el estado operativo (`PENDIENTE`, `ENTREGADO`, `ATRASADO`).

## 🏗️ 5. Patrón de Diseño MVC

El proyecto está rigurosamente estructurado bajo el patrón Modelo-Vista-Controlador para asegurar escalabilidad y un código limpio:

* **Model (`/model`)**: Clases Java (POJOs) como `Libro.java`, `Usuario.java` y `Prestamo.java` que representan la estructura de los datos.
* **View (`/webapp/WEB-INF/view`)**: Archivos `.jsp` protegidos de accesos directos. Se encargan puramente de la interfaz gráfica y la presentación de la información al usuario.
* **Controller (`/controller`)**: Servlets de Java (ej. `LibroServlet.java`, `PrestamoServlet.java`) que interceptan peticiones HTTP, validan reglas de negocio, consultan los DAOs y redirigen a la Vista correspondiente.
* *(Capa extra)* **DAO (`/dao`)**: Encapsula las consultas SQL aislando la base de datos de los controladores, respetando el principio de responsabilidad única.

## 🚀 6. Oportunidades de Mejora (Próximas Actualizaciones)

La arquitectura de la aplicación permite un crecimiento constante. Algunas de las mejoras planificadas incluyen:

* **Tarjetas Interactivas**: Permitir que el clic sobre las tarjetas numéricas (ej. "Libros Prestados") aplique filtros automáticos en las tablas.
* **Enriquecimiento del Catálogo**: Popular la base de datos integrando APIs públicas (como Google Books) para automatizar la obtención de portadas de alta calidad y sinopsis al ingresar un ISBN.
* **Métricas y Analíticas Avanzadas**: Implementación de un Dashboard gráfico (con Chart.js o similar) que muestre los títulos más solicitados y picos de actividad temporal.
* **Notificaciones por Email Reales**: Integración con JavaMail API para enviar recordatorios automáticos de devolución cuando un préstamo entra en estado `ATRASADO`.
* **Paginación del Catálogo**: Añadir segmentación a la vista de libros para optimizar el tiempo de carga a medida que el inventario crezca masivamente.
* **Renovación de Préstamos**: Botón para que los alumnos puedan extender sus préstamos directamente desde su panel, sujeto a confirmación administrativa.
