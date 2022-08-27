import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokedex_app/data/model/pokemon.dart';
import 'package:pokedex_app/data/model/pokemon_detail.dart';

class ApiServices {
  static String getImagePokemon(String url) {
    final id = url.substring(34).replaceAll('/', '').padLeft(3, '0');
    return 'https://assets.pokemon.com/assets/cms2/img/pokedex/full/$id.png';
  }

  Future<PokemonResponse> getListPokemon(int start, int limit) async {
    final response = await http.get(Uri.parse(
        'https://pokeapi.co/api/v2/pokemon/?offset=$start&limit=$limit'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return PokemonResponse.fromJson(data);
    } else {
      throw Exception('Failed to load pokemon');
    }
  }

  Future<DetailPokemonResponse> detailPokemon(String id) async {
    final response = await http.get(Uri.parse(
        "https://pokeapi.co/api/v2/pokemon-species/${id.replaceAll(RegExp(r'^0+(?=.)'), '')}"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DetailPokemonResponse.fromJson(data);
    } else {
      throw Exception('Failed to load detail pokemon');
    }
  }

  Future<Pokemon> searchPokemon(String query) async {
    if (query == null || query.isEmpty) {
      return await getListPokemon(0, 10).then((value) => value.listPokemon[0]);
    }

    final res =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$query/'));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return Pokemon(
        id: data['id'].toString().padLeft(3, '0'),
        name: data['forms'][0]['name'],
        imageUrl:
            'https://assets.pokemon.com/assets/cms2/img/pokedex/full/${data['id'].toString().padLeft(3, '0')}.png',
      );
    } else {
      throw Exception('Ups.. pokemon tidak ditemukan!');
    }
  }
}
