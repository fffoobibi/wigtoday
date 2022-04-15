import 'package:flutter/foundation.dart';

class ValueNotifierList<T> extends ValueNotifier<List<T>> {
  ValueNotifierList(List<T> initValue) : super(initValue);

  void add(T item) {
    value.add(item);
    _copyValue();
  }

  void addAll(Iterable<T> items) {
    value.addAll(items);
    _copyValue();
  }

  void remove(int index) {
    if (value.length < index) {
      return;
    }
    value.removeAt(index);
    _copyValue();
  }

  void removeLast() {
    if (value.length == 0) {
      return;
    }
    value.removeLast();
    _copyValue();
  }

  void clear() {
    value.clear();
    _copyValue();
  }

  void _copyValue() {
    value = [...value];
  }
}
