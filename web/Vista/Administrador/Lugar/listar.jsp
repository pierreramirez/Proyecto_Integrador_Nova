<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, Modelo.DTOLugar" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/Vista/componentes/header.jsp" />
<jsp:include page="/Vista/componentes/menu.jsp" />

<%
    List<DTOLugar> lugares = (List<DTOLugar>) request.getAttribute("lugares");
%>

<div class="container-fluid">
    <div class="card m-3 p-3">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="mb-0">Administrar Lugares</h2>
            <button type="button" id="btnAgregarLugar" class="btn btn-success">➕ Nuevo Lugar</button>
        </div>

        <div class="table-responsive">
            <table id="tablaLugares" class="table table-striped table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nombre</th>
                        <th>Tipo</th>
                        <th>Descripción</th>
                        <th>Estado</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="l" items="${lugares}">
                    <tr>
                        <td>${l.idLugar}</td>
                        <td>${l.nombre}</td>
                        <td>${l.tipo}</td>
                        <td>${l.descripcion}</td>
                        <td>
                    <c:choose>
                        <c:when test="${l.estado == 1}">Activo</c:when>
                        <c:otherwise>Inactivo</c:otherwise>
                    </c:choose>
                    </td>
                    <td>
                        <button type="button" class="btn btn-warning btn-sm btnEditarLugar" data-id="${l.idLugar}">✏</button>
                        <a href="${pageContext.request.contextPath}/LugarServlet?action=eliminar&id=${l.idLugar}"
                           class="btn btn-danger btn-sm"
                           onclick="return confirm('¿Seguro que deseas eliminar este lugar?');">🗑</a>
                    </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal con IFRAME -->
<div class="modal fade" id="modalLugarForm" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl" style="max-width:1000px;">
        <div class="modal-content">
            <div class="modal-header">
                <h5 id="modalLugarTitle" class="modal-title">Formulario Lugar</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="height:60vh; padding:0;">
                <iframe id="modalLugarFrame" src="" frameborder="0" style="width:100%; height:100%;"></iframe>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/Vista/componentes/footer.jsp" />

<!-- Scripts -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
                                       $(document).ready(function () {
                                           var table = $('#tablaLugares').DataTable({
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

                                           var modalEl = document.getElementById('modalLugarForm');
                                           var bsModal = new bootstrap.Modal(modalEl);

                                           // Abrir agregar
                                           $('#btnAgregarLugar').on('click', function () {
                                               var url = '${pageContext.request.contextPath}/LugarServlet?action=agregar';
                                               $('#modalLugarTitle').text('Agregar Lugar');
                                               $('#modalLugarFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Abrir editar (delegación)
                                           $(document).on('click', '.btnEditarLugar', function () {
                                               var id = $(this).data('id');
                                               var url = '${pageContext.request.contextPath}/LugarServlet?action=editar&id=' + id;
                                               $('#modalLugarTitle').text('Editar Lugar #' + id);
                                               $('#modalLugarFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Limpiar iframe al cerrar
                                           $('#modalLugarForm').on('hidden.bs.modal', function () {
                                               $('#modalLugarFrame').attr('src', '');
                                           });

                                           // Escuchar postMessage opcional (si usas parent.postMessage)
                                           window.addEventListener('message', function (e) {
                                               if (e.data && e.data.type === 'lugar-updated') {
                                                   location.reload();
                                               }
                                           }, false);
                                       });
</script>
