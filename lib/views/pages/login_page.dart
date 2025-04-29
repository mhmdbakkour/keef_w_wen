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
    Future.microtask(() => ref.read(loggedUserProvider.notifier).clearUser());
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
    final UserRepository repository = ref.read(userRepositoryProvider);
    final loggedUserNotifier = ref.read(loggedUserProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60.0),
                  Text("Log In", style: TextStyle(fontSize: 40.0)),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Hero(
                      tag: 'hero1',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Column(
                          children: [
                            FormTextWidget(
                              title: 'Username',
                              icon: Icon(Icons.person),
                              controller: controllerUsername,
                              focusNode: usernameFocusNode,
                              onSubmitted: (_) {
                                FocusScope.of(
                                  context,
                                ).requestFocus(passwordFocusNode);
                              },
                            ),
                            FormTextWidget(
                              title: 'Password',
                              icon: Icon(Icons.lock),
                              controller: controllerPassword,
                              focusNode: passwordFocusNode,
                              hidden: true,
                              onEditingComplete: () async {
                                _login(repository, loggedUserNotifier);
                              },
                              onSubmitted: (_) {
                                FocusScope.of(context).unfocus();
                              },
                            ),
                            submissionError
                                ? Text(
                                  "Invalid username or password",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: FilledButton(
                      onPressed: () async {
                        _login(repository, loggedUserNotifier);
                      },
                      child: Text("Login"),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RegisterPage();
                          },
                        ),
                      );
                    },
                    child: Text("Don't have an account? Register now!"),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text("Forgot password? Reset now!"),
                  ),
                ],
              ),
            ],
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

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MainView(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: Duration(milliseconds: 300),
          ),
        );
      }
    } catch (e) {
      setState(() {
        submissionError = true;
        print(submissionError);
      });
      throw Exception(e);
    }
  }
}
