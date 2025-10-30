package Modelo;

import java.sql.Timestamp;

public class DTOReserva {

    private int idReserva;
    private int idViaje;
    private int idAsientoViaje;
    private int idCliente;
    private Timestamp fechaReserva;
    private String estado;
    private String pagoReferencia;

    public DTOReserva() {
    }

    // getters y setters
    public int getIdReserva() {
        return idReserva;
    }

    public void setIdReserva(int idReserva) {
        this.idReserva = idReserva;
    }

    public int getIdViaje() {
        return idViaje;
    }

    public void setIdViaje(int idViaje) {
        this.idViaje = idViaje;
    }

    public int getIdAsientoViaje() {
        return idAsientoViaje;
    }

    public void setIdAsientoViaje(int idAsientoViaje) {
        this.idAsientoViaje = idAsientoViaje;
    }

    public int getIdCliente() {
        return idCliente;
    }

    public void setIdCliente(int idCliente) {
        this.idCliente = idCliente;
    }

    public Timestamp getFechaReserva() {
        return fechaReserva;
    }

    public void setFechaReserva(Timestamp fechaReserva) {
        this.fechaReserva = fechaReserva;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getPagoReferencia() {
        return pagoReferencia;
    }

    public void setPagoReferencia(String pagoReferencia) {
        this.pagoReferencia = pagoReferencia;
    }
}
