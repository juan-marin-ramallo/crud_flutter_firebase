import 'dart:io';

import 'package:crud/src/models/product_model.dart';
import 'package:crud/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:mime_type/mime_type.dart';
import 'dart:convert';


class ProductProvider {
  //final String urlDB = "https://taller3-marin202104-default-rtdb.firebaseio.com";
  final _prefs = new PreferenciasUsuario();

  Future<bool> crearProducto(ProductModel producto) async{
    final Uri uri = new Uri.https("taller3-marin202104-default-rtdb.firebaseio.com", "productos.json", {'auth' : _prefs.token});

    final respuestaAPIRest = await http.post(uri, body: productModelToJson(producto));

    final decodeData = json.decode(respuestaAPIRest.body);

    print(decodeData);

    return true;
  }

  Future<List<ProductModel>> cargarProductos() async{
    final Uri uri = new Uri.https("taller3-marin202104-default-rtdb.firebaseio.com", "productos.json", {'auth' : _prefs.token});

    final respuestaAPIRest = await http.get(uri);

    final Map<String, dynamic> mapaProductos = json.decode(respuestaAPIRest.body);

    final List<ProductModel> listaProductos = [];

    if(mapaProductos == null) return [];

    if(mapaProductos['error'] != null) return [];

    mapaProductos.forEach((key, value) {
      final productoTemp = ProductModel.fromJson(value);
      productoTemp.id = key;

      listaProductos.add(productoTemp);
    });

    return listaProductos;
  }

  Future<bool> borrarProducto(String id) async{
    final Uri uri = new Uri.https("taller3-marin202104-default-rtdb.firebaseio.com", "productos/$id.json", {'auth' : _prefs.token});

    final respuestaAPIRest = await http.delete(uri);

    final decodeData = json.decode(respuestaAPIRest.body);

    print(decodeData);

    return true;
  }

  Future<bool> modificarProducto(ProductModel producto) async{
    final Uri uri = new Uri.https("taller3-marin202104-default-rtdb.firebaseio.com", "productos/${producto.id}.json", {'auth' : _prefs.token});

    final respuestaAPIRest = await http.put(uri, body: productModelToJson(producto));

    final decodeData = json.decode(respuestaAPIRest.body);

    print(decodeData);

    return true;
  }

  Future<String> subirImagen(File imagen) async{
    final url = Uri.parse("https://api.cloudinary.com/v1_1/dh9cbzzgu/image/upload?upload_preset=ttp7fia2");
    final mimeType = mime(imagen.path).split('/'); //image/jpg

    final imageUploadRequest = http.MultipartRequest('POST',url);

    final file = await http.MultipartFile.fromPath(
        'file',
        imagen.path,
        contentType: MediaType(mimeType[0],mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salió mal');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);
    return respData['secure_url'];
  }
}