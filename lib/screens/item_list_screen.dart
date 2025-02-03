import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app/providers/items_provider.dart';
import 'package:firebase_app/providers/auth_provider.dart';
import 'package:firebase_app/widgets/item_card.dart';
import 'package:firebase_app/screens/add_item_screen.dart';
import 'package:firebase_app/screens/login_screen.dart';

class ItemListScreen extends StatelessWidget {
  const ItemListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemsProvider = Provider.of<ItemsProvider?>(context);
    final authProvider = Provider.of<AuthProvider?>(context);

    if (itemsProvider == null ||
        authProvider == null ||
        authProvider.user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item List'),
        actions: [
          IconButton(
            onPressed: () async {
              await authProvider.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Hoş Geldiniz ${authProvider.user!.email!}",
              style: TextStyle(fontSize: 18),
            ),
          ),
          // Removed the ListView.builder that lists items
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddItemScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
