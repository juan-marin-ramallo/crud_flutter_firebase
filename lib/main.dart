import 'package:flutter/material.dart';
import 'package:crud/src/pages/home_page.dart';
import 'package:crud/src/pages/login_page.dart';
import 'package:crud/src/pages/product_page.dart';
import 'package:crud/src/pages/register_page.dart';
import 'package:crud/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:crud/src/bloc/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);

    return Provider(
      widget: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login'   : (BuildContext contexto) => LoginPage(),
          'home'    : (BuildContext contexto) => HomePage(),
          'product' : (BuildContext contexto) => ProductPage(),
          'register' : (BuildContext contexto) => RegisterPage(),
        },
      ),
    );
  }
}