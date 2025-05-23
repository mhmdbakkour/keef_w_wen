import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/classes/repositories/user_repository.dart';
import 'package:keef_w_wen/views/pages/register_page.dart';
import 'package:keef_w_wen/views/widgets/form_text_widget.dart';

import '../../classes/notifiers/logged_user_notifier.dart';
import '../../classes/providers.dart';
import '../main_view.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController controllerUsername = TextEditingController(
    text: "janedoe",
  );
  final TextEditingController controllerPassword = TextEditingController(
    text: "janedoe123",
  );
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  bool submissionError = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(loggedUserProvider.notifier).clearUser();
      ref.read(userRepositoryProvider).logout();
    });
  }

  @override
  void dispose() {
    controllerUsername.dispose();
    controllerPassword.dispose();
    usernameFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(userRepositoryProvider);
    final loggedUserNotifier = ref.read(loggedUserProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(height: 60.0),
                const Text("Log In", style: TextStyle(fontSize: 40.0)),
                const SizedBox(height: 20),
                Hero(
                  tag: 'hero1',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          FormTextWidget(
                            label: "Username",
                            icon: Icons.person,
                            controller: controllerUsername,
                            focusNode: usernameFocusNode,
                            focusNodeNext: passwordFocusNode,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Enter your username'
                                        : null,
                          ),
                          const SizedBox(height: 12),
                          FormTextWidget(
                            label: "Password",
                            icon: Icons.lock,
                            controller: controllerPassword,
                            focusNode: passwordFocusNode,
                            obscureText: true,
                            validator:
                                (value) =>
                                    value == null || value.isEmpty
                                        ? 'Enter your password'
                                        : null,
                            onEditingComplete: () async {
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                await _login(repository, loggedUserNotifier);
                              }
                            },
                          ),
                          if (submissionError)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Invalid username or password",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      await _login(repository, loggedUserNotifier);
                    }
                  },
                  child: const Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text("Don't have an account? Register now!"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Forgot password? Reset now!"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login(
    UserRepository repository,
    LoggedUserNotifier loggedUserNotifier,
  ) async {
    try {
      if (!mounted) return;
      final tokens = await repository.login(
        controllerUsername.text,
        controllerPassword.text,
      );

      await repository.saveTokens(tokens['access'], tokens['refresh']);
      final currentUser = await repository.fetchCurrentUser();
      if (!mounted) return;
      loggedUserNotifier.setUser(currentUser);
      loggedUserNotifier.setFollowers();

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            settings: RouteSettings(name: '/main'),
            pageBuilder:
                (context, animation, secondaryAnimation) => const MainView(),
            transitionsBuilder:
                (context, animation, _, child) =>
                    FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 300),
          ),
        );
      }
    } catch (e) {
      setState(() {
        submissionError = true;
      });
    }
  }
}
