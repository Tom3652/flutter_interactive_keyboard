
import 'package:flutter/material.dart';
import 'package:interactive_keyboard_native/interactive_keyboard_native.dart';

class KeyboardManagerWidget extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;
  KeyboardManagerWidget({Key key, this.child, this.scrollController}) : super(key: key);

  _KeyboardManagerWidgetState createState() => _KeyboardManagerWidgetState();
}

class _KeyboardManagerWidgetState extends State<KeyboardManagerWidget> {
  List<double> _velocities = [];
  double _velocity; 
  int _lastTime;
  double _lastPosition;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details){
        //keyboardScaffold.startScrolling();
        InteractiveKeyboardNative.startScroll();
        _lastPosition = details.position.dy;
        _lastTime = DateTime.now().millisecondsSinceEpoch;
      },
      onPointerUp: (details){
        _velocity = 0;
        _velocities.forEach((velocity){
          _velocity += velocity;
        });
        _velocity = _velocity / _velocities.length;
        InteractiveKeyboardNative.endScroll(_velocity);
        //keyboardScaffold.stopScrolling(_velocity);
      },
      onPointerMove: (details){
        var position = details.position.dy;
        /*if(keyboardScaffold.isDragging){
          var tresholdKeyboard = keyboardScaffold.tresholdKeyboard;
          
          if(position > tresholdKeyboard && keyboardScaffold.keyboardOpen){
            keyboardScaffold.closeKeyboard();
          }
          keyboardScaffold.overTreshold(position-tresholdKeyboard);
        }*/
        InteractiveKeyboardNative.updateScroll(position);
        var time = DateTime.now().millisecondsSinceEpoch;
        if(time - _lastTime > 0) {
          _velocity = (position - _lastPosition)/(time - _lastTime);
          _velocities.add(_velocity);
          if(_velocities.length > 10) {
            _velocities.removeAt(0);
          }
        }
        _lastPosition = position;
        _lastTime = time;
      },
      child: widget.child,
    );
  }

}