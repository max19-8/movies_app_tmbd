import 'package:flutter/material.dart';
import 'package:movies_app_tmbd/ui/Theme/AppButtonStyle.dart';
import 'package:movies_app_tmbd/ui/widgets/auth_screen/auth_model.dart';
import 'package:provider/provider.dart';


class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to your account'),
      ),
      body: ListView(
        children: const [
          _HeaderWidget(),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16, color: Colors.black);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 25),
          const Text(
              'In order to use the editing and rating capabilities of TMDB,'
              ' as well as get personal recommendations you will need to'
              ' login to your account.If you do not have an account,'
              ' registering for an account is free and simple.'
              'Click here to get started.',
              style: textStyle),
          TextButton(
              onPressed: () {},
              style: AppButtonStyle.linkButton,
              child: const Text('Register')),
          const SizedBox(height: 25),
          const Text(
              'If you signed up but didn'
              't '
              'get your verification email, to have it resent.',
              style: textStyle),
          TextButton(
              onPressed: () {},
              style: AppButtonStyle.linkButton,
              child: const Text('Verify Email')),
          const SizedBox(height: 20),
          const _FormWidget(),
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
 const  _FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthViewModel>();
    const textFieldDecorator = InputDecoration(
      // border: OutlineInputBorder(),
      isCollapsed: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFced4da), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF01B4E4), width: 1),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Username'),
        const SizedBox(height: 5),
        TextField(
            decoration: textFieldDecorator,
            controller: model.loginTextController),
        const SizedBox(height: 10),
        const Text('Password'),
        const SizedBox(height: 5),
        TextField(
            decoration: textFieldDecorator,
            obscureText: true,
            controller: model.passwordTextController),
        const SizedBox(height: 20),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(width: 20),
            TextButton(
                onPressed: () {},
                style: AppButtonStyle.linkButton,
                child: const Text('Reset password')),
          ],
        ),
        const _ErrorMessageWidget(),
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
final model = context.watch<AuthViewModel>();
    final onPressed = model.canStartAuth ? () => model.auth(context) : null;
    final child = model.isAuthProgress
        ? const SizedBox(
            width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2,))
        : const Text('Login');
    return ElevatedButton(
      onPressed: onPressed,
      style: AppButtonStyle.elevatedBtn,
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final errorMessage = context.select((AuthViewModel model) => model.errorMessage);
    if (errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(errorMessage,
          style: const TextStyle(fontSize: 17, color: Colors.red)),
    );
  }
}
