package com.homeclothing.api.model;

import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public class Favorito {

    private int idFavorito;

    @NotNull
    private int idUsuario;

    @NotNull
    private int idPrenda;

    private LocalDateTime fechaAdd;

    // Constructor vacío
    public Favorito() {
    }

    // Getters y Setters

    public int getIdFavorito() {
        return idFavorito;
    }

    public void setIdFavorito(int idFavorito) {
        this.idFavorito = idFavorito;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdPrenda() {
        return idPrenda;
    }

    public void setIdPrenda(int idPrenda) {
        this.idPrenda = idPrenda;
    }

    public LocalDateTime getFechaAdd() {
        return fechaAdd;
    }

    public void setFechaAdd(LocalDateTime fechaAdd) {
        this.fechaAdd = fechaAdd;
    }

    @Override
    public String toString() {
        return "Favorito{" +
                "idFavorito=" + idFavorito +
                ", idUsuario=" + idUsuario +
                ", idPrenda=" + idPrenda +
                ", fechaAdd=" + fechaAdd +
                '}';
    }
}