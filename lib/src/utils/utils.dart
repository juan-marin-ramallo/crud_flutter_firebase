import 'package:flutter/material.dart';

bool isNumeric(String s){
  if(s.isEmpty) return false;

  //Si el tryParse se logra, entonces n es igual a un numero
  //caso contrario n seria nulo
  final n = num.tryParse(s);

  if (n == null)
    return false;
  else
    return true;
}

void mostrarAlerta(BuildContext context, String mensaje){
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Mensaje de Advertencia!'),
          content: Text(mensaje),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
              )
          ],
        );
      }
  );
}