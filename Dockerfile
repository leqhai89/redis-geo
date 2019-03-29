FROM microsoft/dotnet:sdk AS build-env
COPY src /app
WORKDIR /app
COPY src/NuGet.Config /root/.nuget/NuGet/

RUN dotnet restore
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/aspnetcore:2.0
WORKDIR /app
COPY --from=build-env /app/RedisGeo/out .
ENV ASPNETCORE_URLS http://*:5000
ENTRYPOINT ["dotnet", "RedisGeo.dll"]
