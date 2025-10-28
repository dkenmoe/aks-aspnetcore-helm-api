# Étape 1 : build
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
# Le répertoire de travail est /src
WORKDIR /src

# Copier les fichiers .csproj et .sln seuls pour l'étape de 'restore'.
# Comme vous êtes dans le répertoire du projet, les fichiers sont à la racine ('.') du contexte de build.
# Le '.' dans la cible signifie 'ici' (dans le conteneur, soit /src).
COPY MyTestApi.csproj ./
# Si votre solution est bien dans le même dossier que le projet, vous pouvez laisser le *.sln (mais ce n'est pas nécessaire pour le restore si le csproj est copié en premier)
COPY *.sln ./ 

# Restaurer les dépendances.
RUN dotnet restore

# Copier le reste du code (Program.cs, Controllers, etc.)
COPY . .

# Publier l'application.
# Note : on publie directement depuis le répertoire de travail (/src) puisque le .csproj y a été copié.
RUN dotnet publish -c Release -o /app/publish

# Étape 2 : runtime
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
# Configuration du port
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "MyTestApi.dll"]