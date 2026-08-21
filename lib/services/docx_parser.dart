import 'dart:io';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

class DocxParser {
  Future<String> extractText(String filePath) async {
    final bytes = await File(filePath).readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    final documentFile = archive.files.firstWhere(
      (f) => f.name == 'word/document.xml',
      orElse: () => throw FormatException('Некорректный DOCX: нет document.xml'),
    );

    final xmlContent = String.fromCharCodes(documentFile.content as List<int>);
    final document = XmlDocument.parse(xmlContent);
    final buffer = StringBuffer();

    for (final node in document.findAllElements('w:t')) {
      buffer.write(node.innerText);
      buffer.write(' ');
    }

    return buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
