import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';

class NewsScreen extends StatelessWidget {
  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          itemCount: snapshot.data.length,
          itemBuilder: (context, int index) {
            bloc.fetchItem(snapshot.data[index]);
            return NewsListTile(itemId: snapshot.data[index]);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    bloc.fetchTopIds();
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News !'),
      ),
      body: Center(
        child: buildList(bloc),
      ),
    );
  }
}
