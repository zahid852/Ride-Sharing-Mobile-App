import 'dart:developer';
import 'package:lift_app/app/app_preferences.dart';
import 'package:lift_app/domain/model/models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDataSourceConstants {
  static const String databaseName = "liftData.db";
  static const int databaseVersion = 1;
  static const String basicInfoTable = 'basicInfo';
  static const String cnicImagesTable = 'cnicImages';
  static const String vehicleInfoTable = 'vehicleInfo';
  static const String vehicleImagesTable = 'vehicleImages';
  static const String licenseInfoTable = 'licenseInfo';
  static const String notificationTable = 'notifications';
  static const String idType = 'TEXT PRIMARY KEY';
  static const String notificationIdType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String boolType = 'BOOLEAN NOT NULL';
  static const String integerType = 'INTEGER NOT NULL';
  static const String id = 'id';
}

class BasicInfoFields {
  static const String cnic = 'cnic';
  static const String fatherName = 'fatherName';
  static const String birthDate = 'birthDate';
  static const String address = 'address';
}

class CNICImagesFields {
  static const String cnicFront = 'cnicFront';
  static const String cnicBack = 'cnicBack';
}

class VehicleInfoFields {
  static const String type = 'type';
  static const String brand = 'brand';
  static const number = 'number';
}

class VehicleImagesFields {
  static const String vehicle = 'vehicle';
  static const String vehicleRegistrationCertificate =
      'vehicleRegistrationCertificate';
}

class LicenseInfoFields {
  static const String number = 'number';
  static const String expiryDate = 'expiryDate';
  static const String licenseCertificate = 'licenseCertificate';
}

class NotificationsFields {
  static const String userId = 'userId';
  static const String title = 'title';
  static const String body = 'body';
  static const String userImage = 'userImage';
  static const String dateTime = 'dateTime';
}

class LocalDataSource {
  final AppPreferences _appPreferences;
  LocalDataSource(this._appPreferences);
  Database? _localDatabase;

  Future<Database> get getDatabaseObject async {
    if (_localDatabase != null) {
      return _localDatabase!;
    } else {
      _localDatabase = await _initLocalDatabase();
      return _localDatabase!;
    }
  }

  Future<Database> _initLocalDatabase() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path =
        join(documentDirectory.path, LocalDataSourceConstants.databaseName);
    return await openDatabase(path,
        version: LocalDataSourceConstants.databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database localDatabase, int version) async {
    await localDatabase.execute('''
          CREATE TABLE ${LocalDataSourceConstants.basicInfoTable} (
            ${LocalDataSourceConstants.id} ${LocalDataSourceConstants.idType}, 
            ${BasicInfoFields.cnic} ${LocalDataSourceConstants.textType},
            ${BasicInfoFields.fatherName} ${LocalDataSourceConstants.textType},
            ${BasicInfoFields.birthDate} ${LocalDataSourceConstants.textType},
            ${BasicInfoFields.address} ${LocalDataSourceConstants.textType}
          )
          ''');
    await localDatabase.execute('''
          CREATE TABLE ${LocalDataSourceConstants.cnicImagesTable} (
            ${LocalDataSourceConstants.id} ${LocalDataSourceConstants.idType},
            ${CNICImagesFields.cnicFront} ${LocalDataSourceConstants.textType},
            ${CNICImagesFields.cnicBack} ${LocalDataSourceConstants.textType}
                 )
          ''');
    await localDatabase.execute('''
          CREATE TABLE ${LocalDataSourceConstants.vehicleInfoTable} (
            ${LocalDataSourceConstants.id} ${LocalDataSourceConstants.idType},
            ${VehicleInfoFields.type} ${LocalDataSourceConstants.textType},
            ${VehicleInfoFields.brand} ${LocalDataSourceConstants.textType},
            ${VehicleInfoFields.number} ${LocalDataSourceConstants.textType}
                 )
          ''');
    await localDatabase.execute('''
          CREATE TABLE ${LocalDataSourceConstants.vehicleImagesTable} (
            ${LocalDataSourceConstants.id} ${LocalDataSourceConstants.idType},
            ${VehicleImagesFields.vehicle} ${LocalDataSourceConstants.textType},
            ${VehicleImagesFields.vehicleRegistrationCertificate} ${LocalDataSourceConstants.textType}
                 )
          ''');
    await localDatabase.execute('''
          CREATE TABLE ${LocalDataSourceConstants.licenseInfoTable} (
            ${LocalDataSourceConstants.id} ${LocalDataSourceConstants.idType},
            ${LicenseInfoFields.number} ${LocalDataSourceConstants.textType},
            ${LicenseInfoFields.expiryDate} ${LocalDataSourceConstants.textType},
            ${LicenseInfoFields.licenseCertificate} ${LocalDataSourceConstants.textType}
                 )
          ''');
    await localDatabase.execute('''
          CREATE TABLE ${LocalDataSourceConstants.notificationTable} (
            ${LocalDataSourceConstants.id} ${LocalDataSourceConstants.notificationIdType},
            ${NotificationsFields.userId} ${LocalDataSourceConstants.integerType},
            ${NotificationsFields.title} ${LocalDataSourceConstants.textType},
            ${NotificationsFields.body} ${LocalDataSourceConstants.textType},
            ${NotificationsFields.userImage} ${LocalDataSourceConstants.textType},
            ${NotificationsFields.dateTime} ${LocalDataSourceConstants.textType}
                 )
          ''');
  }

