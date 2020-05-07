
import 'package:flutter/material.dart';
import 'package:peliculas/src/Models/search/search_delegate.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widgets/movie_horizontal.dart';


class HomePage extends StatelessWidget {
  final peliculasProvider = new PeliculasProvider();
  @override
  Widget build(BuildContext context) {
    peliculasProvider.getPopulares();
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: false,
        title: Text('Películas en cine'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
          icon: Icon(Icons.search), 
          onPressed: (){
            showSearch(
              context: context, 
              delegate: DataSearch()
            );
          }),
        ],

      ),
      body: 
      Container(height: 500,
        child:Column(
          
          children: <Widget>[

            _footer(context)
          ],
        ),

      ),
      
      
    );
  }

 
  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.only(left: 20.0),
            child: Center(child: Text('Películas Recomendadas',style:Theme.of(context).textTheme.title))
          ),
          SizedBox(height: 30.0,),

          StreamBuilder(
           stream: peliculasProvider.popularesStream,
          
            builder: (BuildContext context, AsyncSnapshot snapshot){
             if (snapshot.hasData) {
               return MovieHorizontal(
                 peliculas: snapshot.data,
                 siguientePagina: peliculasProvider.getPopulares,
                 );
              }else {
                return Center(child: CircularProgressIndicator( ));
              }
            }
          )
        ],
      ),
    );
  }
}