import 'package:flutter/material.dart';
import 'package:crud/src/bloc/provider.dart';
import 'package:crud/src/models/product_model.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
          title: Text('HomePage')
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: crearBoton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc){
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){

        if(snapshot.hasData){
          final listaProductos = snapshot.data;

          return ListView.builder(
              itemCount: listaProductos.length,
              itemBuilder: (BuildContext context, int index) => _crearItem(context, productosBloc, listaProductos[index]),
          );
        }
        else
          return Center(child: CircularProgressIndicator());
      }
    );
  }

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc, ProductModel producto){
    return Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.blue
        ),
        onDismissed: (DismissDirection direccion) {
          setState(() {
            productosBloc.borrarProducto(producto.id);
          });
        },
        child: Card(
          child: Column(
            children: <Widget>[
              (producto.fotoUrl == null)
              ? Image(image: AssetImage('assets/No_Image.png'))
              : FadeInImage(
                  placeholder: AssetImage('assets/Loading.gif'),
                  image: NetworkImage(producto.fotoUrl),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.contain
              ),
              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text(producto.id),
                onTap: () => Navigator.pushNamed(context, 'product', arguments: producto).then((value) => setState((){})),
              ),
            ],
          )
        ),
    );
  }

  FloatingActionButton crearBoton(BuildContext context){
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.pushNamed(context, 'product')
    );
  }
}