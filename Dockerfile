# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.* ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build-env /app/out .

# Install libmsquic dependencies
RUN apt update \
    && apt install -y --no-install-recommends \
        curl \
        wget \
        gnupg2 \
        software-properties-common

RUN curl -O https://packages.microsoft.com/debian/10/prod/pool/main/libm/libmsquic/libmsquic-1.5.0-amd64.deb
RUN dpkg -i libmsquic-1.5.0-amd64.deb

ENTRYPOINT ["dotnet", "dotnet-http3.dll"]
