import 'dart:io';

import 'package:crud/src/models/product_model.dart';
import 'package:crud/src/providers/product_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc{
  final _productosController = new BehaviorSubject<List<ProductModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductProvider();

  Stream<List<ProductModel>> get productosStream => _productosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;

  void cargarProductos() async{
    final productos = await _productosProvider.cargarProductos();
    _productosController.sink.add(productos);
  }

  void agregarProducto(ProductModel producto) async{
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(producto);
    _cargandoController.sink.add(false);
  }

  void modificarProducto(ProductModel producto) async{
    _cargandoController.sink.add(true);
    await _productosProvider.modificarProducto(producto);
    _cargandoController.sink.add(false);
  }

  void borrarProducto(String id) async{
    await _productosProvider.borrarProducto(id);
  }

  Future<String> subirImagen(File imagen) async{
    _cargandoController.sink.add(true);
    final imagenUrl = await _productosProvider.subirImagen(imagen);
    _cargandoController.sink.add(false);
    return imagenUrl;
  }

  dispose(){
    _productosController?.close();
    _cargandoController?.close();
  }
}