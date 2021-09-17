import 'dart:async';

class Validators{
  final validarPassword = StreamTransformer<String,String>.fromHandlers(
    handleData: (password,sink){
      if(password.length>=6)
        sink.add(password);
      else
        sink.addError('Ingrese más de 6 caracteres');
    }
  );

  final validarEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (usuario,sink){
      //Para validar que lo ingresado es un correo valido , se debe usar expresiones regulares
      Pattern pattern = r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);

      if  (regExp.hasMatch(usuario))
        sink.add(usuario);
      else
        sink.addError('Usuario debe tener formato correo');
    }
  );
}