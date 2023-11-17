import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_list/model/market_user_model.dart';
import 'package:market_list/routes/market_list_routes.dart';

class MarketListLoginScreen extends StatefulWidget {
  const MarketListLoginScreen({super.key});

  @override
  _MarketListLoginScreen createState() => _MarketListLoginScreen();
}

class _MarketListLoginScreen extends State<MarketListLoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailUsernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Faça login ou cadastre-se'),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailUsernameController,
                    decoration: const InputDecoration(labelText: "E-mail"),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Senha"),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        child: const Text('Login'),
                        onPressed: _login,
                      ),
                      OutlinedButton(
                          child: const Text('Registrar'),
                          onPressed: () {
                            Navigator.of(context).pushNamed(MarketListRoutes.MARKET_LIST_REGISTER_USER);
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

  Future<void> _login() async {
    String getErrorMessage = '';
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailUsernameController.text.trim(),
        password: _passwordController.text,
      );

      final User? user = userCredential.user;

      if (user != null) {
        const snackBar = SnackBar(
          content: Text('Login realizado !'),
          duration: Duration(seconds: 1),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.of(context).pushNamed(MarketListRoutes.MARKET_LIST_HOME,
              arguments: userCredential);
        }
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          getErrorMessage = 'Usuário não encontrado';
          break;
        case 'invalid-email':
          getErrorMessage = 'E-mail inválido';
          break;
        case 'user-disabled':
          getErrorMessage = 'O usuário está desabilitado';
          break;
        case 'wrong-password':
          getErrorMessage = 'A senha não corresponde ao cadastro informado';
          break;
        default:
          getErrorMessage = 'Ocorreu um erro ao efetuar o login';
          break;
      }
    } catch (e) {
      const snackBar = SnackBar(
        content: Text('Erro desconhecido !'),
        duration: Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    final snackBar = SnackBar(
      content: Text(getErrorMessage),
      duration: const Duration(seconds: 3),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      MarketUserModel user = userCredential.user as MarketUserModel;
      print("Usuário autenticado: ${user.uid}");
    } catch (e) {
      print("Erro ao fazer login: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print("Usuário desconectado");
    } catch (e) {
      print("Erro ao fazer logout: $e");
    }
  }
}
