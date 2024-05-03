// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Album> fetchRandomCocktail() async {
  final response =
      await http.get(Uri.parse('https://www.thecocktaildb.com/api.php'));
  var encodeFirst = json.encode(response.body);
  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(encodeFirst));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  final String name;

  const Album({
    required this.name,
  });

  factory Album.fromJson(json) {
    return switch (json) {
      {
        'name': String name,
      } =>
        Album(
          name: name,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Album> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchRandomCocktail();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cocktail',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: AppBarTheme(
          color: Colors.blue,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Cocktail Generator', textAlign: TextAlign.center),
        ),
        body: Center(
          child: FutureBuilder<Album>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data!.name);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return const CircularProgressIndicator();
              }),
        ),
      ),
    );
  }
}
