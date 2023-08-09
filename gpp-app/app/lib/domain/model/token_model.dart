import 'dart:convert';

class Token {
  String accessToken;
  String refreshToken;

  Token({
    required this.accessToken,
    required this.refreshToken,
  });

  Token copyWith({
    String? accessToken,
    String? refreshToken,
  }) {
    return Token(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory Token.fromMap(Map<String, dynamic> map) {
    return Token(
      accessToken: map['accessToken'],
      refreshToken: map['refreshToken'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Token.fromJson(String source) => Token.fromMap(json.decode(source));

  @override
  String toString() =>
      'Token(accessToken: $accessToken, refreshToken: $refreshToken)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Token &&
        other.accessToken == accessToken &&
        other.refreshToken == refreshToken;
  }

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;

  Map<String, String> sendToken() {
    return {
      'Authorization': 'Bearer $accessToken',
    };
  }

  Map<String, String> sendRefreshToken() {
    return {
      'Authorization': 'Bearer $refreshToken',
    };
  }
}
