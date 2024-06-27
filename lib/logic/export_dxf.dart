import 'package:universal_html/html.dart' as html;
import 'dart:io';

import 'package:dxf/dxf.dart';
import 'package:kitchen_draw/logic/ac_db_entity_extensions.dart';
import 'package:kitchen_draw/logic/canvas_manager.dart';
import 'package:kitchen_draw/logic/geometry_functions.dart';
// import 'package:url_launcher/url_launcher.dart';

extension ExportDxf on CanvasManager {
  Future<String?> exportDxf() async {
    if (overlappingShapeIndexes().isNotEmpty) {
      return null;
    }

    final dxf = DXF.create();
    for (var shape in shapes) {
      var polyline = AcDbPolyline(
        vertices: shape.knots.map((k) => [k.x, k.y]).toList(),
        isClosed: true,
      );
      dxf.addEntities(polyline);

      for (var entity in shape.entities) {
        final pos = entity.getLabelPoint();
        var text = AcDbText(
          x: pos.x,
          y: pos.y,
          textString: entity.length.toStringAsPrecision(3),
        );
        dxf.addEntities(text);
      }
    }

    downloadFile(dxf.dxfString, 'output.dxf');

    final file = File('output.dxf');
    await file.writeAsString(dxf.dxfString);

    return file.path;
  }

  void downloadFile(String content, String fileName) {
    // Create a blob object from the file content
    final blob = html.Blob([content]);

    // Create an object URL from the blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Create a new anchor element
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click(); // Trigger download

    // Cleanup
    html.Url.revokeObjectUrl(url);
  }

  // void openEmailAppWithAttachment(String filePath) async {
  //   final Uri params = Uri(
  //     scheme: 'mailto',
  //     queryParameters: {
  //       'subject': 'DXF File',
  //       'body': 'This is a DXF file email with an attachment.',
  //       'attachment': filePath,
  //     },
  //   );

  //   await launchUrl(params);
  // }

  List<int> overlappingShapeIndexes() {
    final Set<int> indexes = {};
    for (var i = 0; i < shapes.length; i++) {
      for (var j = i + 1; j < shapes.length; j++) {
        final isOverlapping =
            arePolygonsOverlapping(shapes[i].knots, shapes[j].knots);
        if (isOverlapping) {
          indexes.add(i);
          indexes.add(j);
        }
      }
    }
    return indexes.toList();
  }
}
