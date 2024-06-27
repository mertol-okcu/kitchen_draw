import 'package:flutter/material.dart';
import 'package:kitchen_draw/logic/canvas_manager.dart';
import 'package:kitchen_draw/views/draw_layer/draw_layer.dart';
import 'package:kitchen_draw/views/gesture_layer.dart';
import 'package:kitchen_draw/views/options_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final manager = CanvasManager();

  @override
  void dispose() {
    manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: manager,
          builder: (context, snapshot) {
            return Column(
              children: [
                OptionsBar(handler: manager),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      DrawLayer(manager: manager),
                      GestureLayer(manager: manager),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
