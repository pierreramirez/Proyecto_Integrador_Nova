<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    if (request.getAttribute("ruta") == null) {
        response.sendRedirect(request.getContextPath() + "/RutaServlet?action=list");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Editar Ruta</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background-color: rgb(231, 239, 246);">
        <div class="container mt-4 col-8">
            <h2>Editar Ruta #<c:out value="${ruta.idViaje}"/></h2>

            <!-- target="_parent" -->
            <form action="${pageContext.request.contextPath}/RutaServlet" method="post" target="_parent">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="idViaje" value="${ruta.idViaje}">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">ID Bus</label>
                        <input type="number" class="form-control" name="idBus" value="${ruta.idBus}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">ID Chofer</label>
                        <input type="number" class="form-control" name="idChofer" value="${ruta.idChofer}" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Fecha Salida</label>
                        <input type="date" class="form-control" name="fechaSalida" value="${ruta.fechaSalida}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Hora Salida</label>
                        <input type="time" class="form-control" name="horaSalida" value="${ruta.horaSalida}" required step="1">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Fecha Llegada</label>
                        <input type="date" class="form-control" name="fechaLlegada" value="${ruta.fechaLlegada}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Hora Llegada</label>
                        <input type="time" class="form-control" name="horaLlegada" value="${ruta.horaLlegada}" required step="1">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Origen (idLugar)</label>
                        <input type="number" class="form-control" name="origen" value="${ruta.origen}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Destino (idLugar)</label>
                        <input type="number" class="form-control" name="destino" value="${ruta.destino}" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Precio</label>
                        <input type="number" step="0.01" class="form-control" name="precio" value="${ruta.precio}" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Boletos Restantes</label>
                        <input type="number" class="form-control" name="boletosRestantes" value="${ruta.boletosRestantes}" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Creador (idUsuario)</label>
                        <input type="number" class="form-control" name="creador" value="${ruta.creador}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Estado</label>
                    <select class="form-select" name="estado" required>
                        <option value="1" <c:if test="${ruta.estado == 1}">selected</c:if>>Activo</option>
                        <option value="0" <c:if test="${ruta.estado == 0}">selected</c:if>>Inactivo</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-warning">✏️ Actualizar</button>
                <a href="${pageContext.request.contextPath}/RutaServlet?action=list" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>
    </body>
</html>
