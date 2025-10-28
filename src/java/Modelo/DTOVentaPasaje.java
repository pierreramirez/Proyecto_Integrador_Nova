package Modelo;

import java.sql.Timestamp;

public class DTOVentaPasaje {
    private int idPasaje;
    private int idViaje;
    private int idCliente;
    private int asiento;
    private Timestamp fechaCompra;
    private Integer creador;
    private Timestamp fechaCreacion;
    private Integer estado; // 0=reserva pendiente, 1=confirmado, 2=cancelado

    public DTOVentaPasaje() {}

    public DTOVentaPasaje(int idViaje, int idCliente, int asiento, Integer creador, Integer estado) {
        this.idViaje = idViaje;
        this.idCliente = idCliente;
        this.asiento = asiento;
        this.creador = creador;
        this.estado = estado;
    }

    // getters / setters
    public int getIdPasaje() { return idPasaje; }
    public void setIdPasaje(int idPasaje) { this.idPasaje = idPasaje; }
    public int getIdViaje() { return idViaje; }
    public void setIdViaje(int idViaje) { this.idViaje = idViaje; }
    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }
    public int getAsiento() { return asiento; }
    public void setAsiento(int asiento) { this.asiento = asiento; }
    public Timestamp getFechaCompra() { return fechaCompra; }
    public void setFechaCompra(Timestamp fechaCompra) { this.fechaCompra = fechaCompra; }
    public Integer getCreador() { return creador; }
    public void setCreador(Integer creador) { this.creador = creador; }
    public Timestamp getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Timestamp fechaCreacion) { this.fechaCreacion = fechaCreacion; }
    public Integer getEstado() { return estado; }
    public void setEstado(Integer estado) { this.estado = estado; }
}
