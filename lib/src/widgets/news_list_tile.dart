import 'package:flutter/material.dart';
import 'loading_container.dart';
import '../models/item_models.dart';
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
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }
            return buildTile(context, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget buildTile(BuildContext context, ItemModel item) {
    return Column(
      children: [
        Card(
          elevation: 10,
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/${item.id}');
            },
            title: Text(item.title),
            subtitle: Text('${item.score} points'),
            trailing: Column(
              children: [Icon(Icons.comment), Text('${item.descendant}')],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}