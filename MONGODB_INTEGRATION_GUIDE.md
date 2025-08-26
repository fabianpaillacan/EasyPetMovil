# Guía de Integración con MongoDB - EasyPet Móvil

## Descripción General

Esta guía explica cómo la aplicación móvil de EasyPet extrae y edita información de usuarios almacenada en MongoDB a través de microservicios.

## Arquitectura del Sistema

```
App Móvil (Flutter) → ConfigurationController → UserService → API Gateway → Servicio Usuario → MongoDB
```

## Flujo de Datos

### 1. Extracción de Datos (GET)

**Endpoint:** `GET /users/user/information`

**Flujo:**
1. Usuario abre pantalla de configuración
2. `ConfigurationController.getConfigUser()` se ejecuta
3. Se obtiene token de Firebase Auth
4. `UserService.getUserInfo()` hace petición HTTP
5. Backend consulta MongoDB y devuelve datos
6. Datos se mapean del formato backend al formato móvil

**Mapeo de Campos:**
```dart
// Backend devuelve:
{
  "user": {
    "name": "Juan",
    "last_name": "Pérez",
    "birth_date": "1990-01-01",
    "email": "juan@example.com",
    "phone": "912345678",
    "gender": "Masculino"
  }
}

// App móvil recibe:
{
  "first_name": "Juan",        // ← name del backend
  "last_name": "Pérez",        // ← last_name del backend
  "birth_date": "1990-01-01",  // ← birth_date del backend
  "email": "juan@example.com", // ← email del backend
  "phone": "912345678",        // ← phone del backend
  "gender": "Masculino"        // ← gender del backend
}
```

### 2. Edición de Datos (PUT)

**Endpoint:** `PUT /users/user/update`

**Flujo:**
1. Usuario modifica campos y presiona "Guardar Cambios"
2. `ConfigurationController.updateConfigUser()` se ejecuta
3. Se validan los datos antes de enviar
4. `UserService.updateUserInfo()` hace petición HTTP
5. Backend actualiza MongoDB
6. Se confirma la actualización

**Mapeo de Campos:**
```dart
// App móvil envía:
{
  "first_name": "Juan",
  "last_name": "Pérez",
  "birth_date": "1990-01-01",
  "phone": "912345678",
  "gender": "Masculino"
}

// Backend recibe:
{
  "name": "Juan",              // ← first_name de la app
  "last_name": "Pérez",        // ← last_name de la app
  "birth_date": "1990-01-01",  // ← birth_date de la app
  "phone": "912345678",        // ← phone de la app
  "gender": "Masculino"        // ← gender de la app
}
```

## Campos Soportados

### Campos Editables:
- **first_name** → `name` en MongoDB
- **last_name** → `last_name` en MongoDB
- **birth_date** → `birth_date` en MongoDB
- **phone** → `phone` en MongoDB
- **gender** → `gender` en MongoDB

### Campos de Solo Lectura:
- **email** → No se puede modificar desde la app
- **rut** → **Campo sensible, NO editable** (solo se muestra)
- **user_id** → ID único del usuario
- **created_at** → Fecha de creación
- **updated_at** → Fecha de última actualización
- **is_active** → Estado del usuario
- **firebase_uid** → ID de Firebase (se preserva al actualizar)
- **veterinarian_id** → ID del veterinario asociado (se preserva al actualizar)

## Características de Seguridad

### Campos Sensibles Preservados:
- **firebase_uid**: Se mantiene al actualizar para preservar la autenticación
- **veterinarian_id**: Se mantiene al actualizar para preservar la relación
- **rut**: Se muestra pero NO se puede editar (dato sensible)

### Validaciones de Seguridad:
- Usuario debe estar autenticado en Firebase
- Token válido requerido para todas las operaciones
- Email no se puede modificar desde la app
- RUT es de solo lectura (campo bloqueado)

## Validaciones Implementadas

### 1. Validaciones de Campos:
- **Nombre y Apellido:** Requeridos, no pueden estar vacíos
- **Teléfono:** Formato chileno (9 dígitos)
- **Género:** Debe ser seleccionado

### 2. Validaciones de Seguridad:
- Usuario debe estar autenticado en Firebase
- Token válido requerido para todas las operaciones
- Email no se puede modificar desde la app

## Solución de Problemas

### Problema: Campos no se cargan
Si los campos `last_name`, `birth_date` o `gender` no se cargan:

1. **Verificar Backend:** Asegúrate de que el servicio de usuario esté corriendo
2. **Verificar Endpoint:** El endpoint debe ser `/users/user/information`
3. **Verificar Respuesta:** El backend debe devolver todos los campos en la estructura `{"user": {...}}`
4. **Verificar MongoDB:** Los datos deben existir en la base de datos

### Script de Prueba:
Usa el script `test_user_endpoints.py` para verificar que el backend esté funcionando:

```bash
python test_user_endpoints.py
```

## Manejo de Errores

### Errores Comunes:
1. **Usuario no autenticado:** Firebase Auth no tiene usuario activo
2. **Token inválido:** Token de Firebase expirado o inválido
3. **Datos inválidos:** Validación fallida en campos
4. **Error de conexión:** Problemas de red o servidor no disponible
5. **Error de MongoDB:** Problemas en la base de datos

### Respuestas de Error:
```dart
// Ejemplo de manejo de error
try {
  await ConfigurationController.updateConfigUser(data);
  // Éxito
} catch (e) {
  // Mostrar error al usuario
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Error: $e"))
  );
}
```

## Configuración del Entorno

### Desarrollo Local:
```dart
// environment.dart
static String get userServiceUrl {
  return 'http://10.0.2.2:8000/users';  // Android Emulator
}
```

### Producción:
```dart
// environment.dart
static String get userServiceUrl {
  return 'https://user-service.easypet.com';
}
```

## Debugging y Logs

### Logs del Controlador:
```dart
debugPrint('Datos del usuario obtenidos de MongoDB: $userData');
debugPrint('Enviando datos actualizados a MongoDB: $sanitizedData');
debugPrint('Usuario actualizado exitosamente en MongoDB: $result');
```

### Logs del Servicio:
```dart
// Los errores se capturan y se relanzan con contexto
throw Exception('Error de conexión: $e');
```

## Consideraciones de Rendimiento

1. **Caché Local:** Los datos se cargan una vez al abrir la pantalla
2. **Validación Local:** Se validan datos antes de enviar al servidor
3. **Timeout:** Las peticiones tienen timeout de 30 segundos
4. **Manejo de Estado:** Se usa `setState` para actualizar la UI

## Próximas Mejoras

1. **Sincronización Offline:** Guardar cambios localmente y sincronizar cuando haya conexión
2. **Validación en Tiempo Real:** Validar campos mientras el usuario escribe
3. **Historial de Cambios:** Mantener registro de modificaciones
4. **Backup de Datos:** Respaldar información antes de actualizar
5. **Notificaciones Push:** Avisar cuando se actualicen datos desde otros dispositivos
