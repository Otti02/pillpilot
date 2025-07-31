abstract class BaseModel {
}

abstract class JsonSerializable {
  Map<String, dynamic> toJson();

}

abstract class Persistable extends BaseModel implements JsonSerializable {
  String get id;
}
