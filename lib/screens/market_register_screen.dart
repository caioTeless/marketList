import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:market_list/routes/market_list_routes.dart';
import 'package:market_list/widgets/input_form_field_widget.dart';

class MarketRegisterScreen extends StatefulWidget {
  const MarketRegisterScreen({super.key});

  @override
  _MarketRegisterScreen createState() => _MarketRegisterScreen();
}

class _MarketRegisterScreen extends State<MarketRegisterScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Cadastre-se', style: TextStyle(fontSize: 25)),
              const SizedBox(height: 25.0),
              Column(
                children: [
                  InputFormFieldWidget(
                    controller: _userNameController,
                    hintText: 'Usuário',
                    onSaved: (_) {},
                  ),
                  const SizedBox(height: 8.0),
                  InputFormFieldWidget(
                    controller: _emailController,
                    hintText: 'E-mail',
                    onSaved: (_) {},
                  ),
                  const SizedBox(height: 8.0),
                  InputFormFieldWidget(
                    controller: _passwordController,
                    hintText: 'Senha',
                    onSaved: (_) {},
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                          child: const Text('Registrar'),
                          onPressed: () => registerUser(_emailController.text,
                              _passwordController.text, context)),
                      OutlinedButton(
                          child: const Text('Voltar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> registerUser(
      String email, String password, BuildContext context) async {
    bool result = await InternetConnectionChecker().hasConnection;
    try {
      if (_userNameController.text == "" ||
          _emailController.text == "" ||
          _passwordController.text == "") {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        userCredential.user!.updateDisplayName(_userNameController.text);

        const snackBar = SnackBar(
          content: Text('Registrado com sucesso !'),
          duration: Duration(seconds: 1),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pushNamed(MarketListRoutes.MARKET_LIST_HOME,
              arguments: userCredential);
        }
      } else {
        const snackBar = SnackBar(
          content: Text('Registrado com sucesso !'),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      // Ocorreu um erro durante o registro.
      print("Erro durante o registro: $e");
    }
  }
}
