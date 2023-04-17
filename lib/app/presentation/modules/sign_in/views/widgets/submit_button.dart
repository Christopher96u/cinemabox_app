import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../global/controllers/session_controller.dart';
import '../../../../routes/routes.dart';
import '../../controller/sign_in_controller.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SignInController controller = Provider.of(context);
    if (controller.state.fetching) {
      return const CircularProgressIndicator();
    }
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            onPressed: () {
              final isValid = Form.of(context).validate();
              if (isValid) {
                _submit(context);
              }
              print('clicked');
            },
            color: Colors.blueAccent,
            elevation: 0,
            highlightElevation: 0,
            child: const Text('Sign in'),
          ),
        ),
      ],
    );
  }

  Future<void> _submit(BuildContext context) async {
    final SignInController controller = context.read();
    final result = await controller.submit();
    if (!controller.mounted) {
      return;
    }
    result.when(
      left: (failure) {
        final message = failure.when(
          notFound: () => 'Not found',
          notVerified: () => 'Email not verified',
          network: () => 'Network error',
          unauthorized: () => 'Unauthorized',
          unkown: () => 'Unkown error',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      right: (user) {
        final SessionController sessionController = context.read();
        sessionController.setuser(user);
        Navigator.pushReplacementNamed(context, Routes.home);
      },
    );
  }
}
