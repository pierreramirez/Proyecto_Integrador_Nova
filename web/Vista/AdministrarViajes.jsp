<%@ include file="menu.jsp" %>
<div class="m-3">
    <div class="mb-3">
        <hr>
        <div class="d-flex justify-content-between">
            <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#mdlAgregarViaje"><i class='bx bx-plus me-2'></i>Programar</button>
            <button type="button" class="btn btn-primary"><i class='bx bx-refresh me-2'></i>Refrescar</button>
        </div>
        <hr>
        <div class="d-flex justify-content-between">
            <div>
                <label for="fechaInicio">Fecha de Inicio</label>
                <input type="date" class="form-control" placeholder="Fecha de inicio">
            </div>
            <div>
                <label for="fechaFin">Fecha de Fin</label>
                <input type="date" class="form-control" placeholder="Fecha de fin">
            </div>
        </div>

        <%@ include file="../componentes/viaje/modalAgregarViaje.jsp" %>
    </div>

    <div class="card-datatable table-responsive bg-light p-3 rounded shadow">
        <table id="datatable-viaje" class="table table-striped m-3">
            <thead>
                <tr>
                    <td class="text-center">ID</td>
                    <td class="text-center">BUS</td>
                    <td class="text-center">CHOFER</td>
                    <td class="text-center">SALIDA</td>
                    <td class="text-center">LLEGADA</td>
                    <td class="text-center">ORIGEN</td>
                    <td class="text-center">DESTINO</td>
                    <td class="text-center">PRECIO</td>
                    <td class="text-center">BOLETOS RESTANTES</td>
                    <td class="text-center">ACCIONES</td>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="rutas" items="${listaRutas}">
                    <tr>
                        <td class="text-center">${rutas.getId()}</td>
                        <td class="text-center">${rutas.getIdBus()}</td>
                        <td class="text-center">
                            <c:forEach var="chofer" items="${listaChoferes}" varStatus="contador">
                                <c:if test="${contador.index == (rutas.getIdChofer()-1)}">
                                    ${chofer.getAppat()} ${chofer.getApmat()}, ${chofer.getNombre()}
                                </c:if>
                            </c:forEach>
                        </td>
                        <td class="text-center">${rutas.getFechaSalida()}  ${rutas.getHoraSalida()}</td>
                        <td class="text-center">${rutas.getFechaLlegada()}  ${rutas.getHoraLlegada()}</td>
                        <td class="text-center">
                            <c:forEach var="origen" items="${listaLugares}" varStatus="contador">
                                <c:if test="${contador.index == (rutas.getOrigen()-1)}">
                                    ${origen.getNombre()}
                                </c:if>
                            </c:forEach>
                        </td>
                        <td class="text-center">
                            <c:forEach var="destino" items="${listaLugares}" varStatus="contador">
                                <c:if test="${contador.index == (rutas.getDestino()-1)}">
                                    ${destino.getNombre()}
                                </c:if>
                            </c:forEach>
                        </td>
                        <td class="text-center">${rutas.getPrecio()}</td>
                        <td class="text-center">${rutas.getBoletosRestantes()}</td>
                        <td class="text-center">
                            <div class="d-inline-block text-nowrap">
                                <a href="../srvControladorViajes?accion=editar&idRuta=${rutas.getId()}" class='btn btn-icon btn-outline-success me-2'><i class='bx bxs-edit'></i></a>
                                <a href="javascript:eliminarViaje(${rutas.getId()})" type='button' class='btn btn-icon btn-outline-danger me-2'><i class='tf-icons bx bxs-trash'></i></a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="footer.jsp" %>