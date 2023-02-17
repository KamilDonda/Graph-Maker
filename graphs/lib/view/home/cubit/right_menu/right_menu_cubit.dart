import 'package:flutter_bloc/flutter_bloc.dart';

class RightMenuCubit extends Cubit<bool> {
  RightMenuCubit() : super(true);

  bool _isMenuOpen = true;

  get isMenuOpen => _isMenuOpen;

  void toggleMenu() {
    _isMenuOpen = !_isMenuOpen;
    emit(_isMenuOpen);
  }
}
