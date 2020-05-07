import 'package:flutter/material.dart';
import 'package:peliculas/src/Models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {

  String seleccion ='';
  final peliculasProvider = new PeliculasProvider();

  final peliculas=[
    'Iron Man',
    'Lolitas',
    'Shazam',
    'nepes',
    'putos',
    'Capitan America'
  ];
  
  final peliculasRecientes=[
    'Spiderman',
    'Capitan America',
  ];
  
  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro AppBar
    return  [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: ((){
            query="";
        }),
        ),
    ];

  
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation,
      ), 
      onPressed: ((){
        close(context, null);
      }),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(

      ),
    );
  }

  Widget buildSuggestions(BuildContext context) {
  
    if(query.isEmpty){
      return Container();
    }
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot){
        if(snapshot.hasData){
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/noImage.jpg'),
                  image: NetworkImage(pelicula.getPosterImg()), 
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context,null);
                  pelicula.uniqueId='';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);

                },
              );
            }).toList()
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );

  }

  //@override
  /**
   *   Widget buildSuggestions(BuildContext context) {
   * // muestra sugerencias que aparecen al escribir
  *final listaSugerida =  (query.isEmpty)
  *                         ? peliculasRecientes
  *                            :peliculas.where(
  *                              (p)=>p.toLowerCase().startsWith(query.toLowerCase())
  *                              ).toList();
  *  return ListView.builder(
  *    itemBuilder: (context, i){
  *      return ListTile(
  *        leading: Icon(Icons.movie),
  *        title: Text(listaSugerida[i]),
  *        onTap: (){
  *          seleccion = listaSugerida[i];
  *          showResults(context);
  *        },
  *      );
  *    },
  *    itemCount: listaSugerida.length,
  *  );
  *}
   */

}