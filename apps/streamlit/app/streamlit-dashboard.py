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


if not wait_for_mysql("mysql", 3306):
    st.error("No se pudo conectar a MySQL. Asegúrate de que el servicio esté activo.")
    st.stop()


@st.cache_resource
def get_engine():
    return create_engine("mysql+pymysql://root:@mysql:3306/home_clothing_tester")


def main():
    engine = get_engine()

    # Verificamos si se puede hacer una conexión
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
    except Exception as e:
        st.error(f"Error conectando a la base de datos: {e}")
        st.stop()

    # Mostrar catálogo disponible
    query_catalogo = "SELECT * FROM view_prendas_disponibles"
    df_catalogo = pd.read_sql(query_catalogo, engine)

    st.header("Prendas Disponibles")
    st.dataframe(df_catalogo)

    # Mostrar ventas por categoría con gráfico
    st.header("Ventas por Categoría")
    query_ventas = "SELECT * FROM view_ventas_por_categoria"
    ventas_df = pd.read_sql(query_ventas, engine)

    if ventas_df.empty:
        st.warning("No hay datos de ventas por categoría para mostrar.")
    else:
        # Gráfico de barras con matplotlib
        fig, ax = plt.subplots(figsize=(10, 6))
        categorias = ventas_df['NOMBRE_CATEGORIA']
        ingresos = ventas_df['INGRESOS_TOTALES']

        ax.bar(categorias, ingresos)
        ax.set_ylabel('Ingresos Totales')
        ax.set_xlabel('Categoría')
        ax.set_title('Ingresos por Categoría')
        plt.xticks(rotation=45, ha='right')
        st.pyplot(fig)


if __name__ == '__main__':
    main()