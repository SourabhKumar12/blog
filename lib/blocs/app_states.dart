import 'package:blog/model/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class BlogState extends Equatable {}

class BlogLoadingState extends BlogState {
  @override
  List<Object?> get props => [];
}

class BlogLoadedgState extends BlogState {
  final List<BlogModel> blogs;
  BlogLoadedgState(this.blogs);
  @override
  List<Object?> get props => [blogs];
}

class BlogsErrorState extends BlogState {
  final String error;
  BlogsErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
