import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mspent/helpers/db_helper.dart';

import '../models/transaction.dart';

class Transactions with ChangeNotifier {
  List<transaction> _userTransactions = [];

  double total = 0;
  void updateTotal(double v) {
    total = v;
    notifyListeners();
  }

  double totalCash = 0;
  void updateTotalCash(double v) {
    totalCash = v;
    notifyListeners();
  }

  double externalReceivables = 0;
  void updateExternalReceivables(double v) {
    externalReceivables = v;
    notifyListeners();
  }

  double debts = 0;
  void updateDebts(double v) {
    debts = v;
    notifyListeners();
  }

  List<transaction> get userTransactions {
    return _userTransactions;
  }

  List<transaction> get recentTransactions {
    return (_userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    })).toList();
  }

  //double total = 0;
  int sameIndex = 0;

  bool exists(transaction tx) {
    for (int i = 0; i < _userTransactions.length; i++) {
      if (tx.name == _userTransactions[i].name) {
        sameIndex = i;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void addNewTransaction(
      String name, double price, int amount, File galleryImage) {
    final newTx = transaction(
        name: name,
        price: price,
        amount: amount,
        date: DateTime.now(),
        galleryImage: galleryImage);

    if (exists(newTx)) {
      total -= (_userTransactions[sameIndex].price *
          _userTransactions[sameIndex].amount);
      _userTransactions[sameIndex].amount += newTx.amount;
      total += (_userTransactions[sameIndex].price *
          _userTransactions[sameIndex].amount);
    } else {
      _userTransactions.add(newTx);
      int n = _userTransactions.length - 1;
      for (int i = n; i > 0; i--) {
        _userTransactions[i] = _userTransactions[i - 1];
      }
      _userTransactions[0] = newTx;
      total += (newTx.price * newTx.amount);
    }
    notifyListeners();
    DBHelper.insert('user_transactions', {
      'name': newTx.name,
      'price': newTx.price.toString(),
      'amount': newTx.amount.toString(),
      'date': newTx.date.toIso8601String(),
      'image': newTx.galleryImage.path,
    });
  }

  void deleteTrans(int i) {
    total -= _userTransactions[i].price * _userTransactions[i].amount;
    _userTransactions.removeAt(i);
    notifyListeners();
  }

  Future<void> fitchAndSetTransactions() async {
    final dataList = await DBHelper.getData('user_transactions');
    _userTransactions = dataList
        .map((e) => transaction(
            name: e['name'],
            price: double.parse(e['price']),
            amount: int.parse(e['amount']),
            date: DateTime.parse(e['date']),
            galleryImage: File(e['galleryImage'])))
        .toList();
    notifyListeners();
  }
}
