package com.homeclothing.api.model;

import jakarta.validation.constraints.*;

public class Prenda {

    //Attributes
    private int idPrenda;
    @NotNull
    private int idCategoria;
    @NotNull
    private int idAdmin;
    @NotBlank
    @Size(max = 120)
    private String nombre;
    private String descripcion;
    @Min(0)
    private double precio;
    @Size(max = 5)
    private String talla;
    @Size(max = 30)
    private String color;
    @PositiveOrZero
    private int stockDisponible;
    private EstadoPrenda estadoPrenda;

    //Builder
    public Prenda() {
    }

    public int getIdPrenda() {
        return idPrenda;
    }

    //Getters & Setters
    public void setIdPrenda(int idPrenda) {
        this.idPrenda = idPrenda;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public int getIdAdmin() {
        return idAdmin;
    }

    public void setIdAdmin(int idAdmin) {
        this.idAdmin = idAdmin;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public double getPrecio() {
        return precio;
    }

    public void setPrecio(double precio) {
        this.precio = precio;
    }

    public String getTalla() {
        return talla;
    }

    public void setTalla(String talla) {
        this.talla = talla;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public int getStockDisponible() {
        return stockDisponible;
    }

    public void setStockDisponible(int stockDisponible) {
        this.stockDisponible = stockDisponible;
    }

    public EstadoPrenda getEstadoPrenda() {
        return estadoPrenda;
    }

    public void setEstadoPrenda(EstadoPrenda estadoPrenda) {
        this.estadoPrenda = estadoPrenda;
    }

    @Override
    public String toString() {
        return "Prenda{" +
                "idPrenda=" + idPrenda +
                ", nombre='" + nombre + '\'' +
                ", precio=" + precio +
                '}';
    }

    public enum EstadoPrenda {DISPONIBLE, RETIRADA, AGOTADA}
}
