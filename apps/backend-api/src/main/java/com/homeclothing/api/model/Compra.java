package com.homeclothing.api.model;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.time.LocalDateTime;

public class Compra {

    private int idCompra;

    @NotNull
    private int idUsuario;

    private int idMetodoPago;

    private int idTransaccion;

    private LocalDateTime fechaCompra;

    @Positive
    private double totalCompra;

    @NotNull
    private EstadoCompra estadoCompra;

    // Constructor vacío
    public Compra() {
    }

    public int getIdCompra() {
        return idCompra;
    }

    // Getters y Setters

    public void setIdCompra(int idCompra) {
        this.idCompra = idCompra;
    }

    public int getIdUsuario() {
        return idUsuario;
    }

    public void setIdUsuario(int idUsuario) {
        this.idUsuario = idUsuario;
    }

    public int getIdMetodoPago() {
        return idMetodoPago;
    }

    public void setIdMetodoPago(int idMetodoPago) {
        this.idMetodoPago = idMetodoPago;
    }

    public int getIdTransaccion() {
        return idTransaccion;
    }

    public void setIdTransaccion(int idTransaccion) {
        this.idTransaccion = idTransaccion;
    }

    public LocalDateTime getFechaCompra() {
        return fechaCompra;
    }

    public void setFechaCompra(LocalDateTime fechaCompra) {
        this.fechaCompra = fechaCompra;
    }

    public double getTotalCompra() {
        return totalCompra;
    }

    public void setTotalCompra(double totalCompra) {
        this.totalCompra = totalCompra;
    }

    public EstadoCompra getEstadoCompra() {
        return estadoCompra;
    }

    public void setEstad_Compra(EstadoCompra estadoCompra) {
        this.estadoCompra = estadoCompra;
    }

    @Override
    public String toString() {
        return "Compra{" +
                "  idCompra=" + idCompra +
                ", idUsuario=" + idUsuario +
                ", idMetodoPago=" + idMetodoPago +
                ", idTransaccion=" + idTransaccion +
                ", fechaCompra=" + fechaCompra +
                ", totalCompra=" + totalCompra +
                ", estadoCompra=" + estadoCompra +
                '}';
    }

    // Enum para estado de compra
    public enum EstadoCompra {
        PAGADA,
        PENDIENTE,
        CANCELADA
    }
}