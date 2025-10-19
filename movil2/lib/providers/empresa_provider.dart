// lib/providers/empresa_provider.dart

import 'package:flutter/foundation.dart';
import '../models/empresa.dart';
import '../api/empresa_service.dart';

class EmpresaProvider with ChangeNotifier {
  final EmpresaService _service = EmpresaService();
  List<Empresa> _items = [];
  bool _isLoading = false;

  List<Empresa> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();
    try {
      _items = await _service.getItems();
    } catch (e) {
      debugPrint("Error en provider de empresas: $e");
    }
    _isLoading = false;
    notifyListeners();
  }
}