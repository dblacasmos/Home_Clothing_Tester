package com.homeclothing.api.model;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public class DetalleCompra {

    private int idDetalleCompra;

    @NotNull
    private int idCompra;

    @NotNull
    private int idPrenda;

    @Positive
    private int cantidad;

    @Positive
    private double precioUnidad;

    private double subtotal;

    // Constructor vacío
    public DetalleCompra() {
    }

    // Getters y Setters

    public int getIdDetalleCompra() {
        return idDetalleCompra;
    }

    public void setIdDetalleCompra(int idDetalleCompra) {
        this.idDetalleCompra = idDetalleCompra;
    }

    public int getIdCompra() {
        return idCompra;
    }

    public void setIdCompra(int idCompra) {
        this.idCompra = idCompra;
    }

    public int getIdPrenda() {
        return idPrenda;
    }

    public void setIdPrenda(int idPrenda) {
        this.idPrenda = idPrenda;
    }

    public int getCantidad() {
        return cantidad;
    }

    public void setCantidad(int cantidad) {
        this.cantidad = cantidad;
        calcularSubtotal();
    }

    public double getPrecioUnidad() {
        return precioUnidad;
    }

    public void setPrecioUnidad(double precioUnidad) {
        this.precioUnidad = precioUnidad;
        calcularSubtotal();
    }

    public double getSubtotal() {
        return subtotal;
    }

    private void calcularSubtotal() {
        this.subtotal = Math.round(cantidad * precioUnidad * 100.0) / 100.0;
    }

    @Override
    public String toString() {
        return "DetalleCompra{" +
                "idDetalleCompra=" + idDetalleCompra +
                ", idCompra=" + idCompra +
                ", idPrenda=" + idPrenda +
                ", cantidad=" + cantidad +
                ", precioUnidad=" + precioUnidad +
                ", subtotal=" + subtotal +
                '}';
    }
}