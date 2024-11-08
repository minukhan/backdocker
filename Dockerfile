# 1단계: Build Stage
FROM gradle:7.5.1-jdk17 AS builder
WORKDIR /app

# 프로젝트 소스를 컨테이너로 복사
COPY . .

# Gradle로 프로젝트 빌드
RUN ./gradlew clean build -x test

# 2단계: Runtime Stage
FROM openjdk:17-jdk-slim
WORKDIR /app

# 빌드된 JAR 파일을 복사
COPY --from=builder /app/build/libs/*.jar app.jar

# secret.yml 파일 복사
COPY --from=builder /app/src/main/resources/secret.yml /app/src/main/resources/secret.yml

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
