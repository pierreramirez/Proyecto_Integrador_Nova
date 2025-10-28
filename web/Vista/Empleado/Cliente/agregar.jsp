<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Agregar Chofer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: rgb(231, 239, 246);">
<div class="container mt-4 col-8">
    <h2>Agregar Chofer</h2>
    <form action="../../ChoferServlet" method="post">
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
            <label class="form-label">Licencia de Conducir</label>
            <input type="text" class="form-control" name="licenciaConducir" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Fecha de Contratación</label>
            <input type="date" class="form-control" name="fechaContratacion" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Fecha de Vencimiento de Licencia</label>
            <input type="date" class="form-control" name="fechaVencimientoLicencia" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Teléfono</label>
            <input type="number" class="form-control" name="telefono" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Disponibilidad</label>
            <select class="form-select" name="disponibilidad" required>
                <option value="1">Disponible</option>
                <option value="0">No Disponible</option>
            </select>
        </div>
        <div class="mb-3">
            <label class="form-label">Estado</label>
            <select class="form-select" name="estado" required>
                <option value="1">Activo</option>
                <option value="0">Inactivo</option>
            </select>
        </div>

        <button type="submit" class="btn btn-success">💾 Guardar</button>
        <a href="../../ChoferServlet?action=listar" class="btn btn-secondary">Cancelar</a>
    </form>
</div>
</body>
</html>
