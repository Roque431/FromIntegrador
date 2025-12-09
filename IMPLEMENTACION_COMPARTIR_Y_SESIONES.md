# Implementación: Compartir Conversación al Foro y Gestión de Sesiones

## Resumen
Este documento detalla las mejoras implementadas para:
1. **Compartir conversaciones completas del chat con LexIA al foro**
2. **Gestión correcta de sesiones de chat** (nueva conversación, historial, eliminar)

---

## 1. Backend - Endpoint de Compartir Conversación

### Ubicación
`microservices/chat/src/index.ts`

### Endpoint Creado
```typescript
POST /foro/compartir-conversacion
```

### Parámetros
- `usuarioId` (string, required): ID del usuario que comparte
- `sessionId` (string, required): ID de la sesión de chat a compartir
- `categoriaId` (string, required): ID de la categoría del foro
- `titulo` (string, optional): Título personalizado para la publicación

### Respuesta
```json
{
  "success": true,
  "publicacion": { ...publicacionModel },
  "message": "Conversación compartida exitosamente en el foro"
}
```

### Funcionalidad
1. Obtiene el historial completo de la conversación desde `ConversationService`
2. Formatea los mensajes en Markdown (pregunta-respuesta agrupadas)
3. Crea una publicación en el foro usando `ForoService`
4. Genera título automático si no se proporciona

---

## 2. Frontend - Repository

### Ubicación
`FromIntegrador/lib/features/forum/data/repository/foro_repository.dart`

### Método Agregado
```dart
/// Compartir conversación completa al foro
Future<PublicacionModel> compartirConversacion({
  required String usuarioId,
  required String sessionId,
  required String categoriaId,
  String? titulo,
}) async {
  // Llama al endpoint /foro/compartir-conversacion
}
```

---

## 3. Frontend - Home Notifier (Gestión de Sesiones)

### Ubicación
`FromIntegrador/lib/features/home/presentation/providers/home_notifier.dart`

### Funcionalidades a Implementar

#### 3.1 Crear Nueva Conversación
```dart
/// Crear nueva conversación (limpia la sesión actual)
void startNewConversation() {
  _sessionId = null;
  _consultations = [];
  _currentConsultation = null;
  _currentResponse = null;
  _errorMessage = null;
  _state = HomeState.initial;
  notifyListeners();
}
```

#### 3.2 Obtener Historial de Sesiones
```dart
/// Obtener todas las sesiones del usuario
Future<List<ChatSession>> getChatSessions() async {
  try {
    // Llamar al endpoint GET /session/user/:userId
    final response = await apiClient.get('/session/user/$_userId');
    return response['sessions'].map((s) => ChatSession.fromJson(s)).toList();
  } catch (e) {
    print('Error obteniendo sesiones: $e');
    return [];
  }
}
```

#### 3.3 Cargar Sesión Existente
```dart
/// Cargar una sesión existente con su historial
Future<void> loadSession(String sessionId) async {
  try {
    _state = HomeState.loading;
    _sessionId = sessionId;

    // Obtener historial de la sesión
    final response = await apiClient.get('/session/$sessionId/history');
    final List<dynamic> messages = response['messages'];

    // Convertir mensajes a consultations
    _consultations = _convertMessagesToConsultations(messages);

    _state = HomeState.success;
    notifyListeners();
  } catch (e) {
    _errorMessage = e.toString();
    _state = HomeState.error;
    notifyListeners();
  }
}
```

#### 3.4 Eliminar Sesión
```dart
/// Eliminar una sesión completamente
Future<bool> deleteSession(String sessionId) async {
  try {
    await apiClient.delete('/session/$sessionId');

    // Si es la sesión actual, limpiarla
    if (_sessionId == sessionId) {
      startNewConversation();
    }

    return true;
  } catch (e) {
    print('Error eliminando sesión: $e');
    return false;
  }
}
```

#### 3.5 Compartir Conversación al Foro
```dart
/// Compartir la conversación actual al foro
Future<bool> compartirConversacionAlForo({
  required String categoriaId,
  String? titulo,
}) async {
  try {
    if (_sessionId == null || _userId == null) {
      throw Exception('No hay conversación activa para compartir');
    }

    final foroRepository = ForoRepository(apiClient: apiClient);

    await foroRepository.compartirConversacion(
      usuarioId: _userId!,
      sessionId: _sessionId!,
      categoriaId: categoriaId,
      titulo: titulo,
    );

    return true;
  } catch (e) {
    print('Error compartiendo conversación: $e');
    _errorMessage = e.toString();
    return false;
  }
}
```

---

## 4. Frontend - UI Components

### 4.1 Botón "Compartir al Foro" en Chat

#### Ubicación
`FromIntegrador/lib/features/home/presentation/widgets/home_content.dart`

#### Modificación en AppBar
Agregar botón de compartir en el AppBar cuando hay conversación activa:

```dart
actions: [
  if (homeNotifier.consultations.isNotEmpty) ...[
    // Botón compartir al foro
    IconButton(
      icon: const Icon(Icons.share),
      onPressed: () => _showCompartirDialog(context, homeNotifier),
      tooltip: 'Compartir al foro',
    ),
    // Botón nueva conversación
    IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () {
        _confirmarNuevaConversacion(context, homeNotifier);
      },
      tooltip: 'Nueva conversación',
    ),
  ],
],
```

