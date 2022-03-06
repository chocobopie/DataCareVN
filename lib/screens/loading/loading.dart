import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Map data = {};

  void loginVerified() {
    data = ModalRoute.of(context)!.settings.arguments as Map;
    String route = data['route'];
    Navigator.pushReplacementNamed(context, '/$route');
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, (){
      loginVerified();
    });
  }

  @override
  Widget build(BuildContext context) {
    ModalRoute.of(context)!.settings.arguments as Map;
    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: SpinKitCubeGrid(
          color: Colors.white,
          size: 100.0,
        ),
      ),
    );
  }
}
