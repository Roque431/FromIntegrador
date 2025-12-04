import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class GoogleSignInService {
  final GoogleSignIn _googleSignIn;

  /// No accedemos a [FirebaseAuth.instance] en el constructor.
  /// Usamos un getter perezoso para evitar excepciones si Firebase
  /// no está inicializado aún al momento de crear el servicio.
  FirebaseAuth? get _firebaseAuth => kIsWeb ? null : FirebaseAuth.instance;

  GoogleSignInService()
      : _googleSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
          // En web necesitamos el clientId explícito
          clientId: kIsWeb ? dotenv.dotenv.env['GOOGLE_CLIENT_ID_WEB'] : null,
        ) {
    print('🔧 GoogleSignIn configurado');
    print('   Platform: ${kIsWeb ? "Web (Solo Google)" : "Mobile (Google + Firebase)"}');
    print('   Scopes: email, profile');
    if (kIsWeb) {
      print('   Client ID: ${dotenv.dotenv.env['GOOGLE_CLIENT_ID_WEB'] ?? 'NOT_FOUND'}');
    }
  }

  /// Inicia sesión con Google (con o sin Firebase según plataforma)
  Future<GoogleSignInAccount?> signIn() async {
    try {
      print('🚀 Iniciando Google Sign-In...');
      
      // 1. Iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('❌ Google Sign-In cancelado por el usuario');
        return null;
      }
      
      print('✅ Google Sign-In exitoso: ${googleUser.email}');

      // 2. Solo en móvil: autenticar con Firebase
      if (!kIsWeb && _firebaseAuth != null) {
        try {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          
          final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          print('✅ Firebase Auth exitoso: ${userCredential.user?.email}');
        } catch (firebaseError) {
          print('⚠️ Firebase Auth falló (continuando con Google): $firebaseError');
        }
      }
      
      return googleUser;
    } catch (e) {
      print('❌ Error en Google Sign-In: $e');
      print('   Tipo de error: ${e.runtimeType}');
      return null;
    }
  }

  /// Obtiene el token de autenticación (ID token en móvil, Access token en web)
  Future<Map<String, String?>> getAuthTokens() async {
    try {
      print('🔑 Obteniendo tokens de autenticación...');

      // Prioridad 1: Firebase (móvil)
      if (!kIsWeb && _firebaseAuth != null) {
        final User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final String? idToken = await user.getIdToken();
          if (idToken != null) {
            print('✅ Firebase ID token obtenido');
            return {'idToken': idToken};
          }
        }
      }

      // Prioridad 2: Google directo (web o fallback)
      final GoogleSignInAccount? account = _googleSignIn.currentUser ?? await _googleSignIn.signInSilently();
      if (account != null) {
        final GoogleSignInAuthentication auth = await account.authentication;

        // En web, usar accessToken ya que idToken puede no estar disponible
        if (kIsWeb) {
          if (auth.accessToken != null) {
            print('✅ Google Access token obtenido (Web)');
            return {'accessToken': auth.accessToken};
          }
        } else {
          // En móvil, preferir idToken
          if (auth.idToken != null) {
            print('✅ Google ID token obtenido (Mobile)');
            return {'idToken': auth.idToken};
          }
        }
      }

      print('❌ No se pudo obtener token de autenticación');
      return {};
    } catch (e) {
      print('❌ Error al obtener tokens: $e');
      return {};
    }
  }

  /// Obtiene el token de ID (para mantener compatibilidad con código existente)
  @Deprecated('Usa getAuthTokens() que soporta web y móvil')
  Future<String?> getIdToken() async {
    final tokens = await getAuthTokens();
    return tokens['idToken'];
  }

  /// Obtiene el access token de Google
  Future<String?> getAccessToken() async {
    try {
      final account = _googleSignIn.currentUser ?? await _googleSignIn.signIn();
      if (account == null) return null;

      final auth = await account.authentication;
      return auth.accessToken;
    } catch (e) {
      print('Error al obtener access token: $e');
      return null;
    }
  }

  /// Cierra sesión de Google y Firebase (si está disponible)
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    if (!kIsWeb && _firebaseAuth != null) {
      await _firebaseAuth!.signOut();
    }
  }

  /// Desconecta completamente la cuenta de Google y Firebase (si está disponible)
  Future<void> disconnect() async {
    await _googleSignIn.disconnect();
    if (!kIsWeb && _firebaseAuth != null) {
      await _firebaseAuth!.signOut();
    }
  }

  /// Verifica si hay una sesión activa
  Future<bool> isSignedIn() async {
    return await _googleSignIn.isSignedIn();
  }

  /// Obtiene la cuenta actual si está logueado
  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;
}
