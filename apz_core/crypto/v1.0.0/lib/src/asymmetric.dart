part of "../apz_crypto.dart";

class _Asymmetric {
  static final Map<String, RSAPublicKey> _publicKeyCache =
      <String, RSAPublicKey>{};
  static final Map<String, RSAPrivateKey> _privateKeyCache =
      <String, RSAPrivateKey>{};

  Future<Uint8List> encrypt({
    required final String publicKeyPath,
    required final Uint8List dataToEncrypt,
  }) async {
    try {
      final RSAPublicKey rsaPublicKey = await _getPublicKey(publicKeyPath);
      final RSAEngine rsaEngine = RSAEngine();
      final OAEPEncoding oaepEncoding = OAEPEncoding.withSHA256(rsaEngine)
        ..init(true, PublicKeyParameter<RSAPublicKey>(rsaPublicKey));
      final Uint8List encryptedBytes = oaepEncoding.process(dataToEncrypt);
      return encryptedBytes;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<Uint8List> decrypt({
    required final String privateKeyPath,
    required final Uint8List encryptedData,
  }) async {
    try {
      final RSAPrivateKey rsaPrivateKey = await _getPrivateKey(privateKeyPath);
      final RSAEngine rsaEngine = RSAEngine();
      final OAEPEncoding oaepEncoding = OAEPEncoding.withSHA256(rsaEngine)
        ..init(false, PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey));
      final Uint8List decryptedBytes = oaepEncoding.process(encryptedData);
      return decryptedBytes;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<Uint8List> sign({
    required final String privateKeyPath,
    required final Uint8List dataToSign,
  }) async {
    try {
      final RSAPrivateKey rsaPrivateKey = await _getPrivateKey(privateKeyPath);
      final Signer signer = Signer(Constants.asymtSigner)
        ..init(true, PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey));
      final RSASignature signature =
          signer.generateSignature(dataToSign) as RSASignature;
      return signature.bytes;
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<bool> verify({
    required final String publicKeyPath,
    required final Uint8List originalData,
    required final Uint8List signedData,
  }) async {
    try {
      final RSAPublicKey rsaPublicKey = await _getPublicKey(publicKeyPath);
      final Signer verifier = Signer(Constants.asymtSigner)
        ..init(false, PublicKeyParameter<RSAPublicKey>(rsaPublicKey));
      final RSASignature sig = RSASignature(signedData);
      return verifier.verifySignature(originalData, sig);
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<RSAPublicKey> _getPublicKey(final String publicKeyPath) async {
    try {
      RSAPublicKey? rsaPublicKey;
      if (_publicKeyCache.containsKey(publicKeyPath)) {
        rsaPublicKey = _publicKeyCache[publicKeyPath];
      } else {
        rsaPublicKey = await _parsePublicKeyFromPem(publicKeyPath);
      }

      if (rsaPublicKey == null) {
        throw Exception("Public key is not proper");
      } else {
        _publicKeyCache[publicKeyPath] = rsaPublicKey;
        return rsaPublicKey;
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<RSAPrivateKey> _getPrivateKey(final String privateKeyPath) async {
    try {
      RSAPrivateKey? rsaPrivateKey;
      if (_privateKeyCache.containsKey(privateKeyPath)) {
        rsaPrivateKey = _privateKeyCache[privateKeyPath];
      } else {
        rsaPrivateKey = await _parsePrivateKeyFromPem(privateKeyPath);
      }

      if (rsaPrivateKey == null) {
        throw Exception("Private key is not proper");
      } else {
        _privateKeyCache[privateKeyPath] = rsaPrivateKey;
        return rsaPrivateKey;
      }
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<RSAPublicKey?> _parsePublicKeyFromPem(
    final String publicKeyPath,
  ) async {
    final String publicPem = await rootBundle.loadString(publicKeyPath);

    // Use RSAKeyParser to parse the PEM string.
    final encrypt_package.RSAKeyParser parser = encrypt_package.RSAKeyParser();
    final RSAAsymmetricKey publicKey = parser.parse(publicPem);
    final RSAPublicKey rsaPublicKey = publicKey as RSAPublicKey;

    return rsaPublicKey;
  }

  Future<RSAPrivateKey> _parsePrivateKeyFromPem(
    final String privateKeyPath,
  ) async {
    final String privatePem = await rootBundle.loadString(privateKeyPath);

    // Use RSAKeyParser to parse the PEM string.
    final encrypt_package.RSAKeyParser parser = encrypt_package.RSAKeyParser();
    final RSAAsymmetricKey privateKey = parser.parse(privatePem);
    final RSAPrivateKey rsaPrivateKey = privateKey as RSAPrivateKey;

    return rsaPrivateKey;
  }
}
