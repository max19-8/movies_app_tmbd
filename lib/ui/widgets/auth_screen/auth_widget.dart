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
        title: const Text( 'войти в свою учётную запись'),
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
    const textStyle = TextStyle(fontSize: 18, color: Colors.black);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 25),
          Text(
              'Чтобы видеть контент  и пользоваться  возможностями рейтинга TMDB,'
                  ' а также получить персональные рекомендации, необходимо войти в свою учётную запись.',
              style: textStyle),
          SizedBox(height: 25),
          _FormWidget(),
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
        const Text('Логин'),
        const SizedBox(height: 5),
        TextField(
            decoration: textFieldDecorator,
            controller: model.loginTextController),
        const SizedBox(height: 10),
        const Text('Пароль'),
        const SizedBox(height: 5),
        TextField(
            decoration: textFieldDecorator,
            obscureText: true,
            controller: model.passwordTextController),
        const SizedBox(height: 4),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(width: 20),
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
        : const Text('Войти');
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
