import 'dart:convert' as convert;

import 'event_handler.dart';
import 'consumer.dart';

class Subscription {
  Consumer consumer;
  String identifier;
  SubscriptionEventHandlers eventHandlers;

  Subscription(this.consumer, this.eventHandlers, dynamic params) {
    identifier = convert.jsonEncode(params);
  }

  /// Perform a channel action with the optional data passed as an attribute
  bool perform(String action, [Map<String, dynamic> data]) {
    Map<String, dynamic> dataToSend = data ?? new Map();
    dataToSend['action'] = action;
    return send(dataToSend);
  }

  // TODO: check if perform is working (may be action must me passed on top level)
  bool send(Map<String, dynamic> data) {
    Map params = {
      'command': "message",
      'identifier': identifier,
      'data': convert.json.encode(data)
    };
    return consumer.send(params);
  }

  Subscription unsubscribe() {
    return consumer.subscriptions.remove(this);
  }

  @override
  String toString() => 'Subscription with id: ${identifier}';
}
