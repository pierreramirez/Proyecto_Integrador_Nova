<%@ include file="menu.jsp" %>
<div class="m-4 p-5 bg-light shadow rounded">
    <h3 class="text-center">EDITAR RUTA DE VIAJE</h3>
    <hr class="mb-5">
    <form id="frmEditViaje" class="row g-3" method="post" action="../srvControladorViajes?accion=actualizar">
        <input type="hidden" name="idRuta" value="${detalleRuta.getId()}">
        <div class="row mb-3">
            <div class="col-6">
                <label for="slctBusViEdit">Bus de Viaje</label>
                <select name="slctBus" id="slctBusViEdit" class="form-select">
                    <option value="">[Seleccione]</option>
                    <option value="1">Bus 1</option>
                </select>
            </div>
            <div class="col-6">
                <label for="slctChoferViEdit">Chofer Destinado</label>
                <select name="slctChofer" id="slctChoferViEdit" class="form-select">
                    <option value="">[Seleccione]</option>
                    <c:forEach var="choferDisponible" items="${listaChoferes}">
                        <option value="${choferDisponible.getId()}" <c:if test="${choferDisponible.getId() == detalleRuta.getIdChofer()}">selected</c:if>>
                            ${choferDisponible.getAppat()} ${choferDisponible.getApmat()}, ${choferDisponible.getNombre()}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="row mb-3">
            <div class="col">
                <label for="txtFechaSalidaViEdit">Fecha de Salida</label>
                <input type="date" name="txtFechaSalida" id="txtFechaSalidaViEdit" class="form-control" value="${detalleRuta.getFechaSalida()}">
            </div>
            <div class="col">
                <label for="txtHoraSalidaViEdit">Hora de Salida</label>
                <input type="time" name="txtHoraSalida" id="txtHoraSalidaViEdit" class="form-control" value="${detalleRuta.getHoraSalida()}">
            </div>
            <div class="col">
                <label for="slctOrigenViEdit">Lugar de Salida</label>
                <select name="slctOrigen" id="slctOrigenViEdit" class="form-select">
                    <option value="">[Seleccione]</option>
                    <c:forEach var="origen" items="${listaLugares}">
                        <option value="${origen.getId()}" <c:if test="${origen.getId() == detalleRuta.getOrigen()}">selected</c:if>>
                            ${origen.getNombre()}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="row mb-3">
            <div class="col">
                <label for="txtFechaLlegadaViEdit">Fecha de Llegada</label>
                <input type="date" name="txtFechaLlegada" id="txtFechaLlegadaViEdit" class="form-control" value="${detalleRuta.getFechaLlegada()}">
            </div>
            <div class="col">
                <label for="txtHoraLlegadaViEdit">Hora de Llegada</label>
                <input type="time" name="txtHoraLlegada" id="txtHoraLlegadaViEdit" class="form-control" value="${detalleRuta.getHoraLlegada()}">
            </div>
            <div class="col">
                <label for="slctDestinoViEdit">Lugar de Llegada</label>
                <select name="slctDestino" id="slctDestinoViEdit" class="form-select">
                    <option value="">[Seleccione]</option>
                    <c:forEach var="destino" items="${listaLugares}">
                        <option value="${destino.getId()}" <c:if test="${destino.getId() == detalleRuta.getDestino()}">selected</c:if>>
                            ${destino.getNombre()}
                        </option>
                    </c:forEach>
                </select>
            </div>
        </div>
        <div class="row mb-3">
            <div class="col">
                <label for="txtPreciVioEdit">Precio</label>
                <input type="number" name="txtPrecio" id="txtPrecioViEdit" class="form-control" step="0.01" min="0" value="${detalleRuta.getPrecio()}">
            </div>
            <div class="col">
                <label for="txtBoletosEdit">Boletos Disponibles</label>
                <input type="number" name="txtBoletos" id="txtBoletosEdit" class="form-control" min="0">
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