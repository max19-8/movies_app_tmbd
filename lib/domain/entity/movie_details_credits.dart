
import 'package:json_annotation/json_annotation.dart';

part 'movie_details_credits.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson:true)
class MovieDetailsCredits {
  List<Actor> cast;
  List<Employee> crew;

  MovieDetailsCredits({ required this.cast,required this.crew});

  factory MovieDetailsCredits.fromJson(Map<String,dynamic> json) => _$MovieDetailsCreditsFromJson(json);

  Map<String,dynamic> toJson() => _$MovieDetailsCreditsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson:true)
class Actor {
  bool adult;
  int? gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String? profilePath;
  int castId;
  String character;
  String creditId;
  int order;

  Actor(
      {
        required this.adult,
        required this.gender,
        required  this.id,
        required  this.knownForDepartment,
        required  this.name,
        required  this.originalName,
        required  this.popularity,
        required this.profilePath,
        required  this.castId,
        required  this.character,
        required  this.creditId,
        required this.order});

  factory Actor.fromJson(Map<String,dynamic> json) => _$ActorFromJson(json);

  Map<String,dynamic> toJson() => _$ActorToJson(this);

}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson:true)
class Employee {
  bool adult;
  int? gender;
  int id;
  String knownForDepartment;
  String name;
  String originalName;
  double popularity;
  String? profilePath;
  String creditId;
  String department;
  String job;

  Employee(
      {
       required this.adult,
        required this.gender,
        required this.id,
        required this.knownForDepartment,
        required this.name,
        required this.originalName,
        required this.popularity,
        required this.profilePath,
        required this.creditId,
        required this.department,
        required this.job});


  factory Employee.fromJson(Map<String,dynamic> json) => _$EmployeeFromJson(json);

  Map<String,dynamic> toJson() => _$EmployeeToJson(this);
}