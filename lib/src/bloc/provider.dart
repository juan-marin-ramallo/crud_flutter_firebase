import 'package:flutter/material.dart';

import 'package:crud/src/bloc/login_bloc.dart';
export 'package:crud/src/bloc/login_bloc.dart';

import 'package:crud/src/bloc/productos_bloc.dart';
export 'package:crud/src/bloc/productos_bloc.dart';

class Provider extends InheritedWidget{
  final _loginBloc      = new LoginBloc();
  final _productosBloc  = new ProductosBloc();

  static Provider _instanciaProvider;

  //Constructor Factory para implementación del Patron Singleton
  factory Provider({Key clave, Widget widget}){
    if(_instanciaProvider == null) {
      _instanciaProvider = new Provider._internal(clave: clave, widget: widget);
    }

    return _instanciaProvider;
  }

  //Constructor Privado
  Provider._internal({Key clave, Widget widget}) : super(key: clave, child: widget);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<Provider>())._loginBloc;
  }

  static ProductosBloc productosBloc (BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType<Provider>())._productosBloc;
  }
}