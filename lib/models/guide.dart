// To parse this JSON data, do
//
//     final guide = guideFromMap(jsonString);

import 'dart:convert';

class Guide {
  Guide({
    this.name,
    this.sections,
    this.bannerUrl,
  });

  String? name;
  List<Section>? sections;
  String? bannerUrl;

  factory Guide.fromJson(String str) => Guide.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Guide.fromMap(Map<String, dynamic> json) => Guide(
        name: json["name"] == null ? null : json["name"],
        sections: json["sections"] == null ? null : List<Section>.from(json["sections"].map((x) => Section.fromMap(x))),
        bannerUrl: json["bannerUrl"] == null ? null : json["bannerUrl"],
      );

  Map<String, dynamic> toMap() => {
        "name": name == null ? null : name,
        "sections": sections == null ? null : List<dynamic>.from(sections!.map((x) => x.toMap())),
        "bannerUrl": bannerUrl == null ? null : bannerUrl,
      };
}

class Section {
  Section({
    this.title,
    this.subtitle,
  });

  String? title;
  String? subtitle;

  factory Section.fromJson(String str) => Section.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        title: json["title"] == null ? null : json["title"],
        subtitle: json["subtitle"] == null ? null : json["subtitle"],
      );

  Map<String, dynamic> toMap() => {
        "title": title == null ? null : title,
        "subtitle": subtitle == null ? null : subtitle,
      };
}
