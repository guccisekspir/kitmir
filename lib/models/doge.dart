// To parse this JSON data, do
//
//     final doge = dogeFromMap(jsonString);

import 'dart:convert';

class Doge {
  Doge({
    this.name,
    this.smallPhoto,
    this.fullPhoto,
    this.description,
    this.bars,
    this.type,
    this.weight,
    this.height,
    this.family,
    this.origin,
    this.dateOrigin,
    this.otherNames,
    this.temperament,
    this.upkeep,
    this.health,
    this.id,
    this.isFirst,
  });

  bool? isFirst;
  String? id;
  String? name;
  String? smallPhoto;
  String? fullPhoto;
  String? description;
  Map<String, int>? bars;
  String? type;
  int? weight;
  int? height;
  String? family;
  String? origin;
  String? dateOrigin;
  String? otherNames;
  String? temperament;
  String? upkeep;
  Health? health;

  factory Doge.fromJson(String str) => Doge.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Doge.fromMap(Map<String, dynamic> json) => Doge(
        isFirst: json["isFirst"] == null ? false : json["isFirst"],
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        smallPhoto: json["smallPhoto"] == null
            ? "https://image.shutterstock.com/image-vector/no-image-available-vector-illustration-260nw-744886198.jpg"
            : json["smallPhoto"],
        fullPhoto: json["fullPhoto"] == null
            ? "https://image.shutterstock.com/image-vector/no-image-available-vector-illustration-260nw-744886198.jpg"
            : json["fullPhoto"],
        description: json["description"] == null ? null : json["description"],
        bars: json["bars"] == null ? null : Map.from(json["bars"]).map((k, v) => MapEntry<String, int>(k, v)),
        type: json["type"] == null ? null : json["type"],
        weight: json["weight"] == null ? null : json["weight"],
        height: json["height"] == null ? null : json["height"],
        family: json["family"] == null ? null : json["family"],
        origin: json["origin"] == null ? null : json["origin"],
        dateOrigin: json["dateOrigin"] == null ? null : json["dateOrigin"],
        otherNames: json["otherNames"] == null ? null : json["otherNames"],
        temperament: json["temperament"] == null ? null : json["temperament"],
        upkeep: json["upkeep"] == null ? null : json["upkeep"],
        health: json["health"] == null ? null : Health.fromMap(json["health"]),
      );

  Map<String, dynamic> toMap() => {
        "isFirst": isFirst == null ? false : isFirst,
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "smallPhoto": smallPhoto == null ? null : smallPhoto,
        "fullPhoto": fullPhoto == null ? null : fullPhoto,
        "description": description == null ? null : description,
        "bars": bars == null ? null : Map.from(bars!).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "type": type == null ? null : type,
        "weight": weight == null ? null : weight,
        "height": height == null ? null : height,
        "family": family == null ? null : family,
        "origin": origin == null ? null : origin,
        "dateOrigin": dateOrigin == null ? null : dateOrigin,
        "otherNames": otherNames == null ? null : otherNames,
        "temperament": temperament == null ? null : temperament,
        "upkeep": upkeep == null ? null : upkeep,
        "health": health == null ? null : health!.toMap(),
      };
}

class Health {
  Health({
    this.major,
    this.minor,
    this.occasionally,
    this.suggestedTest,
    this.lifeSpan,
    this.note,
  });

  List<String>? major;
  List<String>? minor;
  List<String>? occasionally;
  List<String>? suggestedTest;
  List<String>? lifeSpan;
  String? note;

  factory Health.fromJson(String str) => Health.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Health.fromMap(Map<String, dynamic> json) => Health(
        major: json["major"] == null ? null : List<String>.from(json["major"].map((x) => x)),
        minor: json["minor"] == null ? null : List<String>.from(json["minor"].map((x) => x)),
        occasionally: json["occasionally"] == null ? null : List<String>.from(json["occasionally"].map((x) => x)),
        suggestedTest: json["suggestedTest"] == null ? null : List<String>.from(json["suggestedTest"].map((x) => x)),
        lifeSpan: json["lifeSpan"] == null ? null : List<String>.from(json["lifeSpan"].map((x) => x)),
        note: json["note"] == null ? null : json["note"],
      );

  Map<String, dynamic> toMap() => {
        "major": major == null ? null : List<dynamic>.from(major!.map((x) => x)),
        "minor": minor == null ? null : List<dynamic>.from(minor!.map((x) => x)),
        "occasionally": occasionally == null ? null : List<dynamic>.from(occasionally!.map((x) => x)),
        "suggestedTest": suggestedTest == null ? null : List<dynamic>.from(suggestedTest!.map((x) => x)),
        "lifeSpan": lifeSpan == null ? null : List<dynamic>.from(lifeSpan!.map((x) => x)),
        "note": note == null ? null : note,
      };
}
