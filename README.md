# Star Wars App

Star Wars App es una aplicación multiplataforma que permite a los usuarios explorar y descubrir personajes de la saga Star Wars.

---


## Características 🎯

- Soporte para múltiples entornos (desarrollo, staging, producción)
- Clean Architecture
- Patrón BLoC
- Inyección de Dependencias
- Pruebas Unitarias
- Multiplataforma (Web, Android, iOS)

### Prerrequisitos

### FVM

Recomiendo usar FVM para gestionar las versiones de Flutter.

"Flutter Version Management" permite usar versiones específicas de la SDK de Flutter en múltiples proyectos.

Instalar siguiendo la [guía oficial](https://fvm.app/docs/getting_started/installation/).

Para usarlo en el contexto de un proyecto, reemplazar el comando "flutter" por **"fvm flutter"** (o "dart" por **"fvm dart"**).

- Flutter SDK (3.24.0)
- Dart SDK (3.5.0)
- Android Studio / VS Code
- Git

### Instalación

1. Clonar el repositorio

```sh
git clone https://github.com/your-username/star-wars-app.git
```

2. Ingresar a la carpeta del proyecto

```sh
cd my-app
```

3. Instalar dependencias

```sh
fvm flutter pub get
```

4. Ejecutar comando para archivos autogenerados

```sh
fvm flutter pub run build_runner build
```

## Run 🚀

### Configuración en VS Code

Este proyecto incluye configuraciones de lanzamiento para VS Code. Para ejecutar la aplicación:

1. Abrir el proyecto en VS Code
2. Ir a Run and Debug(Ctrl+Shift+D)
3. Seleccionar la configuración deseada:
   - Launch development
   - Launch staging
   - Launch production
4. Presionar F5 o hacer clic en el botón Ejecutar

### Configuración en Android Studio

Para ejecución en Android Studio, se deben crear nuevas configuraciones de ejecución apuntando el `Dart Entrypoint` hacia `lib/main_development.dart`, por ejemplo.

