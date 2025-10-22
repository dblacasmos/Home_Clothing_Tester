package com.homeclothing.api.dao;

import com.homeclothing.api.model.Compra;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class CompraDao {

    private final JdbcTemplate jdbc;

    public CompraDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<Compra> allCamposCompra() {
        String sql = "SELECT * FROM compra";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(Compra.class));
    }

    public int insertarCompra(Compra compra) {
        String sql = "INSERT INTO compra (ID_USUARIO, ID_METODOPAGO, ID_TRANSACCION, FECHA_COMPRA, TOTAL_COMPRA, ESTADO_COMPRA) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbc.update(sql,
                compra.getIdUsuario(),
                compra.getIdMetodoPago(),
                compra.getIdTransaccion(),
                compra.getFechaCompra(),
                compra.getTotalCompra(),
                compra.getEstadoCompra().toString());
    }
}