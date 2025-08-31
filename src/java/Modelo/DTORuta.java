package Modelo;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;

public class DTORuta {
    private int idViaje;
    private int idBus;
    private int idChofer;
    private Date fechaSalida;
    private Time horaSalida;
    private Date fechaLlegada;
    private Time horaLlegada;
    private int origen;
    private int destino;
    private BigDecimal precio;
    private int boletosRestantes;
    private int creador;
    private Timestamp fechaCreacion;
    private int estado;

    // ----- Getters y Setters -----
    public int getIdViaje() { return idViaje; }
    public void setIdViaje(int idViaje) { this.idViaje = idViaje; }

    public int getIdBus() { return idBus; }
    public void setIdBus(int idBus) { this.idBus = idBus; }

    public int getIdChofer() { return idChofer; }
    public void setIdChofer(int idChofer) { this.idChofer = idChofer; }

    public Date getFechaSalida() { return fechaSalida; }
    public void setFechaSalida(Date fechaSalida) { this.fechaSalida = fechaSalida; }

    public Time getHoraSalida() { return horaSalida; }
    public void setHoraSalida(Time horaSalida) { this.horaSalida = horaSalida; }

    public Date getFechaLlegada() { return fechaLlegada; }
    public void setFechaLlegada(Date fechaLlegada) { this.fechaLlegada = fechaLlegada; }

    public Time getHoraLlegada() { return horaLlegada; }
    public void setHoraLlegada(Time horaLlegada) { this.horaLlegada = horaLlegada; }

    public int getOrigen() { return origen; }
    public void setOrigen(int origen) { this.origen = origen; }

    public int getDestino() { return destino; }
    public void setDestino(int destino) { this.destino = destino; }

    public BigDecimal getPrecio() { return precio; }
    public void setPrecio(BigDecimal precio) { this.precio = precio; }

    public int getBoletosRestantes() { return boletosRestantes; }
    public void setBoletosRestantes(int boletosRestantes) { this.boletosRestantes = boletosRestantes; }

    public int getCreador() { return creador; }
    public void setCreador(int creador) { this.creador = creador; }

    public Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }

    public int getEstado() { return estado; }
    public void setEstado(int estado) { this.estado = estado; }
}
