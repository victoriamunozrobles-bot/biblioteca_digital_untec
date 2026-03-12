<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
  <head>
    <meta charset="UTF-8" />
    <title>Mis Préstamos - Biblioteca</title>
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon.png">
  </head>
  <body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-black mb-5 p-3">
      <div class="container">
        <a class="navbar-brand fw-bold" href="libros">
          <i class="bi bi-book-half text-accent me-2"></i>Biblioteca UNTEC
        </a>
        <div class="d-flex align-items-center">
          <span class="text-light me-4"
            ><i class="bi bi-person-circle me-1"></i>
            <c:out value="${sessionScope.usuario.nombre}"
          /></span>
          <a href="logout" class="btn btn-sm btn-outline-danger"
            ><i class="bi bi-box-arrow-right"></i> Salir</a
          >
        </div>
      </div>
    </nav>

    <div class="container">
      <div
        class="d-flex justify-content-between align-items-center mb-4 border-bottom border-secondary pb-3"
      >
        <h2 class="text-white">
          <i class="bi bi-bookmark-star text-accent me-2"></i>Mis Préstamos
          Activos
        </h2>
        <a href="libros" class="btn btn-outline-light"
          ><i class="bi bi-arrow-left me-1"></i>Volver al Catálogo</a
        >
      </div>

      <div class="card bg-dark border-secondary">
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-dark table-hover align-middle mb-0">
              <thead class="table-active">
                <tr>
                  <th class="ps-4 py-3">Libro</th>
                  <th class="py-3">
                    <i class="bi bi-calendar-event me-1"></i> Fecha de Préstamo
                  </th>
                  <th class="text-end pe-4 py-3">Acción</th>
                </tr>
              </thead>
              <tbody>
                <c:if test="${empty prestamos}">
                  <tr>
                    <td colspan="3" class="text-center text-muted py-5">
                      <i class="bi bi-journal-x fs-1 d-block mb-2"></i>
                      No tienes préstamos activos en este momento.
                    </td>
                  </tr>
                </c:if>
                <c:forEach var="p" items="${prestamos}">
                  <tr>
                    <td class="ps-4 fw-bold text-light fs-5">
                      <c:out value="${p.tituloLibro}" />
                    </td>
                    <td class="text-muted">
                      <c:out value="${p.fechaPrestamo}" />
                    </td>
                    <td class="text-end pe-4">
                      <a
                        href="devolverLibro?idLibro=${p.idLibro}"
                        class="btn btn-outline-accent rounded-pill px-4"
                      >
                        <i class="bi bi-arrow-return-left me-1"></i> Devolver
                      </a>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
        </div>
      </div>
      <div class="card bg-dark border-secondary">
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-dark table-hover align-middle mb-0">
              <c:choose>
                  <c:when test="${sessionScope.usuario.rol == 'ADMIN'}">
                      <thead class="table-active">
                          <tr>
                              <th class="ps-4 py-3">ISBN</th>
                              <th class="py-3">Libro y Autor</th>
                              <th class="py-3">Usuario Solicitante</th>
                              <th class="py-3">Estado</th>
                          </tr>
                      </thead>
                      <tbody>
                          <c:forEach var="p" items="${prestamos}">
                              <tr>
                                  <td class="ps-4 text-muted">${p.isbn}</td>
                                  <td>
                                      <div class="fw-bold text-light">${p.tituloLibro}</div>
                                      <div class="small text-muted">${p.autor}</div>
                                  </td>
                                  <td>${p.nombreUsuario} ${p.apellidoUsuario}</td>
                                  <td>
                                      <c:choose>
                                          <c:when test="${p.estado == 'PENDIENTE'}"><span class="badge bg-warning text-dark">Pendiente</span></c:when>
                                          <c:when test="${p.estado == 'ATRASADO'}"><span class="badge bg-danger">Atrasado</span></c:when>
                                          <c:when test="${p.estado == 'ENTREGADO'}"><span class="badge bg-success">Entregado</span></c:when>
                                      </c:choose>
                                  </td>
                              </tr>
                          </c:forEach>
                      </tbody>
                  </c:when>
                  <c:otherwise>
                      ...
                  </c:otherwise>
              </c:choose>
            </table>
          </div>
        </div>
    </div>
    </div>
  </body>
</html>
