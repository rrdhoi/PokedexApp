import 'package:equatable/equatable.dart';
import 'package:pokedex_app/data/network/api_services.dart';

class PokemonResponse extends Equatable {
  List<Pokemon> listPokemon;
  PokemonResponse({required this.listPokemon});

  factory PokemonResponse.fromJson(Map<String, dynamic> json) =>
      PokemonResponse(
        listPokemon:
            List<Pokemon>.from(json["results"].map((x) => Pokemon.fromJson(x))),
      );

  @override
  // TODO: implement props
  List<Object?> get props => [listPokemon];
}

class Pokemon extends Equatable {
  String id;
  String name;
  String imageUrl;

  Pokemon({required this.id, required this.name, required this.imageUrl});

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
        id: json['url'].substring(34).replaceAll('/', '').padLeft(3, '0'),
        name: json["name"],
        imageUrl: ApiServices.getImagePokemon(json['url']),
      );

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, imageUrl];
}
