# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:10.0-alpine AS build
RUN apk update && apk upgrade
WORKDIR /src

# Copy all source (including submodules in modules folder)
COPY . .

# Build and publish
WORKDIR "/src/GatewayApi"
RUN dotnet publish "GatewayApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0-alpine AS final
RUN apk update && apk upgrade
WORKDIR /app

# Use built-in non-root user for security
USER app

# Copy artifacts
COPY --from=build /app/publish .

# Environment variables
ENV ASPNETCORE_URLS=http://+:8080

EXPOSE 8080

ENTRYPOINT ["dotnet", "GatewayApi.dll"]
