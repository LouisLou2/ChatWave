import 'package:chat_wave/extension/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constant/assets_const.dart';
import '../../../ui/widget/backgroud_curves_painter.dart';
import '../widget/selection_sheet.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: context.theme.colorScheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: -200,
              top: 90,
              child: Container(
                height: 500,
                width: 600,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                      Theme.of(context).colorScheme.background.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
            ),
            CustomPaint(
              painter: BackgroundCurvesPainter(context.theme.colorScheme.onSurface),
              size: Size.infinite,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: context.theme.colorScheme.onSurface.withOpacity(0.25),
                            offset: const Offset(4, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Personal AI Buddy',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Image.asset(
                            AssetsConst.aiStarPic,
                            color: Theme.of(context).colorScheme.background,
                            scale: 23,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Lottie.asset(
                    AssetsConst.chatBotAnim,
                  ),
                  Text(
                    'Chat with PDF & Images!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                      fontFamily: 'Poppins',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:20),
                    child:ElevatedButton(
                      onPressed: () {
                        final TextEditingController apiKeyController =
                        TextEditingController();

                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return const SelectionSheet();
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.onSurface,
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text(
                        'Get Started',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}