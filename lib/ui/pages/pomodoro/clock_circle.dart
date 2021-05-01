import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../controllers/pomodoro_controller.dart';
import '../../../models/clock_dail_painter.dart';
import '../../widgets/custom_text.dart';

class ClockCircle extends StatelessWidget {
  const ClockCircle();
  String toTwoDigits(int numb) {
    if (numb <= 9) return '0$numb';
    return numb.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
        alignment: Alignment.topCenter,
        child: GetBuilder<PomodoroController>(
            id: 'pomodoro',
            builder: (pc) {
              return Container(
                padding: const EdgeInsets.only(left: 40, right: 40),
                child: CircularPercentIndicator(
                  percent: pc.percent,
                  animation: true,
                  lineWidth: 20.0,
                  circularStrokeCap: CircularStrokeCap.square,
                  linearGradient: LinearGradient(
                    colors: [
                      Colors.green.withOpacity(0.2),
                      Colors.blue.withOpacity(0.2)
                    ],
                    tileMode: TileMode.mirror,
                  ),
                  reverse: false,
                  backgroundColor: Colors.transparent,
                  animateFromLastPercent: true,
                  radius: getValueForScreenType(
                      context: context, mobile: 300, desktop: 440, tablet: 350),
                  restartAnimation: true,
                  widgetIndicator: Icon(
                    Icons.arrow_drop_down_rounded,
                    size: 100,
                    color: Colors.red,
                  ),
                  center: Container(
                    // color: Colors.amber,
                    margin: EdgeInsets.all(40),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: double.infinity,
                          child: CustomPaint(
                            size: Size.square(200),
                            painter: ClockDialPainter(),
                          ),
                        ),
                        Center(
                          child: CustomText(
                            text:
                                "${toTwoDigits(pc.minutes)} :${toTwoDigits(pc.seconds)}",
                            fontSize: getValueForScreenType(
                                context: context,
                                mobile: 25,
                                desktop: 50,
                                tablet: 25),
                            iprefText: true,
                            textDirection: TextDirection.ltr,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
