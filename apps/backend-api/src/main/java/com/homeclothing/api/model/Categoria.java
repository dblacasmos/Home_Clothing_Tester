package com.homeclothing.api.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class Categoria {

    private int idCategoria;

    @NotBlank
    @Size(max = 100)
    private String nombreCategoria;

    @Size(max = 255)
    private String descripcion;

    // Constructor vacío
    public Categoria() {
    }

    // Getters y Setters

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNombreCategoria() {
        return nombreCategoria;
    }

    public void setNombreCategoria(String nombreCategoria) {
        this.nombreCategoria = nombreCategoria;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    @Override
    public String toString() {
        return "Categoria{" +
                "idCategoria=" + idCategoria +
                ", nombreCategoria='" + nombreCategoria + '\'' +
                ", descripcion='" + descripcion + '\'' +
                '}';
    }
}