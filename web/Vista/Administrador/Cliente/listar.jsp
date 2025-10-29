<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/Vista/componentes/header.jsp" />
<jsp:include page="/Vista/componentes/menu.jsp" />

<div class="container-fluid">
    <div class="card m-3 p-3">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="mb-0">Administrar Clientes</h2>
            <button type="button" id="btnAgregarCliente" class="btn btn-success">➕ Nuevo Cliente</button>
        </div>

        <div class="table-responsive">
            <table id="tablaClientes" class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Apellido Paterno</th>
                        <th>Apellido Materno</th>
                        <th>Nombre</th>
                        <th>DNI</th>
                        <th>Fecha Nacimiento</th>
                        <th>Teléfono</th>
                        <th>Género</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${clientes}">
                        <tr>
                            <td>${c.id}</td>
                            <td>${c.appat}</td>
                            <td>${c.apmat}</td>
                            <td>${c.nombre}</td>
                            <td>${c.dni}</td>
                            <td>${c.fechaNacimiento}</td>
                            <td>${c.telefono}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.genero == 'M'}">Masculino</c:when>
                                    <c:when test="${c.genero == 'F'}">Femenino</c:when>
                                    <c:otherwise>Otro</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button type="button" class="btn btn-warning btn-sm btnEditarCliente" data-id="${c.id}">✏</button>
                                <a href="${pageContext.request.contextPath}/ClienteServlet?action=eliminar&id=${c.id}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('¿Seguro que deseas eliminar este cliente?');">🗑</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal: cargamos agregar/editar mediante iframe -->
<div class="modal fade" id="modalClienteForm" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl" style="max-width:1000px;">
        <div class="modal-content">
            <div class="modal-header">
                <h5 id="modalClienteTitle" class="modal-title">Formulario Cliente</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="height:80vh; padding:0;">
                <iframe id="modalClienteFrame" src="" frameborder="0" style="width:100%; height:100%;"></iframe>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/Vista/componentes/footer.jsp" />

<!-- Scripts al final -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
                                       $(document).ready(function () {
                                           $('#tablaClientes').DataTable({
                                               responsive: true,
                                               scrollY: '50vh',
                                               scrollCollapse: true,
                                               paging: true,
                                               pageLength: 10,
                                               lengthMenu: [10, 25, 50],
                                               language: {
                                                   search: "🔍 Buscar:",
                                                   lengthMenu: "Mostrar _MENU_ registros por página",
                                                   info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
                                                   paginate: {first: "Primero", last: "Último", next: "Siguiente", previous: "Anterior"},
                                                   zeroRecords: "No se encontraron registros"
                                               }
                                           });

                                           var modalEl = document.getElementById('modalClienteForm');
                                           var bsModal = new bootstrap.Modal(modalEl);

                                           // Abrir agregar
                                           $('#btnAgregarCliente').on('click', function () {
                                               var url = '${pageContext.request.contextPath}/ClienteServlet?action=agregar';
                                               $('#modalClienteTitle').text('Agregar Cliente');
                                               $('#modalClienteFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Abrir editar
                                           $(document).on('click', '.btnEditarCliente', function () {
                                               var id = $(this).data('id');
                                               var url = '${pageContext.request.contextPath}/ClienteServlet?action=editar&id=' + id;
                                               $('#modalClienteTitle').text('Editar Cliente #' + id);
                                               $('#modalClienteFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Limpiar iframe cuando se cierre el modal
                                           $('#modalClienteForm').on('hidden.bs.modal', function () {
                                               $('#modalClienteFrame').attr('src', '');
                                           });

                                           // Escuchar mensajes desde iframe/servlet para actualizar la lista
                                           window.addEventListener('message', function (e) {
                                               if (e.data && e.data.type === 'cliente-updated') {
                                                   try {
                                                       var modalInst = bootstrap.Modal.getInstance(modalEl);
                                                       if (modalInst)
                                                           modalInst.hide();
                                                   } catch (err) {
                                                   }
                                                   location.reload();
                                               }
                                           }, false);
                                       });
</script>
