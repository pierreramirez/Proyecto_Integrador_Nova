<%@ include file="menu.jsp" %>
<div class="m-3">
    <div class="mb-3">
        <hr>
        <div class="d-flex justify-content-between">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#mdlAgregarPasaje"><i class='bx bx-plus me-2'></i>Registrar</button>
            <button type="button" class="btn btn-primary"><i class='bx bx-refresh me-2'></i>Refrescar</button>
        </div>
        <hr>
        <h3>Filtros</h3>
        <div class="d-flex justify-content-between">
            <div>
                <label for="rutadeviaje">Ruta de Viaje</label>
                <select name="viaje" id="rutadeviaje" class="form-select">
                    <option value="">[Seleccione]</option>
                    <option value="1">Lima - Cusco</option>
                    <option value="2">Lima - Arequipa</option>
                    <option value="3">Lima - Trujillo</option>
                </select>
            </div>
            <div>
                <label for="fechaInicio">Fecha de inicio</label>
                <input type="date" class="form-control" placeholder="Fecha de inicio">
            </div>
            <div>
                <label for="fechaFin">Fecha de fin</label>
                <input type="date" class="form-control" placeholder="Fecha de fin">
            </div>
        </div>

        <%@ include file="../componentes/pasaje/modalAgregarPasaje.jsp" %>
    </div>

    <div class="card-datatable table-responsive bg-light p-3 rounded shadow">
        <table id="datatable-pasaje" class="table table-striped m-3" style="width: 100%;">
            <thead>
                <tr>
                    <td class="text-center">ID</td>
                    <td class="text-center">NOMBRE</td>
                    <td class="text-center">DNI</td>
                    <td class="text-center">RUTA DE VIAJE</td>
                    <td class="text-center">BUS</td>
                    <td class="text-center">SALIDA</td>
                    <td class="text-center">LLEGADA</td>
                    <td class="text-center">ESTADO</td>
                    <td class="text-center">ACCIONES</td>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="text-center">1</td>
                    <td class="text-center">Vargas Santos, John</td>
                    <td class="text-center">123456789</td>
                    <td class="text-center">Lima - Cusco</td>
                    <td class="text-center">trvdz24</td>
                    <td class="text-center">24/04/2024 - 8:00</td>
                    <td class="text-center">24/04/2024 - 18:00</td>
                    <td class="text-center">En Curso</td>
                    <td class="text-center"></td>
                </tr>
            </tbody>
        </table>
        <%@ include file="../componentes/pasaje/modalDetallesPasaje.jsp" %>
    </div>
    <script>
        $(document).ready(function () {
            $('#datatable-pasaje').DataTable({
                columnDefs: [
                    {
                        // Actions
                        targets: -1,
                        searchable: false,
                        orderable: false,
                        render: function (data, type, full, meta) {
                            var btnDetalles = "<button onclick='(\"" + full['item_id'] + "\")' type='button' data-bs-toggle='modal' data-bs-target='#mdlDetallesPasaje' class='btn btn-icon btn-outline-primary  me-2'><i class='tf-icons bx bxs-detail'></i></button>"
                            var btnEliminar = "<button onclick='(\"" + full['item_id'] + "\")' type='button' class='btn btn-icon btn-outline-danger  me-2'><i class='tf-icons bx bxs-trash'></i></button>"
                            var btnEditar = "<button onclick='(\"" + full['item_id'] + "\")' type='button' class='btn btn-icon btn-outline-info  me-2'><i class='bx bxs-edit'></i></button>"

                            return (
                                    '<div class="d-inline-block text-nowrap">' +
                                    btnDetalles +
                                    btnEditar +
                                    btnEliminar +
                                    '</div>'
                                    );
                        }
                    }
                ],
                order: [[0, 'desc']],
                dom:
                        '<"row mx-2"' +
                        '<"col-md-2"<"me-3"l>>' +
                        '<"col-md-10"<"dt-action-buttons text-xl-end text-lg-start text-md-end text-start d-flex align-items-center justify-content-end flex-md-row flex-column mb-3 mb-md-0"fB>>' +
                        '>t' +
                        '<"row mx-2"' +
                        '<"col-sm-12 col-md-6"i>' +
                        '<"col-sm-12 col-md-6"p>' +
                        '>',
                language: {
                    sLengthMenu: '_MENU_',
                    search: '',
                    searchPlaceholder: 'Search..'
                },
                buttons: [],
                responsive: false
            });
        });
    </script>
</div>
<%@ include file="footer.jsp" %>