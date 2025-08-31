<%@ include file="menu.jsp" %>
<div class="m-4 p-5 bg-light shadow rounded">
    <h3 class="text-center">EDITAR BUS</h3>
    <hr class="mb-5">
    <form id="frmEditBus" class="row g-3" method="post">
        <div class="row mb-3">
            <div class="col-6">
                <label for="txtPlacaEdit">Placa</label>
                <input type="text" name="txtPlaca" id="txtPlacaEdit" class="form-control">
            </div>
            <div class="col-6">
                <label for="txtAsientosEdit">Cantidad de Asientos</label>
                <input type="number" name="txtAsientos" id="txtAsientosEdit" class="form-control">
            </div>
        </div>
        <div class="row mb-3">
            <div class="col">
                <label for="txtDescripcionEdit">Descripción</label>
                <textarea name="txtDescripcion" id="txtDescripcionEdit" class="form-control"></textarea>
            </div>
        </div>
        <div class="d-flex">
            <div class="ms-auto">
                <button type="submit" class="btn btn-primary"><i class='bx bxs-save me-2'></i>Guardar Cambios</button>
            </div>
        </div>
    </form>
</div>
<%@ include file="footer.jsp" %>