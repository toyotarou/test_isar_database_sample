import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../collections/budget.dart';
import '../collections/expense.dart';
import '../collections/income.dart';
import '../collections/receipt.dart';
import '../main.dart';
import '../repository/budget_repository.dart';
import '../repository/expense_repository.dart';
import '../repository/income_repository.dart';
import '../repository/receipt_repository.dart';

mixin Func {
  ///
  Future<Budget?> createBudget(double amount) async {
    final Budget budget = Budget()
      ..month = DateTime.now().month
      ..year = DateTime.now().year
      ..amount = amount;

    return BudgetRepository().createObject(budget);
  }

  ///
  Future<Budget?> getBudget({required int month, required int year}) async =>
      BudgetRepository().getObjectByDate(month: month, year: year).then((Budget? value) => value);

  ///
  Future<Budget?> updateBudget(Budget budget) async => BudgetRepository().updateObject(budget);

  ///
  Future<void> createExpense(double amount, DateTime date, CategoryEnum cenum, String subcat, Set<Receipt> receipts,
      List<String> description, String paymentMethod) async {
    final SubCategory subcategory = SubCategory()..name = subcat;

    final DateTime formattedDate = date.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);

    for (final Receipt receipt in receipts) {
      await ReceiptRepository().createObject(receipt);
    }

    final Expense expense = Expense()
      ..amount = amount
      ..date = formattedDate
      ..category = cenum
      ..subCategory = subcategory
      ..description = description
      ..paymentMethod = paymentMethod
      ..receipts.addAll(receipts);

    return ExpenseRepository().createObject(expense);
  }

  ///
  Future<List<Expense>> getTodaysExpenses() async =>
      ExpenseRepository().getObjectsByToday().then((List<Expense> value) => value);

  ///
  Future<List<Expense>> getAllExpenses() async => ExpenseRepository().getAllObjects().then((List<Expense> value) => value);

  ///
  Future<String> getPath() async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    return appDir.path;
  }

  ///
  Future<List<Receipt>> getAllReceipts() async => ReceiptRepository().getAllObjects();

  ///
  Future<List<Income>> getAllIncomes() async => IncomeRepository().getAllObjects();

  ///
  // ignore: inference_failure_on_function_return_type
  Future<void> clearData() async => ExpenseRepository().clearData();

  ///
  Future<double> getTotalExpenses() async => ExpenseRepository().totalExpenses();

  ///
  Future<List<double>> sumByCategory() async {
    final List<double> total = <double>[];
    for (final CategoryEnum value in CategoryEnum.values) {
      final double sum = await ExpenseRepository().getSumForCategory(value);
      total.add(sum);
    }
    return total;
  }

  ///
  Future<List<Expense>> expensesByCategory(CategoryEnum value) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsByCategory(value).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByAmountRange(double low, double high) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsByAmountRange(low, high).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByAmountGreaterThan(double amount) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsWithAmountGreaterThan(amount).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByAmountLessThan(double amount) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsWithAmountLessThan(amount).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByCategoryAndAmount(CategoryEnum value, double amountHighValue) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsByOptions(value, amountHighValue).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByNotOthersCategory() async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsNotOthersCategory().then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByGroupFilter(String searchText, DateTime dateTime) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsByGroupFilter(searchText, dateTime).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByPaymentMethod(String searchText) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsBySearchText(searchText).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByUsingAny(List<CategoryEnum> categories) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsUsingAnyOf(categories).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByUsingAll(List<CategoryEnum> categories) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsUsingAllOf(categories).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByTags(int tags) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsWithTags(tags).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByTagName(String tagName) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsWithTagName(tagName).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesBySubCategory(String subCategory) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsBySubCategory(subCategory).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByReceipts(String receiptName) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsByReceipts(receiptName).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByPagination(int offset) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getObjectsAndPaginate(offset).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByFindFirst() async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().getOnlyFirstObject().then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> expensesByDeleteFirst() async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().deleteOnlyFirstObject().then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<int> expensesByCount() async => ExpenseRepository().getTotalObjects();

  ///
  Future<List<Expense>> expensesByFullTextSearch(String searchText) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().fullTextSearch(searchText).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<List<Expense>> deleteItem(Expense collection) async {
    List<Expense> expenses = <Expense>[];

    await ExpenseRepository().deleteObject(collection).then((List<Expense> value) => expenses = value);

    return expenses;
  }

  ///
  Future<void> clearGallery(List<Receipt> receipts) async => ReceiptRepository().clearGallery(receipts);

  //
  //
  //
  // Future<Map<String, dynamic>> setConfigs(ExpenseDetailArguments args) async {
  //   String path = await getPath().then((value) => value);
  //   int count = await args.expense.receipts.count();
  //
  //   return {"path": path, "count": count};
  // }
  //
  //
  //

  ///
  // ignore: inference_failure_on_function_return_type, always_declare_return_types
  setWatcher(BuildContext context) async {
    final Stream<List<Expense>> expenseChanged = isar.expenses
        .filter()
        .dateEqualTo(DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0))
        .watch(fireImmediately: true);

    expenseChanged.listen((List<Expense> event) {
      if (event.length > 7) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('You have too many expenses for Today')));
      }
    });
  }

//
//
//
// Future<void> importDataFromFirebase() async {
//   List<Income> incomes = [];
//
//   if (!Firestore.initialized) {
//     Firestore.initialize("project-id");
//   }
//
//   await Firestore.instance.collection('expensetracker').get().then((event) async {
//     await isar.writeTxn(() async {
//       await isar.incomes.clear();
//     });
//
//     for (final doc in event) {
//       final income = Income()..name = doc.map["name"];
//       incomes.add(income);
//     }
//   });
//
//   await IncomeRepository().createMultipleObjects(incomes);
// }
//
//
//

//
//
// Future<void> exportDataToFirebase() async {
//   if (!Firestore.initialized) {
//     Firestore.initialize("project-id");
//   }
//
//   List<Expense> xpenses = await getAllExpenses();
//
//   await Firestore.instance.collection('expenses').get().then((expenses) {
//     for (Document expense in expenses) {
//       expense.reference.delete();
//     }
//   });
//
//   for (Expense expense in xpenses) {
//     await Firestore.instance.collection('expenses').add(expense.toJson());
//   }
// }
//
//

//
//
//
// void backgroundWork(BuildContext context) {
//   setWatcher(context);
//   importDataFromFirebase();
// }
//
//
//
}
