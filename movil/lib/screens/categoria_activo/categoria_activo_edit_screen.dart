// lib/screens/categoria_activo/categoria_activo_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/categoria_activo.dart';
import '../../providers/categoria_activo_provider.dart';

class CategoriaActivoEditScreen extends StatefulWidget {
  final CategoriaActivo item;
  const CategoriaActivoEditScreen({super.key, required this.item});

  @override
  State<CategoriaActivoEditScreen> createState() => _CategoriaActivoEditScreenState();
}

class _CategoriaActivoEditScreenState extends State<CategoriaActivoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late CategoriaActivo _editedItem;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editedItem = widget.item;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    try {
      await Provider.of<CategoriaActivoProvider>(context, listen: false).updateItem(_editedItem);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      // Manejo de error
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Categoría'),
        actions: [IconButton(onPressed: _saveForm, icon: const Icon(Icons.save_outlined))],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: _editedItem.nombre,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la Categoría',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.label_outline),
                  ),
                  validator: (v) => v!.isEmpty ? 'Ingrese un nombre' : null,
                  onSaved: (v) => _editedItem.nombre = v!,
                ),
              ),
            ),
    );
  }
}