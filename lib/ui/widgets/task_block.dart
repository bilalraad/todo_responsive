import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../controllers/settings_controller.dart';
import '../../controllers/task_controller.dart';
import '../../utils/date_formatter.dart';
import '../../models/task.dart';
import './createTask/creat_task.dart';
import './custom_text.dart';

class TaskBlock extends StatefulWidget {
  final Task taskData;

  const TaskBlock({
    Key key,
    this.taskData,
  }) : super(key: key);

  @override
  _TaskBlockState createState() => _TaskBlockState();
}

class _TaskBlockState extends State<TaskBlock>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _opacityAnimation;

  Color priorityBGColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
    ));

    priorityBGColor = widget.taskData.priority == TaskPriority.High
        ? Color(0xFFD8334F)
        : widget.taskData.priority == TaskPriority.Medium
            ? Color(0xFFE3A224)
            : Color(0xFF66C749);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      key: widget.key,
      child: Container(
        width: getValueForScreenType<double>(
            context: context,
            mobile: double.infinity,
            desktop: 440,
            tablet: double.infinity),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                blurRadius: 6, offset: Offset(0, 0), color: Colors.black26)
          ],
        ),
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () => updateTask(context: context, oldTask: widget.taskData),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleCheckbox(
                  value: widget.taskData.isFinished,
                  onChanged: (value) async {
                    await _controller.forward();
                    TaskController.to.updateTask(
                        widget.taskData.copyWith(isFinished: value));
                  },
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.taskData.title,
                    textType: TextType.title,
                  ),
                  CustomText(
                    text: widget.taskData.body.isEmpty
                        ? 'No description'
                        : widget.taskData.body.length > 20
                            ? widget.taskData.body.substring(0, 20)
                            : widget.taskData.body,
                    textType: TextType.smallest,
                    textColor: Color(0xFF878787),
                  ),
                  CustomText(
                    text: CustomDateFormatter.format(widget.taskData.dueDate),
                    iprefText: true,
                    textType: TextType.paragraph,
                  ),
                ],
              ),
              Spacer(),
              Container(
                height: 30,
                width: 90,
                alignment: Alignment.centerRight,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: priorityBGColor),
                child: Center(
                  child: CustomText(
                    text: describeEnum(widget.taskData.priority),
                    textColor: textColorBasedOnBG(priorityBGColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CircleCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color checkColor;
  final bool tristate;
  final MaterialTapTargetSize materialTapTargetSize;

  CircleCheckbox({
    Key key,
    @required this.value,
    this.tristate = false,
    @required this.onChanged,
    this.activeColor,
    this.checkColor,
    this.materialTapTargetSize,
  })  : assert(tristate != null),
        assert(tristate || value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      width: 24,
      height: 24,
      child: Theme(
        data: ThemeData(
          unselectedWidgetColor: Colors.transparent,
        ),
        child: Checkbox(
          activeColor: Colors.transparent,
          checkColor: Theme.of(context).colorScheme.secondary,
          value: value,
          tristate: tristate,
          onChanged: onChanged,
          materialTapTargetSize: materialTapTargetSize,
        ),
      ),
    );
  }
}
