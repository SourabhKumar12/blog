import 'dart:convert';
import 'package:blog/model/blog_model.dart';
import 'package:http/http.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity/connectivity.dart';

import './database_helper.dart';

class UserRepository {
  String useUrl = 'https://intent-kit-16.hasura.app/api/rest/blogs';

  final String adminSecret =
      '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

  Future<List<BlogModel>> getUsers() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No internet, fetch data from the local SQLite database
      Database? db = await DatabaseHelper().db;
      List<Map> results = await db!.query('blogs');
      return results
          .map((e) => BlogModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      Response response = await get(Uri.parse(useUrl), headers: {
        'x-hasura-admin-secret': adminSecret,
      });

      if (response.statusCode == 200) {
        final List result = jsonDecode(response.body)['blogs'];

        // Store the fetched data in the local SQLite database for future use
        Database? db = await DatabaseHelper().db;
        db!.rawDelete('DELETE FROM blogs');
        result.forEach((blog) {
          db.rawInsert(
              'INSERT INTO blogs (id, title, image_url) VALUES (?, ?, ?)',
              [blog['id'], blog['title'], blog['image_url']]);
        });

        return result.map((e) => BlogModel.fromJson(e)).toList();
      } else {
        throw Exception(response.reasonPhrase);
      }
    }
  }
}
