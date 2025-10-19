// lib/providers/rol_provider.dart

import 'package:flutter/foundation.dart';
import '../models/rol.dart';
import '../api/rol_service.dart';

class RolProvider with ChangeNotifier {
  final RolService _service = RolService();
  List<Rol> _roles = [];
  bool _isLoading = false;

  List<Rol> get roles => _roles;
  bool get isLoading => _isLoading;

  Future<void> fetchRoles() async {
    _isLoading = true;
    notifyListeners();
    try {
      _roles = await _service.getRoles();
    } catch (e) {
      debugPrint("Error en provider de roles: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}