  Future<void> insert(String tableName, dynamic dataModel) async {
    final db = await getDatabaseObject;
    log('inserting');
    //here only id to be changed
    try {
      if (dataModel.runtimeType != NotificationModel) {
        final previousData = await db.query(tableName,
            where: '${LocalDataSourceConstants.id} = ?',
            whereArgs: [_appPreferences.getUserId()]);

        if (previousData.isEmpty) {
          await db.insert(tableName, dataModel.toJson());
        } else {
          await db.update(tableName, dataModel.toJson());
        }
      } else {
        await db.insert(tableName, dataModel.toJson());
      }
      _localDatabase = null;
      await db.close();
    } catch (error) {
      log('error $error');
    }
  }

  Future<dynamic> read(String tableName) async {
    try {
      final db = await getDatabaseObject;

      final storedData = await db.query(tableName,
          where: '${LocalDataSourceConstants.id} = ?',
          whereArgs: [_appPreferences.getUserId()]);
      _localDatabase = null;
      await db.close();
      if (storedData.isNotEmpty) {
        return fetchedDataInModelFormat(tableName, storedData.first);
      } else {
        return null;
      }
    } catch (error) {
      log('error $error');
    }
  }

  Future<List<NotificationModel>> readNotifications() async {
    try {
      final db = await getDatabaseObject;

      final storedData = await db.query(
          LocalDataSourceConstants.notificationTable,
          where: '${NotificationsFields.userId} = ?',
          whereArgs: [_appPreferences.getUserId()]);
      _localDatabase = null;
      await db.close();
      if (storedData.isNotEmpty) {
        return storedData.map((e) => NotificationModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }

  dynamic fetchedDataInModelFormat(String tableName, dynamic storedData) {
    switch (tableName) {
      case LocalDataSourceConstants.basicInfoTable:
        return BasicInfoModel.fromJson(storedData);
      case LocalDataSourceConstants.cnicImagesTable:
        return CNICImagesModel.fromJson(storedData);
      case LocalDataSourceConstants.vehicleInfoTable:
        return VehicleInfoModel.fromJson(storedData);
      case LocalDataSourceConstants.vehicleImagesTable:
        return VehicleImagesModel.fromJson(storedData);
      case LocalDataSourceConstants.licenseInfoTable:
        return LicenseInfoModel.fromJson(storedData);
    }
  }

  Future deleteRegisteringData() async {
    final db = await getDatabaseObject;
    // final documentDirectory = await getApplicationDocumentsDirectory();
    // final path =
    //     join(documentDirectory.path, LocalDataSourceConstants.databaseName);
    // await deleteDatabase(path);    //it is for deleting database
    // db.execute(
    //     'DROP TABLE IF EXISTS ${LocalDataSourceConstants.basicInfoTable}');// it for dropping the table
    await db.delete(
      LocalDataSourceConstants.basicInfoTable,
      where: '${LocalDataSourceConstants.id} = ?',
      whereArgs: [_appPreferences.getUserId()],
    );
    await db.delete(
      LocalDataSourceConstants.cnicImagesTable,
      where: '${LocalDataSourceConstants.id} = ?',
      whereArgs: [_appPreferences.getUserId()],
    );
    await db.delete(
      LocalDataSourceConstants.vehicleInfoTable,
      where: '${LocalDataSourceConstants.id} = ?',
      whereArgs: [_appPreferences.getUserId()],
    );
    await db.delete(
      LocalDataSourceConstants.vehicleImagesTable,
      where: '${LocalDataSourceConstants.id} = ?',
      whereArgs: [_appPreferences.getUserId()],
    );
    await db.delete(
      LocalDataSourceConstants.licenseInfoTable,
      where: '${LocalDataSourceConstants.id} = ?',
      whereArgs: [_appPreferences.getUserId()],
    );
    _localDatabase = null;
    await db.close();

    log('Registering data deleted successfully');
  }

  Future deleteLocalDatabase() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    final path =
        join(documentDirectory.path, LocalDataSourceConstants.databaseName);
    _localDatabase = null;
    await deleteDatabase(path); //it is for deleting database

    log('Database deleted successfully');
  }
}
