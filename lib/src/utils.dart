Type typeOf<T>() => T;

const String fileHeader = '''// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// ************************************************************************** \n''';

const String rootFile = """

RouteResult getRouteResult({String name, Map<String, dynamic> arguments}) {
  switch (name) {
{0}   default:
      return RouteResult();
  }
}

class RouteResult {
  /// The Widget return base on route
  final Widget widget;

  /// Whether show this route with status bar.
  final bool showStatusBar;

  /// The route name to track page
  final String routeName;

  /// The type of page route
  final PageRouteType pageRouteType;

  /// The description of route
  final String description;

  const RouteResult({
    this.widget,
    this.showStatusBar = true,
    this.routeName = '',
    this.pageRouteType,
    this.description = '',
  });
}

 enum PageRouteType { material, cupertino, transparent }
""";

String routeHelper(String name) => """
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import '${name}_route.dart';

class FFNavigatorObserver extends NavigatorObserver {
  final ShowStatusBarChange showStatusBarChange;
  final RouteChange routeChange;

  FFNavigatorObserver({this.showStatusBarChange, this.routeChange});

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    _didRouteChange(previousRoute, route);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    _didRouteChange(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    super.didRemove(route, previousRoute);
    _didRouteChange(previousRoute, route);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _didRouteChange(newRoute, oldRoute);
  }

  void _didRouteChange(Route newRoute, Route oldRoute) {
    if (showStatusBarChange != null) {
      final newSetting = getFFRouteSettings(newRoute);
      final oldSetting = getFFRouteSettings(oldRoute);
      if (newSetting?.showStatusBar != oldSetting?.showStatusBar) {
        showStatusBarChange?.call(newSetting.showStatusBar);
      }
    }
    routeChange?.call(newRoute.settings, oldRoute.settings);
  }

  FFRouteSettings getFFRouteSettings(Route route) {
    if (route?.settings is FFRouteSettings) return route.settings;
    return null;
  }
}

typedef ShowStatusBarChange = void Function(bool showStatusBar);

typedef RouteChange = void Function(
    RouteSettings newRouteSettings, RouteSettings oldRouteSettings);

class FFTransparentPageRoute<T> extends PageRouteBuilder<T> {
  FFTransparentPageRoute({
    RouteSettings settings,
    @required RoutePageBuilder pageBuilder,
    RouteTransitionsBuilder transitionsBuilder = _defaultTransitionsBuilder,
    Duration transitionDuration = const Duration(milliseconds: 300),
    bool barrierDismissible = false,
    Color barrierColor,
    String barrierLabel,
    bool maintainState = true,
  })  : assert(pageBuilder != null),
        assert(transitionsBuilder != null),
        assert(barrierDismissible != null),
        assert(maintainState != null),
        super(
          settings: settings,
          opaque: false,
          pageBuilder: pageBuilder,
          transitionsBuilder: transitionsBuilder,
          transitionDuration: transitionDuration,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
          barrierLabel: barrierLabel,
          maintainState: maintainState,
        );
}

Widget _defaultTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return child;
}

Route<dynamic> onGenerateRouteHelper(RouteSettings settings, {Widget notFoundFallback}) {
  final routeResult = getRouteResult(
    name: settings.name,
    arguments: settings.arguments,
  );
  if (routeResult.showStatusBar != null || routeResult.routeName != null) {
    settings = FFRouteSettings(
      name: settings.name,
      isInitialRoute: settings.isInitialRoute,
      routeName: routeResult.routeName,
      arguments: settings.arguments,
      showStatusBar: routeResult.showStatusBar,
    );
  }
  final page = routeResult.widget ??
      notFoundFallback ??
      Center(child: Text("\${settings.name}\\npage not found."));

  if (settings?.arguments is Map<String, dynamic>) {
    RouteBuilder builder = (settings.arguments as Map<String, dynamic>)['routeBuilder'];
    if (builder != null) return builder(page);
  }

  switch (routeResult.pageRouteType) {
    case PageRouteType.material:
      return MaterialPageRoute(settings: settings, builder: (_) => page);
    case PageRouteType.cupertino:
      return CupertinoPageRoute(settings: settings, builder: (_) => page);
    case PageRouteType.transparent:
      return FFTransparentPageRoute(
        settings: settings,
        pageBuilder: (_, __, ___) => page,
      );
    default:
      return Platform.isIOS
          ? CupertinoPageRoute(settings: settings, builder: (_) => page)
          : MaterialPageRoute(settings: settings, builder: (_) => page);
  }
}

typedef RouteBuilder = PageRoute Function(Widget page);

""";

const String ffRouteSettings = '''
class FFRouteSettings extends RouteSettings {
  final String routeName;
  final bool showStatusBar;
  const FFRouteSettings({
    this.routeName,
    this.showStatusBar,
    String name,
    bool isInitialRoute = false,
    Object arguments,
  }) : super(name: name, isInitialRoute: isInitialRoute, arguments: arguments);
}
''';

const String ffRouteSettingsNoArguments = '''
class FFRouteSettings extends RouteSettings {
  final String routeName;
  final bool showStatusBar;
  const FFRouteSettings({
    this.routeName,
    this.showStatusBar,
    String name,
    bool isInitialRoute = false,
  }) : super(name: name, isInitialRoute: isInitialRoute);
}
''';
