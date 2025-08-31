<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Administrar Rutas</title>

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
                    <h2 class="mb-4">Administrar Rutas</h2>
                    <button type="button" class="btn btn-success mb-3" id="btnAgregar">➕ Nueva Ruta</button>
                    <div class="table-responsive">
                        <table id="tablaRutas" class="table table-striped table-bordered align-middle">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Bus</th>
                                    <th>Chofer</th>
                                    <th>Origen</th>
                                    <th>Destino</th>
                                    <th>Fecha Salida</th>
                                    <th>Hora Salida</th>
                                    <th>Fecha Llegada</th>
                                    <th>Hora Llegada</th>
                                    <th>Precio</th>
                                    <th>Boletos Restantes</th>
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="r" items="${listaRutas}">
                                    <tr>
                                        <td>${r.idViaje}</td>
                                        <td>${r.bus.placa}</td>
                                        <td>${r.chofer.nombre} ${r.chofer.apellido}</td>
                                        <td>
                                            <c:forEach var="lugar" items="${listaLugares}">
                                                <c:if test="${lugar.idLugar == r.origen}">
                                                    ${lugar.nombre}
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td>
                                            <c:forEach var="des" items="${listaLugares}">
                                                <c:if test="${des.idLugar == r.destino}">
                                                    ${des.nombre}
                                                </c:if>
                                            </c:forEach>
                                        </td>
                                        <td>${r.fechaSalida}</td>
                                        <td>${r.horaSalida}</td>
                                        <td>${r.fechaLlegada}</td>
                                        <td>${r.horaLlegada}</td>
                                        <td>S/ ${r.precio}</td>
                                        <td>${r.boletosRestantes}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${r.estado == 1}">
                                                    <span style="color:green;">●</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="color:red;">●</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <button type="button" class="btn btn-warning btn-sm btnEditar"
                                                    data-id="${r.idViaje}"
                                                    data-idbus="${r.bus.idBus}"
                                                    data-idchofer="${r.chofer.id}"
                                                    data-origen="${r.origen}"
                                                    data-destino="${r.destino}"
                                                    data-fechasalida="${r.fechaSalida}"
                                                    data-horasalida="${r.horaSalida}"
                                                    data-fechallegada="${r.fechaLlegada}"
                                                    data-horallegada="${r.horaLlegada}"
                                                    data-precio="${r.precio}"
                                                    data-boletos="${r.boletosRestantes}"
                                                    data-estado="${r.estado}">✏️ Editar</button>
                                            <a href="${pageContext.request.contextPath}/RutaServlet?accion=eliminar&id=${r.idViaje}" class="btn btn-danger btn-sm"
                                               onclick="return confirm('¿Está seguro que desea eliminar esta ruta?');">🗑️ Eliminar</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal Agregar / Editar Ruta -->
        <div class="modal fade" id="modalRuta" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalTitle">Editar Ruta</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <form id="formRuta" method="post" action="${pageContext.request.contextPath}/RutaServlet">
                            <!-- Mantengo el mismo patrón que usas en Rutas: 'accion' con 'nuevo'/'editar' -->
                            <input type="hidden" name="accion" id="formAccion" value="editar">
                            <input type="hidden" name="idViaje" id="editId">

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Bus</label>
                                    <select class="form-select" name="idBus" id="editBus" required>
                                        <option value="">-- Seleccionar Bus --</option>
                                        <c:forEach var="b" items="${listaBuses}">
                                            <option value="${b.idBus}">${b.placa}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Chofer</label>
                                    <select class="form-select" name="idChofer" id="editChofer" required>
                                        <option value="">-- Seleccionar Chofer --</option>
                                        <c:forEach var="c" items="${listaChoferes}">
                                            <option value="${c.id}">${c.nombre} ${c.appat}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Origen</label>
                                    <select class="form-select" name="origen" id="editOrigen" required>
                                        <option value="">-- Seleccionar Origen --</option>
                                        <c:forEach var="l" items="${listaLugares}">
                                            <option value="${l.idLugar}">${l.nombre}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Destino</label>
                                    <select class="form-select" name="destino" id="editDestino" required>
                                        <option value="">-- Seleccionar Destino --</option>
                                        <c:forEach var="l2" items="${listaLugares}">
                                            <option value="${l2.idLugar}">${l2.nombre}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Fecha Salida</label>
                                    <input type="date" class="form-control" name="fechaSalida" id="editFechaSalida" required>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Hora Salida</label>
                                    <input type="time" class="form-control" name="horaSalida" id="editHoraSalida" required>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Fecha Llegada</label>
                                    <input type="date" class="form-control" name="fechaLlegada" id="editFechaLlegada" required>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <label class="form-label">Hora Llegada</label>
                                    <input type="time" class="form-control" name="horaLlegada" id="editHoraLlegada" required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Precio (S/)</label>
                                    <input type="number" step="0.01" class="form-control" name="precio" id="editPrecio" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Boletos Restantes</label>
                                    <input type="number" class="form-control" name="boletosRestantes" id="editBoletos" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Estado</label>
                                    <select class="form-select" name="estado" id="editEstadoRuta" required>
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
                                                       // DataTables (con barra horizontal para que no desconfigure)
                                                       $('#tablaRutas').DataTable({
                                                           responsive: true,
                                                           scrollX: true,
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

                                                       var modalRuta = new bootstrap.Modal(document.getElementById('modalRuta'));

                                                       // Botón Agregar
                                                       $('#btnAgregar').click(function () {
                                                           $('#modalTitle').text('Agregar Ruta');
                                                           $('#formAccion').val('nuevo');       // <-- mantiene tu convención de 'accion=nuevo'
                                                           $('#formRuta')[0].reset();
                                                           $('#editId').val('');
                                                           modalRuta.show();
                                                       });

                                                       // Botón Editar
                                                       $('.btnEditar').click(function () {
                                                           $('#modalTitle').text('Editar Ruta');
                                                           $('#formAccion').val('editar');      // <-- mantiene tu convención de 'accion=editar'

                                                           $('#editId').val($(this).attr('data-id'));
                                                           $('#editBus').val($(this).attr('data-idbus'));
                                                           $('#editChofer').val($(this).attr('data-idchofer'));
                                                           $('#editOrigen').val($(this).attr('data-origen'));
                                                           $('#editDestino').val($(this).attr('data-destino'));
                                                           $('#editFechaSalida').val($(this).attr('data-fechasalida'));
                                                           $('#editHoraSalida').val($(this).attr('data-horasalida'));
                                                           $('#editFechaLlegada').val($(this).attr('data-fechallegada'));
                                                           $('#editHoraLlegada').val($(this).attr('data-horallegada'));
                                                           $('#editPrecio').val($(this).attr('data-precio'));
                                                           $('#editBoletos').val($(this).attr('data-boletos'));
                                                           $('#editEstadoRuta').val($(this).attr('data-estado'));

                                                           modalRuta.show();
                                                       });
                                                   });
        </script>
    </body>
</html>
