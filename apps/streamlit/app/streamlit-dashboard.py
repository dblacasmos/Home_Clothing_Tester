import os
import socket
import time
import pandas as pd
import streamlit as st
from matplotlib import pyplot as plt
from sqlalchemy import create_engine, text

st.title("Dashboard Home Clothing Tester")


def wait_for_mysql(host, port, timeout=30):
    start_time = time.time()
    while time.time() - start_time < timeout:
        try:
            with socket.create_connection((host, port), timeout=2):
                return True
        except OSError:
            time.sleep(1)
    return False


# Esperar a MySQL antes de continuar
if not wait_for_mysql("mysql", 3306):
    st.error("No se pudo conectar a MySQL. Asegúrate de que el servicio esté activo.")
    st.stop()


@st.cache_resource
def get_engine():
    host = os.getenv("DB_HOST", "mysql")
    port = os.getenv("DB_PORT", "3306")
    db   = os.getenv("DB_NAME", "home_clothing_tester")
    user = os.getenv("DB_USER", "root")
    pwd  = os.getenv("DB_PASS", "")

    if not pwd:
        raise RuntimeError("DB password missing: expected env var DB_PASS")

    return create_engine(
        f"mysql+pymysql://{user}:{pwd}@{host}:{port}/{db}",
        pool_pre_ping=True
    )


def main():
    engine = get_engine()

    # Verificar conexión
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
    except Exception as e:
        st.error(f"Error conectando a la base de datos: {e}")
        st.stop()

    # Mostrar catálogo disponible
    st.header("Prendas Disponibles")
    query_catalogo = "SELECT * FROM view_prendas_disponibles"
    df_catalogo = pd.read_sql(query_catalogo, engine)
    st.dataframe(df_catalogo)

    # Mostrar ventas por categoría
    st.header("Ventas por Categoría")
    query_ventas = "SELECT * FROM view_ventas_por_categoria"
    ventas_df = pd.read_sql(query_ventas, engine)

    if ventas_df.empty:
        st.warning("No hay datos de ventas por categoría para mostrar.")
    else:
        fig, ax = plt.subplots(figsize=(10, 6))
        categorias = ventas_df['NOMBRE_CATEGORIA']
        ingresos = ventas_df['INGRESOS_TOTALES']

        ax.bar(categorias, ingresos)
        ax.set_ylabel('Ingresos Totales')
        ax.set_xlabel('Categoría')
        ax.set_title('Ingresos por Categoría')
        plt.xticks(rotation=45, ha='right')
        st.pyplot(fig)


if __name__ == "__main__":
    main()
