<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/Vista/componentes/header.jsp" />
<jsp:include page="/Vista/componentes/menu.jsp" />

<div class="container-fluid">
    <div class="card m-3 p-3">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="mb-0">Administrar Buses</h2>
            <button type="button" id="btnAgregarBus" class="btn btn-success">➕ Nuevo Bus</button>
        </div>

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
                                <button type="button" class="btn btn-warning btn-sm btnEditarBus" data-id="${b.idBus}">✏️ Editar</button>
                                <a href="${pageContext.request.contextPath}/BusServlet?action=eliminar&id=${b.idBus}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('¿Seguro que deseas eliminar este bus?');">🗑️ Eliminar</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal con IFRAME para cargar agregar.jsp / editar.jsp -->
<div class="modal fade" id="modalBusForm" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl" style="max-width:1000px;">
        <div class="modal-content">
            <div class="modal-header">
                <h5 id="modalBusTitle" class="modal-title">Formulario Bus</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="height:80vh; padding:0;">
                <iframe id="modalBusFrame" src="" frameborder="0" style="width:100%; height:100%;"></iframe>
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
                                           var table = $('#tablaBuses').DataTable({
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

                                           var modalEl = document.getElementById('modalBusForm');
                                           var bsModal = new bootstrap.Modal(modalEl);

                                           // Abrir agregar
                                           $('#btnAgregarBus').on('click', function () {
                                               var url = '${pageContext.request.contextPath}/BusServlet?action=agregar';
                                               $('#modalBusTitle').text('Agregar Bus');
                                               $('#modalBusFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Abrir editar (delegación)
                                           $(document).on('click', '.btnEditarBus', function () {
                                               var id = $(this).data('id');
                                               var url = '${pageContext.request.contextPath}/BusServlet?action=editar&id=' + id;
                                               $('#modalBusTitle').text('Editar Bus #' + id);
                                               $('#modalBusFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Limpiar iframe al cerrar
                                           $('#modalBusForm').on('hidden.bs.modal', function () {
                                               $('#modalBusFrame').attr('src', '');
                                           });

                                           // Nota: si quieres que al enviar el form dentro del iframe se recargue la lista,
                                           // pon target="_parent" en los <form> de agregar.jsp y editar.jsp
                                       });
</script>
