<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Administrar Choferes</title>

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
            <div class="nav flex-column p-3 col-2 d-flex justify-content-between min-vh-100 shadow" 
                 style="position: fixed;">
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
                    <h2 class="mb-4">Administrar Choferes</h2>
                    <button type="button" class="btn btn-success mb-3" id="btnAgregar">➕ Nuevo Chofer</button>
                    <div class="table-responsive">
                        <table id="tablaChoferes" class="table table-striped table-bordered">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Apellido Paterno</th>
                                    <th>Apellido Materno</th>
                                    <th>Nombre</th>
                                    <th>DNI</th>
                                    <th>Licencia</th>
                                    <th>Fecha Contratación</th>
                                    <th>Fecha Vencimiento Licencia</th>
                                    <th>Teléfono</th>
                                    <th>Disponibilidad</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="c" items="${choferes}">
                                    <tr>
                                        <td>${c.id}</td>
                                        <td>${c.appat}</td>
                                        <td>${c.apmat}</td>
                                        <td>${c.nombre}</td>
                                        <td>${c.dni}</td>
                                        <td>${c.licenciaConducir}</td>
                                        <td>${c.fechaContratacion}</td>
                                        <td>${c.fechaVencimientoLicencia}</td>
                                        <td>${c.telefono}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.disponibilidad == 1}">
                                                    <span style="color:green;">●</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color:red;">●</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${c.estado == 1}">Activo</c:when>
                                                <c:otherwise>Inactivo</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-warning btn-sm btnEditar"
                                                    data-id="${c.id}"
                                                    data-appat="${c.appat}"
                                                    data-apmat="${c.apmat}"
                                                    data-nombre="${c.nombre}"
                                                    data-dni="${c.dni}"
                                                    data-licencia="${c.licenciaConducir}"
                                                    data-fechacon="${c.fechaContratacion}"
                                                    data-fechaven="${c.fechaVencimientoLicencia}"
                                                    data-telefono="${c.telefono}"
                                                    data-disponibilidad="${c.disponibilidad}"
                                                    data-estado="${c.estado}">✏️ Editar</button>
                                            <a href="${pageContext.request.contextPath}/ChoferServlet?action=eliminar&id=${c.id}" class="btn btn-danger btn-sm"
                                               onclick="return confirm('¿Seguro que deseas eliminar este chofer?');">🗑️ Eliminar</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Agregar / Editar Chofer -->
        <div class="modal fade" id="modalChofer" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Editar Chofer</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formChofer" method="post" action="${pageContext.request.contextPath}/ChoferServlet">
                            <input type="hidden" name="action" id="formAction" value="update">
                            <input type="hidden" name="idChofer" id="editId">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Apellido Paterno</label>
                                    <input type="text" class="form-control" name="appat" id="editAppat" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Apellido Materno</label>
                                    <input type="text" class="form-control" name="apmat" id="editApmat" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Nombre</label>
                                    <input type="text" class="form-control" name="nombre" id="editNombre" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">DNI</label>
                                    <input type="number" class="form-control" name="dni" id="editDni" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Licencia Conducir</label>
                                    <input type="text" class="form-control" name="licenciaConducir" id="editLicencia" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Teléfono</label>
                                    <input type="number" class="form-control" name="telefono" id="editTelefono" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Fecha Contratación</label>
                                    <input type="date" class="form-control" name="fechaContratacion" id="editFechaCon" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Fecha Vencimiento Licencia</label>
                                    <input type="date" class="form-control" name="fechaVencimientoLicencia" id="editFechaVen" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Disponibilidad</label>
                                    <select class="form-select" name="disponibilidad" id="editDisponibilidad" required>
                                        <option value="1">Disponible</option>
                                        <option value="0">No Disponible</option>
                                    </select>
                                </div>
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
                                                       $('#tablaChoferes').DataTable({
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
                                                           }});

                                                       var modalChofer = new bootstrap.Modal(document.getElementById('modalChofer'));

                                                       // Botón Agregar
                                                       $('#btnAgregar').click(function () {
                                                           $('#modalTitle').text('Agregar Chofer');
                                                           $('#formAction').val('add');
                                                           $('#formChofer')[0].reset();
                                                           modalChofer.show();
                                                       });

                                                       // Botón Editar
                                                       $('.btnEditar').click(function () {
                                                           $('#modalTitle').text('Editar Chofer');
                                                           $('#formAction').val('update');
                                                           $('#editId').val($(this).data('id'));
                                                           $('#editAppat').val($(this).data('appat'));
                                                           $('#editApmat').val($(this).data('apmat'));
                                                           $('#editNombre').val($(this).data('nombre'));
                                                           $('#editDni').val($(this).data('dni'));
                                                           $('#editLicencia').val($(this).data('licencia'));
                                                           $('#editTelefono').val($(this).data('telefono'));
                                                           $('#editFechaCon').val($(this).data('fechacon'));
                                                           $('#editFechaVen').val($(this).data('fechaven'));
                                                           $('#editDisponibilidad').val($(this).data('disponibilidad'));
                                                           $('#editEstado').val($(this).data('estado'));
                                                           modalChofer.show();
                                                       });
                                                   });
        </script>

    </body>
</html>
