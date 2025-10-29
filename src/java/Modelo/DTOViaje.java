package Modelo;

import java.sql.Date;
import java.sql.Time;

public class DTOViaje {

    private int idViaje;
    private int idBus;
    private int idChofer;
    private int origen_id;
    private int destino_id;
    private Date fechaSalida;
    private Time horaSalida;
    private Integer duracionMin;
    private double precio;
    private int estado;

    // nuevo campo
    private int disponibles;

    public DTOViaje() {
    }

    public DTOViaje(int idBus, int idChofer, int origen_id, int destino_id,
            Date fechaSalida, Time horaSalida, Integer duracionMin, double precio) {
        this.idBus = idBus;
        this.idChofer = idChofer;
        this.origen_id = origen_id;
        this.destino_id = destino_id;
        this.fechaSalida = fechaSalida;
        this.horaSalida = horaSalida;
        this.duracionMin = duracionMin;
        this.precio = precio;
        this.estado = 1;
    }

    // getters y setters completos
    public int getIdViaje() {
        return idViaje;
    }

    public void setIdViaje(int idViaje) {
        this.idViaje = idViaje;
    }

    public int getIdBus() {
        return idBus;
    }

    public void setIdBus(int idBus) {
        this.idBus = idBus;
    }

    public int getIdChofer() {
        return idChofer;
    }

    public void setIdChofer(int idChofer) {
        this.idChofer = idChofer;
    }

    public int getOrigen_id() {
        return origen_id;
    }

    public void setOrigen_id(int origen_id) {
        this.origen_id = origen_id;
    }

    public int getDestino_id() {
        return destino_id;
    }

    public void setDestino_id(int destino_id) {
        this.destino_id = destino_id;
    }

    public Date getFechaSalida() {
        return fechaSalida;
    }

    public void setFechaSalida(Date fechaSalida) {
        this.fechaSalida = fechaSalida;
    }

    public Time getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(Time horaSalida) {
        this.horaSalida = horaSalida;
    }

    public Integer getDuracionMin() {
        return duracionMin;
    }

    public void setDuracionMin(Integer duracionMin) {
        this.duracionMin = duracionMin;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    // disponibles
    public int getDisponibles() {
        return disponibles;
    }

    public void setDisponibles(int disponibles) {
        this.disponibles = disponibles;
    }
}
