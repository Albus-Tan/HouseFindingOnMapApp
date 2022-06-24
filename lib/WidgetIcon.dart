import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PngHome extends StatefulWidget {
  const PngHome({Key? key}) : super(key: key);

  @override
  State<PngHome> createState() => _PngHomeState();
}

Future<Uint8List?> widgetToImage(
    {required Widget widget,
    Alignment alignment = Alignment.center,
    Size size = const Size(double.maxFinite, double.maxFinite),
    double devicePixelRatio = 1.0,
    double pixelRatio = 1.0}) async {
  RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
  RenderView renderView = RenderView(
    child: RenderPositionedBox(alignment: alignment, child: repaintBoundary),
    configuration: ViewConfiguration(
      size: size,
      devicePixelRatio: devicePixelRatio,
    ),
    window: ui.window,
  );
  PipelineOwner pipelineOwner = PipelineOwner();
  pipelineOwner.rootNode = renderView;
  renderView.prepareInitialFrame();
  BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
  RenderObjectToWidgetElement rootElement = RenderObjectToWidgetAdapter(
    container: repaintBoundary,
    child: widget,
  ).attachToRenderTree(buildOwner);
  buildOwner.buildScope(rootElement);
  buildOwner.finalizeTree();
  pipelineOwner.flushLayout();
  pipelineOwner.flushCompositingBits();
  pipelineOwner.flushPaint();
  ui.Image uiImage = await repaintBoundary.toImage(pixelRatio: pixelRatio);
  ByteData? byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);
  return byteData?.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
  // Image image = Image.memory(Uint8List.view(byteData!.buffer));
  // return image;
}

class _PngHomeState extends State<PngHome> {
  bool loaded = false;
  late Image image;
  @override
  Widget build(BuildContext context) {
    return loaded
        ? Center(
            child: image,
          )
        : Center(
            child: TextButton(
              onPressed: () {
                widgetToImage(
                        widget: const Directionality(
                            textDirection: TextDirection.ltr,
                            child: Text("world")))
                    .then((value) {
                  setState(() {
                    image = Image.memory(Uint8List.view(value!.buffer));
                    loaded = true;
                  });
                });
              },
              child: const Text('Hello', textDirection: TextDirection.ltr),
            ),
          );
  }
}
