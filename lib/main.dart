import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:primera_app/models/gif.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';

void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
  }

class _MyAppState extends State<MyApp>{
  late Future<List<Gif>> _listadoGifs;

  Future<List<Gif>> _getGifs() async {
    final response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=NKyaHl3FzjzqToT85W6YykEm560oIQTd&limit=10&rating=g"));

    List<Gif> gifs = [];

    if(response.statusCode == 200){
      String body = utf8.decode(response.bodyBytes);
      final jsonData  = jsonDecode(body);

      for(var item in jsonData["data"]){
        gifs.add(
          Gif(item["title"], item["images"]["downsized"]["url"])
        );
      }

      return gifs;
    } else{
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    _listadoGifs = _getGifs();
  }


  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: FutureBuilder(
          future: _listadoGifs,
          builder: (context, snapshot){
            if (snapshot.hasData){
              return ListView(
                children: _listGifs(snapshot.data as List<Gif>),
              );
            } else if(snapshot.hasError){
              print(snapshot.error);
              return Text('error');
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }
        ),
      ),
    );
  }

  List<Widget> _listGifs(List<Gif> data) {
    List<Widget> gifs = [];

    for (var gif in data){
      gifs.add(
        Card(child: Column(children:
        [ Image.network(gif.url),
          Padding(padding: const EdgeInsets.all(8.0),
        child: Text(gif.name),)],)
      )
      );
    }

    return gifs;
  }
}



