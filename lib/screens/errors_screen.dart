import 'package:display_app/widgets/buttons.dart';
import 'package:display_app/widgets/errors_widget.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class ErrorsScreen extends StatefulWidget {
  final List<BasecampError> errors;
  const ErrorsScreen(this.errors, {Key? key}) : super(key: key);

  @override
  _ErrorsScreenState createState() => _ErrorsScreenState();
}

class _ErrorsScreenState extends State<ErrorsScreen> {
  List<BasecampError> errors = [];
  @override
  void initState() {
    errors = widget.errors;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var errorGroups = groupBy(
      errors,
      (element) => element.origin["module_id"] as String,
    );
    List<String> errorGroupsKeys = List.from(errorGroups.keys);
    return Scaffold(
      floatingActionButton: const PionixCloseButton(),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  errors = activeErrors;
                });
              },
              icon: Icon(
                Icons.refresh,
                color: Theme.of(context).colorScheme.onSecondary,
              ))
        ],
        automaticallyImplyLeading: false,
        title: Text(
          "There are ${errors.length} active errors",
          style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSecondary), // required or its blue text on blue background
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: ListView.builder(
          itemCount: errorGroups.length,
          itemBuilder: (context, index) {
            String groupName = errorGroupsKeys[index];
            List<Widget> errorWidgets = List.from(
                errorGroups[groupName]!.map((error) => ErrorWidget(error)));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                    Text(
                      "$groupName:",
                      style: const TextStyle(fontSize: 20),
                    )
                  ] +
                  errorWidgets,
            );
          },
        ),
      ),
    );
  }
}

class ErrorWidget extends StatefulWidget {
  final BasecampError error;
  const ErrorWidget(this.error, {Key? key}) : super(key: key);

  @override
  _ErrorWidgetState createState() => _ErrorWidgetState();
}

class _ErrorWidgetState extends State<ErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon({
        BasecampErrorSeverity.high: Icons.error,
        BasecampErrorSeverity.medium: Icons.warning,
        BasecampErrorSeverity.low: Icons.info
      }[widget.error.severity]),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft, // both are necessary :(
      title: Text(
          "${widget.error.origin["implementation_id"]}:\n${widget.error.type}"),
      subtitle: widget.error.subType.isNotEmpty
          ? Text(widget.error.subType)
          : null, // to not waste space if no subtype is available
      children: [Text(widget.error.message), Text(widget.error.description)],
    );
  }
}
