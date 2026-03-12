<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${libro != null ? 'Editar' : 'Registrar'} Libro - Biblioteca</title>
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
          <a href="logout" class="btn btn-sm btn-outline-danger">
            <i class="bi bi-box-arrow-right"></i> Salir
          </a>
        </div>
      </div>
    </nav>

    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
          <div class="card form-card p-4 mb-5">
            <h3 class="mb-4 text-white border-bottom border-secondary pb-2">
              <i class="bi bi-journal-plus text-accent me-2"></i>
              <c:out value="${libro != null ? 'Editar' : 'Registrar Nuevo'}" />
              Libro
            </h3>

            <form action="libros" method="post">
              <input type="hidden" name="idLibro" value="${libro.idLibro}" />

              <div class="mb-3">
                <label for="titulo" class="form-label text-light"
                  >Título del Libro</label
                >
                <input
                  type="text"
                  class="form-control bg-dark text-white border-secondary"
                  id="titulo"
                  name="titulo"
                  value="${libro.titulo}"
                  required
                />
              </div>

              <div class="row mb-3">
                <div class="col-md-8">
                  <label for="autor" class="form-label text-light">Autor</label>
                  <input
                    type="text"
                    class="form-control bg-dark text-white border-secondary"
                    id="autor"
                    name="autor"
                    value="${libro.autor}"
                    required
                  />
                </div>
                <div class="col-md-4 mt-3 mt-md-0">
                  <label for="anioLanzamiento" class="form-label text-light"
                    >Año</label
                  >
                  <input
                    type="number"
                    class="form-control bg-dark text-white border-secondary"
                    id="anioLanzamiento"
                    name="anioLanzamiento"
                    value="${libro.anioLanzamiento}"
                    required
                  />
                </div>
              </div>

              <div class="mb-3">
                <div class="col-md-6">
                  <label for="editorial" class="form-label text-light"
                    >Editorial</label
                  >
                  <input
                    type="text"
                    class="form-control bg-dark text-white border-secondary"
                    id="editorial"
                    name="editorial"
                    value="${libro.editorial}"
                    required
                  />
                </div>
                <label for="genero" class="form-label text-light">Género</label>
                <input
                  type="text"
                  class="form-control bg-dark text-white border-secondary"
                  id="genero"
                  name="genero"
                  value="${libro.genero}"
                />
              </div>

              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="isbn" class="form-label text-light"
                    >ISBN (Autogenerado)</label
                  >
                  <input
                    type="text"
                    class="form-control bg-black text-secondary border-secondary"
                    id="isbn"
                    name="isbn"
                    value="${libro.isbn}"
                    placeholder="Se generará automáticamente"
                    readonly
                  />
                </div>
                <div class="col-md-6">
                  <label for="ejemplaresTotales" class="form-label text-light"
                    >Cantidad de Ejemplares</label
                  >
                  <input
                    type="number"
                    class="form-control bg-dark text-white border-secondary"
                    id="ejemplaresTotales"
                    name="ejemplaresTotales"
                    value="${libro.ejemplaresTotales != null ? libro.ejemplaresTotales : 1}"
                    min="1"
                    required
                  />
                </div>
              </div>

              <div class="mb-3">
                <label for="portada" class="form-label text-light"
                  >URL de la Portada</label
                >
                <input
                  type="url"
                  class="form-control bg-dark text-white border-secondary"
                  id="portada"
                  name="portada"
                  value="${libro.portada}"
                  placeholder="https://ejemplo.com/imagen.jpg"
                />
                <div class="form-text text-muted small">
                  Ingresa el enlace directo a una imagen (jpg, png).
                </div>
              </div>

              <div class="mb-3">
                <label for="sinopsis" class="form-label text-light"
                  >Sinopsis</label
                >
                <textarea
                  class="form-control bg-dark text-white border-secondary"
                  id="sinopsis"
                  name="sinopsis"
                  rows="4"
                  placeholder="Escribe un breve resumen del libro..."
                >
${libro.sinopsis}</textarea
                >
              </div>

              <input
                type="hidden"
                name="disponible"
                value="${libro.idLibro != null ? libro.disponible : true}"
              />

              <div
                class="d-flex justify-content-end gap-2 mt-4 border-top border-secondary pt-3"
              >
                <a href="libros" class="btn btn-outline-light"
                  ><i class="bi bi-x-circle me-1"></i>Cancelar</a
                >
                <button type="submit" class="btn btn-primary">
                  <i class="bi bi-save me-1"></i>Guardar Libro
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
