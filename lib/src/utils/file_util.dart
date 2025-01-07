import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/config.dart';
import 'package:flutter_base/src/core/app_constants.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum DocumentSource { image, document, audio }

class FileUtil {
  final ImagePicker imagePicker;

  FileUtil({
    required this.imagePicker,
  });

  static String _getFlavorPath() {
    switch (Config.appFlavor) {
      case Staging _:
        return " Stage";
      case QA _:
        return " QA";
      case Development _:
        return " Dev";
      case Production _:
      default:
        return "";
    }
  }

  static Future<String> getFileSize(String path) async {
    final file = File(path);
    return (await file.length()).toString();
  }

  static Future<String> getApplicationPath() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = !kIsWeb && Platform.isWindows
        ? p.join(documentsDirectory.path, "/FlutterBase${_getFlavorPath()}")
        : documentsDirectory.path;
    final directory = Directory(path);
    if (!await directory.exists()) await directory.create();
    return path;
  }

  static Future<String> getApplicationTempPath() async {
    final documentsDirectory = await getApplicationCacheDirectory();
    final path = !kIsWeb && Platform.isWindows
        ? p.join(documentsDirectory.path, "/FlutterBase${_getFlavorPath()}/Cache")
        : documentsDirectory.path;
    final directory = Directory(path);
    if (!await directory.exists()) await directory.create();
    return path;
  }

  static Future<String> createDirectory(String directory) async {
    final appDocDir = await getApplicationPath();
    final audioDirPath = p.join(appDocDir, directory);
    final audioDir = Directory(audioDirPath);
    if (!await audioDir.exists()) {
      audioDir.createSync(recursive: true);
    }
    return audioDirPath;
  }

  static String getContentType(File file) {
    return lookupMimeType(file.path) ?? "text/plain";
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    final newDirectoryPath = p.dirname(newPath);
    final newDirectory = Directory(newDirectoryPath);
    final isDirExists = await newDirectory.exists();
    if (!isDirExists) {
      await newDirectory.create(recursive: true);
    }

    try {
      // prefer using rename as it is probably faster
      return await sourceFile.rename(newPath);
    } on FileSystemException catch (_) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile.copy(newPath);
      await sourceFile.delete();
      return newFile;
    }
  }

  Future<File?>? openCamera() async {
    XFile? xFile;
    if (!kIsWeb && Platform.isWindows) {
      const falconAcceptedAssets = XTypeGroup(
        label: 'FlutterBaseAcceptedAssets',
        extensions: whiteListImageExtensions,
      );

      xFile = await openFile(
        acceptedTypeGroups: <XTypeGroup>[
          falconAcceptedAssets,
        ],
      );
    } else {
      xFile = await imagePicker.pickImage(
        source: ImageSource.camera,
      );
    }
    if (xFile == null) return null;
    return File(xFile.path);
  }

  Future<File?> openDocumentPicker(
    BuildContext context, {
    bool isImageOnly = false,
    bool isAudioOnly = false,
    bool isPdfOnly = false,
  }) async {
/*  if (Platform.isAndroid) {
    return _documentPicker(
      isImageOnly: isImageOnly,
      isAudioOnly: isAudioOnly,
      isPdfOnly: isPdfOnly,
    );
  }

  return _documentPickerWithModeSelector(
    isImageOnly,
    isAudioOnly,
    context,
    isPdfOnly,
  );*/
    return null;
  }

/*

Future<File> _documentPickerWithModeSelector(
  bool isImageOnly,
  bool isAudioOnly,
  BuildContext context,
  bool isPdfOnly,
) async {
  final source = isImageOnly
      ? DocumentSource.image
      : isAudioOnly
          ? DocumentSource.audio
          : await showModalBottomSheet<DocumentSource>(
              context: context,
              builder: (context) => SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'labelImage'.tr(),
                        style: TextStyles.buttonSemibold(context),
                      ),
                      onTap: () {
                        Navigator.pop(context, DocumentSource.image);
                      },
                    ),
                    const SizedBox(
                      height: Units.kSPadding,
                    ),
                    ListTile(
                      title: Text(
                        'labelDocument'.tr(),
                        style: TextStyles.buttonSemibold(context),
                      ),
                      onTap: () {
                        Navigator.pop(context, DocumentSource.document);
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ),
              ),
            );

  if (source == DocumentSource.image) {
    final xFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return File(xFile.path);
  } else if (source == DocumentSource.document) {
    return _documentPicker(
      isPdfOnly: isPdfOnly,
    );
  } else if (source == DocumentSource.audio) {
    return _documentPicker(isAudioOnly: true);
  }

  return null;
}
*/

  Future<XFile?> pickDocument({
    bool isImageOnly = false,
    bool isAudioOnly = false,
    bool isPdfOnly = false,
  }) async {
    final path = await FlutterDocumentPicker.openDocument(
      params: FlutterDocumentPickerParams(
        allowedMimeTypes: isImageOnly
            ? whiteListImageMimeTypes
            : isAudioOnly
                ? whiteListedAudioMimeTypes
                : isPdfOnly
                    ? whiteListPdfMimeType
                    : whiteListDocumentMimeTypes,
        allowedUtiTypes: isImageOnly
            ? whiteListImageUtiTypes
            : isAudioOnly
                ? whiteListedAudioUtiTypes
                : isPdfOnly
                    ? whiteListPdfUtiType
                    : whiteListDocumentUtiTypes,
      ),
    );

    if (path != null) {
      return XFile(path);
    }
    return null;
  }

  Future<List<XFile>> pickDocumentList({
    bool isImageOnly = false,
    bool isAudioOnly = false,
    bool isPdfOnly = false,
  }) async {
    final pathList = await FlutterDocumentPicker.openDocuments(
      params: FlutterDocumentPickerParams(
        allowedMimeTypes: isImageOnly
            ? whiteListImageMimeTypes
            : isAudioOnly
                ? whiteListedAudioMimeTypes
                : isPdfOnly
                    ? whiteListPdfMimeType
                    : whiteListDocumentMimeTypes,
        allowedUtiTypes: isImageOnly
            ? whiteListImageUtiTypes
            : isAudioOnly
                ? whiteListedAudioUtiTypes
                : isPdfOnly
                    ? whiteListPdfUtiType
                    : whiteListDocumentUtiTypes,
      ),
    );

    if (pathList != null) {
      return pathList.whereNotNull().map((path) => XFile(path)).toList();
    }
    return [];
  }
}
