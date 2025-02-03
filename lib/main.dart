import 'package:firebase_app/screens/item_list_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app/providers/auth_provider.dart';
import 'package:firebase_app/providers/items_provider.dart';
import 'package:firebase_app/screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ItemsProvider>(
          create: (context) => ItemsProvider(
              Provider.of<AuthProvider>(context, listen: false)
                  .firebaseService),
          update: (context, authProvider, previousItemsProvider) =>
              ItemsProvider(authProvider.firebaseService),
        ),
      ],
      child: MaterialApp(
        title: 'Firebase Uygulaması',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return authProvider.isAuthenticated
                ? const ItemListScreen()
                : LoginScreen();
          },
        ),
      ),
    );
  }
}
