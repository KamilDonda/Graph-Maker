import 'package:flutter_bloc/flutter_bloc.dart';

class DirectedGraphCubit extends Cubit<bool> {
  DirectedGraphCubit() : super(true);

  bool _isGraphDirected = true;

  get isGraphDirected => _isGraphDirected;

  void toggleDirectedGraph() {
    _isGraphDirected = !_isGraphDirected;
    emit(_isGraphDirected);
  }
}
