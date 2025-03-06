import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network_app/blocs/sign_in_bloc/sign_in_bloc.dart';

import '../../components/strings.dart';
import '../../components/text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMsg;
  bool obscurePassword = true;
  bool signInRequired = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
            _errorMsg = "Invalid email or password";
          });
        }
      },
      child: Form(
        key: _formKey,
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: CustomTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                prefixIcon: const Icon(CupertinoIcons.mail_solid),
                keyboardType: TextInputType.emailAddress,
                errorMsg: _errorMsg,
                validation: (val) {
                  if (val!.isEmpty) {
                    return 'Email is required';
                  } else if (!emailRexExp.hasMatch(val)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: CustomTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: obscurePassword,
              prefixIcon: const Icon(CupertinoIcons.lock_fill),
              keyboardType: TextInputType.visiblePassword,
              errorMsg: _errorMsg,
              validation: (val) {
                if (val!.isEmpty) {
                  return 'Password is required';
                } else if (!passwordRegExp.hasMatch(val)) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          !signInRequired
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInBloc>().add(
                              SignInRequired(
                                emailController.text,
                                passwordController.text,
                              ),
                            );
                      }
                    },
                    style: TextButton.styleFrom(
                      elevation: 3,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                      child: Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              : const CircularProgressIndicator(),
        ]),
      ),
    );
  }
}
