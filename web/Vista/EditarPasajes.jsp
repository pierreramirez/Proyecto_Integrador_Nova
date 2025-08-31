<%@ include file="menu.jsp" %>
<div class="m-4 p-5 bg-light shadow rounded">
    <h3 class="text-center">EDITAR PASAJES</h3>
    <hr class="mb-5">
    <form id="frmEditPasaje" class="row g-3" method="post">
        <div class="row mb-3">
            <div class="col-6">
                <label for="viaje">Ruta de Viaje</label>
                <select name="viaje" id="viajePas" class="form-select">
                    <option value="">[Seleccione]</option>
                    <option value="1">Lima - Cusco</option>
                    <option value="2">Lima - Arequipa</option>
                    <option value="3">Lima - Trujillo</option>
                </select>
            </div>
            <div class="col-6">
                <label for="cliente">Cliente</label>
                <select name="cliente" id="clientePas" class="form-select">
                    <option value="">[Seleccione]</option>
                    <option value="1">Seminario Gomez, Aldo</option>
                </select>
            </div>
        </div>
        <div class="row mb-3">
            <div class="col-6">
                <label for="asiento">Asiento</label>
                <input type="text" name="asiento" id="asientoPas" class="form-control">
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