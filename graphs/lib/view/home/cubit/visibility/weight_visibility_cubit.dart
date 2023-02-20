import 'package:flutter_bloc/flutter_bloc.dart';

class WeightVisibilityCubit extends Cubit<bool> {
  WeightVisibilityCubit() : super(true);

  bool _areWeightsVisible = true;

  get areWeightsVisible => _areWeightsVisible;

  void toggleWeightsVisibility() {
    _areWeightsVisible = !_areWeightsVisible;
    emit(_areWeightsVisible);
  }
}
