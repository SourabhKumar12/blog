import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class BlogEvent extends Equatable {
  const BlogEvent();
}

class LoadUserEvent extends BlogEvent {
  @override
  List<Object?> get props => [];
}
