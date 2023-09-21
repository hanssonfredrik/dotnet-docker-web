# syntax=docker/dockerfile:1

FROM mcr.microsoft.com/dotnet/sdk:7.0 as build-env
WORKDIR /src
COPY src/*.csproj .
RUN dotnet restore
COPY src .
RUN dotnet publish -c Release -o /publish

FROM mcr.microsoft.com/dotnet/aspnet:7.0 as runtime
WORKDIR /publish
COPY --from=build-env /publish .

# Divio
# --------------------
ENV PORT=80
ENV HOST=0.0.0.0
ENV BROWSER='none'

EXPOSE 80

# Azure Container Apps
# --------------------
# EXPOSE 3500
# ENV ASPNETCORE_URLS=http://+:3500

ENTRYPOINT ["dotnet", "dotnet-docker-web.dll"]
