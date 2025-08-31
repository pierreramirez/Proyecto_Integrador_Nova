<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Editar Chofer</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body style="background-color: rgb(231, 239, 246);">
        <div class="container mt-4 col-8">
            <h2>Editar Chofer</h2>
            <form action="${pageContext.request.contextPath}/ChoferServlet" method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="idChofer" value="${chofer.id}">

                <div class="mb-3">
                    <label class="form-label">Apellido Paterno</label>
                    <input type="text" class="form-control" name="appat" value="${chofer.appat}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Apellido Materno</label>
                    <input type="text" class="form-control" name="apmat" value="${chofer.apmat}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Nombre</label>
                    <input type="text" class="form-control" name="nombre" value="${chofer.nombre}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">DNI</label>
                    <input type="number" class="form-control" name="dni" value="${chofer.dni}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Licencia de Conducir</label>
                    <input type="text" class="form-control" name="licenciaConducir" value="${chofer.licenciaConducir}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Fecha de Contratación</label>
                    <input type="date" class="form-control" name="fechaContratacion" value="${chofer.fechaContratacion}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Fecha de Vencimiento de Licencia</label>
                    <input type="date" class="form-control" name="fechaVencimientoLicencia" value="${chofer.fechaVencimientoLicencia}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Teléfono</label>
                    <input type="number" class="form-control" name="telefono" value="${chofer.telefono}" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Disponibilidad</label>
                    <select class="form-select" name="disponibilidad" required>
                        <option value="1" <c:if test="${chofer.disponibilidad == 1}">selected</c:if>>Disponible</option>
                        <option value="0" <c:if test="${chofer.disponibilidad == 0}">selected</c:if>>No Disponible</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Estado</label>
                        <select class="form-select" name="estado" required>
                            <option value="1" <c:if test="${chofer.estado == 1}">selected</c:if>>Activo</option>
                        <option value="0" <c:if test="${chofer.estado == 0}">selected</c:if>>Inactivo</option>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-warning">✏️ Actualizar</button>
                    <a href="${pageContext.request.contextPath}/ChoferServlet?action=listar" class="btn btn-secondary">Cancelar</a>
            </form>
        </div>
    </body>
</html>