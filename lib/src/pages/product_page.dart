import 'dart:io';

import 'package:crud/src/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crud/src/models/product_model.dart';
import 'package:crud/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();

  ProductosBloc productosBloc;
  ProductModel producto = new ProductModel();
  bool guardando = false;
  File archivoImagen;
  final picker = new ImagePicker();

  @override
  Widget build(BuildContext context) {
    productosBloc = Provider.productosBloc(context);
    final ProductModel productoSeleccionadoHomePage = ModalRoute.of(context).settings.arguments;

    if(productoSeleccionadoHomePage != null)
      producto = productoSeleccionadoHomePage;

    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: [
          IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto,
              ),
          IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _tomarFoto,
              ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
         padding: EdgeInsets.all(15.0),
         child: Form(
           key: formKey,
           child: Column(
             children: [
               _mostrarFoto(),
               _crearNombre(),
               _crearPrecio(),
               _crearDisponible(),
               SizedBox(height: 10,),
               _crearBoton(),
             ],
           )
         )
        )
      )
    );
  }

  Widget _mostrarFoto(){
    if(producto.fotoUrl != null){
      return FadeInImage(
          placeholder: AssetImage('assets/Loading.gif'),
          image: NetworkImage(producto.fotoUrl),
          height: 300.0,
          width: double.infinity,
          fit: BoxFit.contain
      );
    }
    else{
      if(archivoImagen!=null){
        return Image.file(
          archivoImagen,
          fit: BoxFit.cover,
          height: 300.0,
        );
      }
      return Image.asset("assets/No_Image.png");
    }
  }

  Future _seleccionarFoto() async{
    _procesarFoto(ImageSource.gallery);
  }

  Future _tomarFoto() async{
    _procesarFoto(ImageSource.camera);
  }

  Future _procesarFoto(ImageSource imageSource) async{
    final fotoSeleccionada = await picker.getImage(
        source: imageSource
    );

    if(fotoSeleccionada != null)
      producto.fotoUrl = null;

    setState(() {
      archivoImagen = File(fotoSeleccionada.path);
    });
  }

  Widget _crearDisponible(){
    return SwitchListTile(
        value: producto.disponible,
        title: Text('Disponible'),
        onChanged: (value) => setState((){
          producto.disponible = value;
        }),
    );
  }

  Widget _crearNombre(){
    return TextFormField(
      initialValue: producto.titulo,
      onSaved: (value) => producto.titulo = value,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      validator: (value) {
        if (value.length < 3){
          return 'Ingrese un nombre correcto para el producto';
        }
      },
    );
  }

  Widget _crearPrecio(){
    return TextFormField(
      initialValue: producto.valor.toString(),
      onSaved: (value) => producto.valor = double.parse(value),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
          labelText: 'Precio'
      ),
      validator: (value) {
        if(utils.isNumeric(value))
          return null;
        else
          return 'Por favor ingrese solo numeros';
      },
    );
  }

  Widget _crearBoton(){
    return ElevatedButton.icon(
        icon: Icon(Icons.save),
        label: Text('Guardar'),
        onPressed: (guardando) ? null : submit,
    );
  }

  void submit() async{
    //Si el formulario NO es valido, salgo y no hago nada con un return
    if(!formKey.currentState.validate())
      return;

    //Si el formulario es valido, continuo guardando los datos del formulario al objeto
    formKey.currentState.save();

    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);

    setState(() {
      guardando = true;
    });

    if(archivoImagen != null){
      producto.fotoUrl = await productosBloc.subirImagen(archivoImagen);
    }

    if(producto.id == null){
      productosBloc.agregarProducto(producto);
      mostrarSnackbar("El producto fue creado exitosamente");
    }
    else{
      productosBloc.modificarProducto(producto);
      mostrarSnackbar("El producto fue actualizado exitosamente");
    }

    setState(() {
      guardando = false;
    });

    Navigator.pop(context);
  }

  void mostrarSnackbar(String mensaje){
    final snackBar = SnackBar(
        content: Text(mensaje),
        duration: Duration(milliseconds: 1500),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
