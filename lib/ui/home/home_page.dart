import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/bloc/pokemon/pokemon_bloc.dart';
import 'package:pokedex_app/bloc/scroll/scroll_bloc.dart';
import 'package:pokedex_app/common/utils.dart';
import 'package:pokedex_app/ui/search/search_page.dart';

import '../../common/styles.dart';
import '../detail/detail_page.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home-page';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: SafeArea(
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.only(
              top: 30,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildHeader(context),
                const SizedBox(height: 24),
                _buildListPokemon(context)
              ],
            ),
          ),
          BlocBuilder<ScrollBloc, bool>(
            builder: (_, showFab) {
              return Stack(children: [
                AnimatedPositioned(
                  top: showFab ? pageHeight - 100 : pageHeight,
                  left: pageWidth - 80,
                  curve: Curves.easeInOutBack,
                  duration: const Duration(milliseconds: 700),
                  child: FloatingActionButton(
                    backgroundColor: kPrimaryColor,
                    onPressed: () {
                      context.read<PokemonBloc>().add(LoadPokemonEvent());
                    },
                    child: const Icon(Icons.sync),
                  ),
                ),
              ]);
            },
          ),
        ]),
      ),
    );
  }

  _buildHeader(BuildContext context) => [
        Text(
          'Pokedex',
          style: blackTextStyle.copyWith(fontSize: 24, fontWeight: bold),
        ),
        const SizedBox(height: 6),
        Text(
          'Search for a Pokemon by name or using its National Pokedex number.',
          style: greyTextStyle.copyWith(
            fontSize: 14,
            fontWeight: regular,
            height: 1.75,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, SearchPage.routeName);
              },
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: kGreyBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/ic_search.png',
                        width: 24,
                      ),
                      const SizedBox(width: 18),
                      Text(
                        'Name or number',
                        style: greyTextStyle.copyWith(
                          fontSize: 14,
                          fontWeight: regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                /* showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const FilterListDialog();
                            });*/
              },
              child: Container(
                height: 45,
                width: 47,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  'assets/ic_filter.png',
                ),
              ),
            ),
          ],
        ),
      ];

  Widget _buildListPokemon(BuildContext context) => Expanded(
        child: NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            if (scrollEnd.metrics.pixels == scrollEnd.metrics.maxScrollExtent) {
              context.read<ScrollBloc>().add(ScrollMaxBottom());
            } else if (scrollEnd.metrics.pixels !=
                scrollEnd.metrics.maxScrollExtent) {
              context.read<ScrollBloc>().add(ScrollUp());
            }
            return true;
          },
          child: BlocBuilder<PokemonBloc, PokemonState>(
            builder: (_, state) {
              if (state is PokemonInitial) {
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
                PokemonLoaded pokemonLoaded = state as PokemonLoaded;
                return GridView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 210,
                  ),
                  physics: const BouncingScrollPhysics(),
                  semanticChildCount: 0,
                  cacheExtent: 0.0,
                  dragStartBehavior: DragStartBehavior.start,
                  clipBehavior: Clip.hardEdge,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.manual,
                  itemBuilder: (_, index) {
                    final image = Image.network(
                        pokemonLoaded.pokemonList[index].imageUrl);
                    return FutureBuilder(
                        future: Utils.getImagePalette(image.image),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                            final bgColor = snapshot.data as Color;
                            return Container(
                              padding: const EdgeInsets.only(top: 12),
                              decoration: BoxDecoration(
                                // color: kGreyBgColor,
                                color: bgColor.withOpacity(0.3),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, DetailPage.routeName,
                                      arguments: {
                                        'id':
                                            pokemonLoaded.pokemonList[index].id,
                                        'name': pokemonLoaded
                                            .pokemonList[index].name,
                                        'imageUrl': pokemonLoaded
                                            .pokemonList[index].imageUrl,
                                        'bgColor': bgColor,
                                      });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Hero(
                                      tag: pokemonLoaded
                                          .pokemonList[index].imageUrl,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Image.network(
                                          pokemonLoaded
                                              .pokemonList[index].imageUrl,
                                          height: 130,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Hero(
                                      tag:
                                          pokemonLoaded.pokemonList[index].name,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                            pokemonLoaded
                                                .pokemonList[index].name,
                                            textAlign: TextAlign.center,
                                            style: blackTextStyle.copyWith(
                                              fontSize: 14,
                                              fontWeight: semiBold,
                                            )),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Hero(
                                      tag: pokemonLoaded.pokemonList[index].id,
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          pokemonLoaded.pokemonList[index].id,
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
                            );
                          }
                        });
                  },
                  itemCount: pokemonLoaded.pokemonList.length,
                );
              }
            },
          ),
        ),
      );
}
