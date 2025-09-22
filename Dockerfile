# ========================
# Step 1: Build with Mandrel (JDK 21)
# ========================
FROM registry.access.redhat.com/quarkus/mandrel-for-jdk-21-rhel8 as build

# Instalar dependencias de Gradle (opcional: wrapper ya incluido en tu proyecto)
USER root
WORKDIR /workspace/app
COPY . .

# Compilar en modo nativo con Gradle
RUN ./gradlew build -x test -Dquarkus.native.container-build=true \
    && ./gradlew nativeCompile -x test

# ========================
# Step 2: Runtime in UBI9-minimal
# ========================
FROM registry.access.redhat.com/ubi9-minimal

# Instalar librerías mínimas necesarias en runtime
RUN microdnf install -y glibc zlib \
    && microdnf clean all

WORKDIR /app
COPY --from=build /workspace/app/build/native/nativeCompile/grpc-server /app/app

EXPOSE 9090
ENTRYPOINT ["./app"]

