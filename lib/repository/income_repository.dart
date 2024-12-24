import 'package:isar/isar.dart';

import '../collections/income.dart';
import '../main.dart';
import 'adapter.dart';

class IncomeRepository extends Adapter<Income> {
  ///
  @override
  Future<void> createMultipleObjects(List<Income> collections) async =>
      isar.writeTxn(() async => isar.incomes.putAll(collections));

  ///
  @override
  Future<void> createObject(Income collection) async =>
      isar.writeTxn(() async => isar.incomes.put(collection));

  ///
  @override
  Future<void> deleteObject(Income collection) async =>
      isar.writeTxn(() async => isar.incomes.delete(collection.id));

  ///
  @override
  Future<void> deleteMultipleObjects(List<int> ids) async => isar.incomes.deleteAll(ids);

  ///
  @override
  Future<List<Income>> getAllObjects() async => isar.incomes.where().findAll();

  ///
  @override
  Future<Income?> getObjectById(int id) async => isar.incomes.get(id);

  ///
  @override
  Future<List<Income?>> getObjectsById(List<int> ids) async => isar.incomes.getAll(ids);

  ///
  @override
  Future<void> updateObject(Income collection) async {
    await isar.writeTxn(() async {
      final Income? budget = await isar.incomes.get(collection.id);

      if (budget != null) {
        await isar.incomes.put(collection);
      }
    });
  }
}
