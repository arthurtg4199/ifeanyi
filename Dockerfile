FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5206

ENV ASPNETCORE_URLS=http://+:5206

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["ifeanyi.csproj", "./"]
RUN dotnet restore "ifeanyi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ifeanyi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ifeanyi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ifeanyi.dll"]
