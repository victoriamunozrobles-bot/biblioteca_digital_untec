<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Mi Perfil - Biblioteca Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon.png">
</head>
<body>
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white"><i class="bi bi-person-lines-fill text-accent me-2"></i>Mi Perfil</h2>
            <a href="libros" class="btn btn-outline-light"><i class="bi bi-arrow-left me-1"></i>Volver al Catálogo</a>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card bg-dark border-secondary">
                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <div class="bg-black rounded-circle d-inline-flex align-items-center justify-content-center border border-secondary mb-3" style="width: 120px; height: 120px;">
                                <i class="bi bi-person-fill text-secondary" style="font-size: 4rem;"></i>
                            </div>
                            <h4 class="text-white mb-0">${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}</h4>
                            <span class="badge bg-primary mt-2">${sessionScope.usuario.rol}</span>
                        </div>

                        <form action="perfil" method="POST">
                            
                            <div class="mb-3">
                                <label class="form-label text-muted small mb-1">
                                    ID de ${sessionScope.usuario.rol == 'ADMIN' ? 'Empleado / Administrador' : 'Usuario / Estudiante'}
                                </label>
                                <input type="text" class="form-control bg-black text-secondary border-secondary" value="#${sessionScope.usuario.idUsuario}" readonly disabled>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-muted small mb-1">Correo Electrónico</label>
                                <input type="email" class="form-control bg-black text-secondary border-secondary" value="${sessionScope.usuario.email}" readonly disabled>
                            </div>
                            
                            <hr class="border-secondary my-4">
                            <h6 class="text-accent mb-3"><i class="bi bi-pencil-square me-2"></i>Editar Información</h6>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label text-light small">Nombre</label>
                                    <input type="text" class="form-control bg-black text-white border-secondary" name="nombre" value="${sessionScope.usuario.nombre}" required>
                                </div>
                                <div class="col-6">
                                    <label class="form-label text-light small">Apellido</label>
                                    <input type="text" class="form-control bg-black text-white border-secondary" name="apellido" value="${sessionScope.usuario.apellido}" required>
                                </div>
                            </div>
                            
                            <c:choose>
                                <c:when test="${sessionScope.usuario.rol == 'ADMIN'}">
                                    <div class="mb-3">
                                        <label class="form-label text-light small">Cargo en Biblioteca</label>
                                        <input type="text" class="form-control bg-black text-white border-secondary" name="cargo" value="${sessionScope.usuario.cargo}" required>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="mb-3">
                                        <label class="form-label text-light small">Carrera</label>
                                        <input type="text" class="form-control bg-black text-white border-secondary" name="carrera" value="${sessionScope.usuario.carrera}" required>
                                    </div>
                                </c:otherwise>
                            </c:choose>

                            <div class="mb-4">
                                <label class="form-label text-light small">Cambiar Contraseña</label>
                                <input type="password" class="form-control bg-black text-white border-secondary" name="password" value="${sessionScope.usuario.password}" required>
                            </div>
                            <button type="submit" class="btn btn-outline-accent w-100"><i class="bi bi-save me-2"></i>Guardar Cambios</button>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-8">
                <c:choose>
                    
                    <c:when test="${sessionScope.usuario.rol == 'ADMIN'}">
                        
                        <div class="row g-3 mb-4">
                            <div class="col-6">
                                <a href="#" data-bs-toggle="modal" data-bs-target="#modalHistorialAdmin" class="text-decoration-none">
                                    <div class="card bg-dark border-secondary h-100 p-3 text-center transition-hover">
                                        <h3 class="text-white mb-0">${totalPrestamosHistoricos != null ? totalPrestamosHistoricos : 0}</h3>
                                        <small class="text-muted"><i class="bi bi-search me-1"></i>Préstamos Procesados</small>
                                    </div>
                                </a>
                            </div>
                            <div class="col-6">
                                <div class="card bg-dark border-secondary h-100 p-3 text-center">
                                    <h3 class="text-warning mb-0">${totalPrestamosPendientes != null ? totalPrestamosPendientes : 0}</h3>
                                    <small class="text-muted">Pendientes de Devolución</small>
                                </div>
                            </div>
                        </div>

                        <div class="card bg-dark border-secondary">
                            <div class="card-header bg-black border-secondary">
                                <h5 class="mb-0 text-white"><i class="bi bi-calendar2-week text-accent me-2"></i>Agenda Operativa de Préstamos</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-dark table-striped mb-0 align-middle">
                                        <thead>
                                            <tr>
                                                <th class="ps-3 py-3">Usuario</th>
                                                <th class="py-3">Libro</th>
                                                <th class="py-3">Estado</th>
                                                <th class="text-center pe-3 py-3">Acciones</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty agendaPrestamos}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-5">
                                                        <i class="bi bi-check2-circle fs-1 d-block mb-2"></i>
                                                        No hay préstamos pendientes en la agenda.
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:forEach var="a" items="${agendaPrestamos}">
                                                <tr>
                                                    <td class="ps-3">${a.nombreUsuario} ${a.apellidoUsuario}</td>
                                                    <td>${a.tituloLibro}</td>
                                                    <td><span class="badge bg-warning text-dark">Pendiente</span></td>
                                                    <td class="text-center pe-3">
                                                        <a href="terminarPrestamo?id=${a.idPrestamo}" class="btn btn-sm btn-success me-1" title="Terminar Proceso">
                                                            <i class="bi bi-check2-all"></i>
                                                        </a>
                                                        <button type="button" class="btn btn-sm btn-outline-info" title="Enviar Mensaje" 
                                                            onclick="abrirModalMensaje('${a.idUsuario}', '${a.nombreUsuario} ${a.apellidoUsuario}', '${a.emailUsuario}')">
                                                            <i class="bi bi-envelope"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    
                    <%-- ================= VISTA USUARIO ESTUDIANTE ================= --%>
                    <c:otherwise>
                        
                        <div class="card bg-dark border-secondary mb-4">
                            <div class="card-body d-flex justify-content-between align-items-center p-4">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-journal-bookmark text-accent me-4" style="font-size: 3rem;"></i>
                                    <div>
                                        <h2 class="display-6 text-white mb-0 fw-bold">${totalActivos}</h2>
                                        <p class="text-muted mb-0">Préstamos Activos Actualmente</p>
                                    </div>
                                </div>
                                <a href="mis-prestamos" class="btn btn-outline-light px-4">Gestionar Activos</a>
                            </div>
                        </div>

                        <div class="card bg-dark border-secondary">
                            <div class="card-header border-secondary bg-black">
                                <h5 class="mb-0 text-white"><i class="bi bi-clock-history text-accent me-2"></i>Historial de Lectura</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-dark table-striped align-middle mb-0">
                                        <thead>
                                            <tr>
                                                <th class="ps-3 py-3">Libro</th>
                                                <th class="py-3">Fecha Préstamo</th>
                                                <th class="py-3">Fecha Devolución</th>
                                                <th class="py-3">Estado</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:if test="${empty historial}">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-5">
                                                        <i class="bi bi-journal-text fs-1 d-block mb-2"></i>
                                                        Aún no tienes historial de libros devueltos.
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:forEach var="h" items="${historial}">
                                                <tr>
                                                    <td class="ps-3 fw-bold text-light">${h.tituloLibro}</td>
                                                    <td class="text-muted">${h.fechaPrestamo}</td>
                                                    <td class="text-muted">${h.fechaDevolucion}</td>
                                                    <td><span class="badge bg-success">Devuelto</span></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                    
                </c:choose>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalMensaje" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-white border-secondary">
                <div class="modal-header border-secondary">
                    <h5 class="modal-title"><i class="bi bi-envelope-paper text-info me-2"></i>Aviso al Lector</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="mb-2">
                            <label class="small text-muted">Destinatario</label>
                            <input type="text" id="msgNombre" class="form-control bg-black text-white border-secondary" readonly>
                        </div>
                        <div class="mb-2">
                            <label class="small text-muted">Correo Destino</label>
                            <input type="email" id="msgEmail" class="form-control bg-black text-white border-secondary" readonly>
                        </div>
                        <div class="mb-3 mt-3">
                            <label class="small text-light mb-1">Cuerpo del Mensaje</label>
                            <textarea class="form-control bg-dark text-white border-secondary" rows="4" placeholder="Escribe el aviso de recordatorio de devolución..." required></textarea>
                        </div>
                        <button type="button" class="btn btn-info w-100" data-bs-dismiss="modal" onclick="alert('Demostración: Mensaje enviado exitosamente a ' + document.getElementById('msgEmail').value)">
                            <i class="bi bi-send me-2"></i>Enviar Mensaje
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="modalHistorialAdmin" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-scrollable">
            <div class="modal-content bg-dark text-white border-secondary">
                <div class="modal-header border-secondary bg-black">
                    <h5 class="modal-title"><i class="bi bi-clock-history text-accent me-2"></i>Historial de Préstamos Procesados</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <table class="table table-dark table-striped mb-0 align-middle">
                        <thead>
                            <tr>
                                <th class="ps-3 py-3">Usuario</th>
                                <th class="py-3">Libro (ISBN)</th>
                                <th class="py-3">Fecha Préstamo</th>
                                <th class="py-3">Fecha Devolución</th>
                                <th class="py-3">Estado</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="h" items="${historialAdmin}">
                                <tr>
                                    <td class="ps-3">${h.nombreUsuario} ${h.apellidoUsuario}</td>
                                    <td>
                                        <div class="fw-bold">${h.tituloLibro}</div>
                                        <div class="small text-muted">${h.isbn}</div>
                                    </td>
                                    <td>${h.fechaPrestamo}</td>
                                    <td>${h.fechaDevolucion}</td>
                                    <td><span class="badge bg-success">Entregado</span></td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty historialAdmin}">
                                <tr><td colspan="5" class="text-center py-4 text-muted">Aún no hay historial de préstamos devueltos.</td></tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function abrirModalMensaje(id, nombre, email) {
            document.getElementById('msgNombre').value = "#" + id + " - " + nombre;
            document.getElementById('msgEmail').value = email !== 'null' && email !== '' ? email : 'usuario' + id + '@correo.com';
            new bootstrap.Modal(document.getElementById('modalMensaje')).show();
        }
    </script>
</body>
</html>