<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
<head>
    <meta charset="UTF-8">
    <title>Catálogo - Biblioteca Digital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/img/favicon.png">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-black mb-4 p-3">
        <div class="container">
            <a class="navbar-brand fw-bold" href="libros">
                <i class="bi bi-book-half text-accent me-2"></i>Biblioteca UNTEC
            </a>
            <div class="d-flex align-items-center">
                <a href="perfil" class="text-light text-decoration-none me-4 btn btn-link">
                    <i class="bi bi-person-circle me-1"></i> <c:out value="${sessionScope.usuario.nombre}" />
                    <span class="badge bg-secondary ms-1"><c:out value="${sessionScope.usuario.rol}" /></span>
                </a>
                <a href="logout" class="btn btn-sm btn-outline-danger">
                    <i class="bi bi-box-arrow-right"></i> Salir
                </a>
            </div>
        </div>
    </nav>

    <div class="container">
        
        <div class="row mb-4">
            <div class="col-lg-6 mb-3 mb-lg-0">
                <div class="alert bg-dark border border-secondary text-white h-100 d-flex align-items-center mb-0">
                    <c:choose>
                        <c:when test="${sessionScope.usuario.rol == 'ADMIN'}">
                            <i class="bi bi-person-workspace fs-1 text-accent me-3"></i>
                            <div>
                                <h4 class="alert-heading mb-1">¡Hola, <c:out value="${sessionScope.usuario.nombre}"/>!</h4>
                                <p class="mb-0 text-muted">Cargo: <span class="text-light fw-bold"><c:out value="${sessionScope.usuario.cargo}"/></span></p>
                                <p class="mb-0 text-muted">Panel de gestión y administración de la biblioteca.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-emoji-smile fs-1 text-accent me-3"></i>
                            <div>
                                <h4 class="alert-heading mb-1">¡Hola, <c:out value="${sessionScope.usuario.nombre}"/>!</h4>
                                <p class="mb-0 text-muted">Estudiante de <span class="text-light fw-bold"><c:out value="${sessionScope.usuario.carrera}"/></span></p>
                                <p class="mb-0 text-muted">Bienvenido de vuelta a tu biblioteca digital. ¿Qué te gustaría leer hoy?</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="col-lg-6">
                <div class="d-flex justify-content-end gap-2 h-100">
                    <c:choose>
                        <c:when test="${sessionScope.usuario.rol == 'ADMIN'}">
                            <div class="card bg-dark border-secondary text-center flex-fill">
                                <div class="card-body p-2 d-flex flex-column justify-content-center">
                                    <h3 class="text-white mb-0">${totalLibros != null ? totalLibros : 0}</h3>
                                    <small class="text-muted">Total Títulos</small>
                                </div>
                            </div>
                            <div class="card bg-dark border-secondary text-center flex-fill">
                                <div class="card-body p-2 d-flex flex-column justify-content-center">
                                    <h3 class="text-success mb-0">${librosDisponibles != null ? librosDisponibles : 0}</h3>
                                    <small class="text-muted">Ejemplares Disp.</small>
                                </div>
                            </div>
                            <div class="card bg-dark border-secondary text-center flex-fill">
                                <div class="card-body p-2 d-flex flex-column justify-content-center">
                                    <h3 class="text-accent mb-0">${librosPrestados != null ? librosPrestados : 0}</h3>
                                    <small class="text-muted">En Préstamo</small>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="card bg-dark border-secondary text-center flex-fill">
                                <div class="card-body p-2 d-flex flex-column justify-content-center">
                                    <h3 class="text-warning mb-0">${librosPendientes != null ? librosPendientes : 0}</h3>
                                    <small class="text-muted">Por Devolver</small>
                                </div>
                            </div>
                            <div class="card bg-dark border-secondary text-center flex-fill">
                                <div class="card-body p-2 d-flex flex-column justify-content-center">
                                    <h3 class="text-success mb-0">${librosLeidos != null ? librosLeidos : 0}</h3>
                                    <small class="text-muted">Libros Leídos</small>
                                </div>
                            </div>
                            <div class="card bg-dark border-secondary text-center flex-fill">
                                <div class="card-body p-2 d-flex flex-column justify-content-center">
                                    <h3 class="text-accent mb-0">${porcentajeLeido != null ? porcentajeLeido : 0}%</h3>
                                    <small class="text-muted">Del Catálogo</small>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-white">Catálogo de Libros</h2>
            <div>
                <c:if test="${sessionScope.usuario.rol == 'ADMIN'}">
                    <a href="libros?accion=nuevo" class="btn btn-outline-accent">
                        <i class="bi bi-plus-lg"></i> Registrar Nuevo
                    </a>
                </c:if>
                <c:if test="${sessionScope.usuario.rol == 'USUARIO'}">
                    <a href="mis-prestamos" class="btn btn-outline-light">
                        <i class="bi bi-journal-bookmark"></i> Mis Préstamos
                    </a>
                </c:if>
            </div>
        </div>

        <div class="card bg-dark border-secondary mb-4">
            <div class="card-body p-3">
                <form action="libros" method="GET" class="m-0">
                    <div class="input-group shadow-sm">
                        <select name="criterio" class="form-select bg-black text-white border-secondary" style="max-width: 130px; flex: none;">
                            <option value="todo" ${param.criterio == 'todo' || empty param.criterio ? 'selected' : ''}>Todos</option>
                            <option value="titulo" ${param.criterio == 'titulo' ? 'selected' : ''}>Título</option>
                            <option value="autor" ${param.criterio == 'autor' ? 'selected' : ''}>Autor</option>
                            <option value="genero" ${param.criterio == 'genero' ? 'selected' : ''}>Género</option>
                            <option value="anio" ${param.criterio == 'anio' ? 'selected' : ''}>Año</option>
                        </select>
                        <span class="input-group-text bg-black border-secondary text-muted">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text" name="q" class="form-control bg-black text-white border-secondary" placeholder="Buscar libro, autor o género..." value="${param.q}">
                        <c:if test="${not empty param.q}">
                            <a href="libros" class="btn btn-outline-secondary border-secondary text-muted d-flex align-items-center" title="Limpiar búsqueda">
                                <i class="bi bi-x-lg"></i>
                            </a>
                        </c:if>
                        <button type="submit" class="btn btn-outline-accent fw-bold px-4">Buscar</button>
                    </div>
                </form>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-dark table-hover align-middle border-secondary">
                <thead>
                    <tr class="border-bottom border-secondary">
                        <th>ID</th>
                        <th>ISBN</th>
                        <th>Título</th>
                        <th>Autor</th>
                        <th>Año</th>
                        <th>Género</th>
                        <th>Disponibilidad</th>
                        <th class="text-center">Acciones</th>
                    </tr>
                </thead>
                <tbody class="table-group-divider">
                    <c:forEach var="l" items="${libros}">
                        <tr>
                            <td class="text-muted fw-bold"># ${l.idLibro}</td>
                            <td class="text-muted">${l.isbn}</td>
                            
                            <td class="fw-bold">
                                <a href="javascript:void(0)" onclick="abrirDetalleModal('${l.idLibro}')" class="text-light text-decoration-none">
                                    ${l.titulo} <i class="bi bi-box-arrow-up-right ms-1 text-muted" style="font-size: 0.7rem;"></i>
                                </a>
                                <div class="small text-muted mt-1"><i class="bi bi-building me-1"></i>${l.editorial}</div>
                            </td>
                            <td>${l.autor}</td>
                            <td>${l.anioLanzamiento}</td>
        
                            <td><span class="badge bg-dark border border-secondary">${l.genero}</span></td>
                            <td>
                                <span class="badge ${l.ejemplaresDisponibles > 0 ? 'bg-success' : 'bg-danger'}">
                                    ${l.ejemplaresDisponibles} / ${l.ejemplaresTotales} disp.
                                </span>
                            </td>
                            <td class="text-center">
                                <div class="d-flex justify-content-center align-items-center flex-nowrap gap-1">
                                    
                                    <c:choose>
                                        <c:when test="${sessionScope.usuario.rol == 'ADMIN'}">
                                            <c:choose>
                                                <c:when test="${l.ejemplaresDisponibles > 0}">
                                                    <button type="button" class="btn btn-sm btn-outline-accent" title="Asignar Préstamo"
                                                        onclick="abrirModalPrestamo('${l.idLibro}', '${l.isbn}', '${l.titulo}', '${l.autor}')">
                                                    <i class="bi bi-person-plus-fill"></i>
                                                </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-danger d-flex align-items-center justify-content-center" 
                                                        style="width: 32px; height: 31px;" title="Sin stock disponible">
                                                        <i class="bi bi-exclamation-triangle-fill"></i>
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <a href="libros?accion=editar&id=${l.idLibro}" class="btn btn-sm btn-secondary" title="Editar">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <a href="libros?accion=eliminar&id=${l.idLibro}" onclick="return confirm('¿Eliminar este libro?');" class="btn btn-sm btn-danger" title="Eliminar">
                                                <i class="bi bi-trash"></i>
                                            </a>
                                        </c:when>
                                        
                                        <c:when test="${sessionScope.usuario.rol == 'USUARIO'}">
                                            <c:choose>
                                                <c:when test="${l.ejemplaresDisponibles > 0}">
                                                    <button type="button" class="btn btn-sm btn-outline-accent text-nowrap"
                                                            onclick="abrirModalSolicitar('${l.idLibro}', '${l.isbn}', '${l.titulo}', '${l.autor}')">
                                                        <i class="bi bi-hand-index-thumb"></i> Solicitar
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted fst-italic text-nowrap"><i class="bi bi-dash-circle me-1"></i>Agotado</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                    </c:choose>
                                    
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="modal fade" id="modalPrestamo" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content bg-dark text-white border-secondary">
          <div class="modal-header border-secondary">
            <h5 class="modal-title text-accent"><i class="bi bi-journal-arrow-up me-2"></i>Asignar Préstamo Manual</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="asignarPrestamo" method="post">
              <div class="modal-body">
                  <h6 class="text-light mb-3">Datos del Libro</h6>
                  <div class="row g-2 mb-3">
                      <div class="col-12">
                          <label class="small text-muted">ISBN / ID</label>
                          <input type="hidden" id="modalIdLibro" name="idLibro">
                          <input type="text" class="form-control bg-black text-white border-secondary" id="modalIsbn" name="isbn" readonly>
                      </div>
                      <div class="col-12">
                          <label class="small text-muted">Título</label>
                          <input type="text" class="form-control bg-black text-white border-secondary" id="modalTitulo" name="titulo" readonly>
                      </div>
                      <div class="col-12">
                          <label class="small text-muted">Autor</label>
                          <input type="text" class="form-control bg-black text-white border-secondary" id="modalAutor" name="autor" readonly>
                      </div>
                  </div>
                  <hr class="border-secondary">
                  <h6 class="text-light mb-3">Datos del Solicitante</h6>
                  <div class="row g-2 mb-3">
                      <div class="col-6">
                          <label class="small text-muted">Nombre</label>
                          <input type="text" class="form-control bg-dark text-white border-secondary" name="nombreUsuario" required>
                      </div>
                      <div class="col-6">
                          <label class="small text-muted">Apellido</label>
                          <input type="text" class="form-control bg-dark text-white border-secondary" name="apellidoUsuario" required>
                      </div>
                      <div class="col-12">
                          <label class="small text-muted">Fecha de Devolución</label>
                          <input type="date" class="form-control bg-dark text-white border-secondary" name="fechaEntrega" required>
                      </div>
                  </div>
              </div>
              <div class="modal-footer border-secondary">
                <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-primary">Registrar Préstamo</button>
              </div>
          </form>
        </div>
      </div>
    </div>

    <div class="modal fade" id="modalDetalleLibro" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content bg-dark text-white border-secondary" id="modalDetalleContenido">
            <div class="text-center p-5">
                <div class="spinner-border text-accent" role="status"></div>
                <div class="mt-2 text-muted">Cargando detalles...</div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalSolicitarPrestamo" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content bg-dark text-white border-secondary">
          <div class="modal-header border-secondary bg-black">
            <h5 class="modal-title text-accent"><i class="bi bi-bookmark-plus me-2"></i>Solicitar Libro</h5>
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <form action="solicitarPrestamo" method="post">
              <div class="modal-body p-4">
                  <div class="d-flex align-items-center mb-3">
                      <i class="bi bi-book fs-3 text-secondary me-3"></i>
                      <div>
                          <input type="hidden" id="solicitarIdLibro" name="idLibro">
                          <h5 class="mb-0 text-white"><input type="text" id="solicitarTitulo" class="bg-transparent border-0 text-white fw-bold w-100" readonly></h5>
                          <div class="text-muted small">
                              Autor: <input type="text" id="solicitarAutor" class="bg-transparent border-0 text-muted" readonly style="width:130px"> | 
                              ISBN: <input type="text" id="solicitarIsbn" class="bg-transparent border-0 text-muted" readonly style="width:100px">
                          </div>
                      </div>
                  </div>
                  <hr class="border-secondary">
                  <div class="row g-3 mb-3">
                      <div class="col-md-6">
                          <label class="small text-muted mb-1">Tu Nombre</label>
                          <input type="text" class="form-control bg-black text-secondary border-secondary" value="${sessionScope.usuario.nombre} ${sessionScope.usuario.apellido}" readonly>
                      </div>
                      <div class="col-md-6">
                          <label class="small text-muted mb-1">Tu Correo</label>
                          <input type="email" class="form-control bg-black text-secondary border-secondary" value="${sessionScope.usuario.email}" readonly>
                      </div>
                      <div class="col-12 mt-4">
                          <label class="form-label text-light"><i class="bi bi-calendar-check text-accent me-2"></i>¿Cuándo devolverás el libro?</label>
                          <input type="date" class="form-control bg-dark text-white border-accent" name="fechaEntrega" required>
                      </div>
                  </div>
              </div>
              <div class="modal-footer border-secondary">
                <button type="button" class="btn btn-outline-light" data-bs-dismiss="modal">Cancelar</button>
                <button type="submit" class="btn btn-primary"><i class="bi bi-check2-circle me-1"></i> Confirmar Solicitud</button>
              </div>
          </form>
        </div>
      </div>
    </div>

    <script>
      function abrirModalSolicitar(idLibro, isbn, titulo, autor) {
          if(typeof detalleModal !== 'undefined' && detalleModal) {
              detalleModal.hide();
          }
          document.getElementById('solicitarIdLibro').value = idLibro;
          document.getElementById('solicitarIsbn').value = isbn;
          document.getElementById('solicitarTitulo').value = titulo;
          document.getElementById('solicitarAutor').value = autor;
          new bootstrap.Modal(document.getElementById('modalSolicitarPrestamo')).show();
      }
    </script>
    <script>
        let detalleModal;

        function abrirDetalleModal(idLibro) {
            document.getElementById('modalDetalleContenido').innerHTML = `
                <div class="text-center p-5">
                    <div class="spinner-border text-accent" role="status"></div>
                    <div class="mt-2 text-muted">Cargando detalles...</div>
                </div>
            `;
            
            if (!detalleModal) {
                detalleModal = new bootstrap.Modal(document.getElementById('modalDetalleLibro'));
            }
            detalleModal.show();

            fetch('libros?accion=detalle&id=' + idLibro)
                .then(response => response.text())
                .then(html => {
                    document.getElementById('modalDetalleContenido').innerHTML = html;
                })
                .catch(error => {
                    document.getElementById('modalDetalleContenido').innerHTML = `
                        <div class="p-4 text-center text-danger">
                            <i class="bi bi-x-circle fs-1"></i>
                            <p>Error al cargar los detalles del libro.</p>
                        </div>
                    `;
                });
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      function abrirModalPrestamo(idLibro, isbn, titulo, autor) {
          document.getElementById('modalIdLibro').value = idLibro;
          document.getElementById('modalIsbn').value = isbn;
          document.getElementById('modalTitulo').value = titulo;
          document.getElementById('modalAutor').value = autor;
          new bootstrap.Modal(document.getElementById('modalPrestamo')).show();
      }
    </script>
</body>
</html>