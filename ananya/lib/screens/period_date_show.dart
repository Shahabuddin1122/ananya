import 'package:ananya/utils/constants.dart';
import 'package:ananya/utils/custom_theme.dart';
import 'package:flutter/material.dart';

class PeriodDateShow extends StatelessWidget {
  const PeriodDateShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Theme.of(context).largemainPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Image.network(
                  'https://s3-alpha-sig.figma.com/img/cd87/d28f/ba2592f440db12c51c088a402e29ddbb?Expires=1724630400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=LFEdfkADcKTVLmPga6IthUoowiq6nO200RKPcck23ViBGRxGVzURzClzrk612Moa9XPCnfgYei7JkfeeFsoxGGkWVDHybgSsQwkltMLUAJsJ-GQ6n~pdpp2CaUjmKpinE1CkQ6fjvk-gtDXCf9AO~-hJg7TBOo5e2xCdiHHSgIHebCHmFjfnZ0rN4ryubny9ysASNTxFjIUY77Jo1PdXZdh6OsRILA2X6o-2SATewF7cAD9Y4OCV7gSLfERQdzJZzb-gQXBt6~XLfPYMORblfGq7TyGwxFnqaMrvCVpvQ-SPtf89OQ6gyA9g0tyQZKCTtAz2CbPRJTgbWUaKLphjsA__',
                  width: 100,
                ),
                const SizedBox(height: 20),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Your next period will start around \n',
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ),
                      TextSpan(
                        text: '26 July',
                        style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loading');
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(ACCENT),
                minimumSize: WidgetStatePropertyAll(Size(double.infinity, 20)),
                shadowColor: WidgetStatePropertyAll(Colors.black),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    width: 1,
                  ),
                ),
              ),
              child: const Text(
                "Continue",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
