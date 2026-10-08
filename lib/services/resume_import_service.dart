import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

import 'docx_parser.dart';

enum ResumeImportErrorKind {
  unsupportedExtension,
  legacyDocFormat,
  emptyDocument,
  invalidDocx,
}

class ResumeImportException implements Exception {
  ResumeImportException(this.kind, {this.detail});

  final ResumeImportErrorKind kind;
  final String? detail;

  @override
  String toString() => 'ResumeImportException($kind, $detail)';
}

/// Imports resume text from .docx files (Word 2007+). Legacy .doc is not supported.
class ResumeImportService {
  ResumeImportService({DocxParser? parser}) : _parser = parser ?? DocxParser();

  final DocxParser _parser;

  static const supportedExtensions = ['docx'];

  bool isSupportedFilename(String filename) {
    final ext = p.extension(filename).toLowerCase();
    return ext == '.docx';
  }

  bool isLegacyDoc(String filename) => p.extension(filename).toLowerCase() == '.doc';

  Future<({String filename, String text})> importFile({
    required String filename,
    String? sourcePath,
    Uint8List? bytes,
  }) async {
    final name = p.basename(filename);
    if (isLegacyDoc(name)) {
      throw ResumeImportException(ResumeImportErrorKind.legacyDocFormat);
    }
    if (!isSupportedFilename(name)) {
      throw ResumeImportException(
        ResumeImportErrorKind.unsupportedExtension,
        detail: p.extension(name),
      );
    }

    String text;
    try {
      if (sourcePath != null && sourcePath.isNotEmpty) {
        text = await _parser.extractText(sourcePath);
      } else if (bytes != null && bytes.isNotEmpty) {
        final temp = File(
          '${Directory.systemTemp.path}/resume_${DateTime.now().millisecondsSinceEpoch}.docx',
        );
        await temp.writeAsBytes(bytes, flush: true);
        try {
          text = await _parser.extractText(temp.path);
        } finally {
          if (await temp.exists()) await temp.delete();
        }
      } else {
        throw ResumeImportException(ResumeImportErrorKind.invalidDocx);
      }
    } on FormatException {
      throw ResumeImportException(ResumeImportErrorKind.invalidDocx);
    }

    if (text.trim().isEmpty) {
      throw ResumeImportException(ResumeImportErrorKind.emptyDocument);
    }

    return (filename: name, text: text);
  }
}
