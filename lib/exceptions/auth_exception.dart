class AuthException implements Exception {
  final String key;
  final Map<String, String> errors = {
    "EMAIL_EXISTS": "Este e-mail já está em uso!",
    "OPERATION_NOT_ALLOWED": "Operação não permitida",
    "TOO_MANY_ATTEMPTS_TRY_LATER":
        "Muitas tentativas.Tente novamente mais tarde!",
    "EMAIL_NOT_FOUND": "E-mail não foi encontrado!",
    "INVALID_PASSWORD": "Senha inválida!",
    "USER_DISABLED": "Usuário inativo!",
  };

  AuthException(this.key);

  @override
  String toString() {
    if (errors.containsKey(key)) {
      return errors[key];
    } else {
      return "Ocorreu um erro na autenticação!";
    }
  }
}
