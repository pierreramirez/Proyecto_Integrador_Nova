<%@ page contentType="text/html" pageEncoding="UTF-8" %>

</div> <%-- cierra col-10 main-content --%>
</div>   <%-- cierra d-flex principal --%>

<%-- Footer visible --%>
<footer class="site-footer mt-4 text-center">
    <hr/>
    <p>&copy; 2025 NOVA'S TRAVELS - Todos los derechos reservados</p>
</footer>

<%-- Scripts al final para mejor carga --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<%-- DataTables JS --%>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.min.js"></script>
<script src="https://cdn.datatables.net/2.0.7/js/dataTables.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/3.0.2/js/dataTables.buttons.min.js"></script>
<script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.bootstrap5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.html5.min.js"></script>
<script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.print.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>

<%-- SweetAlert ya incluido en header (pero si quieres cargar aquí, mueve la etiqueta) --%>

<%-- Inicializaciones comunes (ejemplo DataTable) --%>
<script>
    $(document).ready(function () {
        // Inicialización genérica para tablas con clase .datatable (ajusta a tus tablas)
        if ($.fn.dataTable) {
            $('.datatable').DataTable({
                dom: 'Bfrtip',
                buttons: ['excel', 'pdf', 'print'],
                language: {
                    url: '//cdn.datatables.net/plug-ins/1.13.5/i18n/es-ES.json'
                }
            });
        }
    });
</script>

</body>
</html>
