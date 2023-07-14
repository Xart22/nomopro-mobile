import 'dart:convert';
import 'dart:io';

class Session {
  WebSocket? _socket;
  int _nextId = 0;
  String type = '';
  Map<int, dynamic>? _completionHandlers = {};

  Session(socket) {
    _socket = socket;
    _socket!.listen(onMessage);
  }

  void dispose() {
    if (_socket != null) {
      _socket!.listen(onMessage);
      if (_socket!.readyState == WebSocket.open) {
        _socket!.close();
      }
    }
    _socket = null;
    _completionHandlers = null;
  }

  int getNextId() {
    return _nextId++;
  }

  Map<String, dynamic> makeResponse(int id, dynamic result, dynamic error) {
    final response = {
      'id': id,
      'jsonrpc': '2.0',
    };
    if (error != null) {
      response['error'] = error;
    } else {
      response['result'] = result;
    }
    return response;
  }

  void onMessage(dynamic message) {
    didReceiveMessage(message, (response) {
      if (_socket != null) {
        _socket!.add(response);
      }
    });
  }

  void onBinary() {}

  void didReceiveMessage(dynamic message, Function sendResponseText) {
    final json = jsonDecode(message);
    sendResponseInternal(result, error) {
      var id = json['id'] == 0 ? '0' : json['id'];
      final response = makeResponse(int.parse(id), result, error);
      sendResponseText(jsonEncode(response));
    }

    sendResponse(result, error) {
      try {
        sendResponseInternal(result, error);
      } catch (err1) {
        sendResponseInternal(null, 'Could not encode response');
      }
    }

    try {
      if (json['jsonrpc'] != '2.0') {
        throw Exception('unrecognized JSON-RPC version string');
      }
      if (json['method'] != null) {
        didReceiveRequest(json, (result, err) => sendResponse(result, err));
      } else if (json['result'] != null || json['error'] != null) {
        didReceiveResponse(json);
      } else {
        throw Exception('message is neither request nor response');
      }
    } catch (err) {
      sendResponse(null, err.toString());
    }
  }

  void didReceiveRequest(dynamic request, Function sendResult) {
    final method = request['method'];
    final params = request['params'] ?? {};
    if (method == null || method is! String) {
      throw Exception('method value missing or not a string');
    }
    didReceiveCall(method, params, sendResult);
  }

  void didReceiveResponse(dynamic response) {
    final id = response['id'];
    final error = response['error'];
    final result = response['result'];
    if (id == null) {
      throw Exception('response ID value missing or wrong type');
    }
    final completionHandler = _completionHandlers?[id];
    if (completionHandler == null) {
      throw Exception('response ID does not correspond to any open request');
    }
    try {
      if (error != null) {
        completionHandler(null, error);
      } else {
        completionHandler(result, null);
      }
    } catch (err) {
      throw Exception('exception encountered while handling response $id');
    }
  }

  void didReceiveCall(String method, dynamic params, Function sendResult) {}

  void sendRemoteRequest(
    String? method,
    dynamic params,
    Function completion,
  ) {
    final request = {
      'jsonrpc': '2.0',
      'method': method,
    };

    if (params != null) {
      request['params'] = '{"peripheralId":"tes","name":"tes"}';
    }
    final requestId = getNextId();
    request['id'] = requestId.toString();
    _completionHandlers?[requestId] = completion;
    try {
      if (_socket != null) {
        _socket!.add(jsonEncode(request));
      }
    } catch (err) {
      print('Error serializing or sending request: $err');
      print('Request was: $request');
    }
  }
}

class Params {
  String name;
  String peripheralId;
  Params(this.name, this.peripheralId);

  Map<String, dynamic> toJson() => {
        'name': name,
        'peripheralId': peripheralId,
      };

  factory Params.fromJson(Map<String, dynamic> json) {
    return Params(
      json['name'] as String,
      json['peripheralId'] as String,
    );
  }
}
