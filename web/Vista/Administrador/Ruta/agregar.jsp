<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Agregar Ruta</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background-color: rgb(231, 239, 246);">
        <div class="container mt-4 col-8">
            <h2>Agregar Ruta</h2>
            <!-- target="_parent" -> la respuesta reemplaza la ventana padre -->
            <form action="${pageContext.request.contextPath}/RutaServlet" method="post" target="_parent">
                <input type="hidden" name="action" value="add">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">ID Bus</label>
                        <input type="number" class="form-control" name="idBus" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">ID Chofer</label>
                        <input type="number" class="form-control" name="idChofer" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Fecha Salida</label>
                        <input type="date" class="form-control" name="fechaSalida" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Hora Salida</label>
                        <input type="time" class="form-control" name="horaSalida" required step="1">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Fecha Llegada</label>
                        <input type="date" class="form-control" name="fechaLlegada" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Hora Llegada</label>
                        <input type="time" class="form-control" name="horaLlegada" required step="1">
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Origen (idLugar)</label>
                        <input type="number" class="form-control" name="origen" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Destino (idLugar)</label>
                        <input type="number" class="form-control" name="destino" required>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Precio</label>
                        <input type="number" step="0.01" class="form-control" name="precio" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Boletos Restantes</label>
                        <input type="number" class="form-control" name="boletosRestantes" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Creador (idUsuario)</label>
                        <input type="number" class="form-control" name="creador" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Estado</label>
                    <select class="form-select" name="estado" required>
                        <option value="1" selected>Activo</option>
                        <option value="0">Inactivo</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-success">💾 Guardar</button>
                <a href="${pageContext.request.contextPath}/RutaServlet?action=list" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>
    </body>
</html>
