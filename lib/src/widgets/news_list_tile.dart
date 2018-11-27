import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';
import 'dart:async';

class NewsListTile extends StatelessWidget {
  final int itemId;
  NewsListTile({this.itemId});
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return StreamBuilder(
      stream: bloc.items,
      builder: (BuildContext context,
          AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        snapshot.data[itemId]
            .then((value) => print('=========> ${value.title}'))
            .catchError((err) => print('xxxxxx=> $err'));
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot itemSnapshot) {
            if (!itemSnapshot.hasData || itemSnapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            //  else if (itemSnapshot.hasError) {
            //   print('[*]xxxxxxx=>${itemSnapshot.error}');
            // } else if (itemSnapshot.data == null) {
            //   print('[*]xxxxxxx=>nulllllllllll');
            // }

            return Text(itemSnapshot.data.title);
          },
        );
      },
    );
  }
}
