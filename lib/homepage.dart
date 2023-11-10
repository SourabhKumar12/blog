import 'package:blog/blocs/app_blocs.dart';
import 'package:blog/blocs/app_event.dart';
import 'package:blog/blocs/app_states.dart';
import 'package:blog/model/blog_model.dart';
import 'package:blog/repo/repositories.dart';
import 'package:blog/blog_detail.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc(UserRepository()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('The blog Explorer App'),
          backgroundColor: Colors.blue,
          elevation: 0,
          centerTitle: true,
        ),
        body: blocBody(),
      ),
    );
  }

  Widget blocBody() {
    return BlocProvider(
      create: (context) => UserBloc(
        UserRepository(),
      )..add(LoadUserEvent()),
      child: BlocBuilder<UserBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is BlogLoadedgState) {
            List<BlogModel> blogList = state.blogs;

            if (blogList.isEmpty) {
              // Handle empty state
              return const Center(
                child: Text('No blogs available.'),
              );
            }
            return ListView.builder(
                itemCount: blogList.length,
                itemBuilder: (_, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              BlogDetailPage(blog: blogList[index]),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      margin: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        blogList[index].imageurl!,
                                      ),
                                      fit: BoxFit.fill),
                                ),
                                width: double.maxFinite,
                                height: 200.0,
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    blogList[index].isFavorite =
                                        !blogList[index].isFavorite;
                                  });
                                },
                                icon: Icon(
                                  blogList[index].isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: blogList[index].isFavorite
                                      ? Colors.red
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  blogList[index].title!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }

          if (state is BlogsErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error loading blogs: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserBloc>().add(LoadUserEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
