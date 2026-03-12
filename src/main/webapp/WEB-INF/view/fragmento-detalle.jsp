<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<div class="modal-header border-secondary bg-black">
    <h5 class="modal-title text-accent"><i class="bi bi-book-half me-2"></i>Detalle del Libro</h5>
    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
</div>
<div class="modal-body p-4">
    <div class="row">
        <div class="col-md-4 text-center mb-3 mb-md-0">
            <c:choose>
                <c:when test="${not empty libroDetalle.portada}">
                    <img src="${libroDetalle.portada}" class="img-fluid rounded shadow" alt="Portada" style="max-height: 300px; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <div class="bg-black rounded shadow d-flex align-items-center justify-content-center border border-secondary" style="height: 300px;">
                        <i class="bi bi-image text-muted" style="font-size: 4rem;"></i>
                    </div>
                </c:otherwise>
            </c:choose>
            <div class="mt-3">
                <span class="badge ${libroDetalle.ejemplaresDisponibles > 0 ? 'bg-success' : 'bg-danger'} w-100 py-2 mb-2">
                    ${libroDetalle.ejemplaresDisponibles} / ${libroDetalle.ejemplaresTotales} Disponibles
                </span>

                <c:choose>
                    <c:when test="${sessionScope.usuario.rol == 'ADMIN'}">
                        <a href="libros?accion=editar&id=${libroDetalle.idLibro}" class="btn btn-outline-secondary w-100">
                            <i class="bi bi-pencil-square me-1"></i> Editar Libro
                        </a>
                    </c:when>
                    
                    <c:when test="${sessionScope.usuario.rol == 'USUARIO'}">
                        <c:choose>
                            <c:when test="${libroDetalle.ejemplaresDisponibles > 0}">
                                <button type="button" class="btn btn-primary w-100 text-white fw-bold" 
                                        onclick="abrirModalSolicitar('${libroDetalle.idLibro}', '${libroDetalle.isbn}', '${libroDetalle.titulo}', '${libroDetalle.autor}')">
                                    <i class="bi bi-hand-index-thumb me-1"></i> Solicitar
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-secondary w-100" disabled>
                                    <i class="bi bi-dash-circle me-1"></i> Agotado
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                </c:choose>
            </div>
        </div>

        <div class="col-md-8">
            <h3 class="fw-bold text-white mb-1">${libroDetalle.titulo}</h3>
            <h5 class="text-muted mb-3">${libroDetalle.autor}</h5>
            
            <div class="d-flex gap-2 mb-3">
                <span class="badge bg-dark border border-secondary"><i class="bi bi-calendar3 me-1"></i>${libroDetalle.anioLanzamiento}</span>
                <span class="badge bg-dark border border-secondary"><i class="bi bi-building me-1"></i>${libroDetalle.editorial}</span>
                <span class="badge bg-dark border border-secondary"><i class="bi bi-tag-fill me-1"></i>${libroDetalle.genero}</span>
                <span class="badge bg-dark border border-secondary"><i class="bi bi-upc-scan me-1"></i>${libroDetalle.isbn}</span>
            </div>

            <h6 class="text-light fw-bold border-bottom border-secondary pb-1">Sinopsis</h6>
            <p class="text-muted small" style="text-align: justify;">
                ${not empty libroDetalle.sinopsis ? libroDetalle.sinopsis : 'No hay sinopsis registrada para este libro.'}
            </p>
        </div>
    </div>

    <div class="mt-4 pt-3 border-top border-secondary">
        <h6 class="text-light fw-bold mb-3"><i class="bi bi-collection me-2"></i>Otros libros de ${libroDetalle.genero}</h6>
        
        <c:choose>
            <c:when test="${empty relacionados}">
                <div class="alert bg-black border-secondary text-muted small py-2 mb-0">
                    <i class="bi bi-info-circle me-1"></i> No hay más ejemplares registrados de este género.
                </div>
            </c:when>
            <c:otherwise>
                <div class="d-flex flex-wrap gap-2">
                    <c:forEach var="r" items="${relacionados}">
                        <a href="javascript:void(0)" onclick="abrirDetalleModal('${r.idLibro}')" class="badge bg-dark text-decoration-none border border-secondary p-2 d-flex align-items-center">
                            <i class="bi bi-book me-2 text-accent"></i>
                            <div class="text-start">
                                <div class="text-white">${r.titulo}</div>
                                <div class="text-muted" style="font-size: 0.65rem;">${r.autor}</div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>