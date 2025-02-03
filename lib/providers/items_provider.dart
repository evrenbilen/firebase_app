// /lib/providers/items_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_app/models/item.dart';
import 'package:firebase_app/services/firebase_service.dart';

class ItemsProvider with ChangeNotifier {
  final FirebaseService _service;
  List<Item> _items = [];

  List<Item> get items => _items;

  ItemsProvider(this._service);

  void loadItems() {
    _service.getItems().listen((items) {
      _items = items;
      notifyListeners();
    });
  }

  Future<void> addItem(Item item) async {
    await _service.addItem(item);
  }

  Future<void> updateItem(Item item) async {
    await _service.updateItem(item);
  }

  Future<void> deleteItem(String itemId) async {
    await _service.deleteItem(itemId);
  }
}
