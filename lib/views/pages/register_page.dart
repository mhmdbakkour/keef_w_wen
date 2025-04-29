import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../classes/providers.dart';
import '../../classes/repositories/user_repository.dart';
import '../../services/registration_validator.dart';
import '../widgets/form_text_widget.dart';
import 'login_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController controllerUsername = TextEditingController();
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final TextEditingController controllerConfirmPassword =
      TextEditingController();

  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();

  String? usernameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  @override
  void initState() {
    super.initState();

    controllerEmail.addListener(validateEmail);
    controllerPassword.addListener(validatePassword);
    controllerConfirmPassword.addListener(validateConfirmPassword);
    controllerUsername.addListener(validateUsername);
  }

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
    controllerUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserRepository repository = ref.read(userRepositoryProvider);
    TextStyle errorStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.error,
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(leading: BackButton()),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Register", style: TextStyle(fontSize: 40.0)),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Hero(
                      tag: 'register_column',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Column(
                          children: [
                            FormTextWidget(
                              focusNode: usernameFocusNode,
                              title: 'Username',
                              icon: Icon(Icons.person),
                              controller: controllerUsername,
                              onSubmitted:
                                  (_) => FocusScope.of(
                                    context,
                                  ).requestFocus(emailFocusNode),
                            ),
                            usernameError != null
                                ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    usernameError!,
                                    style: errorStyle,
                                  ),
                                )
                                : SizedBox.shrink(),
                            FormTextWidget(
                              focusNode: emailFocusNode,
                              title: 'E-mail',
                              icon: Icon(Icons.alternate_email),
                              controller: controllerEmail,
                              onSubmitted:
                                  (_) => FocusScope.of(
                                    context,
                                  ).requestFocus(passwordFocusNode),
                            ),
                            emailError != null
                                ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(emailError!, style: errorStyle),
                                )
                                : SizedBox.shrink(),
                            FormTextWidget(
                              focusNode: passwordFocusNode,
                              title: 'Password',
                              icon: Icon(Icons.lock),
                              controller: controllerPassword,
                              hidden: true,
                              onSubmitted:
                                  (_) => FocusScope.of(
                                    context,
                                  ).requestFocus(confirmPasswordFocusNode),
                            ),
                            passwordError != null
                                ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    passwordError!,
                                    style: errorStyle,
                                  ),
                                )
                                : SizedBox.shrink(),
                            FormTextWidget(
                              focusNode: confirmPasswordFocusNode,
                              title: 'Repeat password',
                              icon: Icon(Icons.lock_reset),
                              controller: controllerConfirmPassword,
                              hidden: true,
                              onSubmitted:
                                  (_) => FocusScope.of(context).unfocus(),
                              onEditingComplete: () {
                                if (emailError == null &&
                                    passwordError == null &&
                                    confirmPasswordError == null &&
                                    usernameError == null) {
                                  repository.register({
                                    'username': controllerUsername.text,
                                    'email': controllerEmail.text,
                                    'password': controllerPassword.text,
                                  });

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LoginPage();
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                            confirmPasswordError != null
                                ? SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    confirmPasswordError!,
                                    style: errorStyle,
                                  ),
                                )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Map<String, String?> validation =
                          RegistrationValidator.validateRegistration(
                            email: controllerEmail.text,
                            password: controllerPassword.text,
                            confirmPassword: controllerConfirmPassword.text,
                            username: controllerUsername.text,
                          );

                      if (validation['email'] == null &&
                          validation['password'] == null &&
                          validation['confirmPassword'] == null &&
                          validation['username'] == null) {
                        repository.register({
                          'username': controllerUsername.text,
                          'email': controllerEmail.text,
                          'password': controllerPassword.text,
                        });

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPage();
                            },
                          ),
                        );
                      } else {
                        setState(() {
                          emailError = validation['email'];
                          passwordError = validation['password'];
                          confirmPasswordError = validation['confirmPassword'];
                          usernameError = validation['username'];
                        });
                      }
                    },
                    child: Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validateEmail() {
    setState(() {
      if (controllerEmail.text.isNotEmpty) {
        emailError =
            RegistrationValidator.isValidEmail(controllerEmail.text)
                ? null
                : 'Invalid email format.';
      } else {
        emailError = null;
      }
    });
  }

  void validatePassword() {
    setState(() {
      if (controllerPassword.text.isNotEmpty) {
        passwordError =
            RegistrationValidator.isValidPassword(controllerPassword.text)
                ? null
                : 'Password must be at least 8 characters long and include a letter and a number.';
      } else {
        passwordError = null;
      }
    });
  }

  void validateConfirmPassword() {
    setState(() {
      if (controllerConfirmPassword.text.isNotEmpty) {
        confirmPasswordError =
            RegistrationValidator.doPasswordsMatch(
                  controllerPassword.text,
                  controllerConfirmPassword.text,
                )
                ? null
                : 'Passwords do not match.';
      } else {
        confirmPasswordError = null;
      }
    });
  }

  void validateUsername() {
    setState(() {
      if (controllerUsername.text.isNotEmpty) {
        usernameError =
            RegistrationValidator.isValidUsername(controllerUsername.text)
                ? null
                : 'Username must be 3-20 characters long, must include letters, and can include numbers and underscores.';
      } else {
        usernameError = null;
      }
    });
  }
}
