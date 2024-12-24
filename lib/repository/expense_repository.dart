import 'package:isar/isar.dart';

import '../collections/expense.dart';
import '../collections/receipt.dart';
import '../main.dart';
import 'adapter.dart';

class ExpenseRepository extends Adapter<Expense> {
  ///
  @override
  Future<void> createMultipleObjects(List<Expense> collections) async =>
      isar.writeTxn(() async => isar.expenses.putAll(collections));

  ///
  @override
  Future<void> createObject(Expense collection) async {
    await isar.writeTxn(() async {
      await isar.expenses.put(collection);

      await collection.receipts.save();
    });
  }

  ///
  @override
  Future<List<Expense>> deleteObject(Expense collection) async {
    await isar.writeTxn(() async => isar.expenses.delete(collection.id));

    return isar.expenses.where().findAll();
  }

  ///
  @override
  Future<void> deleteMultipleObjects(List<int> ids) async => isar.expenses.deleteAll(ids);

  ///
  @override
  Future<List<Expense>> getAllObjects() async => isar.expenses.where().findAll();

  ///
  @override
  Future<Expense?> getObjectById(int id) async => isar.expenses.get(id);

  ///
  @override
  Future<List<Expense?>> getObjectsById(List<int> ids) async => isar.expenses.getAll(ids);

  ///
  @override
  Future<void> updateObject(Expense collection) async {
    await isar.writeTxn(() async {
      final Expense? budget = await isar.expenses.get(collection.id);

      if (budget != null) {
        await isar.expenses.put(collection);
      }
    });
  }

  ///
  Future<List<Expense>> getObjectsByToday() async => isar.expenses
      .where()
      .dateEqualTo(DateTime.now().copyWith(hour: 0, minute: 0, second: 0, microsecond: 0, millisecond: 0))
      .findAll();

  ///
  Future<double> getSumForCategory(CategoryEnum value) async =>
      isar.expenses.filter().categoryEqualTo(value).amountProperty().sum();

  ///
  Future<List<Expense>> getObjectsByCategory(CategoryEnum value) async =>
      isar.expenses.filter().categoryEqualTo(value).findAll();

  ///
  Future<List<Expense>> getObjectsByAmountRange(double lowAmount, double highAmount) async =>
      isar.expenses.filter().amountBetween(lowAmount, highAmount, includeLower: false).findAll();

  ///
  Future<List<Expense>> getObjectsWithAmountGreaterThan(double amountValue) async =>
      isar.expenses.filter().amountGreaterThan(amountValue).findAll();

  ///
  Future<List<Expense>> getObjectsWithAmountLessThan(double amountValue) async =>
      isar.expenses.filter().amountLessThan(amountValue).findAll();

  ///
  Future<List<Expense>> getObjectsByOptions(CategoryEnum value, double amountHighValue) async =>
      isar.expenses.filter().categoryEqualTo(value).or().amountGreaterThan(amountHighValue).findAll();

  ///
  Future<List<Expense>> getObjectsNotOthersCategory() async =>
      isar.expenses.filter().not().categoryEqualTo(CategoryEnum.others).findAll();

  ///
  Future<List<Expense>> getObjectsByGroupFilter(String searchText, DateTime dateTime) async => isar.expenses
      .filter()
      .categoryEqualTo(CategoryEnum.others)
      .group((QueryBuilder<Expense, Expense, QFilterCondition> q) => q.paymentMethodContains(searchText).or().dateEqualTo(dateTime))
      .findAll();

  ///
  Future<List<Expense>> getObjectsBySearchText(String searchText) async => isar.expenses
      .filter()
      .paymentMethodStartsWith(searchText, caseSensitive: false)
      .or()
      .paymentMethodEndsWith(searchText, caseSensitive: false)
      .findAll();

  ///
  Future<List<Expense>> getObjectsUsingAnyOf(List<CategoryEnum> categories) async =>
      // ignore: inference_failure_on_function_invocation
      isar.expenses.filter().anyOf(categories, (QueryBuilder<Expense, Expense, QFilterCondition> q, CategoryEnum cat) => q.categoryEqualTo(cat)).findAll();

  ///
  Future<List<Expense>> getObjectsUsingAllOf(List<CategoryEnum> categories) async =>
      // ignore: inference_failure_on_function_invocation
      isar.expenses.filter().allOf(categories, (QueryBuilder<Expense, Expense, QFilterCondition> q, CategoryEnum cat) => q.categoryEqualTo(cat)).findAll();

  ///
  Future<List<Expense>> getObjectsWithoutPaymentMethod() async =>
      isar.expenses.filter().paymentMethodIsEmpty().findAll();

  ///
  Future<List<Expense>> getObjectsWithTags(int tags) async =>
      isar.expenses.filter().descriptionLengthEqualTo(tags).findAll();

  ///
  Future<List<Expense>> getObjectsWithTagName(String tagWord) async =>
      isar.expenses.filter().descriptionElementEqualTo(tagWord, caseSensitive: false).findAll();

  ///
  Future<List<Expense>> getObjectsBySubCategory(String subCategory) async =>
      isar.expenses.filter().subCategory((QueryBuilder<SubCategory, SubCategory, QFilterCondition> q) => q.nameEqualTo(subCategory)).findAll();

  ///
  Future<List<Expense>> getObjectsByReceipts(String receiptName) async =>
      isar.expenses.filter().receipts((QueryBuilder<Receipt, Receipt, QFilterCondition> q) => q.nameEqualTo(receiptName).or().nameContains(receiptName)).findAll();

  ///
  Future<List<Expense>> getObjectsAndPaginate(int offset) async =>
      isar.expenses.where().offset(offset).limit(3).findAll();

  ///
  Future<List<Expense>> getObjectsWithDistinctValues() async =>
      isar.expenses.where().distinctByCategory().findAll();

  ///
  Future<List<Expense>> getOnlyFirstObject() async {
    final List<Expense> querySelected = <Expense>[];

    await isar.expenses.where().findFirst().then((Expense? value) {
      if (value != null) {
        querySelected.add(value);
      }
    });

    return querySelected;
  }

  ///
  Future<List<Expense>> deleteOnlyFirstObject() async {
    await isar.writeTxn(() async => isar.expenses.where().deleteFirst());

    return isar.expenses.where().findAll();
  }

  ///
  Future<int> getTotalObjects() async => isar.expenses.where().count();

  ///
  Future<void> clearData() async => isar.writeTxn(() async => isar.clear());

  ///
  Future<List<String?>> getPaymentProperty() async => isar.expenses.where().paymentMethodProperty().findAll();

  ///
  Future<double> totalExpenses() async => isar.expenses.where().amountProperty().sum();

  ///
  Future<double> totalExpensesByCategory() async =>
      isar.expenses.where().distinctByCategory().amountProperty().sum();

  ///
  Future<List<Expense>> fullTextSearch(String searchText) async {
    return isar.expenses
        .filter()
        .descriptionElementEqualTo(searchText)
        .or()
        .descriptionElementStartsWith(searchText)
        .or()
        .descriptionElementEndsWith(searchText)
        .findAll();

    //another way to do this!!
    // return await isar.expenses
    //     .filter()
    //     .descriptionElementContains(searchText)
    //     .findAll();
  }
}
