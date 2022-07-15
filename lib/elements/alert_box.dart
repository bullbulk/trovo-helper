import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class UriAlertBox extends StatelessWidget {
  final Uri uri;
  final Function() dismissCallback;

  const UriAlertBox(this.uri, this.dismissCallback, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Open the following link:"),
          const SizedBox(height: 12),
          SizedBox(
            width: 400,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: uri.toString(),
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        launchUrl(uri);
                      },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                child: const Text("Copy"),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: uri.toString()));
                },
              ),
              ElevatedButton(
                child: const Text("Close"),
                onPressed: dismissCallback,
              )
            ],
          )
        ],
      ),
    );
  }
}
