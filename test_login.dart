// Test rápido para verificar el login demo
void main() {
  bool isDemoCredentials(String email, String password) {
    return (email == 'usuario@lexia.com' && password == 'Usuario123') ||
           (email == 'abogado@lexia.com' && password == 'Abogado123');
  }

  // Test 1: Credenciales de abogado
  print('Test 1 - Abogado:');
  String email = 'abogado@lexia.com';
  String password = 'Abogado123';
  bool result = isDemoCredentials(email, password);
  print('Email: $email');
  print('Password: $password');
  print('¿Es credencial demo?: $result');
  print('');

  // Test 2: Credenciales de usuario
  print('Test 2 - Usuario:');
  email = 'usuario@lexia.com';
  password = 'Usuario123';
  result = isDemoCredentials(email, password);
  print('Email: $email');
  print('Password: $password');
  print('¿Es credencial demo?: $result');
  print('');

  // Test 3: Credenciales incorrectas
  print('Test 3 - Incorrectas:');
  email = 'abogado@lexia.com';
  password = 'wrong123';
  result = isDemoCredentials(email, password);
  print('Email: $email');
  print('Password: $password');
  print('¿Es credencial demo?: $result');
}