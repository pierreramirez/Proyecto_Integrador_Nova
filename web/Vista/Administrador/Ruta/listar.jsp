<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<jsp:include page="/Vista/componentes/header.jsp" />
<jsp:include page="/Vista/componentes/menu.jsp" />

<!-- Agrego CSS específico para Buttons -->
<link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.3.6/css/buttons.bootstrap5.min.css"/>

<!-- CONTENIDO: Programar Rutas (misma apariencia que Administrar Buses, con modal pequeño para agregar/editar) -->
<div class="container-fluid" style="margin-top:18px;">
    <div class="card m-3 p-3">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="mb-0">Programar Rutas</h2>
            <div>
                <!-- Botón agregar -->
                <a id="btnAgregarRuta" class="btn btn-success" href="#" data-url="${pageContext.request.contextPath}/RutaServlet?action=agregar">➕ Nueva Ruta</a>
                <!-- Los botones de export se generan por DataTables, pero dejamos un small placeholder si quieres estilos extra -->
            </div>
        </div>

        <div class="table-responsive">
            <table id="tablaRutas" class="table table-striped table-bordered" style="width:100%;">
                <thead class="table-dark">
                    <tr>
                        <th style="width:60px;">ID</th>
                        <th>Bus (ID)</th>
                        <th>Chofer (ID)</th>
                        <th>Origen</th>
                        <th>Destino</th>
                        <th>Fecha / Hora</th>
                        <th>Precio</th>
                        <th>Boletos</th>
                        <th style="width:160px;">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${lista}">
                        <tr>
                            <td>${r.idViaje}</td>
                            <td>${r.idBus}</td>
                            <td>${r.idChofer}</td>
                            <td>${r.origen}</td>
                            <td>${r.destino}</td>
                            <td>${r.fechaSalida} ${r.horaSalida}</td>
                            <td>S/ ${r.precio}</td>
                            <td>${r.boletosRestantes}</td>
                            <td>
                                <!-- Editar abre modal pequeño -->
                                <button type="button"
                                        class="btn btn-warning btn-sm btnEditarRuta"
                                        data-id="${r.idViaje}"
                                        data-url-base="${pageContext.request.contextPath}/RutaServlet?action=editar&id=">
                                    ✏️ Editar
                                </button>

                                <a href="${pageContext.request.contextPath}/RutaServlet?action=eliminar&id=${r.idViaje}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('¿Eliminar ruta ${r.idViaje}?');">🗑️ Eliminar</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal pequeño (centrado) con iframe -->
<div class="modal fade" id="modalRutaForm" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document" style="max-width:760px;">
        <div class="modal-content">
            <div class="modal-header">
                <h5 id="modalRutaTitle" class="modal-title">Formulario Ruta</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>
            <div class="modal-body" style="height:60vh; padding:0;">
                <iframe id="modalRutaFrame" src="" frameborder="0" style="width:100%; height:100%;"></iframe>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/Vista/componentes/footer.jsp" />

<!-- Scripts (mismos CDN y DataTables) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- DataTables Buttons + dependencias para export (Excel/PDF) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/pdfmake@0.2.7/build/pdfmake.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/pdfmake@0.2.7/build/vfs_fonts.js"></script>

<script src="https://cdn.datatables.net/buttons/2.3.6/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.html5.min.js"></script>

<script>
                                       $(document).ready(function () {
                                           // Inicializar DataTable con Buttons (Excel / PDF)
                                           var table = $('#tablaRutas').DataTable({
                                               dom: "Bfrtip", // muestra Buttons
                                               buttons: [
                                                   {
                                                       extend: 'excelHtml5',
                                                       text: '📥 Excel',
                                                       className: 'btn btn-outline-success btn-sm',
                                                       filename: function () {
                                                           var d = new Date();
                                                           return 'Rutas_' + d.toISOString().slice(0, 10);
                                                       },
                                                       title: null,
                                                       exportOptions: {
                                                           columns: ':not(:last-child)' // excluir la columna Acciones
                                                       }
                                                   },
                                                   {
                                                       extend: 'pdfHtml5',
                                                       text: '📄 PDF',
                                                       className: 'btn btn-outline-danger btn-sm',
                                                       filename: function () {
                                                           var d = new Date();
                                                           return 'Rutas_' + d.toISOString().slice(0, 10);
                                                       },
                                                       title: 'Listado de Rutas',
                                                       orientation: 'landscape',
                                                       pageSize: 'A4',
                                                       exportOptions: {
                                                           columns: ':not(:last-child)'
                                                       },
                                                       customize: function (doc) {
                                                           // reducir tamaño de fuente en PDF si la tabla es ancha
                                                           doc.defaultStyle.fontSize = 8;
                                                           // centrar título
                                                           if (doc.content && doc.content[0]) {
                                                               doc.content[0].alignment = 'center';
                                                           }
                                                       }
                                                   }
                                               ],
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

                                           // Modal bootstrap instance
                                           var modalEl = document.getElementById('modalRutaForm');
                                           var bsModal = new bootstrap.Modal(modalEl);

                                           // Exponer para que el iframe pueda llamarlo
                                           window.bsModal = bsModal;
                                           window.closeRouteModalAndReload = function (reloadParent = true) {
                                               try {
                                                   window.bsModal.hide();
                                               } catch (e) { /* noop */
                                               }
                                               if (reloadParent) {
                                                   window.location.reload();
                                           }
                                           };

                                           // Abrir modal para Agregar
                                           $('#btnAgregarRuta').on('click', function (e) {
                                               e.preventDefault();
                                               var url = $(this).data('url');
                                               $('#modalRutaTitle').text('Agregar Ruta');
                                               $('#modalRutaFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Abrir modal para Editar (delegación)
                                           $(document).on('click', '.btnEditarRuta', function () {
                                               var base = $(this).data('url-base');
                                               var id = $(this).data('id');
                                               var url = base + id;
                                               $('#modalRutaTitle').text('Editar Ruta #' + id);
                                               $('#modalRutaFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           // Limpiar iframe al cerrar
                                           $('#modalRutaForm').on('hidden.bs.modal', function () {
                                               $('#modalRutaFrame').attr('src', '');
                                           });
                                       });
</script>
