import 'package:flutter/material.dart';
import 'package:munch_app/api/structured_exception.dart';
import 'package:munch_app/styles/buttons.dart';

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

  static void showError(BuildContext context, Object exception) {
    if (exception is StructuredException) {
      showDialog(
        context: context,
        builder: (c) => MunchDialog.error(c,
            title: exception.type ?? "Error", content: exception.message),
      );
    } else {
      showDialog(
        context: context,
        builder: (c) => MunchDialog.error(c, content: exception.toString()),
      );
    }
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
              onPressed: onPressed,
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
            EdgeInsets.fromLTRB(24.0, 24.0, 24.0, content == null ? 20.0 : 0.0),
        child: DefaultTextStyle(
          style: Theme.of(context).textTheme.title,
          child: Semantics(child: title, namesRoute: true),
        ),
      ));
    }

    if (content != null) {
      children.add(Flexible(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.subhead,
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
