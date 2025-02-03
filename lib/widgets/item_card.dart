// /lib/widgets/item_card.dart
import 'package:flutter/material.dart';
import 'package:firebase_app/models/item.dart';
import 'package:firebase_app/providers/items_provider.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(item.description),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            Provider.of<ItemsProvider>(context, listen: false)
                .deleteItem(item.id);
          },
        ),
      ),
    );
  }
}
