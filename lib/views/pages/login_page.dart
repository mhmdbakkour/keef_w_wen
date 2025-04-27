import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keef_w_wen/views/pages/register_page.dart';
import 'package:keef_w_wen/views/main_view.dart';
import 'package:keef_w_wen/views/widgets/form_text_widget.dart';

import '../../classes/data/user.dart';
import '../../classes/providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController controllerUsername = TextEditingController(
    text: "janedoe",
  );
  TextEditingController controllerPassword = TextEditingController(
    text: "password",
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(userProvider.notifier).fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
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
                                ),
                                FormTextWidget(
                                  title: 'Password',
                                  icon: Icon(Icons.lock),
                                  controller: controllerPassword,
                                  password: false,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: FilledButton(
                          onPressed: () {
                            final List<User> users =
                                ref.read(userProvider).users;
                            final matches = users.where(
                              (u) => u.username == controllerUsername.text,
                            );
                            if (matches.isNotEmpty) {
                              final matchedUser = matches.first;
                              ref
                                  .read(loggedUserProvider.notifier)
                                  .setUser(matchedUser);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainView(),
                                  settings: RouteSettings(name: "/main"),
                                ),
                              );
                            } else {
                              print("User not found :( (LoginPage)");
                            }
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
      },
    );
  }
}
