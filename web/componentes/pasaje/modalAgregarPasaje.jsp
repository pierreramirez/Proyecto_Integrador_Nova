<div class="modal fade" id="mdlAgregarPasaje" tabindex="-1" aria-hidden="true">
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
                <form id="frmAddPasaje" class="row g-3" onsubmit="return false">
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