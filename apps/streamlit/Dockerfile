FROM python:3.10-slim

WORKDIR /app

# Copia el requirements y instálalo
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia los secretos
COPY .streamlit/ .streamlit/

# Copia el resto del código
COPY app/ app/
# Exponer el puerto de Streamlit
EXPOSE 8501

# Arrancar Streamlit en 0.0.0.0:8501
CMD ["streamlit", "run", "./app/streamlit-dashboard.py", \
     "--server.port=8501", "--server.address=0.0.0.0"]
