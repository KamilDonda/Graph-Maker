import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphs/models/edge.dart';
import 'package:graphs/view/home/cubit/sprites_cubit.dart';
import 'package:graphs/view/home/widgets/right_menu/input_field_widget.dart';

class LineEditorWidget extends StatefulWidget {
  final bool isMenuOpen;
  final Edge edge;

  const LineEditorWidget({
    Key? key,
    required this.isMenuOpen,
    required this.edge,
  }) : super(key: key);

  @override
  State<LineEditorWidget> createState() => _LineEditorWidgetState();
}

class _LineEditorWidgetState extends State<LineEditorWidget> {
  final TextEditingController weightController = TextEditingController();

  double _parseString(String value) {
    try {
      return double.parse(value);
    } on Exception {
      return widget.edge.weight;
    }
  }

  @override
  Widget build(BuildContext context) {
    weightController.text = widget.edge.weight.toString();
    return Column(
      children: [
        InputFieldWidget(
          isOpen: widget.isMenuOpen,
          controller: weightController,
          labelText: 'Weight',
        ),
        const SizedBox(height: 50),
        if (widget.isMenuOpen)
          FloatingActionButton.extended(
            onPressed: () {
              BlocProvider.of<SpritesCubit>(context)
                  .editEdge(widget.edge, _parseString(weightController.text));
            },
            backgroundColor: Colors.green,
            label: Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Save this edge"),
                  Icon(Icons.done),
                ],
              ),
            ),
          ),
        const SizedBox(height: 10),
        if (widget.isMenuOpen)
          FloatingActionButton.extended(
            onPressed: () {
              BlocProvider.of<SpritesCubit>(context).removeEdge(widget.edge);
            },
            backgroundColor: Colors.red,
            label: Container(
              width: 200,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Delete this edge"),
                  Icon(Icons.delete),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
