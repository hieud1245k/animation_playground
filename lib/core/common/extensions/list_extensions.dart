extension ListExtensions<T> on List<T> {
  T? firstWhereOrNull(bool test(T element)) {
    try {
      return firstWhere(test);
    } catch (_) {
      return null;
    }
  }
}
