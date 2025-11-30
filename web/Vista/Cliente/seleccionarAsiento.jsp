<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, Modelo.DTOAsientoViaje" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../componentes/public/header.jsp" />
<style>
    body {
        background: #eef3f9;
        margin: 0;
        padding: 0;
    }

    .bus-container {
        width: 500px;
        margin: 120px auto;
        background: white;
        padding: 25px;
        border-radius: 25px;
        box-shadow: 0 6px 20px rgba(0,0,0,0.12);
        text-align: center;
    }

    .title-box {
        background: #0a1a77;
        color: white;
        padding: 16px;
        font-size: 22px;
        font-weight: bold;
        border-radius: 12px;
        margin-bottom: 20px;
    }

    /* Leyenda */
    .legend {
        display: flex;
        justify-content: center;
        gap: 20px;
        margin-bottom: 15px;
        font-size: 14px;
    }

    .legend-item {
        display: flex;
        align-items: center;
        gap: 6px;
    }

    .legend-box {
        width: 18px;
        height: 18px;
        border-radius: 4px;
    }

    .legend-free {
        background: #1b74c9;
    }
    .legend-taken {
        background: #bcbcbc;
    }

    /* Asiento del conductor */
    .driver-row {
        display: grid;
        grid-template-columns: 1fr 1fr 40px 1fr 1fr;
        margin-bottom: 20px;
    }

    .driver-seat {
        width: 80px;
        height: 50px;
        background: #d97706;
        border-radius: 12px;
        display: flex;
        justify-content: center;
        align-items: center;
        color: white;
        font-size: 26px;
        grid-column: 1;
    }

    .seats-grid {
        display: grid;
        grid-template-columns: 1fr 1fr 40px 1fr 1fr;
        gap: 12px;
        justify-content: center;
        padding: 10px 0;
    }

    .seat {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 45px;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
        text-decoration: none;
        transition: 0.15s;
    }

    .seat-free {
        background: #1b74c9;
        color: white;
    }

    .seat-free:hover {
        transform: scale(1.07);
    }

    .seat-taken {
        background: #bcbcbc;
        color: #555;
        cursor: not-allowed;
    }

    .aisle {
        background: transparent;
    }

    .seat-label {
        margin-top: 15px;
        color: #777;
        font-size: 14px;
    }
</style>
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

<jsp:include page="../componentes/public/footer.jsp" />
