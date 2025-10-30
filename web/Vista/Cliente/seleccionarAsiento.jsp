<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, Modelo.DTOAsientoViaje" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/Vista/componentes/header.jsp" />

<%
    List<DTOAsientoViaje> asientos = (List<DTOAsientoViaje>) request.getAttribute("asientos");
    Integer idViaje = (Integer) request.getAttribute("idViaje");
%>

<div class="container mt-4">
    <h3>Seleccionar Asiento - Viaje #<c:out value="${idViaje}" /></h3>

    <form action="${pageContext.request.contextPath}/BookSeatServlet" method="post" id="bookForm">
        <input type="hidden" name="idViaje" value="${idViaje}" />
        <input type="hidden" name="idAsiento" id="idAsiento" value="" />

        <div class="seats-grid" style="display:flex; flex-wrap:wrap; gap:12px; margin-top:1rem;">
            <c:forEach var="a" items="${asientos}">
                <c:choose>
                    <c:when test="${a.estado == 0}">
                        <button type="button" class="seat available" data-id="${a.idAsientoViaje}">${a.numeroAsiento}</button>
                    </c:when>
                    <c:when test="${a.estado == 1}">
                        <button type="button" class="seat reserved" disabled>${a.numeroAsiento}</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="seat occupied" disabled>${a.numeroAsiento}</button>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </div>

        <div style="margin-top:20px;">
            <button type="submit" class="btn btn-success" id="confirmBtn" disabled>Reservar asiento</button>
            <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-secondary">Cancelar</a>
        </div>
    </form>
</div>

<script>
    document.querySelectorAll('.seat.available').forEach(btn => {
        btn.addEventListener('click', function () {
            document.querySelectorAll('.seat.available.selected').forEach(x => x.classList.remove('selected'));
            this.classList.add('selected');
            document.getElementById('idAsiento').value = this.dataset.id;
            document.getElementById('confirmBtn').disabled = false;
        });
    });
</script>

<style>
    .seat {
        width:56px;
        height:56px;
        border-radius:8px;
        border:none;
        font-weight:bold;
        cursor:pointer;
    }
    .available {
        background:#2ecc71;
        color:#fff;
    }
    .reserved {
        background:#f1c40f;
        color:#fff;
    }
    .occupied {
        background:#95a5a6;
        color:#fff;
    }
    .selected {
        outline:3px solid #ff8c00;
        transform:scale(1.04);
    }
</style>

<jsp:include page="/Vista/componentes/footer.jsp" />
