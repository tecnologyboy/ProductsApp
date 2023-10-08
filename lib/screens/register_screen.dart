import 'package:flutter/material.dart';
import 'package:productos_app/Ui/input_decorations.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'register';
  const RegisterScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              CardContainer(
                  child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 30),
                  ChangeNotifierProvider(
                    create: (_) => LoginFormProvider(),
                    child: const _LoginForm(),
                  ),
                ],
              )),
              const SizedBox(
                height: 50,
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, LoginScreen.routeName),
                style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        Colors.indigo.withOpacity(0.1)),
                    shape: MaterialStateProperty.all(const StadiumBorder())),
                child: const Text('Do you have an account?',
                    style: TextStyle(fontSize: 18, color: Colors.black87)),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: loginForm.formKey,
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputdecoration(
                    hintText: 'lperez@medasoft.do',
                    labelText: 'Email',
                    prefixIcon: Icons.alternate_email_outlined),
                onChanged: (value) => loginForm.email = value,
                validator: (value) {
                  String pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = RegExp(pattern);

                  return regExp.hasMatch(value ?? '')
                      ? null
                      : 'The value is not like email';
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecorations.authInputdecoration(
                    hintText: '**************',
                    labelText: 'Password',
                    prefixIcon: Icons.lock_outlined),
                onChanged: (value) => loginForm.password = value,
                validator: (value) {
                  return (value != null && value.length > 6)
                      ? null
                      : 'The password need mor than 6 character';
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                color: Colors.deepPurple,
                onPressed: loginForm.isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).unfocus();

                        //Siempre que estamos dentro de un metodo ponemos el listen en false
                        //para evitar que de error el llamado del provider
                        //solo se escucha dentro del Build
                        final authService =
                            Provider.of<AuthService>(context, listen: false);

                        if (!loginForm.isValidForm()) return;

                        // loginForm.isLoading = true;

                        // await Future.delayed(const Duration(seconds: 2));

                        loginForm.isLoading = true;

                        //TODO validar si el login es correcto

                        final String? errorMessage = await authService
                            .createUser(loginForm.email, loginForm.password);

                        if (errorMessage == null) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(
                              context, HomeScreen.routeName);
                        } else {
                          //TODO mostrar error en pantalla
                          print(errorMessage);
                        }

                        loginForm.isLoading = false;
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  child: Text(
                    loginForm.isLoading ? 'Espere...' : 'Login',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
