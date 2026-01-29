# Multi-stage build para otimizar o tamanho da imagem

# Estágio 1: Build da aplicação
# Trocamos para a versão sem 'alpine' para funcionar no Mac M1/M2/M3
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copia o pom.xml
COPY pom.xml .

# Baixa as dependências
RUN mvn dependency:go-offline -B

# Copia o código fonte
COPY src ./src

# Compila a aplicação
RUN mvn clean package -DskipTests

# Estágio 2: Imagem de runtime
# Também trocamos aqui para manter compatibilidade
FROM eclipse-temurin:17-jre

WORKDIR /app

# Cria usuário não-root (segurança)
RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring:spring

# Copia o JAR compilado do estágio anterior
COPY --from=builder /app/target/*.jar app.jar

# Expõe a porta padrão
EXPOSE 8080

# Configurações de JVM otimizadas
ENV JAVA_OPTS="-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0 -Djava.security.egd=file:/dev/./urandom"

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD java -version || exit 1

# Executa a aplicação
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]