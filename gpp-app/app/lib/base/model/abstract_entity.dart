abstract class AbstractEntity {
  late int id;
  late DateTime creation;
  late bool enabled;

  toJson();
  toMap();
}
