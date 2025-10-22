package com.homeclothing.api.model;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class Administrador {

    // Atributos
    private int idAdmin;

    @Size(max = 120)
    private String nombreAdmin;

    @NotBlank
    @Size(max = 100)
    @Email
    private String correoAdmin;

    @NotBlank
    @Size(max = 50)
    private String password;

    @NotBlank
    @Size(max = 40)
    private String rol;

    // Constructor vacío
    public Administrador() {
    }

    // Getters y setters

    public int getIdAdmin() {
        return idAdmin;
    }

    public void setIdAdmin(int idAdmin) {
        this.idAdmin = idAdmin;
    }

    public String getNombreAdmin() {
        return nombreAdmin;
    }

    public void setNombreAdmin(String nombreAdmin) {
        this.nombreAdmin = nombreAdmin;
    }

    public String getCorreoAdmin() {
        return correoAdmin;
    }

    public void setCorreoAdmin(String correoAdmin) {
        this.correoAdmin = correoAdmin;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRol() {
        return rol;
    }

    public void setRol(String rol) {
        this.rol = rol;
    }

    @Override
    public String toString() {
        return "Administrador{" +
                "idAdmin=" + idAdmin +
                ", nombreAdmin='" + nombreAdmin + '\'' +
                ", correoAdmin='" + correoAdmin + '\'' +
                ", password='********'" +
                ", rol='" + rol + '\'' +
                '}';
    }
}