<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
    Map<String,Object> ruta = (Map<String,Object>) request.getAttribute("ruta");
    Set<Integer> vendidos = (Set<Integer>) request.getAttribute("vendidos");
    List<Integer> asientos = (List<Integer>) request.getAttribute("asientos");
    if (ruta == null) {
        response.sendRedirect(request.getContextPath()+"/rutas.jsp?error=ruta_no_encontrada");
        return;
    }
    int idViaje = (Integer) ruta.get("idViaje");
    String origenNombre = (String) ruta.get("origenNombre");
    String destinoNombre = (String) ruta.get("destinoNombre");
    java.sql.Date fecha = (java.sql.Date) ruta.get("fechaSalida");
    java.sql.Time hora = (java.sql.Time) ruta.get("horaSalida");
    java.math.BigDecimal precio = (java.math.BigDecimal) ruta.get("precio");
    int boletosRestantes = (Integer) ruta.get("boletosRestantes");
    String placa = (String) ruta.get("placa");
%>
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Seleccionar asiento - Viaje #<%=idViaje%></title>
  <style>
    .seat { width:42px; height:42px; margin:6px; display:inline-block; text-align:center; line-height:42px; cursor:pointer; border-radius:6px; border:1px solid #444; }
    .sold { background:#ccc; cursor:not-allowed; color:#666; }
    .selected { background:#2ecc71; color:white; }
    .available { background:#fff; }
    .seats-wrap { max-width:520px; margin:20px 0; }
  </style>
</head>
<body>
  <h2>Seleccionar asiento</h2>
  <p><strong>Ruta:</strong> <%= origenNombre %> → <%= destinoNombre %></p>
  <p><strong>Fecha / Hora:</strong> <%= fecha %> | <%= hora %></p>
  <p><strong>Bus:</strong> <%= placa %> — <strong>Precio:</strong> S/ <%= precio %></p>
  <p><strong>Boletos disponibles:</strong> <%= boletosRestantes %></p>

  <div class="seats-wrap" id="seats">
    <form id="bookForm" method="post" action="<%=request.getContextPath()%>/bookSeat">
      <input type="hidden" name="idViaje" value="<%=idViaje%>"/>
      <input type="hidden" name="asiento" id="asientoInput" value=""/>
      <div>
      <%
        for (Integer s : asientos) {
            boolean isSold = (vendidos != null && vendidos.contains(s));
      %>
        <div class="seat <%= isSold ? "sold" : "available" %>" data-seat="<%=s%>" <%= isSold ? "title='Vendido'":"" %>>
          <%= s %>
        </div>
      <%
        }
      %>
      </div>

      <p>
        <button type="button" id="btnConfirm">Reservar asiento seleccionado</button>
        <a href="<%=request.getContextPath()%%>/rutas.jsp">Volver a rutas</a>
      </p>
    </form>
  </div>

<script>
  (function(){
    const seats = document.querySelectorAll('.seat');
    let selected = null;
    seats.forEach(function(el){
      if (el.classList.contains('sold')) return;
      el.addEventListener('click', function(){
        if (selected) selected.classList.remove('selected');
        el.classList.add('selected');
        selected = el;
        document.getElementById('asientoInput').value = el.getAttribute('data-seat');
      });
    });

    document.getElementById('btnConfirm').addEventListener('click', function(){
      const asiento = document.getElementById('asientoInput').value;
      if (!asiento) {
        alert('Selecciona primero un asiento.');
        return;
      }
      if (!confirm('Confirmar reserva del asiento ' + asiento + '?')) return;
      document.getElementById('bookForm').submit();
    });
  })();
</script>
</body>
</html>
