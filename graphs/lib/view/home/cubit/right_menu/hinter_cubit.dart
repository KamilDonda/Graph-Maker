import 'package:flutter_bloc/flutter_bloc.dart';

class HinterCubit extends Cubit<bool> {
  HinterCubit() : super(true);

  bool _isHinterOpen = true;

  get isHinterOpen => _isHinterOpen;

  void toggleHinter() {
    _isHinterOpen = !_isHinterOpen;
    emit(_isHinterOpen);
  }
}
