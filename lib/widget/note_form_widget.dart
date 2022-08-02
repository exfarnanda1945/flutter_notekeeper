import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoteFormWidget extends StatelessWidget {
  final bool isImportant;
  final ValueChanged<bool> onChangeIsImportant;

  final int number;
  final ValueChanged<int> onChangeNumber;

  final String title;
  final ValueChanged<String> onChangeTitle;

  final String description;
  final ValueChanged<String> onChangeDescription;

  const NoteFormWidget(
      {Key? key,
      required this.isImportant,
      required this.onChangeIsImportant,
      required this.number,
      required this.onChangeNumber,
      required this.title,
      required this.onChangeTitle,
      required this.description,
      required this.onChangeDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(
            children: [
              Switch(value: isImportant, onChanged: onChangeIsImportant),
              Expanded(
                  child: Slider(
                value: number.toDouble(),
                min: 0,
                max: 5,
                divisions: 5,
                onChanged: (value) => onChangeNumber(value.toInt()),
              ))
            ],
          ),
          buildTitleField(),
          const SizedBox(
            height: 8,
          ),
          buildDescriptionField()
        ]),
      ),
    );
  }

  Widget buildTitleField() {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Title",
          hintStyle: TextStyle(color: Colors.white70)),
      validator: (title) {
        return title != null && title.isEmpty
            ? 'The title cannot be empty'
            : null;
      },
      onChanged: onChangeTitle,
    );
  }

  Widget buildDescriptionField() {
    return TextFormField(
      maxLines: 5,
      initialValue: description,
      style: const TextStyle(
        color: Colors.white70,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Type something...",
          hintStyle: TextStyle(color: Colors.white70)),
      validator: (description) {
        return description != null && description.isEmpty
            ? 'The description cannot be empty'
            : null;
      },
      onChanged: onChangeDescription,
    );
  }
}
