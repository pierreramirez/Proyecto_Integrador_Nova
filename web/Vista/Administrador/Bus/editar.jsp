<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Editar Bus</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background-color: rgb(231, 239, 246);">
        <div class="container mt-4 col-8">
            <h2>Editar Bus</h2>
            <form action="${pageContext.request.contextPath}/BusServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="idBus" value="${bus.id}">

                <div class="mb-3">
                    <label class="form-label">Placa</label>
                    <input type="text" class="form-control" name="placa" value="${bus.placa}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Capacidad de Asientos</label>
                    <input type="number" class="form-control" name="capacidadAsientos" value="${bus.capacidadAsientos}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Tipo</label>
                    <input type="text" class="form-control" name="tipo" value="${bus.tipo}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Descripción</label>
                    <input type="text" class="form-control" name="descripcion" value="${bus.descripcion}">
                </div>
                <div class="mb-3">
                    <label class="form-label">Estado</label>
                    <select class="form-select" name="estado" required>
                        <option value="1" <c:if test="${bus.estado == 1}">selected</c:if>>Activo</option>
                        <option value="0" <c:if test="${bus.estado == 0}">selected</c:if>>Inactivo</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-warning">✏️ Actualizar</button>
                <a href="${pageContext.request.contextPath}/BusServlet?action=listar" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>
    </body>
</html>
