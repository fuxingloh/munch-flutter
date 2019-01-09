import 'package:flutter/material.dart';
import 'package:munch_app/api/structured_exception.dart';
import 'package:munch_app/styles/buttons.dart';
import 'package:munch_app/styles/colors.dart';
import 'package:munch_app/styles/texts.dart';

class MunchDialog extends Dialog {
  MunchDialog({
    Widget title,
    Widget content,
    List<Widget> actions,
  }) : super(
          child: _MunchDialogChild(
            title: title,
            content: content,
            actions: actions,
          ),
        );

  MunchDialog._string({
    String title,
    String content,
    List<Widget> actions,
  }) : super(
          child: _MunchDialogChild(
            title: title != null ? Text(title) : null,
            content: content != null ? Text(content) : null,
            actions: actions,
          ),
        );

  static void showError(BuildContext context, Object exception,
      {String type = 'Error'}) {
    if (exception is StructuredException) {
      showDialog(
        context: context,
        builder: (c) => MunchDialog.error(c,
            title: exception.type ?? type, content: exception.message),
      );
    } else {
      showDialog(
        context: context,
        builder: (c) => MunchDialog.error(c, content: exception.toString()),
      );
    }
  }

  static void showConfirm(
    BuildContext context, {
    String title,
    String content,
    String confirm = "Confirm",
    String cancel = "Cancel",
    @required VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      builder: (c) => MunchDialog.confirm(
            context,
            title: title,
            content: content,
            confirm: confirm,
            cancel: cancel,
            onPressed: onPressed,
          ),
    );
  }

  static void showOkay(
    BuildContext context, {
    String title,
    String content,
    String okay = "Okay",
  }) {
    showDialog(
      context: context,
      builder: (c) => MunchDialog.okay(
            context,
            title: title,
            content: content,
            okay: okay,
          ),
    );
  }

  static void showProgress(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: MunchColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: SizedBox(
                height: 48,
                width: 48,
                child: const CircularProgressIndicator(
                  backgroundColor: MunchColors.secondary500,
                ),
              ),
            ),
          );
        });
  }

  MunchDialog.error(
    BuildContext context, {
    String title = "Error",
    String content,
    String okay = "Okay",
  }) : this._string(
          title: title,
          content: content,
          actions: [
            MunchButton.text(
              okay,
              onPressed: () => Navigator.of(context).pop(),
              style: MunchButtonStyle.border,
            )
          ],
        );

  MunchDialog.okay(
    BuildContext context, {
    String title,
    String content,
    String okay = "Okay",
  }) : this._string(
          title: title,
          content: content,
          actions: [
            MunchButton.text(
              okay,
              onPressed: () => Navigator.of(context).pop(),
              style: MunchButtonStyle.secondary,
            )
          ],
        );

  MunchDialog.confirm(
    BuildContext context, {
    String title,
    String content,
    String confirm = "Confirm",
    String cancel = "Cancel",
    @required VoidCallback onPressed,
  }) : this._string(
          title: title,
          content: content,
          actions: [
            MunchButton.text(
              confirm,
              onPressed: () {
                Navigator.of(context).pop();
                onPressed();
              },
              style: MunchButtonStyle.secondary,
            ),
            MunchButton.text(
              cancel,
              onPressed: () => Navigator.of(context).pop(),
              style: MunchButtonStyle.border,
            ),
          ],
        );
}

class _MunchDialogChild extends StatelessWidget {
  const _MunchDialogChild({Key key, this.title, this.content, this.actions})
      : super(key: key);

  final Widget title;
  final Widget content;

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (title != null) {
      children.add(Padding(
        padding:
            EdgeInsets.fromLTRB(24.0, 24.0, 24.0, content == null ? 24.0 : 0.0),
        child: DefaultTextStyle(
          style: MTextStyle.h3,
          child: Semantics(child: title, namesRoute: true),
        ),
      ));
    }

    if (content != null) {
      children.add(Flexible(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DefaultTextStyle(
            style: MTextStyle.regular,
            child: content,
          ),
        ),
      ));
    }

    if (actions != null) {
      children.add(Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 20.0),
        child: Row(
          children: List.generate(actions.length, (i) {
            if (i == 0) return actions[i];
            var action = actions[i];
            return Container(child: action, margin: EdgeInsets.only(right: 16));
          }),
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.rtl,
        ),
      ));
    }

    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}
