<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/Vista/componentes/header.jsp" />
<h3>Buscar viajes</h3>

<form action="${pageContext.request.contextPath}/BuscarViajesServlet" method="get">
    Origen:
    <select name="origen_id">
        <c:forEach var="l" items="${lugares}">
            <option value="${l.idLugar}">${l.nombre}</option>
        </c:forEach>
    </select>
    Destino:
    <select name="destino_id">
        <c:forEach var="l" items="${lugares}">
            <option value="${l.idLugar}">${l.nombre}</option>
        </c:forEach>
    </select>
    <button>Buscar</button>
</form>

<div class="row">
    <c:if test="${not empty viajes}">
        <c:forEach var="v" items="${viajes}">
            <div class="col-md-4">
                <div class="card mb-4">
                    <div class="card-body">
                        <h5 class="card-title">Viaje #${v.idViaje}</h5>
                        <p>${v.fechaSalida} ${v.horaSalida} - S/ ${v.precio}</p>
                        <a href="${pageContext.request.contextPath}/SeatSelectorServlet?idViaje=${v.idViaje}" class="btn btn-primary">Seleccionar Asiento</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>
    <c:if test="${empty viajes}">
        <p>No hay viajes para esos filtros.</p>
    </c:if>
</div>
<jsp:include page="/Vista/componentes/footer.jsp" />
