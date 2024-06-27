import 'package:flutter/material.dart';
import 'package:kitchen_draw/enums/shape_type.dart';
import 'package:kitchen_draw/logic/canvas_manager.dart';
import 'package:kitchen_draw/logic/export_dxf.dart';

class OptionsBar extends StatelessWidget {
  final CanvasManager handler;

  const OptionsBar({
    super.key,
    required this.handler,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: _OptionButton(
              onTap: () =>
                  handler.selectedShapeType = ShapeType.kitchenCountertop,
              label: "Kitchen Countertop",
              isActive:
                  handler.selectedShapeType == ShapeType.kitchenCountertop,
            ),
          ),
          Expanded(
            child: _OptionButton(
              onTap: () => handler.selectedShapeType = ShapeType.island,
              label: "Island",
              isActive: handler.selectedShapeType == ShapeType.island,
            ),
          ),
          _OptionButton(
            onTap: () async {
              final path = await handler.exportDxf();
              if (path == null) {
                const snackBar = SnackBar(
                  content: Text(
                      "When there are overlapping objects, you cannot export."),
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              }
              //  else {
              //   handler.openEmailAppWithAttachment(path);
              // }
            },
            label: "Export",
            isActive: false,
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final void Function() onTap;
  final String label;
  final bool isActive;

  const _OptionButton({
    required this.onTap,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive
          ? Theme.of(context).primaryColor
          : Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive
                  ? Theme.of(context).cardColor
                  : Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
