package com.homeclothing.api.model;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;

public class Comentario {

    private int idComentario;

    @NotNull
    private int idUsuario;

    private int idPrenda;

    @Size(max = 1000)
    private String contenido;

    @Min(1)
    @Max(5)
    private int calificacion;

    private LocalDateTime fechaComentario;

    // Constructor vacío
    public Comentario() {
    }

    // Getters y Setters

    public int getIdComentario() {
        return idComentario;
    }

    public void setIdComentario(int idComentario) {
        this.idComentario = idComentario;
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

    public String getContenido() {
        return contenido;
    }

    public void setContenido(String contenido) {
        this.contenido = contenido;
    }

    public int getCalificacion() {
        return calificacion;
    }

    public void setCalificacion(int calificacion) {
        this.calificacion = calificacion;
    }

    public LocalDateTime getFechaComentario() {
        return fechaComentario;
    }

    public void setFechaComentario(LocalDateTime fechaComentario) {
        this.fechaComentario = fechaComentario;
    }

    @Override
    public String toString() {
        return "Comentario{" +
                "  idComentario=" + idComentario +
                ", idUsuario=" + idUsuario +
                ", idPrenda=" + idPrenda +
                ", contenido='" + contenido + '\'' +
                ", calificacion=" + calificacion +
                ", fechaComentario=" + fechaComentario +
                '}';
    }
}