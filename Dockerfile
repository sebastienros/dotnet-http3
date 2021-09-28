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

RUN if [ "$(uname -m)" != "aarch64" ] ; then curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add - ; fi
RUN if [ "$(uname -m)" != "aarch64" ] ; then apt-add-repository https://packages.microsoft.com/debian/11/prod ; fi
RUN if [ "$(uname -m)" != "aarch64" ] ; then apt-get update && apt-get install -y --no-install-recommends libmsquic ; fi

ENTRYPOINT ["dotnet", "dotnet-http3.dll"]
