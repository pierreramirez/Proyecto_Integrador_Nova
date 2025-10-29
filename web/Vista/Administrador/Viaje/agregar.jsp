<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html>
    <head><meta charset="utf-8"/><title>Programar Viaje</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"></head>
    <body style="background-color: rgb(231, 239, 246);">
        <div class="container mt-4 col-8">
            <h2>Programar Nuevo Viaje</h2>
            <form action="${pageContext.request.contextPath}/ViajeServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="mb-3">
                    <label class="form-label">Bus</label>
                    <select name="idBus" class="form-select" required>
                        <option value="">-- Selecciona un bus --</option>
                        <c:forEach var="b" items="${buses}">
                            <option value="${b.idBus}">${b.placa} — ${b.tipo} — ${b.capacidadAsientos} asientos</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Chofer</label>
                    <select name="idChofer" class="form-select" required>
                        <option value="">-- Selecciona un chofer --</option>
                        <c:forEach var="c" items="${choferes}">
                            <option value="${c.idChofer}">${c.nombre}</option>
                        </c:forEach>
                    </select>
                </div>

                <!-- lugares, fecha, hora, duracion, precio, estado (igual que antes) -->
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Origen</label>
                        <select name="origen_id" class="form-select" required>
                            <option value="">-- Origen --</option>
                            <c:forEach var="l" items="${lugares}">
                                <option value="${l.idLugar}">${l.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Destino</label>
                        <select name="destino_id" class="form-select" required>
                            <option value="">-- Destino --</option>
                            <c:forEach var="l" items="${lugares}">
                                <option value="${l.idLugar}">${l.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-3"><label class="form-label">Fecha de Salida</label><input type="date" name="fechaSalida" class="form-control" required /></div>
                    <div class="col-md-4 mb-3"><label class="form-label">Hora de Salida</label><input type="time" name="horaSalida" class="form-control" required /></div>
                    <div class="col-md-4 mb-3"><label class="form-label">Duración (min)</label><input type="number" name="duracionMin" class="form-control" placeholder="ej. 600" /></div>
                </div>

                <div class="mb-3"><label class="form-label">Precio (S/)</label><input type="number" step="0.01" name="precio" class="form-control" required /></div>

                <div class="mb-3"><label class="form-label">Estado</label>
                    <select name="estado" class="form-select"><option value="1">Activo</option><option value="0">Inactivo</option></select>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-success">💾 Crear Viaje</button>
                    <button type="button" class="btn btn-secondary" onclick="(function () {
                        try {
                            const modalEl = parent.document.getElementById('modalViajeForm');
                            const modal = parent.bootstrap.Modal.getInstance(modalEl) || new parent.bootstrap.Modal(modalEl);
                            modal.hide();
                        } catch (e) {
                            parent.location.reload();
                        }
                    })();">Cancelar</button>
                </div>
            </form>
        </div>
    </body>
</html>
