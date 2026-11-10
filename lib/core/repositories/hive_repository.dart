import 'package:hive_flutter/hive_flutter.dart';

class HiveRepository<T> {
  HiveRepository(this._box);

  final Box<T> _box;

  List<T> getAll() => _box.values.toList();

  T? getById(String id) => _box.get(id);

  Future<void> put(String id, T value) => _box.put(id, value);

  Future<void> delete(String id) => _box.delete(id);

  Future<void> deleteAll() => _box.clear();

  Stream<BoxEvent> watch({String? key}) => _box.watch(key: key);
}
