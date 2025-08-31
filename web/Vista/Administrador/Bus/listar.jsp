<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Administrar Buses</title>

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- DataTables -->
        <link href="https://cdn.datatables.net/2.0.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://cdn.datatables.net/2.0.7/js/dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/2.0.7/js/dataTables.bootstrap5.min.js"></script>

        <!-- Iconos -->
        <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/estilos.css">
    </head>
    <body>

        <div class="d-flex align-items-start">
            <!-- Sidebar -->
            <div class="nav flex-column p-3 col-2 d-flex justify-content-between min-vh-100 shadow" style="position: fixed;">
                <div>
                    <div class="d-flex justify-content-center align-items-center my-4">
                        <img src="https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg" 
                             class="rounded-circle" alt="..." width="100" height="100">
                    </div>
                    <div>
                        <h4 class="text-center">
                            <c:out value="${sessionScope.user.appat} ${sessionScope.user.apmat}, ${sessionScope.user.nombre}"/>
                        </h4>
                    </div>
                </div>
                <hr>
                <ul class="nav flex-column">
                    <li class="nav-item mb-3">
                        <a class="nav-link" href="${pageContext.request.contextPath}/BusServlet?action=listar"><i class='bx bxs-bus me-2'></i>Registrar Bus</a>
                    </li>
                    <li class="nav-item mb-3">
                        <a class="nav-link" href="${pageContext.request.contextPath}/ChoferServlet?action=listar"><i class='bx bxs-user-account me-2'></i>Registrar Choferes</a>
                    </li>
                    <li class="nav-item mb-3">
                        <a class="nav-link" href="${pageContext.request.contextPath}/viaje/listar.jsp"><i class='bx bxs-map me-2'></i>Programar Ruta</a>
                    </li>
                    <li class="nav-item mb-3">
                        <a class="nav-link" href="${pageContext.request.contextPath}/ClienteServlet?action=listar"><i class='bx bx-user me-2'></i>Registrar Cliente</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/pasaje/listar.jsp"><i class='bx bxs-coupon me-2'></i>Pasajes</a>
                    </li>
                </ul>
                <hr>
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/srvIniciarSesion?accion=cerrar" class="text-dark" style="text-decoration: none;">
                        <i class='bx bx-log-out me-2'></i>Cerrar Sesión
                    </a>
                </div>
            </div>

            <!-- Espaciador -->
            <div class="col-2"></div>

            <!-- Contenido -->
            <div class="col-10">
                <div class="row">
                    <div class="d-flex align-items-center justify-content-center p-2 flex-fill">
                        <img src="${pageContext.request.contextPath}/Imagenes/novas_logo.png" class="img-fluid me-3" alt="..." width="100px">
                        <h1 class="m-0">NOVA'S TRAVELS</h1>
                    </div>
                </div>

                <div class="container mt-4">
                    <h2 class="mb-4">Administrar Buses</h2>
                    <button type="button" class="btn btn-success mb-3" id="btnAgregar">➕ Nuevo Bus</button>
                    <div class="table-responsive">
                        <table id="tablaBuses" class="table table-striped table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Placa</th>
                                    <th>Capacidad</th>
                                    <th>Tipo</th>
                                    <th>Descripción</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="b" items="${buses}">
                                    <tr>
                                        <td>${b.idBus}</td>
                                        <td>${b.placa}</td>
                                        <td>${b.capacidadAsientos}</td>
                                        <td>${b.tipo}</td>
                                        <td>${b.descripcion}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${b.estado == 1}">Activo</c:when>
                                                <c:otherwise>Inactivo</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-warning btn-sm btnEditar"
                                                    data-id="${b.idBus}"
                                                    data-placa="${b.placa}"
                                                    data-capacidad="${b.capacidadAsientos}"
                                                    data-tipo="${b.tipo}"
                                                    data-descripcion="${b.descripcion}"
                                                    data-estado="${b.estado}">✏️ Editar</button>
                                            <a href="${pageContext.request.contextPath}/BusServlet?action=eliminar&id=${b.idBus}" class="btn btn-danger btn-sm"
                                               onclick="return confirm('¿Seguro que deseas eliminar este bus?');">🗑️ Eliminar</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Agregar / Editar Bus -->
        <div class="modal fade" id="modalBus" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Editar Bus</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formBus" method="post" action="${pageContext.request.contextPath}/BusServlet">
                            <input type="hidden" name="action" id="formAction" value="update">
                            <input type="hidden" name="idBus" id="editId">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Placa</label>
                                    <input type="text" class="form-control" name="placa" id="editPlaca" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Capacidad</label>
                                    <input type="number" class="form-control" name="capacidadAsientos" id="editCapacidad" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tipo</label>
                                    <input type="text" class="form-control" name="tipo" id="editTipo" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Descripción</label>
                                    <input type="text" class="form-control" name="descripcion" id="editDescripcion" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Estado</label>
                                    <select class="form-select" name="estado" id="editEstado" required>
                                        <option value="1">Activo</option>
                                        <option value="0">Inactivo</option>
                                    </select>
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="submit" class="btn btn-warning" id="btnSubmit">Guardar</button>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                   $(document).ready(function () {
                                                       // Inicializar DataTable con search en español
                                                       $('#tablaBuses').DataTable({
                                                           responsive: true,
                                                           language: {
                                                               search: "🔍 Buscar:",
                                                               lengthMenu: "Mostrar _MENU_ registros por página",
                                                               info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
                                                               paginate: {
                                                                   first: "Primero",
                                                                   last: "Último",
                                                                   next: "Siguiente",
                                                                   previous: "Anterior"
                                                               },
                                                               zeroRecords: "No se encontraron registros"
                                                           }
                                                       });

                                                       var modalBus = new bootstrap.Modal(document.getElementById('modalBus'));

                                                       // Botón Agregar
                                                       $('#btnAgregar').click(function () {
                                                           $('#modalTitle').text('Agregar Bus');
                                                           $('#formAction').val('add');
                                                           $('#formBus')[0].reset();
                                                           modalBus.show();
                                                       });

                                                       // Botón Editar
                                                       $('.btnEditar').click(function () {
                                                           $('#modalTitle').text('Editar Bus');
                                                           $('#formAction').val('update');
                                                           $('#editId').val($(this).data('id'));
                                                           $('#editPlaca').val($(this).data('placa'));
                                                           $('#editCapacidad').val($(this).data('capacidad'));
                                                           $('#editTipo').val($(this).data('tipo'));
                                                           $('#editDescripcion').val($(this).data('descripcion'));
                                                           $('#editEstado').val($(this).data('estado'));
                                                           modalBus.show();
                                                       });
                                                   });
        </script>
    </body>
</html>
