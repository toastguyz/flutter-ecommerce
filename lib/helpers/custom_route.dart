import 'package:flutter/material.dart';
import 'package:flutter/src/material/page_transitions_theme.dart';

class CustomRoute<T> extends MaterialPageRoute<T>{

  CustomRoute({WidgetBuilder builder,RouteSettings settings}):super(builder:builder,settings:settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if(settings.isInitialRoute){
      return child;
    }

    return FadeTransition(opacity: animation,child: child,);
//    return super.buildTransitions(context, animation, secondaryAnimation, child);
  }
}

class CustomPageTransitionsBuilder extends PageTransitionsBuilder{
  @override
  Widget buildTransitions<T>(PageRoute<T> pageRoute,BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if(pageRoute.settings.isInitialRoute){
      return child;
    }

    return FadeTransition(opacity: animation,child: child,);
  }
}