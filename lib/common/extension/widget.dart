import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension Uint8ListConversion on Widget {
  Future<Uint8List?> toUint8List({
    Alignment alignment = Alignment.center,
    Size size = const Size(double.maxFinite, double.maxFinite),
    double devicePixelRatio = 1.0,
    double pixelRatio = 1.0,
  }) async {
    RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    RenderView renderView = RenderView(
      child: RenderPositionedBox(
        alignment: alignment,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        size: size,
        devicePixelRatio: devicePixelRatio,
      ),
      window: ui.window,
    );
    PipelineOwner pipelineOwner = PipelineOwner();
    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();
    BuildOwner buildOwner = BuildOwner(
      focusManager: FocusManager(),
    );
    RenderObjectToWidgetElement rootElement = RenderObjectToWidgetAdapter(
      container: repaintBoundary,
      child: this,
    ).attachToRenderTree(buildOwner);
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();
    ui.Image uiImage = await repaintBoundary.toImage(
      pixelRatio: pixelRatio,
    );
    ByteData? byteData = await uiImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData?.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
    // Image image = Image.memory(Uint8List.view(byteData!.buffer),);
    // return image;
  }
}
