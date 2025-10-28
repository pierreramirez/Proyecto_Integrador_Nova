<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- includes: header y menu (fragmentos sin directivas 'page') -->
<jsp:include page="/Vista/componentes/header.jsp" />
<jsp:include page="/Vista/componentes/menu.jsp" />

<!-- CONTENIDO: Listar Choferes -->
<div class="container-fluid" style="margin-top:18px;">
    <div class="card m-3 p-3">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2 class="mb-0">Administrar Choferes</h2>
            <button type="button" id="btnAgregar" class="btn btn-success">➕ Nuevo Chofer</button>
        </div>

        <div class="table-responsive">
            <table id="tablaChoferes" class="table table-striped table-bordered" style="width:100%;">
                <thead class="table-dark">
                    <tr>
                        <th style="width:60px;">ID</th>
                        <th style="width:160px;"><span class="th-wrap">Apellido<br>Paterno</span></th>
                        <th style="width:160px;"><span class="th-wrap">Apellido<br>Materno</span></th>
                        <th style="width:140px;"><span class="th-wrap">Nombre</span></th>
                        <th style="width:110px;"><span class="th-wrap">DNI</span></th>
                        <th style="width:130px;"><span class="th-wrap">Licencia</span></th>
                        <th style="width:130px;"><span class="th-wrap">Fecha de<br>Contratación</span></th>
                        <th style="width:130px;"><span class="th-wrap">Fecha Venc.<br>Licencia</span></th>
                        <th style="width:120px;"><span class="th-wrap">Teléfono</span></th>
                        <th style="width:120px;"><span class="th-wrap">Disponibilidad</span></th>
                        <th style="width:100px;"><span class="th-wrap">Estado</span></th>
                        <th style="width:120px;"><span class="th-wrap">Acciones</span></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${choferes}">
                        <tr>
                            <td class="ellipsisCell text-center">${c.id}</td>
                            <td class="ellipsisCell">${c.appat}</td>
                            <td class="ellipsisCell">${c.apmat}</td>
                            <td class="ellipsisCell">${c.nombre}</td>
                            <td class="ellipsisCell text-center">${c.dni}</td>
                            <td class="ellipsisCell">${c.licenciaConducir}</td>
                            <td class="ellipsisCell">${c.fechaContratacion}</td>
                            <td class="ellipsisCell">${c.fechaVencimientoLicencia}</td>
                            <td class="ellipsisCell text-center">${c.telefono}</td>
                            <td class="ellipsisCell text-center">
                                <c:choose>
                                    <c:when test="${c.disponibilidad == 1}">Disponible</c:when>
                                    <c:otherwise>No</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="ellipsisCell text-center">
                                <c:choose>
                                    <c:when test="${c.estado == 1}">Activo</c:when>
                                    <c:otherwise>Inactivo</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <button type="button" class="btn btn-warning btn-sm btnEditar"
                                        data-id="${c.id}" title="Editar">✏️</button>
                                <a href="${pageContext.request.contextPath}/ChoferServlet?action=eliminar&id=${c.id}"
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('¿Seguro que deseas eliminar este chofer?');" title="Eliminar">🗑️</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Modal con iframe: carga agregar/editar sin duplicar estilos -->
<div class="modal fade" id="modalForm" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl" style="max-width:1100px;">
        <div class="modal-content">
            <div class="modal-header">
                <h5 id="modalTitle" class="modal-title">Formulario</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body" style="height:82vh; padding:0;">
                <iframe id="modalFrame" src="" frameborder="0" style="width:100%; height:100%;"></iframe>
            </div>
        </div>
    </div>
</div>

<!-- include footer -->
<jsp:include page="/Vista/componentes/footer.jsp" />

<!-- ===== Estilos y comportamiento ===== -->
<style>
    /* header wrap (permitir que headers se partan en 2 líneas) */
    .th-wrap {
        display:block;
        white-space: normal;
        text-align:center;
    }

    /* Celdas con truncado ... para que el cuerpo no aumente de alto */
    #tablaChoferes {
        table-layout: fixed !important;
        width:100% !important;
    }
    #tablaChoferes th, #tablaChoferes td {
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap; /* NO querías salto en celdas */
        vertical-align: middle;
        box-sizing: border-box;
    }

    /* Asegura que la cabeza generada por DataTables use fixed layout también */
    .dataTables_scrollHeadInner table {
        table-layout: fixed !important;
        width:100% !important;
    }

    /* Ajustes para el contenedor scroll */
    .dataTables_scrollBody {
        max-height: 55vh !important;
    }
</style>

