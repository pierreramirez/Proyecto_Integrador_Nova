<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Modelo.DTOAsientoViaje" %>
<%
    List<DTOAsientoViaje> asientos = (List<DTOAsientoViaje>) request.getAttribute("asientos");
    int idViaje = (Integer) request.getAttribute("idViaje");
%>
<h3>Seleccionar Asiento</h3>
<form action="${pageContext.request.contextPath}/BookSeatServlet" method="post">
    <input type="hidden" name="idViaje" value="<%=idViaje%>"/>
    <%-- si no hay login, pide idCliente aquí; si tienes sesión, no mostrar el campo --%>
    Cliente ID: <input type="number" name="idCliente" required />
    <div style="display:flex; flex-wrap:wrap;">
        <% for (DTOAsientoViaje a : asientos) { %>
        <div style="width:70px; margin:6px; text-align:center;">
            <% if (a.getEstado() == 0) {%>
            <!-- disponible -->
            <label style="background:#3cb371; padding:8px; display:block; border-radius:6px; cursor:pointer;">
                <input type="radio" name="idAsiento" value="<%=a.getIdAsientoViaje()%>" style="display:none;">
                <div>#<%=a.getNumeroAsiento()%></div>
            </label>
            <% } else if (a.getEstado() == 1) { %>
            <div style="background:#ffd700; padding:8px; border-radius:6px;">Reservado</div>
            <% } else { %>
            <div style="background:#ccc; padding:8px; border-radius:6px;">Ocupado</div>
            <% } %>
        </div>
        <% }%>
    </div>
    <button type="submit">Reservar Asiento</button>
</form>
