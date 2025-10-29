<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Agregar Cliente</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background-color: rgb(231, 239, 246);">
        <div class="container mt-4 col-8">
            <h2>Agregar Cliente</h2>
            <form action="${pageContext.request.contextPath}/ClienteServlet" method="post">
                <input type="hidden" name="action" value="add">

                <div class="mb-3">
                    <label class="form-label">Apellido Paterno</label>
                    <input type="text" class="form-control" name="appat" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Apellido Materno</label>
                    <input type="text" class="form-control" name="apmat" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <input type="text" class="form-control" name="nombre" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">DNI</label>
                    <input type="number" class="form-control" name="dni" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Fecha de Nacimiento</label>
                    <input type="date" class="form-control" name="fechaNacimiento" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Teléfono</label>
                    <input type="number" class="form-control" name="telefono" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Género</label>
                    <select class="form-select" name="genero" required>
                        <option value="M">Masculino</option>
                        <option value="F">Femenino</option>
                        <option value="O">Otro</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-success">💾 Guardar</button>

                <!-- cancelar: cerrar modal en el parent -->
                <button type="button" class="btn btn-secondary"
                        onclick="(function () {
                            try {
                                const modalEl = parent.document.getElementById('modalClienteForm') || parent.document.getElementById('modalForm');
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
