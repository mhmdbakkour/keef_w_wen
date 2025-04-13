import 'package:flutter/material.dart';
import '../widgets/form_text_widget.dart';
import 'login_page.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                              title: 'Username',
                              icon: Icon(Icons.person),
                            ),
                            FormTextWidget(
                              title: 'E-mail',
                              icon: Icon(Icons.alternate_email),
                            ),
                            FormTextWidget(
                              title: 'Password',
                              icon: Icon(Icons.lock),
                            ),
                            FormTextWidget(
                              title: 'Repeat password',
                              icon: Icon(Icons.lock_reset),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage();
                          },
                        ),
                      );
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
}
