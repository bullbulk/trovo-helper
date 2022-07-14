class InvalidNonce implements Exception {
  String message;

  InvalidNonce(this.message);
}

class InvalidStorageValue implements Exception {
  String message;

  InvalidStorageValue(this.message);
}
