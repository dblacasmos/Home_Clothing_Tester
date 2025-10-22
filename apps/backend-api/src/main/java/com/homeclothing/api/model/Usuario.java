package com.homeclothing.api.model;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public class Usuario {

    private int idUsuario;

    @NotNull
    private int idAdmin;

    @Size(max = 120)
    private String nombreUsuario;

    @NotBlank
    @Size(max = 100)
    @Email
    private String correoUsuario;

    @NotBlank
    @Size(max = 50)
    private String password;

    @NotNull
    private Estado estado;

    // Constructor vacío
    public Usuario() {
    }

    // Constructor completo
    public Usuario(int idUsuario, String nombreUsuario, String correoUsuario, String password, Estado estado) {
        this.idUsuario = idUsuario;
        this.nombreUsuario = nombreUsuario;
        this.correoUsuario = correoUsuario;
        this.password = password;
        this.estado = estado;
    }

    // Getters y Setters
    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdAdmin() {
        return idAdmin;
    }

    public void setIdAdmin(int idAdmin) {
        this.idAdmin = idAdmin;
    }

    public String getNombreUsuario() {
        return nombreUsuario;
    }

    public void setNombreUsuario(String nombreUsuario) {
        this.nombreUsuario = nombreUsuario;
    }

    public String getCorreoUsuario() {
        return correoUsuario;
    }

    public void setCorreoUsuario(String correoUsuario) {
        this.correoUsuario = correoUsuario;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Estado getEstado() {
        return estado;
    }

    public void setEstado(Estado estado) {
        this.estado = estado;
    }

    @Override
    public String toString() {
        return "Usuario{" +
                "idUsuario=" + idUsuario +
                ", idAdmin=" + idAdmin +
                ", nombreUsuario='" + nombreUsuario + '\'' +
                ", correoUsuario='" + correoUsuario + '\'' +
                ", password='********'" +
                ", estado=" + estado +
                '}';
    }

    // Enum para el estado del usuario
    public enum Estado {
        ACTIVO,
        BLOQUEADO,
        INACTIVO
    }
}