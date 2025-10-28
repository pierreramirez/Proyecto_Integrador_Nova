<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Cliente</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: rgb(231, 239, 246);">
<div class="container mt-4 col-8">
    <h2>Editar Cliente</h2>
    <!-- Usa ${pageContext.request.contextPath} para no depender de rutas relativas -->
    <form action="${pageContext.request.contextPath}/ClienteServlet" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="idCliente" value="${cliente.id}">

        <div class="mb-3">
            <label class="form-label">Apellido Paterno</label>
            <input type="text" class="form-control" name="appat" value="${cliente.appat}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Apellido Materno</label>
            <input type="text" class="form-control" name="apmat" value="${cliente.apmat}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Nombre</label>
            <input type="text" class="form-control" name="nombre" value="${cliente.nombre}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">DNI</label>
            <input type="number" class="form-control" name="dni" value="${cliente.dni}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Fecha de Nacimiento</label>
            <input type="date" class="form-control" name="fechaNacimiento" value="${cliente.fechaNacimiento}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Teléfono</label>
            <input type="number" class="form-control" name="telefono" value="${cliente.telefono}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Género</label>
            <select class="form-select" name="genero" required>
                <option value="M" <c:if test="${cliente.genero == 'M'}">selected</c:if>>Masculino</option>
                <option value="F" <c:if test="${cliente.genero == 'F'}">selected</c:if>>Femenino</option>
                <option value="O" <c:if test="${cliente.genero == 'O'}">selected</c:if>>Otro</option>
            </select>
        </div>
        <button type="submit" class="btn btn-warning">✏️ Actualizar</button>
        <a href="${pageContext.request.contextPath}/ClienteServlet?action=listar" class="btn btn-secondary">Cancelar</a>
    </form>
</div>
</body>
</html>
