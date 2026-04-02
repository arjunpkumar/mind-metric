import 'package:mind_metric/src/data/core/config_repository.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';
import 'package:mind_metric/src/utils/extensions.dart';

class UserService {
  final ConfigRepository configRepository;

  UserService({required this.configRepository});

  Future<Map<String, dynamic>> fetchUser(AuthToken authToken) async {
    return {};
    /*try {
      final response = await NetworkClient.dioInstance.get(
        Config.appFlavor.restBaseUrlHeads +
            configRepository.restEmployeeBasicDetailsUrl,
        options: Options(headers: getHeaders(authToken)),
      );
      final responseMap = toGenericMap(response.data);
      if (responseMap["responseCode"] == 200) {
        return toGenericMap(responseMap["data"]);
      } else {
        throw CustomException(
          'ERROR FETCHING USER',
          message: responseMap['message'].toString(),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      throw CustomException('ERROR FETCHING USER', message: e.toString());
    }*/
  }
}

class UserMapper {
  User fromNetworkJson(Map<String, dynamic> json) {
    return User(
      id: toDefaultString(json["sub"]),
      firstName: toDefaultString(json["first_name"]),
      lastName: toDefaultString(json["last_name"]),
      designation: toString(json["designation"]),
      email: toString(json["email"]),
    );
  }
}

bool getBool(String value) {
  return value.toLowerCase() == "true";
}
