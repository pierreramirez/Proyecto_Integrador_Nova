<%@ include file="menu.jsp" %>
<div class="main-content">
    <h2>Bienvenido!</h2>
    <h4><c:out value="${usuario.getAppat()} ${usuario.getApmat()}, ${usuario.getNombre()}"/></h4>
</div>
<%@ include file="footer.jsp" %>