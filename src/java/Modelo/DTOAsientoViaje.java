package Modelo;

public class DTOAsientoViaje {

    private int idAsientoViaje;
    private int idViaje;
    private int numeroAsiento;
    private int estado; // 0 disponible, 1 reservado, 2 ocupado
    private double precio;

    public DTOAsientoViaje() {
    }

    public DTOAsientoViaje(int idViaje, int numeroAsiento, double precio) {
        this.idViaje = idViaje;
        this.numeroAsiento = numeroAsiento;
        this.precio = precio;
        this.estado = 0;
    }

    public int getIdAsientoViaje() {
        return idAsientoViaje;
    }

    public void setIdAsientoViaje(int idAsientoViaje) {
        this.idAsientoViaje = idAsientoViaje;
    }

    public int getIdViaje() {
        return idViaje;
    }

    public void setIdViaje(int idViaje) {
        this.idViaje = idViaje;
    }

    public int getNumeroAsiento() {
        return numeroAsiento;
    }

    public void setNumeroAsiento(int numeroAsiento) {
        this.numeroAsiento = numeroAsiento;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }
}
