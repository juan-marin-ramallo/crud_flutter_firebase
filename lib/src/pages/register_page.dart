import 'package:crud/src/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:crud/src/providers/usuario_provider.dart';
import 'package:crud/src/bloc/provider.dart';
import 'package:crud/src/bloc/login_bloc.dart';

class RegisterPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('RegisterPage')
      ),
      body: Stack(
        children: <Widget> [
          crearFondo(context),
          registroForm(context)
        ],
      ),
    );
  }

  Widget crearFondo(BuildContext contexto){
    final size = MediaQuery.of(contexto).size;
    final fondo = Container(
      height: size.height * 0.4,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color> [
                Color.fromRGBO(30, 120, 160, 1.0),
                Color.fromRGBO(50, 70, 150, 1.0),
              ]
          )
      ),
    );
    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.white
      ),
    );
    return Stack(
      children: [
        fondo,
        Positioned(top: 90.0, left: 30, child: circulo),
        Positioned(top: -40.0, right: -30, child: circulo),
        Positioned(bottom: -50.0, right: -10, child: circulo),
        Positioned(bottom: -120.0, left: 20, child: circulo),
        Positioned(bottom: -50.0, left: -20, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: [
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0,),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('REGISTER FLUTTER', style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );
  }

  Widget registroForm(BuildContext context){
    final bloc = Provider.of(context);
    final sizeScreen = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(child: Container(height: 190.0,)),
          Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.symmetric(vertical: 30.0),
              width: sizeScreen.width * 0.85,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: <BoxShadow> [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 5.0),
                        spreadRadius: 3.0
                    )
                  ]
              ),
              child: Column(
                children: [
                  Text('Registro'),
                  SizedBox(height: 10),
                  crearEmail(bloc),
                  SizedBox(height: 10),
                  crearPassword(bloc),
                  SizedBox(height: 15),
                  crearBotonRegistrar(bloc),
                ],
              )
          ),
          ElevatedButton(
            child: Text('Ya tienes una cuenta?'),
            onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget crearEmail(LoginBloc bloc){
    return StreamBuilder(
        stream: bloc.streamUsuario,
        builder: (BuildContext contexto, AsyncSnapshot snapshot) {
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    icon: Icon(Icons.email, color: Colors.blue),
                    labelText: 'Correo Electronico',
                    hintText: 'ejemplo@correo.com',
                    counterText: snapshot.data,
                    errorText: snapshot.error
                ),
                onChanged: bloc.sinkUsuario,
              )
          );
        }
    );
  }

  Widget crearPassword(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.streamPassword,
      builder: (BuildContext context, AsyncSnapshot datos) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Colors.blue),
                  labelText: 'Contraseña',
                  counterText: datos.data,
                  errorText: datos.error
              ),
              onChanged: bloc.sinkPassword,
            )
        );
      },
    );
  }

  Widget crearBotonRegistrar(LoginBloc bloc){
    return StreamBuilder(
        stream: bloc.combineStream,
        builder: (BuildContext context, AsyncSnapshot data){
          return ElevatedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text('Registrar'),
            ),
            onPressed: data.hasData ? () => register(context, bloc) : null,
          );
        }
    );
  }

  void register(BuildContext context, LoginBloc bloc) async {
    final Map infoRegister = await usuarioProvider.crearNuevoUsuario(
        bloc.usuario, bloc.password);

    if (infoRegister['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    }
    else {
      mostrarAlerta(context, infoRegister['mensaje']);
    }
  }
}





