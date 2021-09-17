import 'dart:async';
import 'package:crud/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
  final usuarioController = BehaviorSubject<String>();
  final passwordController = BehaviorSubject<String>();

  //Objetos para insertar información a los StreamController
  Function(String) get sinkUsuario => usuarioController.sink.add;
  Function(String) get sinkPassword => passwordController.sink.add;

  //Recuperar información del StreamController
  Stream<String> get streamUsuario => usuarioController.stream.transform(validarEmail);
  Stream<String> get streamPassword => passwordController.stream.transform(validarPassword);

  Stream<bool> get combineStream => Rx.combineLatest2(streamUsuario, streamPassword, (a, b) => true);

  //Obtener los valores emitidos por el Stream
  String get usuario => usuarioController.value;
  String get password => passwordController.value;

  dispose(){
    usuarioController?.close();
    passwordController?.close();
  }
}