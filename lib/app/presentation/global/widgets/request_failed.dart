import 'package:flutter/material.dart';

import '../../../generated/assets.gen.dart';

class RequestFailed extends StatelessWidget {
  const RequestFailed({
    Key? key,
    required this.onRetry,
    this.text,
  }) : super(key: key);
  final VoidCallback onRetry;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              Assets.images.error404.path,
            ),
          ),
          Text(text ?? 'Request Failed'),
          const SizedBox(
            height: 10,
          ),
          MaterialButton(
            onPressed: onRetry,
            color: Colors.blueAccent,
            child: const Text(
              'Retry',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
