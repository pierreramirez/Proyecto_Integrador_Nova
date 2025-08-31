<div class="modal fade" id="mdlAgregarBus" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-simple">
        <div class="modal-content p-3 p-md-5">
            <div class="modal-body">
                <div class="d-flex">
                    <div class="ms-auto">
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                </div>

                <div class="text-center mb-4">
                    <h3>Agregar</h3>
                </div>
                <hr style="padding-bottom: 20px;">
                <form id="frmAddBus" class="row g-3" onsubmit="return false">
                    <div class="row mb-3">
                        <div class="col-6">
                            <label for="placa">Placa</label>
                            <input type="text" name="placa" id="placa" class="form-control">
                        </div>
                        <div class="col-6">
                            <label for="asientos">Cantidad de Asientos</label>
                            <input type="number" name="asientos" id="asientos" class="form-control">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6">
                            <label for="tipo">Tipo</label>
                            <input type="text" name="tipo" id="tipo" class="form-control">
                        </div>
                    </div>
                </form>
                <hr style="padding-bottom: 20px;">
                <div class="d-flex">
                    <div class="ms-auto">
                        <a href="#" class="btn btn-primary"><i class='bx bxs-save me-2'></i>Registrar</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>