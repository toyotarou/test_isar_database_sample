import 'package:isar/isar.dart';

import '../collections/budget.dart';
import '../main.dart';
import 'adapter.dart';

class BudgetRepository extends Adapter<Budget> {
  ///
  @override
  Future<void> createMultipleObjects(List<Budget> collections) async =>
      isar.writeTxn(() async => isar.budgets.putAll(collections));

  ///
  @override
  Future<Budget?> createObject(Budget collection) async {
    await isar.writeTxn(() async => isar.budgets.put(collection));

    return getObjectById(collection.id);
  }

  ///
  @override
  Future<void> deleteObject(Budget collection) async =>
      isar.writeTxn(() async => isar.budgets.delete(collection.id));

  ///
  @override
  Future<void> deleteMultipleObjects(List<int> ids) async => isar.budgets.deleteAll(ids);

  ///
  @override
  Future<List<Budget>> getAllObjects() async => isar.budgets.where().findAll();

  ///
  @override
  Future<Budget?> getObjectById(int id) async => isar.budgets.get(id);

  ///
  @override
  Future<List<Budget?>> getObjectsById(List<int> ids) async => isar.budgets.getAll(ids);

  ///
  @override
  Future<Budget?> updateObject(Budget collection) async {
    await isar.writeTxn(() async {
      final Budget? budget = await isar.budgets.get(collection.id);

      if (budget != null) {
        await isar.budgets.put(collection);
      }
    });

    return getObjectById(collection.id);
  }

  ///
  Future<Budget?> getObjectByDate({required int month, required int year}) async =>
      isar.budgets.filter().monthEqualTo(month).yearEqualTo(year).findFirst();
}
