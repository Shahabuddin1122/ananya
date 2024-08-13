import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: Theme.of(context).largemainPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Image.network(
                'https://s3-alpha-sig.figma.com/img/aef7/3a79/cc9105cf3b9077b72d3e81c9af2d1b39?Expires=1724630400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=p4ZACGagYH6DQcgYcRyNbSstQKB6wR1YX5V8OpI~x28YCq2HbgL8wEyDd05ub6UztwBCdUVrepht1L3gymLVt7GXZBakHewwx0lq5VwJycPt1O82xo-xYDoJPJMZm2gXHuuzcKV6XsgKVVqivlWN1r0jLyxqxiNyM9P7oMKl8QaEa4iKWgrDJBddP5njHrZbsQIJicpjcTb7F4wyMkaIsWHq3huYGIoLwW0Oeg45jCPaiLIGNVYhGlC6ghTeHLplGFrzGF0yA~hH2z8krAtDwhBN-C4GuiZUP1eRjmT88xmewS93jpIb5ELMQoTqRZkY4bqbJBmTmToKDVTdAAnTfg__',
                width: 500,
              ),
              Padding(
                padding: Theme.of(context).largemainPadding,
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Calculating ',
                        style: TextStyle(
                          fontSize: 32,
                          color: ACCENT,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'your cycle prediction...',
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
