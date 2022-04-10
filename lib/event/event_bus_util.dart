import 'dart:async';

import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  static EventBus _instance;

  static EventBus getInstance() {
    if (null == _instance) {
      _instance = new EventBus();
    }
    return _instance;
  }

  static StreamSubscription<T> listener<T>(void onData(T event)) {
    return getInstance().on<T>().listen(onData);
  }
}
