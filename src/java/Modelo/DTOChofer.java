package Modelo;

import java.io.Serializable;
import java.util.Date;

public class DTOChofer implements Serializable {

    private static final long serialVersionUID = 1L;

    // campo principal (tu DAO usa setId/ getId)
    private int id;

    private String appat;
    private String apmat;
    private String nombre;
    private int dni;
    private String licenciaConducir;
    private Date fechaContratacion;
    private Date fechaVencimientoLicencia;
    private int telefono;
    private int disponibilidad;
    private int estado;

    public DTOChofer() {
    }

    // --- id getters / setters compatibles ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    // alias para JSP/EL que espera idChofer
    public int getIdChofer() {
        return id;
    }

    public void setIdChofer(int idChofer) {
        this.id = idChofer;
    }

    // --- otros getters / setters ---
    public String getAppat() {
        return appat;
    }

    public void setAppat(String appat) {
        this.appat = appat;
    }

    public String getApmat() {
        return apmat;
    }

    public void setApmat(String apmat) {
        this.apmat = apmat;
    }

    // Este es el getter que usan tus JSP: ${c.nombre}
    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public int getDni() {
        return dni;
    }

    public void setDni(int dni) {
        this.dni = dni;
    }

    public String getLicenciaConducir() {
        return licenciaConducir;
    }

    public void setLicenciaConducir(String licenciaConducir) {
        this.licenciaConducir = licenciaConducir;
    }

    public Date getFechaContratacion() {
        return fechaContratacion;
    }

    public void setFechaContratacion(Date fechaContratacion) {
        this.fechaContratacion = fechaContratacion;
    }

    public Date getFechaVencimientoLicencia() {
        return fechaVencimientoLicencia;
    }

    public void setFechaVencimientoLicencia(Date fechaVencimientoLicencia) {
        this.fechaVencimientoLicencia = fechaVencimientoLicencia;
    }

    public int getTelefono() {
        return telefono;
    }

    public void setTelefono(int telefono) {
        this.telefono = telefono;
    }

    public int getDisponibilidad() {
        return disponibilidad;
    }

    public void setDisponibilidad(int disponibilidad) {
        this.disponibilidad = disponibilidad;
    }

    public int getEstado() {
        return estado;
    }

    public void setEstado(int estado) {
        this.estado = estado;
    }

    // utilidad: nombre completo
    public String getNombreCompleto() {
        StringBuilder sb = new StringBuilder();
        if (appat != null && !appat.isEmpty()) {
            sb.append(appat).append(" ");
        }
        if (apmat != null && !apmat.isEmpty()) {
            sb.append(apmat).append(" ");
        }
        if (nombre != null) {
            sb.append(nombre);
        }
        return sb.toString().trim();
    }
}
