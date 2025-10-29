<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Agregar Lugar</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background-color: rgb(231, 239, 246);">
        <div class="container mt-4 col-8">
            <h2>Agregar Lugar</h2>
            <form action="${pageContext.request.contextPath}/LugarServlet" method="post">
                <input type="hidden" name="action" value="add">

                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <input type="text" class="form-control" name="nombre" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Descripción</label>
                    <input type="text" class="form-control" name="descripcion">
                </div>

                <div class="mb-3">
                    <label class="form-label">Tipo</label>
                    <input type="text" class="form-control" name="tipo" value="CIUDAD">
                </div>

                <div class="mb-3">
                    <label class="form-label">Estado</label>
                    <select class="form-select" name="estado" required>
                        <option value="1">Activo</option>
                        <option value="0">Inactivo</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-success">💾 Guardar</button>

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
