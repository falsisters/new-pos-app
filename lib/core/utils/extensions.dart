extension NullableExtensions<T> on T? {
  R? let<R>(R Function(T) transform) {
    final self = this;
    return self != null ? transform(self) : null;
  }
}
