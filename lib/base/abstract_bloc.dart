import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'action/navigation_action.dart';

/*
 * Created by Aman on 05/07/2021.
 * Description -
 */

abstract class AbstractBloc<Event, State> extends Bloc<Event, State> {
  AbstractBloc(State initialState) : super(initialState);

  final StreamController<NavigationAction> _navigationActionBS =
      StreamController<NavigationAction>.broadcast();

  Stream<NavigationAction> get _navigationActionStream =>
      _navigationActionBS.stream;

  @override
  @mustCallSuper
  Future<void> close() {
    _navigationActionBS.close();
    return super.close();
  }

  @mustCallSuper
  void onNavigationAction(NavigationAction navigationAction) {
    _navigationActionBS.add(navigationAction);
  }

  Stream<NavigationAction> getNavigationActionObservable() {
    return _navigationActionStream;
  }
}
