import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/bloc/detail_pokemon/detail_pokemon_bloc.dart';
import 'package:pokedex_app/data/model/pokemon.dart';

import '../../common/styles.dart';

class DetailPage extends StatelessWidget {
  static const String routeName = '/detail-page';
  final Pokemon pokemon;
  final Animation<double> animation;
  final Color bgColor;

  const DetailPage(
      {required this.pokemon,
      required this.animation,
      required this.bgColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    context
        .read<DetailPokemonBloc>()
        .add(LoadDetailPokemonEvent(id: pokemon.id));
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back,
            color: kGreyColor,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Hero(
              tag: pokemon.name,
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  pokemon.name,
                  textAlign: TextAlign.center,
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Hero(
              tag: pokemon.id,
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  pokemon.id.toString(),
                  style: greyTextStyle.copyWith(
                    fontSize: 14,
                    fontWeight: regular,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              top: 30,
              left: defaultMargin,
              right: defaultMargin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedBuilder(
                  animation: animation,
                  builder: (_, __) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.2, 1, curve: Curves.easeIn),
                      ),
                      child: __,
                    );
                  },
                  child: Container(
                    height: 328,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: bgColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Hero(
                      tag: pokemon.imageUrl,
                      child: Image.network(
                        pokemon.imageUrl,
                        scale: 1.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Forms',
                  style: blackTextStyle.copyWith(
                    color: kBlackColor,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedBuilder(
                  animation: animation,
                  builder: (_, __) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0.2, 1, curve: Curves.easeInOut),
                      ),
                      child: __,
                    );
                  },
                  child: SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: bgColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.network(
                              pokemon.imageUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: blackTextStyle.copyWith(
                    color: kBlackColor,
                    fontWeight: semiBold,
                  ),
                ),
                const SizedBox(height: 6),
                BlocBuilder<DetailPokemonBloc, DetailPokemonState>(
                    builder: (_, state) {
                  if (state is DetailPokemonLoading) {
                    return const Center(
                      child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()),
                    );
                  } else if (state is DetailPokemonHasData) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (_, __) {
                        return FadeTransition(
                          opacity: CurvedAnimation(
                            parent: animation,
                            curve:
                                const Interval(0.2, 1, curve: Curves.easeInOut),
                          ),
                          child: __,
                        );
                      },
                      child: Text(
                        state.flavorTextEntries[0].flavorText
                                .replaceAll('\n', ' ')
                                .replaceAll('\f', ' ') +
                            ' ' +
                            state.flavorTextEntries[3].flavorText
                                .replaceAll('\n', ' ')
                                .replaceAll('\f', ' '),
                        style: greyTextStyle.copyWith(
                            height: 1.75, fontWeight: regular),
                      ),
                    );
                  } else if (state is DetailPokemonError) {
                    return Center(
                      child: Text(state.message),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
