import 'package:json_annotation/json_annotation.dart';

part 'character_dto.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: true)
class CharacterDTO {
  const CharacterDTO({
    required this.name,
    required this.birthYear,
    required this.eyeColor,
    required this.gender,
    required this.hairColor,
    required this.height,
    required this.mass,
    required this.skinColor,
    required this.url,
  });

  final String name;
  @JsonKey(name: 'birth_year')
  final String birthYear;
  @JsonKey(name: 'eye_color')
  final String eyeColor;
  final String gender;
  @JsonKey(name: 'hair_color')
  final String hairColor;
  final String height;
  final String mass;
  @JsonKey(name: 'skin_color')
  final String skinColor;
  final String url;

  factory CharacterDTO.fromJson(Map<String, dynamic> json) =>
      _$CharacterDTOFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterDTOToJson(this);
}
