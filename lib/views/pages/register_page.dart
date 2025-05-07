import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';
import 'package:keef_w_wen/views/pages/register_details_page.dart';
import '../../classes/providers.dart';
import '../../services/registration_validator.dart';
import '../widgets/form_text_widget.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final controllerUsername = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerConfirmPassword = TextEditingController();

  final FocusNode usernameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  bool isUsernameAvailable = true;
  bool isEmailAvailable = true;

  Future<void> submitDetails(UserRepository repository) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      Map<String, bool> userAvailability = await repository
          .checkUserAvailability(
            username: controllerUsername.text.trim(),
            email: controllerEmail.text.trim(),
          );

      setState(() {
        isUsernameAvailable = userAvailability['username'] ?? false;
        isEmailAvailable = userAvailability['email'] ?? false;
      });

      if (isUsernameAvailable && isEmailAvailable) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => RegisterDetailsPage(
                  requiredUserData: {
                    'username': controllerUsername.text.trim(),
                    'email': controllerEmail.text.trim(),
                    'password': controllerPassword.text.trim(),
                    'associated_color': repository.generateAssociatedColor(),
                  },
                ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    controllerUsername.dispose();
    controllerEmail.dispose();
    controllerPassword.dispose();
    controllerConfirmPassword.dispose();
    usernameNode.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(userRepositoryProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(leading: BackButton()),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            autovalidateMode: AutovalidateMode.onUnfocus,
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Register", style: TextStyle(fontSize: 40)),
                  const SizedBox(height: 20),
                  FormTextWidget(
                    controller: controllerUsername,
                    label: 'Username',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Username required';
                      if (!RegistrationValidator.isValidUsername(value)) {
                        return '3-20 chars, letters, optional numbers';
                      }
                      return null;
                    },
                    focusNode: usernameNode,
                    focusNodeNext: emailNode,
                  ),
                  FormTextWidget(
                    controller: controllerEmail,
                    label: 'Email',
                    icon: Icons.alternate_email,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Email required';
                      if (!RegistrationValidator.isValidEmail(value)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    focusNode: emailNode,
                    focusNodeNext: passwordNode,
                  ),
                  FormTextWidget(
                    controller: controllerPassword,
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return 'Password required';
                      if (!RegistrationValidator.isValidPassword(value)) {
                        return 'Min 8 chars, include letter & number';
                      }
                      return null;
                    },
                    focusNode: passwordNode,
                    focusNodeNext: confirmPasswordNode,
                  ),
                  FormTextWidget(
                    controller: controllerConfirmPassword,
                    label: 'Confirm Password',
                    icon: Icons.lock_reset,
                    obscureText: true,
                    validator: (value) {
                      if (value != controllerPassword.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    focusNode: confirmPasswordNode,
                    onEditingComplete: () {
                      submitDetails(repository);
                    },
                  ),
                  if (!isUsernameAvailable && !isEmailAvailable)
                    Text(
                      "Username and email already taken",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  else if (!isEmailAvailable)
                    Text(
                      "Email already taken",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  else if (!isUsernameAvailable)
                    Text(
                      "Username already taken",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    )
                  else
                    SizedBox.shrink(),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      submitDetails(repository);
                    },
                    child: Text("Register"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
