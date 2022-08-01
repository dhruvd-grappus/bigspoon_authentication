import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/single_child_widget.dart';

import 'abstract_bloc.dart';
import 'action/navigation_action.dart';

/*
 * Created by Aman on 05/07/2021.
 * Description - AbstractBlocListener
 */

/// Mixin which allows `MultiBlocListener` to infer the types
/// of multiple [BlocListener]s.
mixin BlocListenerSingleChildWidget on SingleChildWidget {}

class AbstractBlocListener<B extends AbstractBloc<E, S>, E, S>
    extends BlocListenerBase<B, E, S> with BlocListenerSingleChildWidget {
  /// {@macro bloc_listener}
  const AbstractBlocListener({
    Key? key,
    required BlocWidgetListener<S> listener,
    B? bloc,
    BlocListenerCondition<S>? listenWhen,
    Widget? child,
    Function(NavigationAction action)? onNavigationAction,
  }) : super(
          key: key,
          child: child,
          listener: listener,
          bloc: bloc,
          listenWhen: listenWhen,
          onNavigationAction: onNavigationAction,
        );
}

/// {@template bloc_listener_base}
/// Base class for widgets that listen to state changes in a specified [bloc].
///
/// A [BlocListenerBase] is stateful and maintains the state subscription.
/// The type of the state and what happens with each state change
/// is defined by sub-classes.
/// {@end_template}
abstract class BlocListenerBase<B extends AbstractBloc<E, S>, E, S>
    extends SingleChildStatefulWidget {
  /// {@macro bloc_listener_base}
  const BlocListenerBase({
    Key? key,
    required this.listener,
    this.bloc,
    this.child,
    this.listenWhen,
    this.onNavigationAction,
  }) : super(key: key, child: child);

  /// The widget which will be rendered as a descendant of the
  /// [BlocListenerBase].
  final Widget? child;

  /// The [bloc] whose `state` will be listened to.
  /// Whenever the [bloc]'s `state` changes, [listener] will be invoked.
  final B? bloc;

  /// The [BlocWidgetListener] which will be called on every `state` change.
  /// This [listener] should be used for any code which needs to execute
  /// in response to a `state` change.
  final BlocWidgetListener<S> listener;

  /// {@macro bloc_listener_listen_when}
  final BlocListenerCondition<S>? listenWhen;

  final Function(NavigationAction action)? onNavigationAction;

  @override
  SingleChildState<BlocListenerBase<B, E, S>> createState() =>
      _BlocListenerBaseState<B, E, S>();
}

class _BlocListenerBaseState<B extends AbstractBloc<E, S>, E, S>
    extends SingleChildState<BlocListenerBase<B, E, S>> {
  StreamSubscription<S>? _subscription;
  StreamSubscription<NavigationAction>? _navigationActionObservable;
  late B _bloc;
  late S _previousState;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _previousState = _bloc.state;
    _subscribe();
  }

  @override
  void didUpdateWidget(BlocListenerBase<B, E, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = currentBloc;
        _previousState = _bloc.state;
      }
      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) => child!;

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = _bloc.stream.listen((state) {
      if (widget.listenWhen?.call(_previousState, state) ?? true) {
        widget.listener(context, state);
      }
      _previousState = state;
    });

    _navigationActionObservable =
        _bloc.getNavigationActionObservable().listen(onNavigationAction);
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _navigationActionObservable?.cancel();
    _subscription = null;
    _navigationActionObservable = null;
  }

  void onNavigationAction(NavigationAction action) {
    if (widget.onNavigationAction != null) {
      widget.onNavigationAction!(action);
      return;
    }

    if (action is ToastAction) {
      Fluttertoast.showToast(msg: action.message);
    }
  }
}
