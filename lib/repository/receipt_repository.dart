import 'package:isar/isar.dart';

import '../collections/receipt.dart';
import '../main.dart';
import 'adapter.dart';

class ReceiptRepository extends Adapter<Receipt> {
  ///
  @override
  Future<void> createMultipleObjects(List<Receipt> collections) async =>
      isar.writeTxn(() async => isar.receipts.putAll(collections));

  ///
  @override
  Future<void> createObject(Receipt collection) async =>
      isar.writeTxn(() async => isar.receipts.put(collection));

  ///
  @override
  Future<void> deleteObject(Receipt collection) async =>
      isar.writeTxn(() async => isar.receipts.delete(collection.id));

  ///
  @override
  Future<void> deleteMultipleObjects(List<int> ids) async => isar.receipts.deleteAll(ids);

  ///
  @override
  Future<List<Receipt>> getAllObjects() async => isar.receipts.where().findAll();

  ///
  @override
  Future<Receipt?> getObjectById(int id) async => isar.receipts.get(id);

  ///
  @override
  Future<List<Receipt?>> getObjectsById(List<int> ids) async => isar.receipts.getAll(ids);

  ///
  @override
  Future<void> updateObject(Receipt collection) async {
    await isar.writeTxn(() async {
      final Receipt? budget = await isar.receipts.get(collection.id);

      if (budget != null) {
        await isar.receipts.put(collection);
      }
    });
  }

  ///
  Future<void> uploadReceipts(List<Receipt> receipts) async {
    await isar.writeTxn(() async {
      for (final Receipt receipt in receipts) {
        await isar.receipts.put(receipt);
      }
    });
  }

  ///
  Future<List<Receipt>> downloadReceipts() async {
    final int totalReceipts = await isar.receipts.where().count();

    final List<Receipt> all = <Receipt>[];

    await isar.txn(() async {
      for (int i = 1; i < totalReceipts; i++) {
        final Receipt? receipt = await isar.receipts.where().idEqualTo(i).findFirst();

        if (receipt != null) {
          all.add(receipt);
        }
      }
    });

    return all;
  }

  ///
  Future<void> clearGallery(List<Receipt> receipts) async {
    await isar.writeTxn(() async {
      for (int i = 0; i < receipts.length; i++) {
        await isar.receipts.delete(receipts[i].id);
      }
    });
  }
}
