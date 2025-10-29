<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Editar Lugar</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background-color: rgb(231, 239, 246);">
        <div class="container mt-4 col-8">
            <h2>Editar Lugar</h2>
            <form action="${pageContext.request.contextPath}/LugarServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="idLugar" value="${lugar.idLugar}">

                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <input type="text" class="form-control" name="nombre" value="${lugar.nombre}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Descripción</label>
                    <input type="text" class="form-control" name="descripcion" value="${lugar.descripcion}">
                </div>

                <div class="mb-3">
                    <label class="form-label">Tipo</label>
                    <input type="text" class="form-control" name="tipo" value="${lugar.tipo}">
                </div>

                <div class="mb-3">
                    <label class="form-label">Estado</label>
                    <select class="form-select" name="estado" required>
                        <option value="1" <c:if test="${lugar.estado == 1}">selected</c:if>>Activo</option>
                        <option value="0" <c:if test="${lugar.estado == 0}">selected</c:if>>Inactivo</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-warning">✏️ Actualizar</button>

                <button type="button" class="btn btn-secondary"
                        onclick="(function () {
                                    try {
                                        const modalEl = parent.document.getElementById('modalLugarForm');
                                        const modal = parent.bootstrap.Modal.getInstance(modalEl) || new parent.bootstrap.Modal(modalEl);
                                        modal.hide();
                                    } catch (e) {
                                        parent.location.reload();
                                    }
                                })();">Cancelar</button>
            </form>
        </div>
    </body>
</html>