#### Dialog para Compartir
```dart
void _showCompartirDialog(BuildContext context, HomeNotifier notifier) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Compartir al Foro'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('¿Deseas compartir esta conversación al foro para ayudar a otros usuarios?'),
          const SizedBox(height: 16),
          // Selector de categoría
          _buildCategorySelector(),
          const SizedBox(height: 16),
          // Campo de título opcional
          TextField(
            decoration: const InputDecoration(
              labelText: 'Título (opcional)',
              hintText: 'Se generará automáticamente si se deja vacío',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.pop(ctx);
            final success = await notifier.compartirConversacionAlForo(
              categoriaId: selectedCategoryId,
              titulo: tituloController.text.trim().isEmpty
                ? null
                : tituloController.text.trim(),
            );

            if (success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ Conversación compartida al foro'),
                  backgroundColor: Colors.green,
                ),
              );
              // Opcional: navegar al foro
              context.push('/forum');
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('❌ ${notifier.errorMessage ?? "Error al compartir"}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Compartir'),
        ),
      ],
    ),
  );
}
```

### 4.2 Drawer con Historial de Chats

#### Ubicación
`FromIntegrador/lib/features/home/presentation/widgets/home_drawer.dart`

#### Contenido del Drawer
```dart
Drawer(
  child: Column(
    children: [
      // Header
      DrawerHeader(
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              child: Icon(Icons.chat_bubble_outline, size: 40),
            ),
            const SizedBox(height: 12),
            const Text('Mis Conversaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      // Botón Nueva Conversación
      ListTile(
        leading: const Icon(Icons.add),
        title: const Text('Nueva Conversación'),
        onTap: () {
          Navigator.pop(context);
          homeNotifier.startNewConversation();
        },
      ),

      const Divider(),

      // Lista de sesiones recientes
      Expanded(
        child: FutureBuilder<List<ChatSession>>(
          future: homeNotifier.getChatSessions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No hay conversaciones previas'),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final session = snapshot.data![index];
                final isActive = session.id == homeNotifier.sessionId;

                return ListTile(
                  leading: Icon(
                    Icons.chat_bubble_outline,
                    color: isActive ? Colors.blue : Colors.grey,
                  ),
                  title: Text(
                    session.titulo ?? 'Conversación sin título',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  subtitle: Text(
                    _formatDate(session.fechaUltimoMensaje),
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      _confirmarEliminar(context, session, homeNotifier);
                    },
                  ),
                  selected: isActive,
                  onTap: () {
                    Navigator.pop(context);
                    homeNotifier.loadSession(session.id);
                  },
                );
              },
            );
          },
        ),
      ),
    ],
  ),
);
```

---

## 5. Backend - Endpoints Adicionales Necesarios

### 5.1 Obtener sesiones del usuario
```typescript
GET /session/user/:userId
```

### 5.2 Eliminar sesión
```typescript
DELETE /session/:sessionId
```

### 5.3 Obtener historial de una sesión
```typescript
GET /session/:sessionId/history
```

Estos endpoints ya deberían estar parcialmente implementados en `ConversationService`, pero pueden necesitar endpoints REST en `index.ts`.

---

## 6. Modelos de Datos

### ChatSession Model (Frontend)
```dart
class ChatSession {
  final String id;
  final String usuarioId;
  final String? titulo;
  final String? clusterPrincipal;
  final int totalMensajes;
  final DateTime fechaInicio;
  final DateTime fechaUltimoMensaje;
  final bool activa;

  ChatSession({
    required this.id,
    required this.usuarioId,
    this.titulo,
    this.clusterPrincipal,
    required this.totalMensajes,
    required this.fechaInicio,
    required this.fechaUltimoMensaje,
    required this.activa,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'],
      usuarioId: json['usuarioId'] ?? json['usuario_id'],
      titulo: json['titulo'],
      clusterPrincipal: json['clusterPrincipal'] ?? json['cluster_principal'],
      totalMensajes: json['totalMensajes'] ?? json['total_mensajes'] ?? 0,
      fechaInicio: DateTime.parse(json['fechaInicio'] ?? json['fecha_inicio']),
      fechaUltimoMensaje: DateTime.parse(json['fechaUltimoMensaje'] ?? json['fecha_ultimo_mensaje']),
      activa: json['activa'] ?? true,
    );
  }
}
```

---

## 7. Testing

### Casos de Prueba

1. **Compartir conversación al foro**
   - Crear una conversación con varias preguntas y respuestas
   - Click en botón "Compartir"
   - Seleccionar categoría
   - Verificar que la publicación aparece en el foro con formato correcto

2. **Nueva conversación**
   - Tener una conversación activa
   - Click en "Nueva conversación"
   - Verificar que se limpia el chat y se crea nueva sesión

3. **Historial de chats**
   - Crear varias conversaciones
   - Abrir drawer
   - Verificar que aparecen todas las sesiones ordenadas por fecha

4. **Eliminar chat**
   - Click en icono de basurero
   - Confirmar eliminación
   - Verificar que el chat desaparece del historial y de la BD

---

## 8. Próximos Pasos

- [ ] Implementar los 3 endpoints adicionales en backend
- [ ] Crear modelo `ChatSession` en Flutter
- [ ] Modificar `home_content.dart` para agregar botón compartir
- [ ] Modificar `home_drawer.dart` para mostrar historial
- [ ] Implementar métodos en `HomeNotifier`
- [ ] Testing completo
- [ ] Documentación de usuario

---

**Fecha:** 2025-12-05
**Autor:** Claude Code
