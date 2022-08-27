import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_app/bloc/detail_pokemon/detail_pokemon_bloc.dart';
import 'package:pokedex_app/bloc/pokemon/pokemon_bloc.dart';
import 'package:pokedex_app/bloc/scroll/scroll_bloc.dart';
import 'package:pokedex_app/bloc/search_pokemon/search_bloc.dart';
import 'package:pokedex_app/data/model/pokemon.dart';
import 'package:pokedex_app/injection.dart' as di;
import 'package:pokedex_app/ui/detail/detail_page.dart';
import 'package:pokedex_app/ui/home/home_page.dart';
import 'package:pokedex_app/ui/search/search_page.dart';
import 'package:pokedex_app/ui/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  di.setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<PokemonBloc>()),
        BlocProvider(create: (_) => ScrollBloc()),
        BlocProvider(create: (_) => di.locator<SearchBloc>()),
        BlocProvider(create: (_) => di.locator<DetailPokemonBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const SplashScreenPage(),
        // multiple bloc
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case HomePage.routeName:
              return MaterialPageRoute(
                builder: (_) => const HomePage(),
              );
            case DetailPage.routeName:
              final pokemonData = settings.arguments as Map<String, dynamic>;
              return PageRouteBuilder(
                  transitionDuration: const Duration(seconds: 1),
                  reverseTransitionDuration: const Duration(milliseconds: 700),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    final curveAnimation = CurvedAnimation(
                        parent: animation,
                        curve: const Interval(0, 0.5, curve: Curves.easeInOut));
                    return FadeTransition(
                      opacity: curveAnimation,
                      child: DetailPage(
                        pokemon: Pokemon(
                          name: pokemonData['name'],
                          id: pokemonData['id'],
                          imageUrl: pokemonData['imageUrl'],
                        ),
                        animation: animation,
                        bgColor: pokemonData['bgColor'],
                      ),
                    );
                  });
            case SearchPage.routeName:
              return MaterialPageRoute(
                builder: (_) => const SearchPage(),
              );
          }
        },
      ),
    );
  }
}
