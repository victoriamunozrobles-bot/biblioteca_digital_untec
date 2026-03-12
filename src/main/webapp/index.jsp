<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es" data-bs-theme="dark">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Login - Biblioteca Digital</title>
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
  <body class="body-login">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-md-5 col-lg-4">
          <div class="card login-card p-4">
            <div class="text-center mb-4">
              <i
                class="bi bi-book-half text-accent"
                style="font-size: 3rem"
              ></i>
              <h3 class="mt-2 text-white">Biblioteca Digital</h3>
            </div>

            <ul
              class="nav nav-pills nav-fill mb-4 border-bottom border-secondary pb-3"
              id="pills-tab"
              role="tablist"
            >
              <li class="nav-item" role="presentation">
                <button
                  class="nav-link active bg-transparent text-light"
                  id="login-tab"
                  data-bs-toggle="pill"
                  data-bs-target="#login"
                  type="button"
                  role="tab"
                >
                  Iniciar Sesión
                </button>
              </li>
              <li class="nav-item" role="presentation">
                <button
                  class="nav-link bg-transparent text-muted"
                  id="registro-tab"
                  data-bs-toggle="pill"
                  data-bs-target="#registro"
                  type="button"
                  role="tab"
                >
                  Registrarse
                </button>
              </li>
            </ul>

            <div class="tab-content" id="pills-tabContent">
              <div class="tab-pane fade show active" id="login" role="tabpanel">
                <c:if test="${param.registro == 'exito'}">
                  <div class="alert alert-success py-2 small">
                    <i class="bi bi-check-circle me-1"></i>Registro exitoso.
                    Ahora puedes entrar.
                  </div>
                </c:if>
                <c:if test="${param.registro == 'error_admin'}">
                  <div class="alert alert-danger py-2 small">
                    <i class="bi bi-x-circle me-1"></i>Error: Contraseña de
                    autorización de Administrador incorrecta.
                  </div>
                </c:if>
                <form action="login" method="post">
                  <div class="mb-3">
                    <input
                      type="email"
                      class="form-control bg-dark text-white border-secondary"
                      name="email"
                      required
                      placeholder="tu@email.com"
                    />
                  </div>
                  <div class="mb-4">
                    <input
                      type="password"
                      class="form-control bg-dark text-white border-secondary"
                      name="password"
                      required
                      placeholder="Contraseña"
                    />
                  </div>
                  <button type="submit" class="btn btn-primary w-100">
                    Entrar
                  </button>
                </form>
              </div>

              <div class="tab-pane fade" id="registro" role="tabpanel">
                <form action="registro" method="post">
                  <div class="mb-3">
                    <select
                      class="form-select bg-dark text-accent border-secondary fw-bold"
                      name="rol"
                      id="selectRol"
                      required
                      onchange="toggleFormFields()"
                    >
                      <option value="USUARIO" selected>
                        Soy Usuario / Estudiante
                      </option>
                      <option value="ADMIN">Soy Administrador</option>
                    </select>
                  </div>

                  <div class="row g-2 mb-2">
                    <div class="col-6">
                      <input
                        type="text"
                        class="form-control bg-dark text-white border-secondary"
                        name="nombre"
                        placeholder="Nombre"
                        required
                      />
                    </div>
                    <div class="col-6">
                      <input
                        type="text"
                        class="form-control bg-dark text-white border-secondary"
                        name="apellido"
                        placeholder="Apellido"
                        required
                      />
                    </div>
                  </div>

                  <div class="mb-2">
                    <input
                      type="email"
                      class="form-control bg-dark text-white border-secondary"
                      name="email"
                      placeholder="Correo electrónico"
                      required
                    />
                  </div>

                  <div class="mb-2" id="divCarrera">
                    <input
                      type="text"
                      class="form-control bg-dark text-white border-secondary"
                      name="carrera"
                      id="inputCarrera"
                      placeholder="Carrera que estudias"
                      required
                    />
                  </div>

                  <div class="mb-2 d-none" id="divCargo">
                    <input
                      type="text"
                      class="form-control bg-dark text-white border-secondary"
                      name="cargo"
                      id="inputCargo"
                      placeholder="Cargo que ocupas en la biblioteca"
                    />
                  </div>

                  <div class="mb-2">
                    <input
                      type="password"
                      class="form-control bg-dark text-white border-secondary"
                      name="password"
                      placeholder="Crea una contraseña"
                      required
                    />
                  </div>

                  <div class="mb-4 d-none" id="divAdminAuth">
                    <input
                      type="password"
                      class="form-control bg-dark border-danger text-white placeholder-glow"
                      name="adminPassword"
                      id="adminPassword"
                      placeholder="Clave de autorización Admin (ej: admin123)"
                    />
                  </div>

                  <button type="submit" class="btn btn-outline-accent w-100">
                    Crear Cuenta
                  </button>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      function toggleFormFields() {
        const rol = document.getElementById("selectRol").value;

        const divCarrera = document.getElementById("divCarrera");
        const inputCarrera = document.getElementById("inputCarrera");

        const divCargo = document.getElementById("divCargo");
        const inputCargo = document.getElementById("inputCargo");

        const divAuth = document.getElementById("divAdminAuth");
        const inputAuth = document.getElementById("adminPassword");

        if (rol === "ADMIN") {
          divCarrera.classList.add("d-none");
          inputCarrera.removeAttribute("required");
          inputCarrera.value = ""; 

          divCargo.classList.remove("d-none");
          inputCargo.setAttribute("required", "required");

          divAuth.classList.remove("d-none");
          inputAuth.setAttribute("required", "required");
        } else {
          divCarrera.classList.remove("d-none");
          inputCarrera.setAttribute("required", "required");

          divCargo.classList.add("d-none");
          inputCargo.removeAttribute("required");
          inputCargo.value = "";

          divAuth.classList.add("d-none");
          inputAuth.removeAttribute("required");
          inputAuth.value = "";
        }
      }
    </script>
  </body>
</html>
