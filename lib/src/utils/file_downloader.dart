import 'dart:io';

import 'package:mind_metric/src/application/model/file_info.dart';
import 'package:mind_metric/src/core/app_constants.dart';
import 'package:mind_metric/src/data/auth/auth_repository.dart';
import 'package:mind_metric/src/utils/extensions.dart';
import 'package:mind_metric/src/utils/network_utils.dart';
import 'package:mind_metric/src/utils/string_utils.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  final AuthRepository authRepository;

  FileDownloader({
    required this.authRepository,
  });

  Future<String> downloadForFileInfo({
    required FileInfo fileInfo,
    String? pathPrefix,
    bool isDatePrefixRequired = true,
    bool isAccessTokenRequired = false,
  }) async {
    // 1. Create Local File Path
    final docsDirectory = await getApplicationDocumentsDirectory();
    String fileName;
    if (isDatePrefixRequired) {
      final formattedDate = formatDate(
        fileInfo.updatedAt ?? fileInfo.createdAt,
        format: 'ddMMyyyyHHmmss',
      );
      fileName = "${formattedDate}_${fileInfo.name}";
    } else {
      fileName = fileInfo.name;
    }

    final List<String> pathComponents = [
      docsDirectory.path,
      pathPrefix,
      fileName,
    ]
        .where((s) => StringUtils.isNotNullAndEmpty(s))
        .map((e) => e!)
        .toList(growable: false);
    final localFilePath = p.joinAll(pathComponents);

    // 2. If Local file is available, return it
    final localFile = File(localFilePath);
    final isLocalFileExists = await localFile.exists();
    if (isLocalFileExists) {
      return localFilePath;
    }

    // 3. If not available, download
    await download(
      downloadUrl: fileInfo.url,
      savePath: localFilePath,
      isAccessTokenRequired: isAccessTokenRequired,
    );

    return localFilePath;
  }

  Future<void> download({
    required String downloadUrl,
    required String savePath,
    bool isAccessTokenRequired = false,
  }) async {
    // 1. Create Directory if not available
    final directoryPath = p.dirname(savePath);
    final dir = Directory(directoryPath);
    final isDirExist = await dir.exists();
    if (!isDirExist) {
      await dir.create(recursive: true);
    }

    // 2. Download file
    int receivedBytes = 0;
    final response = await NetworkClient.dioInstance.download(
      downloadUrl,
      savePath,
      options: isAccessTokenRequired
          ? await getDioOptions(authRepository: authRepository)
          : null,
      onReceiveProgress: (received, total) {
        receivedBytes = received;
      },
    );

/*    final _ = networkUsagesRepository.log(
      sentBytes: dataLengthInBytes(response.requestOptions.data),
      receivedBytes: receivedBytes,
    );*/
  }
}
