import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/bloc/search_pokemon/search_bloc.dart';
import 'package:pokedex_app/common/styles.dart';
import 'package:pokedex_app/common/utils.dart';
import 'package:pokedex_app/ui/detail/detail_page.dart';

class SearchPage extends StatelessWidget {
  static const String routeName = '/search-page';

  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 30,
            left: defaultMargin,
            right: defaultMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _searchBar(context),
              const SizedBox(height: 24),
              _buildListPokemon(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 45,
        child: TextField(
          autofocus: true,
          onSubmitted: (value) {
            context.read<SearchBloc>().add(OnQueryChanged(value));
          },
          style: blackTextStyle.copyWith(
            fontSize: 14,
            fontWeight: regular,
          ),
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            hintText: 'Name or number',
            hintStyle: greyTextStyle.copyWith(
              fontSize: 14,
              fontWeight: regular,
            ),
            contentPadding: const EdgeInsets.only(right: 8, left: 12),
            filled: true,
            fillColor: kGreyBgColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: 14.0,
                right: 18,
              ),
              child: Image.asset(
                'assets/ic_search.png',
                width: 24,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minHeight: 24,
              minWidth: 24,
            ),
          ),
        ),
      );

  Widget _buildListPokemon(BuildContext context) =>
      BlocBuilder<SearchBloc, SearchState>(
        builder: (_, state) {
          if (state is SearchLoading) {
            return Expanded(
              child: Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ),
              ),
            );
          } else if (state is SearchError) {
            return Expanded(
              child: Center(
                child: Text(
                  "Ups.. Pokemon tidak ditemukan!",
                  style: blackTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: regular,
                  ),
                ),
              ),
            );
          } else if (state is SearchHasData) {
            final image = Image.network(state.pokemon.imageUrl);
            return FutureBuilder(
              future: Utils.getImagePalette(image.image),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        color: kPrimaryColor,
                      ),
                    ),
                  );
                } else {
                  final palette = snapshot.data as Color;
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DetailPage.routeName,
                        arguments: {
                          'id': state.pokemon.id,
                          'name': state.pokemon.name,
                          'imageUrl': state.pokemon.imageUrl,
                          'bgColor': palette,
                        },
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 200,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: palette.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Hero(
                            tag: state.pokemon.imageUrl,
                            child: Material(
                              type: MaterialType.transparency,
                              child: Image.network(
                                state.pokemon.imageUrl,
                                width: double.infinity,
                                height: 150,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Hero(
                                  tag: state.pokemon.name,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      state.pokemon.name,
                                      style: blackTextStyle.copyWith(
                                        fontSize: 14,
                                        fontWeight: semiBold,
                                      ),
                                    ),
                                  ),
                                ),
                                Hero(
                                  tag: state.pokemon.id,
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: Text(
                                      state.pokemon.id,
                                      style: greyTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: regular,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            );
          } else {
            return const SizedBox();
          }
        },
      );
}
