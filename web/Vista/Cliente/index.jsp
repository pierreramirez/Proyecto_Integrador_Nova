<%@ include file="../componentes/header.jsp" %>
<%@ include file="../componentes/menu.jsp" %>

<!-- Contenido único de la página -->
<h2>Panel Cliente</h2>
<p>Bienvenido, <c:out value="${sessionScope.user.nombre}"/></p>

<%@ include file="../componentes/footer.jsp" %>
