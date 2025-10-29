<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, Modelo.DTOViaje" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/Vista/componentes/header.jsp" />
<jsp:include page="/Vista/componentes/menu.jsp" />

<%
    List<DTOViaje> viajes = (List<DTOViaje>) request.getAttribute("viajes");
%>

<div class="container-fluid">
    <div class="card m-3 p-3">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="mb-0">Administrar Viajes</h2>
            <button type="button" id="btnAgregarViaje" class="btn btn-success">➕ Programar Viaje</button>
        </div>

        <div class="table-responsive">
            <table id="tablaViajes" class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Bus (id)</th>
                        <th>Chofer (id)</th>
                        <th>Origen (id)</th>
                        <th>Destino (id)</th>
                        <th>Fecha</th>
                        <th>Hora</th>
                        <th>Duración (min)</th>
                        <th>Precio</th>
                        <th>Asientos disp.</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="v" items="${viajes}">
                        <tr>
                            <td>${v.idViaje}</td>
                            <td>${v.idBus}</td>
                            <td>${v.idChofer}</td>
                            <td>${v.origen_id}</td>
                            <td>${v.destino_id}</td>
                            <td>${v.fechaSalida}</td>
                            <td>${v.horaSalida}</td>
                            <td><c:out value="${v.duracionMin}" default="-" /></td>
                            <td>S/ ${v.precio}</td>
                            <td><c:out value="${v.disponibles}" default="0" /></td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.estado == 1}">Activo</c:when>
                                    <c:when test="${v.estado == 0}">Inactivo</c:when>
                                    <c:otherwise>Otro</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button type="button" class="btn btn-warning btn-sm btnEditarViaje" data-id="${v.idViaje}">✏</button>
                                <a href="${pageContext.request.contextPath}/ViajeServlet?action=eliminar&id=${v.idViaje}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('¿Seguro que deseas eliminar este viaje?');">🗑</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal con IFRAME -->
<div class="modal fade" id="modalViajeForm" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl" style="max-width:1000px;">
        <div class="modal-content">
            <div class="modal-header">
                <h5 id="modalViajeTitle" class="modal-title">Formulario Viaje</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="height:60vh; padding:0;">
                <iframe id="modalViajeFrame" src="" frameborder="0" style="width:100%; height:100%;"></iframe>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/Vista/componentes/footer.jsp" />

<!-- Scripts -->
<!-- Si ya incluyes jQuery/Datatables/Bootstrap en header/footer, quita duplicados -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
                                       $(document).ready(function () {
                                           var table = $('#tablaViajes').DataTable({
                                               responsive: true,
                                               scrollY: '55vh',
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

                                           var modalEl = document.getElementById('modalViajeForm');
                                           var bsModal = new bootstrap.Modal(modalEl);

                                           // Abrir agregar (carga la vista ligera de agregar.jsp dentro del iframe)
                                           $('#btnAgregarViaje').on('click', function () {
                                               var url = '${pageContext.request.contextPath}/ViajeServlet?action=agregar';
                                               $('#modalViajeTitle').text('Programar Nuevo Viaje');
                                               $('#modalViajeFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Abrir editar (delegación)
                                           $(document).on('click', '.btnEditarViaje', function () {
                                               var id = $(this).data('id');
                                               var url = '${pageContext.request.contextPath}/ViajeServlet?action=editar&id=' + id;
                                               $('#modalViajeTitle').text('Editar Viaje #' + id);
                                               $('#modalViajeFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Limpiar iframe al cerrar
                                           $('#modalViajeForm').on('hidden.bs.modal', function () {
                                               $('#modalViajeFrame').attr('src', '');
                                           });

                                           // Escuchar postMessage opcional (si usas parent.postMessage en el servlet para notificar)
                                           window.addEventListener('message', function (e) {
                                               if (e.data && e.data.type === 'viaje-updated') {
                                                   location.reload();
                                               }
                                           }, false);
                                       });
</script>
