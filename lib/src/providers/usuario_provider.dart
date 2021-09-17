import 'package:crud/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioProvider{
  final String _firebaseAPIKey = 'AIzaSyChMAwMK4nPh35zHsldcPmFxQ98MPdFES4';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async{
    final authData = {
      'email'     : email,
      'password'  : password,
      'returnSecureToken' : true
    };

    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseAPIKey');

    final resp = await http.post(
        url,
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      _prefs.token = decodedResp['idToken'];
      return {'ok' : true, 'token' : decodedResp['idToken']};
    }
    else{
      return {'ok' : false, 'mensaje' : decodedResp['error']['message']};
    }
  }

  Future<Map<String, dynamic>> crearNuevoUsuario(String email, String password) async{
    final authData = {
      'email'     : email,
      'password'  : password,
      'returnSecureToken' : true
    };

    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseAPIKey');

    final resp = await http.post(
        url,
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      _prefs.token = decodedResp['idToken'];
      return {'ok' : true, 'token' : decodedResp['idToken']};
    }
    else{
      return {'ok' : false, 'mensaje' : decodedResp['error']['message']};
    }
  }
}