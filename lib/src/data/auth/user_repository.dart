import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mind_metric/src/core/exceptions.dart';
import 'package:mind_metric/src/data/auth/user_service.dart';
import 'package:mind_metric/src/data/database/core/app_database.dart';
import 'package:mind_metric/src/data/database/user_dao.dart';
import 'package:mind_metric/src/utils/string_utils.dart';

class UserRepository {
  final UserDao userDao;
  final UserService networkProvider;
  final UserMapper userMapper;

  static UserRepository? instance;

  UserRepository({
    required this.userDao,
    required this.networkProvider,
    required this.userMapper,
  });

  Future<User> getUser(AuthToken? authToken) async {
    if (StringUtils.isNullOrEmpty(authToken?.accessToken)) {
      throw CustomException('INVALID TOKEN');
    }
    try {
      final networkJson = await networkProvider.fetchUser(authToken!);
      final user = userMapper.fromNetworkJson(networkJson);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<User?> userById(String userId) {
    return userDao.userById(userId);
  }

  Future<void> saveUser(User user) async {
    await userDao.saveUser(user);
  }

  Future<User?> getCurrentUser() {
    return userDao.getCurrentUser();
  }

  Future<User> getActiveUser() async {
    return (await userDao.getCurrentUser())!;
  }

  Stream<User> watchGetActiveUser() {
    return userDao.watchGetActiveUser();
  }

  Future<void> deleteUsers() {
    return userDao.deleteUsers();
  }
}
