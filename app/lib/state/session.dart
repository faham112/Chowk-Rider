import 'package:flutter/material.dart';

enum CrRole { customer, rider }

class CrSession extends ChangeNotifier {
  CrRole? role;
  String? phone;
  bool get isLoggedIn => phone != null && role != null;

  void setRole(CrRole value) {
    role = value;
    notifyListeners();
  }

  void login(String p) {
    phone = p;
    notifyListeners();
  }

  void logout() {
    phone = null;
    role = null;
    notifyListeners();
  }
}

class SessionScope extends InheritedNotifier<CrSession> {
  const SessionScope({
    super.key,
    required CrSession session,
    required super.child,
  }) : super(notifier: session);

  static CrSession of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SessionScope>();
    assert(scope != null, 'SessionScope missing');
    return scope!.notifier!;
  }
}