<!-- ===== Scripts (asegúrate de no duplicar en header/footer) ===== -->
<link href="https://cdn.datatables.net/2.0.7/css/dataTables.bootstrap5.min.css" rel="stylesheet">
<link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
                                       $(document).ready(function () {
                                           // Inicializa DataTable con scroll (barra lateral en el body)
                                           var table = $('#tablaChoferes').DataTable({
                                               responsive: false,
                                               scrollY: '55vh', // altura del body; cambia si quieres menos/más
                                               scrollX: true,
                                               scrollCollapse: true,
                                               paging: true,
                                               pageLength: 10,
                                               lengthMenu: [10, 25, 50],
                                               autoWidth: false,
                                               columnDefs: [
                                                   {orderable: false, targets: -1, width: '120px'}, // Acciones
                                                   {targets: 0, width: '60px', className: 'text-center'}, // ID
                                                   {targets: 1, width: '160px'}, // Apellido Paterno
                                                   {targets: 2, width: '160px'}, // Apellido Materno
                                                   {targets: 3, width: '140px'}, // Nombre
                                                   {targets: 4, width: '110px', className: 'text-center'}, // DNI
                                                   {targets: 5, width: '130px'}, // Licencia
                                                   {targets: 6, width: '130px'}, // Fecha Contratación
                                                   {targets: 7, width: '130px'}, // Fecha Venc.
                                                   {targets: 8, width: '120px', className: 'text-center'}, // Teléfono
                                                   {targets: 9, width: '120px', className: 'text-center'}, // Disponibilidad
                                                   {targets: 10, width: '100px', className: 'text-center'} // Estado
                                               ],
                                               language: {
                                                   search: "🔍 Buscar:",
                                                   lengthMenu: "Mostrar _MENU_ registros por página",
                                                   info: "Mostrando _START_ a _END_ de _TOTAL_ registros",
                                                   paginate: {first: "Primero", last: "Último", next: "Siguiente", previous: "Anterior"},
                                                   zeroRecords: "No se encontraron registros"
                                               },
                                               drawCallback: function () {
                                                   // reaplicar tooltips y sincronizar ancho después de cada dibujo
                                                   applyTooltips();
                                                   setTimeout(syncHeadWidths, 50);
                                               }
                                           });

                                           // forzar ajuste inicial y sincronización
                                           table.columns.adjust();
                                           setTimeout(syncHeadWidths, 200);

                                           // recalcula en resize (debounced)
                                           var resizeTimer;
                                           $(window).on('resize', function () {
                                               clearTimeout(resizeTimer);
                                               resizeTimer = setTimeout(function () {
                                                   table.columns.adjust();
                                                   syncHeadWidths();
                                               }, 150);
                                           });

                                           // Modal iframe
                                           var modalEl = document.getElementById('modalForm');
                                           var bsModal = new bootstrap.Modal(modalEl);

                                           $('#btnAgregar').on('click', function () {
                                               var url = '${pageContext.request.contextPath}/ChoferServlet?action=agregar';
                                               $('#modalTitle').text('Agregar Chofer');
                                               $('#modalFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           $(document).on('click', '.btnEditar', function () {
                                               var id = $(this).data('id');
                                               var url = '${pageContext.request.contextPath}/ChoferServlet?action=editar&id=' + id;
                                               $('#modalTitle').text('Editar Chofer #' + id);
                                               $('#modalFrame').attr('src', url);
                                               bsModal.show();
                                           });

                                           $('#modalForm').on('hidden.bs.modal', function () {
                                               $('#modalFrame').attr('src', '');
                                               setTimeout(function () {
                                                   table.columns.adjust();
                                                   syncHeadWidths();
                                               }, 150);
                                           });

                                           // Sincroniza anchos entre head generado por datatables y body
                                           function syncHeadWidths() {
                                               try {
                                                   var $headTable = $('.dataTables_scrollHeadInner table');
                                                   var $bodyTable = $('.dataTables_scrollBody table');

                                                   if ($headTable.length && $bodyTable.length) {
                                                       // dar al head el ancho total real del body
                                                       var bodyW = $bodyTable.outerWidth();
                                                       $headTable.css('width', bodyW + 'px');

                                                       // sincronizar columna a columna con el primer TR del body
                                                       var $firstRowTds = $bodyTable.find('tr:eq(0) td');
                                                       if ($firstRowTds.length) {
                                                           $firstRowTds.each(function (idx) {
                                                               var w = $(this).outerWidth();
                                                               $headTable.find('th').eq(idx).css('width', w + 'px');
                                                           });
                                                       }
                                                   }
                                               } catch (e) {
                                                   table.columns.adjust();
                                               }
                                           }

                                           // Tooltip: agrega title con texto completo a celdas truncadas
                                           function applyTooltips() {
                                               $('#tablaChoferes tbody td.ellipsisCell').each(function () {
                                                   var $td = $(this);
                                                   var text = $td.text().trim();
                                                   if (text.length > 0) {
                                                       $td.attr('title', text);
                                                   } else {
                                                       $td.removeAttr('title');
                                                   }
                                               });
                                           }

                                           // ejecutar por primera vez
                                           applyTooltips();

                                       });
</script>
