import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mind_metric/config.dart';
import 'package:mind_metric/generated/l10n.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/presentation/core/theme/text_styles.dart';
import 'package:mind_metric/src/utils/guard.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum DocumentSource { image, document, audio }

class FileUtil {
  static FileUtil? instance;
  final ImagePicker imagePicker;

  FileUtil({
    required this.imagePicker,
  });

  @visibleForTesting
  factory FileUtil.fromMock(FileUtil util) {
    return instance = util;
  }

  String _getFlavorPath() {
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

  Future<String> getApplicationPath() {
    return Guard.withDefaultAsync(
      () async {
        final documentsDirectory = await getApplicationDocumentsDirectory();
        final path = !kIsWeb && Platform.isWindows
            ? p.join(documentsDirectory.path, "FlutterBase${_getFlavorPath()}")
            : documentsDirectory.path;
        final directory = Directory(path);
        if (!await directory.exists()) await directory.create(recursive: true);
        return path;
      },
      defaultValue: '',
    );
  }

  Future<String> getApplicationTempPath() async {
    final documentsDirectory = await getApplicationCacheDirectory();
    final path = !kIsWeb && Platform.isWindows
        ? p.join(
            documentsDirectory.path,
            "FlutterBase${_getFlavorPath()}/Cache",
          )
        : documentsDirectory.path;
    final directory = Directory(path);
    if (!await directory.exists()) await directory.create(recursive: true);
    return path;
  }

  Future<String> getExternalPath() async {
    final documentsDirectory = await getExternalStorageDirectory();
    final path = !kIsWeb && Platform.isWindows
        ? p.join(
            documentsDirectory!.path,
            "Flutter Base${_getFlavorPath()}/Cache",
          )
        : documentsDirectory!.path;
    final directory = Directory(path);
    if (!await directory.exists()) await directory.create(recursive: true);
    return path;
  }

  Future<String> getDownloadPath() async {
    final documentsDirectory = await getDownloadsDirectory();
    final path = !kIsWeb && Platform.isWindows
        ? p.join(
            documentsDirectory!.path,
            "Flutter Base${_getFlavorPath()}/Cache",
          )
        : documentsDirectory!.path;
    final directory = Directory(path);
    if (!await directory.exists()) await directory.create(recursive: true);
    return path;
  }

  String getPathPrefix({
    required String cdcNumber,
    String? module,
  }) {
    return p.joinAll([
      cdcNumber,
      if (module != null) ...[module],
    ]);
  }

  Future<void> createDir(String basePath) async {
    final path = await absolutePath(basePath);
    final dir = Directory(path);
    final exists = await dir.exists();
    if (!exists) {
      await dir.create(recursive: true);
    }
  }

  Future<void> createDirectoryFromPath(String newPath) async {
    final newDirectoryPath = p.dirname(newPath);
    final newDirectory = Directory(newDirectoryPath);
    final isDirExists = await newDirectory.exists();
    if (!isDirExists) {
      await newDirectory.create(recursive: true);
    }
  }

  Future<String> absolutePath(
    String relativePath, {
    bool useCache = false,
    bool useExternal = false,
    bool useDownload = false,
  }) async {
    final path = useCache
        ? await getApplicationTempPath()
        : useExternal
            ? await getExternalPath()
            : useDownload
                ? await getDownloadPath()
                : await getApplicationPath();
    return p.joinAll([path, relativePath]);
  }

  Future<File> moveFile(File sourceFile, String newPath) async {
    await createDirectoryFromPath(newPath);
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

  Future<File> copyFile(File sourceFile, String newPath) async {
    await createDirectoryFromPath(newPath);
    final newFile = await sourceFile.copy(newPath);
    return newFile;
  }

  Future<String> getFileSize(String path) async {
    final file = File(path);
    return file.length().toString();
  }

  String getContentType(File file) {
    return lookupMimeType(file.path) ?? "text/plain";
  }

  String getContentTypeFromXFile(XFile file) {
    return lookupMimeType(file.path) ?? "text/plain";
  }

  String getProcessedFileUri(String path) {
    if (!path.startsWith("file://")) {
      return "file://$path";
    }
    return path;
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

  Future<File?> openDocumentPickerForMobile(
    BuildContext context, {
    bool isImageOnly = false,
    bool isAudioOnly = false,
    bool isPdfOnly = false,
  }) {
    return Guard.asNullableAsync<File>(() async {
      final source =
          await _getDocumentSource(context, isImageOnly, isAudioOnly);

      XFile? xFile;
      if (source == DocumentSource.image) {
        xFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
      } else if (source == DocumentSource.document) {
        xFile = await _documentPickerXFile(
          isPdfOnly: isPdfOnly,
        );
      } else if (source == DocumentSource.audio) {
        xFile = await _documentPickerXFile(isAudioOnly: true);
      }
      if (xFile != null) {
        return File(xFile.path);
      }
      return null;
    });
  }

  Future<XFile?> openDocumentPickerXFile(
    BuildContext context, {
    bool isImageOnly = false,
    bool isAudioOnly = false,
    bool isPdfOnly = false,
    bool useFileSelectorOnly = false,
  }) async {
    final source = await _getDocumentSource(context, isImageOnly, isAudioOnly);

    if (!useFileSelectorOnly && source == DocumentSource.image) {
      return ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
    } else if (useFileSelectorOnly || source == DocumentSource.document) {
      return _documentPickerXFile(
        isImageOnly: isImageOnly || source == DocumentSource.image,
        isPdfOnly: isPdfOnly,
      );
    }
    return null;
  }

  Future<DocumentSource?> _getDocumentSource(
    BuildContext context,
    bool isImageOnly,
    bool isAudioOnly,
  ) async {
    return isImageOnly
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
                          S.current.labelImage,
                          style: TextStyles.buttonSemiBold(context),
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
                          S.current.labelDocument,
                          style: TextStyles.buttonSemiBold(context),
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
  }

  Future<XFile?> _documentPickerXFile({
    bool isImageOnly = false,
    bool isAudioOnly = false,
    bool isPdfOnly = false,
  }) {
    return openFile(
      acceptedTypeGroups: getTypeGroups(isImageOnly, isAudioOnly, isPdfOnly),
    );
  }

  List<XTypeGroup> getTypeGroups(
    bool isImageOnly,
    bool isAudioOnly,
    bool isPdfOnly,
  ) {
    const XTypeGroup imageGroup = XTypeGroup(
      label: 'images',
      mimeTypes: whiteListImageMimeTypes,
      uniformTypeIdentifiers: whiteListImageUtiTypes,
    );
    const XTypeGroup audioGroup = XTypeGroup(
      label: 'audio',
      mimeTypes: whiteListedAudioMimeTypes,
      uniformTypeIdentifiers: whiteListedAudioUtiTypes,
    );
    const XTypeGroup pdfGroup = XTypeGroup(
      label: 'pdf',
      mimeTypes: whiteListPdfMimeType,
      uniformTypeIdentifiers: whiteListPdfUtiType,
    );
    const XTypeGroup allTypesGroup = XTypeGroup(
      label: 'allTypes',
      mimeTypes: whiteListDocumentMimeTypes,
      uniformTypeIdentifiers: whiteListDocumentUtiTypes,
      extensions: whiteListDocumentExtensions,
    );
    return isImageOnly
        ? [imageGroup]
        : isAudioOnly
            ? [audioGroup]
            : isPdfOnly
                ? [pdfGroup]
                : [allTypesGroup];
  }

  Future<List<XFile>> pickDocumentList({
    bool isImageOnly = false,
    bool isAudioOnly = false,
    bool isPdfOnly = false,
  }) async {
    final pathList = await openFiles(
      acceptedTypeGroups: getTypeGroups(isImageOnly, isAudioOnly, isPdfOnly),
    );

    return pathList;
  }
}
