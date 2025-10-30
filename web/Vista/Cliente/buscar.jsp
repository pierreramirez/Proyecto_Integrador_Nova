<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<form action="${pageContext.request.contextPath}/BuscarViajesServlet" method="get">
    Origen:
    <select name="origen_id"><%-- cargar lugares --%></select>
    Destino:
    <select name="destino_id"><%-- cargar lugares --%></select>
    <button>Buscar</button>
</form>
