# 🏗️ Arquitectura de EasyPet Mobile

## 📁 Estructura de Directorios

```
lib/
├── core/                          # Funcionalidades compartidas
│   ├── config/                   # Configuraciones
│   ├── models/                   # Modelos compartidos
│   ├── navigation/               # Navegación principal
│   │   ├── main_navigation.dart  # NavBar principal
│   │   └── main_navigation.dev.dart
│   ├── services/                 # Servicios compartidos
│   ├── utils/                    # Utilidades
│   └── widgets/                  # Widgets reutilizables
│       └── custom_bottom_nav_bar.dart
├── features/                     # Funcionalidades específicas
│   ├── auth/                     # Autenticación
│   ├── dashboard/                # Pantalla principal
│   │   ├── screens/
│   │   │   ├── dashboard_screen.dart
│   │   │   └── dashboard_screen.dev.dart
│   │   └── controllers/
│   ├── pets/                     # Gestión de mascotas
│   ├── appointments/             # Citas
│   ├── veterinarians/            # Veterinarios
│   ├── medical_centers/          # Centros médicos
│   ├── medications/              # Medicamentos
│   ├── ratings/                  # Calificaciones
│   └── profile/                  # Perfil del usuario
│       ├── screens/
│       │   ├── profile_screen.dart
│       │   └── password_screen.dart
│       └── controllers/
│           ├── configuration_controller.dart
│           ├── configuration_controller.dev.dart
│           ├── password_controller.dart
│           └── password_controller.dev.dart
├── shared/                       # Recursos compartidos
│   ├── themes/
│   │   └── app_theme.dart       # Temas centralizados
│   ├── constants/
│   │   └── app_constants.dart   # Constantes de la app
│   ├── assets/                   # Imágenes, iconos, etc.
│   └── localizations/            # Traducciones
├── main.dart                     # Punto de entrada principal
└── main.dev.dart                 # Punto de entrada desarrollo
```

## 🔄 Cambios Realizados

### **1. Reorganización de Features:**
- **`home/`** → **`dashboard/`**: Pantalla principal más descriptiva
- **`updateUserInfo/`** → **`profile/`**: Agrupación lógica del perfil
- **`updatePassword/`** → **`profile/`**: Parte del perfil del usuario

### **2. Separación de Responsabilidades:**
- **`core/navigation/`**: Solo maneja navegación entre features
- **`features/dashboard/`**: Solo muestra contenido de bienvenida
- **`features/profile/`**: Solo maneja información del usuario

### **3. Recursos Centralizados:**
- **`shared/themes/`**: Temas y estilos centralizados
- **`shared/constants/`**: Constantes de la aplicación
- **`shared/assets/`**: Recursos compartidos

## 🎯 Beneficios de la Nueva Arquitectura

1. **Claridad**: Cada directorio tiene una responsabilidad específica
2. **Mantenibilidad**: Más fácil encontrar y modificar código
3. **Escalabilidad**: Estructura preparada para crecer
4. **Consistencia**: Patrones claros para nuevos desarrolladores
5. **Separación de responsabilidades**: Navegación separada del contenido

## 🚀 Uso de la Nueva Estructura

### **Navegación Principal:**
```dart
import 'package:easypet/core/navigation/main_navigation.dart';

// Usar MainNavigation como pantalla principal
```

### **Dashboard:**
```dart
import 'package:easypet/features/dashboard/screens/dashboard_screen.dart';

// Pantalla de bienvenida con título y logout
```

### **Perfil:**
```dart
import 'package:easypet/features/profile/screens/profile_screen.dart';
import 'package:easypet/features/profile/screens/password_screen.dart';

// Pantallas de configuración y cambio de contraseña
```

### **Temas:**
```dart
import 'package:easypet/shared/themes/app_theme.dart';

// Usar AppTheme.lightTheme o AppTheme.devTheme
```

### **Constantes:**
```dart
import 'package:easypet/shared/constants/app_constants.dart';

// Usar AppConstants.appTitle, etc.
```

## 📝 Notas Importantes

- **Imports**: Todos los imports han sido actualizados para usar las nuevas rutas
- **Controladores**: Los controladores se mantienen en sus respectivas features
- **Desarrollo**: Se mantienen las versiones de desarrollo (.dev.dart)
- **Compatibilidad**: La funcionalidad se mantiene igual, solo cambia la organización

## 🔧 Mantenimiento

Para agregar nuevas features:
1. Crear directorio en `features/`
2. Seguir la estructura: `screens/`, `controllers/`, etc.
3. Actualizar `main_navigation.dart` si es necesario
4. Usar los temas y constantes centralizados

Para modificar estilos:
1. Editar `shared/themes/app_theme.dart`
2. Los cambios se aplicarán automáticamente en toda la app
