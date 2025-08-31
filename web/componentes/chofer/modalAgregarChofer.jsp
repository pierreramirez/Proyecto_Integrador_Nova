<div class="modal fade" id="mdlAgregarChofer" tabindex="-1" aria-hidden="true">
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
                <form id="frmAddChofer" class="row g-3" onsubmit="return false">
                    <div class="row mb-3">
                        <div class="col-6">
                            <label for="appat">Apellido Paterno</label>
                            <input type="text" name="appat" id="appatCh" class="form-control">
                        </div>
                        <div class="col-6">
                            <label for="apmat">Apellido Materno</label>
                            <input type="text" name="apmat" id="apmatCh" class="form-control">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6">
                            <label for="nombre">Nombre</label>
                            <input type="text" name="nombre" id="nombreCh" class="form-control">
                        </div>
                        <div class="col-6">
                            <label for="dni">DNI</label>
                            <input type="text" name="dni" id="dniCh" class="form-control">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6">
                            <label for="licencia">Licencia de Conducir</label>
                            <input type="text" name="licencia" id="licenciaCh" class="form-control">
                        </div>
                        <div class="col-6">
                            <label for="vencLicencia">Fecha de Vencimiento de Licencia</label>
                            <input type="date" name="vencLicencia" id="vencLicenciaCh" class="form-control">
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-6">
                            <label for="telefono">Telefono de Contacto</label>
                            <input type="text" name="telefono" id="telefonoCh" class="form-control">
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