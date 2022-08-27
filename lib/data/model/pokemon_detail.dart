class DetailPokemonResponse {
  List<FlavorTextEntry> flavorTextEntries;

  DetailPokemonResponse({
    required this.flavorTextEntries,
  });

  factory DetailPokemonResponse.fromJson(Map<String, dynamic> json) =>
      DetailPokemonResponse(
        flavorTextEntries: List<FlavorTextEntry>.from(
            json["flavor_text_entries"]
                .map((x) => FlavorTextEntry.fromJson(x))),
      );
}

class FlavorTextEntry {
  String flavorText;

  FlavorTextEntry({
    required this.flavorText,
  });

  factory FlavorTextEntry.fromJson(Map<String, dynamic> json) =>
      FlavorTextEntry(
        flavorText: json["flavor_text"],
      );
}
