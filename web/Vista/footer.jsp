<%--JS Administrar Tablas--%>
<script src="../js/FuncionesAdministrarBuses.js" type="text/javascript"></script>
<script src="../js/FuncionesAdministrarChoferes.js" type="text/javascript"></script>
<script src="../js/FuncionesAdministrarViajes.js" type="text/javascript"></script>
<script src="../js/FuncionesAdministrarClientes.js" type="text/javascript"></script>
<script>
    //Obtiene los datos de la BD
    $(document).ready(function () {
        obtenerChoferes();
        obtenerViajes();
        
        listarLugares();
    });
</script>
</body>
</html>