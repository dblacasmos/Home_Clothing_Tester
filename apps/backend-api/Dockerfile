# Etapa 1: Compilar el proyecto con Maven
FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /app

# Copia pom.xml y descarga dependencias
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copia el código fuente
COPY . .

# Compila y empaqueta el JAR
RUN mvn clean package -DskipTests

# Etapa 2: Crear imagen liviana solo con el JAR
FROM eclipse-temurin:21-jdk

WORKDIR /app

# Copiar el JAR compilado desde la etapa anterior
COPY --from=builder /app/target/backend-api-1.0-SNAPSHOT.jar app.jar

# Exponer el puerto de la aplicación
EXPOSE 8080

# Lanzar la aplicación al iniciar el contenedor
ENTRYPOINT ["java","-jar","app.jar"]