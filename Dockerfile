FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY "ApiMinimal.csproj" .
RUN dotnet restore "ApiMinimal.csproj"
COPY . .
WORKDIR /src
RUN dotnet build "./ApiMinimal.csproj" -c $BUILD_CONFIGURATION -o app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "ApiMinimal.csproj" -c $BUILD_CONFIGURATION -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet", "ApiMinimal.dll"]