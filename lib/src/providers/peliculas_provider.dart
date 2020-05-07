import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/Models/actores_model.dart';
import 'package:peliculas/src/Models/pelicula_model.dart';
import 'package:http/http.dart' as http;
class PeliculasProvider{
  String _apikey='99c846308d0eea3a4a5ce2a189339cf7';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage=0;
  bool _cargando=false;

  List<Pelicula> _populares =new List();


  final _popularesStream = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStream.sink.add;//agrega peliculas al afluente

  Stream <List<Pelicula>>get popularesStream => _popularesStream.stream;



  void disposeStreams(){//Valida si hay un contenido en el stream, si no hay cierra el stream
    _popularesStream?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
     
    return peliculas.items;
  }


  Future<List<Pelicula>> getPopulares() async {
    if (_cargando) return [];
     _popularesPage ++;
    _cargando = true;
    final url = Uri.https(_url, '3/movie/popular',{
      'api_key'  : _apikey,
      'language' : _language,
      'page'      :_popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);
    
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;

    return resp;
  
  }

//  Future<List<Pelicula>> getAdultos() async{
  //  final url = Uri.https(_url, '');
  //}

  Future <List<Actor>>getCast(String peliId) async{
    final url =Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key'  : _apikey,
      'language' : _language,
      
    });
    final resp = await http.get(url);//ejecuta el http el cual almacena en la respuesta
    final decodedData= json.decode(resp.body);//almacena la respuesta del mapa

    final cast = new Cast.fromJsonList(decodedData['cast']);//envia la propiedad de cast que es la de los datos
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula (String query) async {
    final url = Uri.https(_url, '3/search/movie',{
      'api_key'  : _apikey,
      'language' : _language,
      'query'    : query,
    });
    
    return await _procesarRespuesta(url);  

  }

} 