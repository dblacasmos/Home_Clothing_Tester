package com.homeclothing.api.dao;

import com.homeclothing.api.model.DetalleCompra;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class DetalleCompraDao {

    private final JdbcTemplate jdbc;

    public DetalleCompraDao(JdbcTemplate jdbc) {
        this.jdbc = jdbc;
    }

    public List<DetalleCompra> allCamposDetalle() {
        String sql = "SELECT * FROM detallecompra";
        return jdbc.query(sql, new BeanPropertyRowMapper<>(DetalleCompra.class));
    }

    public int insertarDetalle(DetalleCompra detalle) {
        String sql = "INSERT INTO detallecompra (ID_COMPRA, ID_PRENDA, CANTIDAD, PRECIO_UNIDAD, SUBTOTAL) VALUES (?, ?, ?, ?, ?)";
        return jdbc.update(sql,
                detalle.getIdCompra(),
                detalle.getIdPrenda(),
                detalle.getCantidad(),
                detalle.getPrecioUnidad(),
                detalle.getSubtotal());
    }
}