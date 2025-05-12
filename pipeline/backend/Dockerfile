# Build fázis átmeneti image
# A build fázisban a dotnet/sdk:7.0 image-t használjuk
# A dotnet/sdk:7.0 image tartalmazza a .NET SDK 7.0 verzióját
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /source

# Restore csomagok
COPY *.csproj .
RUN dotnet restore

# Másolás és publikálás
COPY . .
RUN dotnet publish -c Release -o /app

# Futtatási image készítése
# A dotnet/aspnet:7.0 image használata a buildelt fájlok futtatására
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app ./

# Környezeti változók
ENV ASPNETCORE_URLS=http://+:80
ENV ASPNETCORE_ENVIRONMENT=Production

EXPOSE 80

ENTRYPOINT ["dotnet", "MyBackendApp.dll"]