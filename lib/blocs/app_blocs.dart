import 'package:blog/blocs/app_event.dart';
import 'package:blog/blocs/app_states.dart';
import 'package:blog/repo/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<BlogEvent, BlogState> {
  final UserRepository _userRepository;

  UserBloc(this._userRepository) : super(BlogLoadingState()) {
    on<LoadUserEvent>((event, emit) async {
      emit(BlogLoadingState());

      try {
        final Blogs = await _userRepository.getUsers();
        emit(BlogLoadedgState(Blogs));
      } catch (e) {
        emit(BlogsErrorState(e.toString()));
      }
    });
  }
}
