// lib/screens/departamento/departamento_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/departamento.dart';
import '../../providers/departamento_provider.dart';

class DepartamentoEditScreen extends StatefulWidget {
  final Departamento departamento;
  const DepartamentoEditScreen({super.key, required this.departamento});

  @override
  State<DepartamentoEditScreen> createState() => _DepartamentoEditScreenState();
}

class _DepartamentoEditScreenState extends State<DepartamentoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Departamento _editedItem;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editedItem = widget.departamento;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      await Provider.of<DepartamentoProvider>(context, listen: false)
          .updateDepartamento(_editedItem);
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
        title: const Text('Editar Departamento'),
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
                  decoration: const InputDecoration(labelText: 'Nombre del Departamento'),
                  validator: (v) => v!.isEmpty ? 'Ingrese un nombre' : null,
                  onSaved: (v) => _editedItem.nombre = v!,
                ),
              ),
            ),
    );
  }
}