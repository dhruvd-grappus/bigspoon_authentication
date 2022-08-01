import 'package:equatable/equatable.dart';

/*
 * Created by Aman on 05/07/2021.
 * Description - 
 */

abstract class NavigationAction extends Equatable {}

class ToastAction extends NavigationAction {
  ToastAction({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

class DisplayScreen extends NavigationAction {
  DisplayScreen({
    required this.screenName,
    this.data,
  });

  final String screenName;
  final Object? data;

  @override
  List<Object?> get props => [screenName, data];
}

class DispatchAction extends NavigationAction {
  DispatchAction({
    required this.actionName,
    this.data,
  });

  final String actionName;
  final Object? data;

  @override
  List<Object?> get props => [actionName, data];
}
