import 'package:chatapp_firebase/helper/helper_function.dart';
import 'package:chatapp_firebase/pages/auth/login_page.dart';
import 'package:chatapp_firebase/pages/home_page.dart';
import 'package:chatapp_firebase/service/auth_service.dart';
import 'package:chatapp_firebase/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
                child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          "Iniciar sesión",
                          style: TextStyle(
                            color: Colors.black,
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                         const Text(
                             "¡Crea una cuenta ahora para empezar a explorar!",
                             style: TextStyle(
                               color: Color(0xFF999999),
                                 fontSize: 15, fontWeight: FontWeight.w400)),
                        //  Image.asset("assets/register.png"),
                        TextFormField(
                          cursorColor: Color(0xFFF28500),
                          style: TextStyle(color: Colors.black),
                          decoration: textInputDecoration.copyWith(
                              labelText: "Nombre completo",
                              labelStyle: TextStyle(
                              color: Color(0xFF999999),
                              ),
                              prefixIcon: Icon(
                              Icons.person,
                              color: Color(0xFFF28500)),  
                              focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Color(0xFFF28500))),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Color(0xFFF28500)),),
                              ),              
                          onChanged: (val) {
                            setState(() {
                              fullName = val;
                            });
                          },
                          validator: (val) {
                            if (val!.isNotEmpty) {
                              return null;
                            } else {
                              return "El mombre no puede estar vacío";
                            }
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          cursorColor: Color(0xFFF28500),
                          style: TextStyle(color: Colors.black),
                          decoration: textInputDecoration.copyWith(
                              labelText: "Correo",
                              labelStyle: TextStyle(
                                color: Color(0xFF999999)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: Color(0xFFF28500),
                              ),
                              focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Color(0xFFF28500))),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Color(0xFFF28500))),
                              ),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },

                          // check tha validation
                          validator: (val) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val!)
                                ? null
                                : "Por favor ingresa un correo válido";
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          cursorColor: Color(0xFFF28500),
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Contraseña",
                              labelStyle: TextStyle(
                              color: Color(0xFF999999)),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Color(0xFFF28500),
                              ),
                              focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Color(0xFFF28500))),
                              enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2, color: Color(0xFFF28500))),
                              ),
                          validator: (val) {
                            if (val!.length < 6) {
                              return "La contraseña debe tener al menos 6 carácteres ";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: const Text(
                              "Registrarse",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            onPressed: () {
                              register();
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text.rich(TextSpan(
                          text: "Ya tengo cuenta ",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: "¡Inicia sesión ahora!",
                                style: const TextStyle(
                                    color: Color(0xFFF28500),
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreen(context, const LoginPage());
                                  }),
                          ],
                        )),
                      ],
                    )),
              ),
            ),
    );
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullName);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
