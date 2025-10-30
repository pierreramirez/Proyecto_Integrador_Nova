<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<form action="${pageContext.request.contextPath}/ViajeServlet" method="post">
    <input type="hidden" name="action" value="create">
    Bus:
    <select name="idBus">
        <%-- cargar con DAO o SQL: idBus y placa --%>
    </select><br/>
    Chofer:
    <select name="idChofer"><%-- cargar --%></select><br/>
    Origen:
    <select name="origen_id"><%-- cargar lugares --%></select><br/>
    Destino:
    <select name="destino_id"><%-- cargar lugares --%></select><br/>
    Fecha: <input type="date" name="fechaSalida" required><br/>
    Hora: <input type="time" name="horaSalida" required><br/>
    Duración (min): <input type="number" name="duracionMin"><br/>
    Precio: <input type="number" step="0.01" name="precio" required><br/>
    <button class="btn btn-primary">Programar viaje</button>
</form>
