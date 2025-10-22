package com.homeclothing.api.model;

import jakarta.validation.constraints.NotNull;

import java.time.LocalDateTime;

public class SistemaPago {

    private int idTransaccion;

    private LocalDateTime fechaTransaccion;

    @NotNull
    private EstadoTransaccion estadoTransaccion;

    // Constructor vacío
    public SistemaPago() {
    }

    public int getIdTransaccion() {
        return idTransaccion;
    }

    // Getters y Setters

    public void setIdTransaccion(int idTransaccion) {
        this.idTransaccion = idTransaccion;
    }

    public LocalDateTime getFechaTransaccion() {
        return fechaTransaccion;
    }

    public void setFechaTransaccion(LocalDateTime fechaTransaccion) {
        this.fechaTransaccion = fechaTransaccion;
    }

    public EstadoTransaccion getEstadoTransaccion() {
        return estadoTransaccion;
    }

    public void setEstadoTransaccion(EstadoTransaccion estadoTransaccion) {
        this.estadoTransaccion = estadoTransaccion;
    }

    @Override
    public String toString() {
        return "SistemaPago{" +
                "idTransaccion=" + idTransaccion +
                ", fechaTransaccion=" + fechaTransaccion +
                ", estadoTransaccion=" + estadoTransaccion +
                '}';
    }

    // Enum para estado de la transacción
    public enum EstadoTransaccion {
        PENDIENTE,
        APROBADA,
        RECHAZADA
    }
}