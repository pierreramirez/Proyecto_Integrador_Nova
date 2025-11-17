<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- HEADER PRINCIPAL -->
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
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/novas-landing.css">
<div class="bus-container">

    <div class="title-box">PLANO DEL BUS</div>

    <!-- Leyenda -->
    <div class="legend">
        <div class="legend-item">
            <div class="legend-box legend-free"></div> Disponible
        </div>
        <div class="legend-item">
            <div class="legend-box legend-taken"></div> Ocupado
        </div>
    </div>

    <!-- Asiento del conductor -->
    <div class="driver-row">
        <div class="driver-seat">🧑‍️</div>
    </div>

    <!-- Asientos -->
    <div class="seats-grid">

        <c:set var="col" value="0"/>
        <c:forEach var="a" items="${asientos}">

            <c:if test="${col == 2}">
                <div class="aisle"></div>
            </c:if>

            <c:choose>
                <c:when test="${a.estado == 0}">
                    <a href="${pageContext.request.contextPath}/ReservaServlet?action=reserveForm&viajeId=${a.idViaje}&asientoId=${a.idAsientoViaje}"
                       class="seat seat-free">
                        ${a.numeroAsiento}
                    </a>
                </c:when>
                <c:otherwise>
                    <div class="seat seat-taken">${a.numeroAsiento}</div>
                </c:otherwise>
            </c:choose>

            <c:set var="col" value="${col + 1}"/>
            <c:if test="${col == 4}">
                <c:set var="col" value="0"/>
            </c:if>

        </c:forEach>

    </div>

    <div class="seat-label">Seleccione un asiento disponible</div>

</div>

<!-- FOOTER PRINCIPAL -->
<jsp:include page="../componentes/public/footer.jsp" />



