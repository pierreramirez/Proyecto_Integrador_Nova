<%@ include file="menu.jsp" %>
<div class="m-3">
    <div class="mb-3">
        <hr>
        <div class="d-flex justify-content-between">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#mdlAgregarBus"><i class='bx bx-plus me-2'></i>Registrar</button>
            <button type="button" class="btn btn-primary"><i class='bx bx-refresh me-2'></i>Refrescar</button>
        </div>

        <%@ include file="../componentes/bus/modalAgregarBus.jsp" %>
    </div>

    <div class="card-datatable table-responsive bg-light p-3 rounded shadow">
        <table id="datatable-bus" class="table table-striped m-3">
            <thead>
                <tr>
                    <td class="text-center">ID</td>
                    <td class="text-center">PLACA</td>
                    <td class="text-center">ASIENTOS</td>
                    <td class="text-center">TIPO</td>
                    <td class="text-center">ESTADO</td>
                    <td class="text-center">ACCIONES</td>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="text-center">1</td>
                    <td class="text-center">trvdz24</td>
                    <td class="text-center">45</td>
                    <td class="text-center">Omnibus de 2 niveles</td>
                    <td class="text-center">Activo</td>
                    <td class="text-center"></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="footer.jsp" %>