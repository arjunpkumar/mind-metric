// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _firstNameMeta =
      const VerificationMeta('firstName');
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
      'first_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastNameMeta =
      const VerificationMeta('lastName');
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
      'last_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _designationMeta =
      const VerificationMeta('designation');
  @override
  late final GeneratedColumn<String> designation = GeneratedColumn<String>(
      'designation', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _profilePhotoMeta =
      const VerificationMeta('profilePhoto');
  @override
  late final GeneratedColumn<String> profilePhoto = GeneratedColumn<String>(
      'profile_photo', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, firstName, lastName, designation, email, profilePhoto];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('designation')) {
      context.handle(
          _designationMeta,
          designation.isAcceptableOrUnknown(
              data['designation']!, _designationMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('profile_photo')) {
      context.handle(
          _profilePhotoMeta,
          profilePhoto.isAcceptableOrUnknown(
              data['profile_photo']!, _profilePhotoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      firstName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}first_name'])!,
      lastName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_name'])!,
      designation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}designation']),
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      profilePhoto: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_photo']),
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String firstName;
  final String lastName;
  final String? designation;
  final String? email;
  final String? profilePhoto;
  const User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.designation,
      this.email,
      this.profilePhoto});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || designation != null) {
      map['designation'] = Variable<String>(designation);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || profilePhoto != null) {
      map['profile_photo'] = Variable<String>(profilePhoto);
    }
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      designation: designation == null && nullToAbsent
          ? const Value.absent()
          : Value(designation),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      profilePhoto: profilePhoto == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePhoto),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      designation: serializer.fromJson<String?>(json['designation']),
      email: serializer.fromJson<String?>(json['email']),
      profilePhoto: serializer.fromJson<String?>(json['profilePhoto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'designation': serializer.toJson<String?>(designation),
      'email': serializer.toJson<String?>(email),
      'profilePhoto': serializer.toJson<String?>(profilePhoto),
    };
  }

  User copyWith(
          {String? id,
          String? firstName,
          String? lastName,
          Value<String?> designation = const Value.absent(),
          Value<String?> email = const Value.absent(),
          Value<String?> profilePhoto = const Value.absent()}) =>
      User(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        designation: designation.present ? designation.value : this.designation,
        email: email.present ? email.value : this.email,
        profilePhoto:
            profilePhoto.present ? profilePhoto.value : this.profilePhoto,
      );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      designation:
          data.designation.present ? data.designation.value : this.designation,
      email: data.email.present ? data.email.value : this.email,
      profilePhoto: data.profilePhoto.present
          ? data.profilePhoto.value
          : this.profilePhoto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('designation: $designation, ')
          ..write('email: $email, ')
          ..write('profilePhoto: $profilePhoto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, firstName, lastName, designation, email, profilePhoto);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.designation == this.designation &&
          other.email == this.email &&
          other.profilePhoto == this.profilePhoto);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String?> designation;
  final Value<String?> email;
  final Value<String?> profilePhoto;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.designation = const Value.absent(),
    this.email = const Value.absent(),
    this.profilePhoto = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String firstName,
    required String lastName,
    this.designation = const Value.absent(),
    this.email = const Value.absent(),
    this.profilePhoto = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        firstName = Value(firstName),
        lastName = Value(lastName);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? designation,
    Expression<String>? email,
    Expression<String>? profilePhoto,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (designation != null) 'designation': designation,
      if (email != null) 'email': email,
      if (profilePhoto != null) 'profile_photo': profilePhoto,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<String?>? designation,
      Value<String?>? email,
      Value<String?>? profilePhoto,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      designation: designation ?? this.designation,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (designation.present) {
      map['designation'] = Variable<String>(designation.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (profilePhoto.present) {
      map['profile_photo'] = Variable<String>(profilePhoto.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('designation: $designation, ')
          ..write('email: $email, ')
          ..write('profilePhoto: $profilePhoto, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AuthTokensTable extends AuthTokens
    with TableInfo<$AuthTokensTable, AuthToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accessTokenMeta =
      const VerificationMeta('accessToken');
  @override
  late final GeneratedColumn<String> accessToken = GeneratedColumn<String>(
      'access_token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _idTokenMeta =
      const VerificationMeta('idToken');
  @override
  late final GeneratedColumn<String> idToken = GeneratedColumn<String>(
      'id_token', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _refreshTokenMeta =
      const VerificationMeta('refreshToken');
  @override
  late final GeneratedColumn<String> refreshToken = GeneratedColumn<String>(
      'refresh_token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [accessToken, idToken, refreshToken];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_tokens';
  @override
  VerificationContext validateIntegrity(Insertable<AuthToken> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('access_token')) {
      context.handle(
          _accessTokenMeta,
          accessToken.isAcceptableOrUnknown(
              data['access_token']!, _accessTokenMeta));
    } else if (isInserting) {
      context.missing(_accessTokenMeta);
    }
    if (data.containsKey('id_token')) {
      context.handle(_idTokenMeta,
          idToken.isAcceptableOrUnknown(data['id_token']!, _idTokenMeta));
    } else if (isInserting) {
      context.missing(_idTokenMeta);
    }
    if (data.containsKey('refresh_token')) {
      context.handle(
          _refreshTokenMeta,
          refreshToken.isAcceptableOrUnknown(
              data['refresh_token']!, _refreshTokenMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  AuthToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthToken(
      accessToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}access_token'])!,
      idToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id_token'])!,
      refreshToken: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}refresh_token']),
    );
  }

  @override
  $AuthTokensTable createAlias(String alias) {
    return $AuthTokensTable(attachedDatabase, alias);
  }
}

class AuthToken extends DataClass implements Insertable<AuthToken> {
  final String accessToken;
  final String idToken;
  final String? refreshToken;
  const AuthToken(
      {required this.accessToken, required this.idToken, this.refreshToken});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['access_token'] = Variable<String>(accessToken);
    map['id_token'] = Variable<String>(idToken);
    if (!nullToAbsent || refreshToken != null) {
      map['refresh_token'] = Variable<String>(refreshToken);
    }
    return map;
  }

  AuthTokensCompanion toCompanion(bool nullToAbsent) {
    return AuthTokensCompanion(
      accessToken: Value(accessToken),
      idToken: Value(idToken),
      refreshToken: refreshToken == null && nullToAbsent
          ? const Value.absent()
          : Value(refreshToken),
    );
  }

  factory AuthToken.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthToken(
      accessToken: serializer.fromJson<String>(json['accessToken']),
      idToken: serializer.fromJson<String>(json['idToken']),
      refreshToken: serializer.fromJson<String?>(json['refreshToken']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accessToken': serializer.toJson<String>(accessToken),
      'idToken': serializer.toJson<String>(idToken),
      'refreshToken': serializer.toJson<String?>(refreshToken),
    };
  }

  AuthToken copyWith(
          {String? accessToken,
          String? idToken,
          Value<String?> refreshToken = const Value.absent()}) =>
      AuthToken(
        accessToken: accessToken ?? this.accessToken,
        idToken: idToken ?? this.idToken,
        refreshToken:
            refreshToken.present ? refreshToken.value : this.refreshToken,
      );
  AuthToken copyWithCompanion(AuthTokensCompanion data) {
    return AuthToken(
      accessToken:
          data.accessToken.present ? data.accessToken.value : this.accessToken,
      idToken: data.idToken.present ? data.idToken.value : this.idToken,
      refreshToken: data.refreshToken.present
          ? data.refreshToken.value
          : this.refreshToken,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthToken(')
          ..write('accessToken: $accessToken, ')
          ..write('idToken: $idToken, ')
          ..write('refreshToken: $refreshToken')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(accessToken, idToken, refreshToken);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthToken &&
          other.accessToken == this.accessToken &&
          other.idToken == this.idToken &&
          other.refreshToken == this.refreshToken);
}

class AuthTokensCompanion extends UpdateCompanion<AuthToken> {
  final Value<String> accessToken;
  final Value<String> idToken;
  final Value<String?> refreshToken;
  final Value<int> rowid;
  const AuthTokensCompanion({
    this.accessToken = const Value.absent(),
    this.idToken = const Value.absent(),
    this.refreshToken = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthTokensCompanion.insert({
    required String accessToken,
    required String idToken,
    this.refreshToken = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : accessToken = Value(accessToken),
        idToken = Value(idToken);
  static Insertable<AuthToken> custom({
    Expression<String>? accessToken,
    Expression<String>? idToken,
    Expression<String>? refreshToken,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accessToken != null) 'access_token': accessToken,
      if (idToken != null) 'id_token': idToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthTokensCompanion copyWith(
      {Value<String>? accessToken,
      Value<String>? idToken,
      Value<String?>? refreshToken,
      Value<int>? rowid}) {
    return AuthTokensCompanion(
      accessToken: accessToken ?? this.accessToken,
      idToken: idToken ?? this.idToken,
      refreshToken: refreshToken ?? this.refreshToken,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accessToken.present) {
      map['access_token'] = Variable<String>(accessToken.value);
    }
    if (idToken.present) {
      map['id_token'] = Variable<String>(idToken.value);
    }
    if (refreshToken.present) {
      map['refresh_token'] = Variable<String>(refreshToken.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthTokensCompanion(')
          ..write('accessToken: $accessToken, ')
          ..write('idToken: $idToken, ')
          ..write('refreshToken: $refreshToken, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationsTable extends Notifications
    with TableInfo<$NotificationsTable, NotificationData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
      'body', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _notificationTypeMeta =
      const VerificationMeta('notificationType');
  @override
  late final GeneratedColumn<String> notificationType = GeneratedColumn<String>(
      'notification_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notifierIdMeta =
      const VerificationMeta('notifierId');
  @override
  late final GeneratedColumn<String> notifierId = GeneratedColumn<String>(
      'notifier_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notifierTypeMeta =
      const VerificationMeta('notifierType');
  @override
  late final GeneratedColumn<String> notifierType = GeneratedColumn<String>(
      'notifier_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, true,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        title,
        body,
        notificationType,
        notifierId,
        notifierType,
        isRead,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifications';
  @override
  VerificationContext validateIntegrity(Insertable<NotificationData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
          _bodyMeta, body.isAcceptableOrUnknown(data['body']!, _bodyMeta));
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('notification_type')) {
      context.handle(
          _notificationTypeMeta,
          notificationType.isAcceptableOrUnknown(
              data['notification_type']!, _notificationTypeMeta));
    }
    if (data.containsKey('notifier_id')) {
      context.handle(
          _notifierIdMeta,
          notifierId.isAcceptableOrUnknown(
              data['notifier_id']!, _notifierIdMeta));
    }
    if (data.containsKey('notifier_type')) {
      context.handle(
          _notifierTypeMeta,
          notifierType.isAcceptableOrUnknown(
              data['notifier_type']!, _notifierTypeMeta));
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      body: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}body'])!,
      notificationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}notification_type']),
      notifierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notifier_id']),
      notifierType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notifier_type']),
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at']),
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at']),
    );
  }

  @override
  $NotificationsTable createAlias(String alias) {
    return $NotificationsTable(attachedDatabase, alias);
  }
}

class NotificationData extends DataClass
    implements Insertable<NotificationData> {
  final String id;
  final String title;
  final String body;
  final String? notificationType;
  final String? notifierId;
  final String? notifierType;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  const NotificationData(
      {required this.id,
      required this.title,
      required this.body,
      this.notificationType,
      this.notifierId,
      this.notifierType,
      this.isRead,
      this.createdAt,
      this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || notificationType != null) {
      map['notification_type'] = Variable<String>(notificationType);
    }
    if (!nullToAbsent || notifierId != null) {
      map['notifier_id'] = Variable<String>(notifierId);
    }
    if (!nullToAbsent || notifierType != null) {
      map['notifier_type'] = Variable<String>(notifierType);
    }
    if (!nullToAbsent || isRead != null) {
      map['is_read'] = Variable<bool>(isRead);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  NotificationsCompanion toCompanion(bool nullToAbsent) {
    return NotificationsCompanion(
      id: Value(id),
      title: Value(title),
      body: Value(body),
      notificationType: notificationType == null && nullToAbsent
          ? const Value.absent()
          : Value(notificationType),
      notifierId: notifierId == null && nullToAbsent
          ? const Value.absent()
          : Value(notifierId),
      notifierType: notifierType == null && nullToAbsent
          ? const Value.absent()
          : Value(notifierType),
      isRead:
          isRead == null && nullToAbsent ? const Value.absent() : Value(isRead),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory NotificationData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      notificationType: serializer.fromJson<String?>(json['notificationType']),
      notifierId: serializer.fromJson<String?>(json['notifierId']),
      notifierType: serializer.fromJson<String?>(json['notifierType']),
      isRead: serializer.fromJson<bool?>(json['isRead']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'notificationType': serializer.toJson<String?>(notificationType),
      'notifierId': serializer.toJson<String?>(notifierId),
      'notifierType': serializer.toJson<String?>(notifierType),
      'isRead': serializer.toJson<bool?>(isRead),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  NotificationData copyWith(
          {String? id,
          String? title,
          String? body,
          Value<String?> notificationType = const Value.absent(),
          Value<String?> notifierId = const Value.absent(),
          Value<String?> notifierType = const Value.absent(),
          Value<bool?> isRead = const Value.absent(),
          Value<DateTime?> createdAt = const Value.absent(),
          Value<DateTime?> updatedAt = const Value.absent()}) =>
      NotificationData(
        id: id ?? this.id,
        title: title ?? this.title,
        body: body ?? this.body,
        notificationType: notificationType.present
            ? notificationType.value
            : this.notificationType,
        notifierId: notifierId.present ? notifierId.value : this.notifierId,
        notifierType:
            notifierType.present ? notifierType.value : this.notifierType,
        isRead: isRead.present ? isRead.value : this.isRead,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
      );
  NotificationData copyWithCompanion(NotificationsCompanion data) {
    return NotificationData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      notificationType: data.notificationType.present
          ? data.notificationType.value
          : this.notificationType,
      notifierId:
          data.notifierId.present ? data.notifierId.value : this.notifierId,
      notifierType: data.notifierType.present
          ? data.notifierType.value
          : this.notifierType,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('notificationType: $notificationType, ')
          ..write('notifierId: $notifierId, ')
          ..write('notifierType: $notifierType, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, body, notificationType, notifierId,
      notifierType, isRead, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationData &&
          other.id == this.id &&
          other.title == this.title &&
          other.body == this.body &&
          other.notificationType == this.notificationType &&
          other.notifierId == this.notifierId &&
          other.notifierType == this.notifierType &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotificationsCompanion extends UpdateCompanion<NotificationData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> notificationType;
  final Value<String?> notifierId;
  final Value<String?> notifierType;
  final Value<bool?> isRead;
  final Value<DateTime?> createdAt;
  final Value<DateTime?> updatedAt;
  final Value<int> rowid;
  const NotificationsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.notificationType = const Value.absent(),
    this.notifierId = const Value.absent(),
    this.notifierType = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationsCompanion.insert({
    required String id,
    required String title,
    required String body,
    this.notificationType = const Value.absent(),
    this.notifierId = const Value.absent(),
    this.notifierType = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        title = Value(title),
        body = Value(body);
  static Insertable<NotificationData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? notificationType,
    Expression<String>? notifierId,
    Expression<String>? notifierType,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (notificationType != null) 'notification_type': notificationType,
      if (notifierId != null) 'notifier_id': notifierId,
      if (notifierType != null) 'notifier_type': notifierType,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationsCompanion copyWith(
      {Value<String>? id,
      Value<String>? title,
      Value<String>? body,
      Value<String?>? notificationType,
      Value<String?>? notifierId,
      Value<String?>? notifierType,
      Value<bool?>? isRead,
      Value<DateTime?>? createdAt,
      Value<DateTime?>? updatedAt,
      Value<int>? rowid}) {
    return NotificationsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      notificationType: notificationType ?? this.notificationType,
      notifierId: notifierId ?? this.notifierId,
      notifierType: notifierType ?? this.notifierType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (notificationType.present) {
      map['notification_type'] = Variable<String>(notificationType.value);
    }
    if (notifierId.present) {
      map['notifier_id'] = Variable<String>(notifierId.value);
    }
    if (notifierType.present) {
      map['notifier_type'] = Variable<String>(notifierType.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('notificationType: $notificationType, ')
          ..write('notifierId: $notifierId, ')
          ..write('notifierType: $notifierType, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JobsTable extends Jobs with TableInfo<$JobsTable, Job> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recordIdMeta =
      const VerificationMeta('recordId');
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
      'record_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
      'user_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _failureCountMeta =
      const VerificationMeta('failureCount');
  @override
  late final GeneratedColumn<int> failureCount = GeneratedColumn<int>(
      'failure_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, recordId, type, userId, priority, status, failureCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'jobs';
  @override
  VerificationContext validateIntegrity(Insertable<Job> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(_recordIdMeta,
          recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta));
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta,
          userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('failure_count')) {
      context.handle(
          _failureCountMeta,
          failureCount.isAcceptableOrUnknown(
              data['failure_count']!, _failureCountMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Job map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Job(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      recordId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}record_id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      userId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      failureCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}failure_count'])!,
    );
  }

  @override
  $JobsTable createAlias(String alias) {
    return $JobsTable(attachedDatabase, alias);
  }
}

class Job extends DataClass implements Insertable<Job> {
  final String id;
  final String recordId;
  final String type;
  final String userId;
  final int priority;
  final String status;
  final int failureCount;
  const Job(
      {required this.id,
      required this.recordId,
      required this.type,
      required this.userId,
      required this.priority,
      required this.status,
      required this.failureCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['record_id'] = Variable<String>(recordId);
    map['type'] = Variable<String>(type);
    map['user_id'] = Variable<String>(userId);
    map['priority'] = Variable<int>(priority);
    map['status'] = Variable<String>(status);
    map['failure_count'] = Variable<int>(failureCount);
    return map;
  }

  JobsCompanion toCompanion(bool nullToAbsent) {
    return JobsCompanion(
      id: Value(id),
      recordId: Value(recordId),
      type: Value(type),
      userId: Value(userId),
      priority: Value(priority),
      status: Value(status),
      failureCount: Value(failureCount),
    );
  }

  factory Job.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Job(
      id: serializer.fromJson<String>(json['id']),
      recordId: serializer.fromJson<String>(json['recordId']),
      type: serializer.fromJson<String>(json['type']),
      userId: serializer.fromJson<String>(json['userId']),
      priority: serializer.fromJson<int>(json['priority']),
      status: serializer.fromJson<String>(json['status']),
      failureCount: serializer.fromJson<int>(json['failureCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recordId': serializer.toJson<String>(recordId),
      'type': serializer.toJson<String>(type),
      'userId': serializer.toJson<String>(userId),
      'priority': serializer.toJson<int>(priority),
      'status': serializer.toJson<String>(status),
      'failureCount': serializer.toJson<int>(failureCount),
    };
  }

  Job copyWith(
          {String? id,
          String? recordId,
          String? type,
          String? userId,
          int? priority,
          String? status,
          int? failureCount}) =>
      Job(
        id: id ?? this.id,
        recordId: recordId ?? this.recordId,
        type: type ?? this.type,
        userId: userId ?? this.userId,
        priority: priority ?? this.priority,
        status: status ?? this.status,
        failureCount: failureCount ?? this.failureCount,
      );
  Job copyWithCompanion(JobsCompanion data) {
    return Job(
      id: data.id.present ? data.id.value : this.id,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      type: data.type.present ? data.type.value : this.type,
      userId: data.userId.present ? data.userId.value : this.userId,
      priority: data.priority.present ? data.priority.value : this.priority,
      status: data.status.present ? data.status.value : this.status,
      failureCount: data.failureCount.present
          ? data.failureCount.value
          : this.failureCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Job(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('type: $type, ')
          ..write('userId: $userId, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('failureCount: $failureCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recordId, type, userId, priority, status, failureCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Job &&
          other.id == this.id &&
          other.recordId == this.recordId &&
          other.type == this.type &&
          other.userId == this.userId &&
          other.priority == this.priority &&
          other.status == this.status &&
          other.failureCount == this.failureCount);
}

class JobsCompanion extends UpdateCompanion<Job> {
  final Value<String> id;
  final Value<String> recordId;
  final Value<String> type;
  final Value<String> userId;
  final Value<int> priority;
  final Value<String> status;
  final Value<int> failureCount;
  final Value<int> rowid;
  const JobsCompanion({
    this.id = const Value.absent(),
    this.recordId = const Value.absent(),
    this.type = const Value.absent(),
    this.userId = const Value.absent(),
    this.priority = const Value.absent(),
    this.status = const Value.absent(),
    this.failureCount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JobsCompanion.insert({
    required String id,
    required String recordId,
    required String type,
    required String userId,
    this.priority = const Value.absent(),
    required String status,
    this.failureCount = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        recordId = Value(recordId),
        type = Value(type),
        userId = Value(userId),
        status = Value(status);
  static Insertable<Job> custom({
    Expression<String>? id,
    Expression<String>? recordId,
    Expression<String>? type,
    Expression<String>? userId,
    Expression<int>? priority,
    Expression<String>? status,
    Expression<int>? failureCount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordId != null) 'record_id': recordId,
      if (type != null) 'type': type,
      if (userId != null) 'user_id': userId,
      if (priority != null) 'priority': priority,
      if (status != null) 'status': status,
      if (failureCount != null) 'failure_count': failureCount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JobsCompanion copyWith(
      {Value<String>? id,
      Value<String>? recordId,
      Value<String>? type,
      Value<String>? userId,
      Value<int>? priority,
      Value<String>? status,
      Value<int>? failureCount,
      Value<int>? rowid}) {
    return JobsCompanion(
      id: id ?? this.id,
      recordId: recordId ?? this.recordId,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      failureCount: failureCount ?? this.failureCount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (failureCount.present) {
      map['failure_count'] = Variable<int>(failureCount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JobsCompanion(')
          ..write('id: $id, ')
          ..write('recordId: $recordId, ')
          ..write('type: $type, ')
          ..write('userId: $userId, ')
          ..write('priority: $priority, ')
          ..write('status: $status, ')
          ..write('failureCount: $failureCount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $AuthTokensTable authTokens = $AuthTokensTable(this);
  late final $NotificationsTable notifications = $NotificationsTable(this);
  late final $JobsTable jobs = $JobsTable(this);
  late final UserDao userDao = UserDao(this as AppDatabase);
  late final AuthTokenDao authTokenDao = AuthTokenDao(this as AppDatabase);
  late final NotificationDao notificationDao =
      NotificationDao(this as AppDatabase);
  late final JobDao jobDao = JobDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [users, authTokens, notifications, jobs];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  required String id,
  required String firstName,
  required String lastName,
  Value<String?> designation,
  Value<String?> email,
  Value<String?> profilePhoto,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> firstName,
  Value<String> lastName,
  Value<String?> designation,
  Value<String?> email,
  Value<String?> profilePhoto,
  Value<int> rowid,
});

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profilePhoto => $composableBuilder(
      column: $table.profilePhoto, builder: (column) => ColumnFilters(column));
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstName => $composableBuilder(
      column: $table.firstName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastName => $composableBuilder(
      column: $table.lastName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profilePhoto => $composableBuilder(
      column: $table.profilePhoto,
      builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get designation => $composableBuilder(
      column: $table.designation, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get profilePhoto => $composableBuilder(
      column: $table.profilePhoto, builder: (column) => column);
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> firstName = const Value.absent(),
            Value<String> lastName = const Value.absent(),
            Value<String?> designation = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> profilePhoto = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            firstName: firstName,
            lastName: lastName,
            designation: designation,
            email: email,
            profilePhoto: profilePhoto,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String firstName,
            required String lastName,
            Value<String?> designation = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<String?> profilePhoto = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            firstName: firstName,
            lastName: lastName,
            designation: designation,
            email: email,
            profilePhoto: profilePhoto,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    User,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
    User,
    PrefetchHooks Function()>;
typedef $$AuthTokensTableCreateCompanionBuilder = AuthTokensCompanion Function({
  required String accessToken,
  required String idToken,
  Value<String?> refreshToken,
  Value<int> rowid,
});
typedef $$AuthTokensTableUpdateCompanionBuilder = AuthTokensCompanion Function({
  Value<String> accessToken,
  Value<String> idToken,
  Value<String?> refreshToken,
  Value<int> rowid,
});

class $$AuthTokensTableFilterComposer
    extends Composer<_$AppDatabase, $AuthTokensTable> {
  $$AuthTokensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get idToken => $composableBuilder(
      column: $table.idToken, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => ColumnFilters(column));
}

class $$AuthTokensTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthTokensTable> {
  $$AuthTokensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get idToken => $composableBuilder(
      column: $table.idToken, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken,
      builder: (column) => ColumnOrderings(column));
}

class $$AuthTokensTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthTokensTable> {
  $$AuthTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accessToken => $composableBuilder(
      column: $table.accessToken, builder: (column) => column);

  GeneratedColumn<String> get idToken =>
      $composableBuilder(column: $table.idToken, builder: (column) => column);

  GeneratedColumn<String> get refreshToken => $composableBuilder(
      column: $table.refreshToken, builder: (column) => column);
}

class $$AuthTokensTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AuthTokensTable,
    AuthToken,
    $$AuthTokensTableFilterComposer,
    $$AuthTokensTableOrderingComposer,
    $$AuthTokensTableAnnotationComposer,
    $$AuthTokensTableCreateCompanionBuilder,
    $$AuthTokensTableUpdateCompanionBuilder,
    (AuthToken, BaseReferences<_$AppDatabase, $AuthTokensTable, AuthToken>),
    AuthToken,
    PrefetchHooks Function()> {
  $$AuthTokensTableTableManager(_$AppDatabase db, $AuthTokensTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> accessToken = const Value.absent(),
            Value<String> idToken = const Value.absent(),
            Value<String?> refreshToken = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthTokensCompanion(
            accessToken: accessToken,
            idToken: idToken,
            refreshToken: refreshToken,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String accessToken,
            required String idToken,
            Value<String?> refreshToken = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AuthTokensCompanion.insert(
            accessToken: accessToken,
            idToken: idToken,
            refreshToken: refreshToken,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AuthTokensTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AuthTokensTable,
    AuthToken,
    $$AuthTokensTableFilterComposer,
    $$AuthTokensTableOrderingComposer,
    $$AuthTokensTableAnnotationComposer,
    $$AuthTokensTableCreateCompanionBuilder,
    $$AuthTokensTableUpdateCompanionBuilder,
    (AuthToken, BaseReferences<_$AppDatabase, $AuthTokensTable, AuthToken>),
    AuthToken,
    PrefetchHooks Function()>;
typedef $$NotificationsTableCreateCompanionBuilder = NotificationsCompanion
    Function({
  required String id,
  required String title,
  required String body,
  Value<String?> notificationType,
  Value<String?> notifierId,
  Value<String?> notifierType,
  Value<bool?> isRead,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});
typedef $$NotificationsTableUpdateCompanionBuilder = NotificationsCompanion
    Function({
  Value<String> id,
  Value<String> title,
  Value<String> body,
  Value<String?> notificationType,
  Value<String?> notifierId,
  Value<String?> notifierType,
  Value<bool?> isRead,
  Value<DateTime?> createdAt,
  Value<DateTime?> updatedAt,
  Value<int> rowid,
});

class $$NotificationsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notifierId => $composableBuilder(
      column: $table.notifierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notifierType => $composableBuilder(
      column: $table.notifierType, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$NotificationsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get body => $composableBuilder(
      column: $table.body, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notificationType => $composableBuilder(
      column: $table.notificationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notifierId => $composableBuilder(
      column: $table.notifierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notifierType => $composableBuilder(
      column: $table.notifierType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$NotificationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationsTable> {
  $$NotificationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get notificationType => $composableBuilder(
      column: $table.notificationType, builder: (column) => column);

  GeneratedColumn<String> get notifierId => $composableBuilder(
      column: $table.notifierId, builder: (column) => column);

  GeneratedColumn<String> get notifierType => $composableBuilder(
      column: $table.notifierType, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotificationsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $NotificationsTable,
    NotificationData,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      NotificationData,
      BaseReferences<_$AppDatabase, $NotificationsTable, NotificationData>
    ),
    NotificationData,
    PrefetchHooks Function()> {
  $$NotificationsTableTableManager(_$AppDatabase db, $NotificationsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> body = const Value.absent(),
            Value<String?> notificationType = const Value.absent(),
            Value<String?> notifierId = const Value.absent(),
            Value<String?> notifierType = const Value.absent(),
            Value<bool?> isRead = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCompanion(
            id: id,
            title: title,
            body: body,
            notificationType: notificationType,
            notifierId: notifierId,
            notifierType: notifierType,
            isRead: isRead,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String title,
            required String body,
            Value<String?> notificationType = const Value.absent(),
            Value<String?> notifierId = const Value.absent(),
            Value<String?> notifierType = const Value.absent(),
            Value<bool?> isRead = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<DateTime?> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              NotificationsCompanion.insert(
            id: id,
            title: title,
            body: body,
            notificationType: notificationType,
            notifierId: notifierId,
            notifierType: notifierType,
            isRead: isRead,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$NotificationsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $NotificationsTable,
    NotificationData,
    $$NotificationsTableFilterComposer,
    $$NotificationsTableOrderingComposer,
    $$NotificationsTableAnnotationComposer,
    $$NotificationsTableCreateCompanionBuilder,
    $$NotificationsTableUpdateCompanionBuilder,
    (
      NotificationData,
      BaseReferences<_$AppDatabase, $NotificationsTable, NotificationData>
    ),
    NotificationData,
    PrefetchHooks Function()>;
typedef $$JobsTableCreateCompanionBuilder = JobsCompanion Function({
  required String id,
  required String recordId,
  required String type,
  required String userId,
  Value<int> priority,
  required String status,
  Value<int> failureCount,
  Value<int> rowid,
});
typedef $$JobsTableUpdateCompanionBuilder = JobsCompanion Function({
  Value<String> id,
  Value<String> recordId,
  Value<String> type,
  Value<String> userId,
  Value<int> priority,
  Value<String> status,
  Value<int> failureCount,
  Value<int> rowid,
});

class $$JobsTableFilterComposer extends Composer<_$AppDatabase, $JobsTable> {
  $$JobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get failureCount => $composableBuilder(
      column: $table.failureCount, builder: (column) => ColumnFilters(column));
}

class $$JobsTableOrderingComposer extends Composer<_$AppDatabase, $JobsTable> {
  $$JobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recordId => $composableBuilder(
      column: $table.recordId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId => $composableBuilder(
      column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get failureCount => $composableBuilder(
      column: $table.failureCount,
      builder: (column) => ColumnOrderings(column));
}

class $$JobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JobsTable> {
  $$JobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get failureCount => $composableBuilder(
      column: $table.failureCount, builder: (column) => column);
}

class $$JobsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $JobsTable,
    Job,
    $$JobsTableFilterComposer,
    $$JobsTableOrderingComposer,
    $$JobsTableAnnotationComposer,
    $$JobsTableCreateCompanionBuilder,
    $$JobsTableUpdateCompanionBuilder,
    (Job, BaseReferences<_$AppDatabase, $JobsTable, Job>),
    Job,
    PrefetchHooks Function()> {
  $$JobsTableTableManager(_$AppDatabase db, $JobsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> recordId = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> userId = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> failureCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JobsCompanion(
            id: id,
            recordId: recordId,
            type: type,
            userId: userId,
            priority: priority,
            status: status,
            failureCount: failureCount,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String recordId,
            required String type,
            required String userId,
            Value<int> priority = const Value.absent(),
            required String status,
            Value<int> failureCount = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              JobsCompanion.insert(
            id: id,
            recordId: recordId,
            type: type,
            userId: userId,
            priority: priority,
            status: status,
            failureCount: failureCount,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$JobsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $JobsTable,
    Job,
    $$JobsTableFilterComposer,
    $$JobsTableOrderingComposer,
    $$JobsTableAnnotationComposer,
    $$JobsTableCreateCompanionBuilder,
    $$JobsTableUpdateCompanionBuilder,
    (Job, BaseReferences<_$AppDatabase, $JobsTable, Job>),
    Job,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$AuthTokensTableTableManager get authTokens =>
      $$AuthTokensTableTableManager(_db, _db.authTokens);
  $$NotificationsTableTableManager get notifications =>
      $$NotificationsTableTableManager(_db, _db.notifications);
  $$JobsTableTableManager get jobs => $$JobsTableTableManager(_db, _db.jobs);
}
