// lib/screens/ubicacion/ubicacion_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/ubicacion.dart';
import '../../providers/ubicacion_provider.dart';

class UbicacionEditScreen extends StatefulWidget {
  final Ubicacion item;
  const UbicacionEditScreen({super.key, required this.item});

  @override
  State<UbicacionEditScreen> createState() => _UbicacionEditScreenState();
}

class _UbicacionEditScreenState extends State<UbicacionEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Ubicacion _editedItem;
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
      await Provider.of<UbicacionProvider>(context, listen: false).updateItem(_editedItem);
      Navigator.of(context).pop();
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
        title: const Text('Editar Ubicación'),
        actions: [IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: _editedItem.nombre,
                  decoration: const InputDecoration(labelText: 'Nombre de la Ubicación'),
                  validator: (v) => v!.isEmpty ? 'Ingrese un nombre' : null,
                  onSaved: (v) => _editedItem.nombre = v!,
                ),
              ),
            ),
    );
  }
}