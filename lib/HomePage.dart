import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:restfulapi/PostModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Post>?> getData() async {
    var uri = Uri.parse("http://jsonplaceholder.typicode.com/posts");
    var request = await http.get(uri);
    if (request.statusCode == 200) {
      var json = request.body;
      return postFromJson(json);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("POST")),
        body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error Occured"),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("No Data"),
              );
            }

            List posts = snapshot.data as List;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Text(posts[index].title),
                );
              },
            );
          },
        ));
  }
}
