// lib/screens/cargo/cargo_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/cargo.dart';
import '../../providers/cargo_provider.dart';

class CargoEditScreen extends StatefulWidget {
  final Cargo cargo;
  const CargoEditScreen({super.key, required this.cargo});

  @override
  State<CargoEditScreen> createState() => _CargoEditScreenState();
}

class _CargoEditScreenState extends State<CargoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Cargo _editedItem;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editedItem = widget.cargo;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await Provider.of<CargoProvider>(context, listen: false).updateCargo(_editedItem);
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
        title: const Text('Editar Cargo'),
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
                    labelText: 'Nombre del Cargo',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.work_history_outlined),
                  ),
                  validator: (v) => v!.isEmpty ? 'Ingrese un nombre' : null,
                  onSaved: (v) => _editedItem.nombre = v!,
                ),
              ),
            ),
    );
  }
}