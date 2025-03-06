import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

import '../../blocs/sign_up_bloc/sign_up_bloc.dart';
import '../../components/strings.dart';
import '../../components/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  bool obscurePassword = true;
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool isLengthValid = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpProcess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          return;
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
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
                onChanged: (val) {
                  if (val!.contains(RegExp(r'[A-Z]'))) {
                    setState(() {
                      containsUpperCase = true;
                    });
                  } else {
                    setState(() {
                      containsUpperCase = false;
                    });
                  }
                  if (val.contains(RegExp(r'[a-z]'))) {
                    setState(() {
                      containsLowerCase = true;
                    });
                  } else {
                    setState(() {
                      containsLowerCase = false;
                    });
                  }
                  if (val.contains(RegExp(r'[0-9]'))) {
                    setState(() {
                      containsNumber = true;
                    });
                  } else {
                    setState(() {
                      containsNumber = false;
                    });
                  }
                  if (val.contains(specialCharRexExp)) {
                    setState(() {
                      containsSpecialChar = true;
                    });
                  } else {
                    setState(() {
                      containsSpecialChar = false;
                    });
                  }
                  if (val.length >= 8) {
                    setState(() {
                      isLengthValid = true;
                    });
                  } else {
                    setState(() {
                      isLengthValid = false;
                    });
                  }
                  return null;
                },
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "⚈  1 uppercase",
                      style:
                          TextStyle(color: containsUpperCase ? Colors.green : Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "⚈  1 lowercase",
                      style:
                          TextStyle(color: containsLowerCase ? Colors.green : Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "⚈  1 number",
                      style: TextStyle(color: containsNumber ? Colors.green : Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "⚈  1 special character",
                      style: TextStyle(
                          color: containsSpecialChar ? Colors.green : Theme.of(context).colorScheme.onSurface),
                    ),
                    Text(
                      "⚈  8 minimum character",
                      style: TextStyle(color: isLengthValid ? Colors.green : Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: CustomTextField(
                controller: nameController,
                hintText: 'Name',
                obscureText: false,
                prefixIcon: const Icon(CupertinoIcons.person_fill),
                keyboardType: TextInputType.name,
                validation: (val) {
                  if (val!.isEmpty) {
                    return 'Name is required';
                  } else if (val.length < 3 || val.length > 50) {
                    return 'Name must be between 3 and 50 characters';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            !signUpRequired
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          MyUser myUser = MyUser.empty;
                          myUser = myUser.copyWith(
                            email: emailController.text,
                            name: nameController.text,
                          );
                          setState(() {
                            context.read<SignUpBloc>().add(
                                  SignUpRequired(
                                    myUser,
                                    passwordController.text,
                                  ),
                                );
                          });
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
                          'Sign Up',
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
          ],
        ),
      ),
    );
  }
}
