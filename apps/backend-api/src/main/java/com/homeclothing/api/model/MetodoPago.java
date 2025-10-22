package com.homeclothing.api.model;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class MetodoPago {

    private int idMetodoPago;

    @NotBlank
    @Size(max = 50)
    private String formaPago;

    @Size(max = 255)
    private String detalles;

    // Constructor vacío
    public MetodoPago() {
    }

    // Getters y Setters

    public int getIdMetodoPago() {
        return idMetodoPago;
    }

    public void setIdMetodoPago(int idMetodoPago) {
        this.idMetodoPago = idMetodoPago;
    }

    public String getFormaPago() {
        return formaPago;
    }

    public void setFormaPago(String formaPago) {
        this.formaPago = formaPago;
    }

    public String getDetalles() {
        return detalles;
    }

    public void setDetalles(String detalles) {
        this.detalles = detalles;
    }

    @Override
    public String toString() {
        return "MetodoPago{" +
                "idMetodoPago=" + idMetodoPago +
                ", formaPago='" + formaPago + '\'' +
                ", detalles='" + detalles + '\'' +
                '}';
    }
}