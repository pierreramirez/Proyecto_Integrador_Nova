<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    java.util.List<Modelo.DTOAsientoViaje> asientos = (java.util.List<Modelo.DTOAsientoViaje>) request.getAttribute("asientos");
    int idViaje = (Integer) request.getAttribute("idViaje");
%>

<h3>Selecciona tu asiento</h3>

<div class="row">
    <c:forEach var="a" items="${asientos}">
        <div class="col-2 mb-2">
            <c:choose>
                <c:when test="${a.estado == 0}">
                    <form action="${pageContext.request.contextPath}/BookSeatServlet" method="post">
                        <input type="hidden" name="idViaje" value="${idViaje}" />
                        <input type="hidden" name="idAsiento" value="${a.idAsientoViaje}" />
                        <button type="submit" class="btn btn-success w-100">Asiento ${a.numeroAsiento}</button>
                    </form>
                </c:when>
                <c:when test="${a.estado == 1}">
                    <button class="btn btn-warning w-100" disabled>Reservado ${a.numeroAsiento}</button>
                </c:when>
                <c:otherwise>
                    <button class="btn btn-danger w-100" disabled>Ocupado ${a.numeroAsiento}</button>
                </c:otherwise>
            </c:choose>
        </div>
    </c:forEach>
</div>
