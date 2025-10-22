package com.homeclothing.api.model;

import java.time.LocalDateTime;

public class Sistema_RA {

    private int idSistemaRa;

    private int id_Usuario;

    private int id_Prenda;

    private LocalDateTime fecha;

    private String resultado;

    public Sistema_RA() {
    }

    // Getters y Setters
    public int getIdSistemaRa() { return idSistemaRa; }
    public void setIdSistemaRa(int idSistemaRa) { this.idSistemaRa = idSistemaRa; }

    public int getId_Usuario() { return id_Usuario; }
    public void setId_Usuario(int id_Usuario) { this.id_Usuario = id_Usuario; }

    public int getId_Prenda() { return id_Prenda; }
    public void setId_Prenda(int id_Prenda) { this.id_Prenda = id_Prenda; }

    public LocalDateTime getFecha() { return fecha; }
    public void setFecha(LocalDateTime fecha) { this.fecha = fecha; }

    public String getResultado() { return resultado; }
    public void setResultado(String resultado) { this.resultado = resultado; }
}