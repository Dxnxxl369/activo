// lib/screens/empleado/empleado_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/empleado.dart';
import '../../providers/empleado_provider.dart';

class EmpleadoEditScreen extends StatefulWidget {
  final Empleado empleado;
  const EmpleadoEditScreen({super.key, required this.empleado});

  @override
  State<EmpleadoEditScreen> createState() => _EmpleadoEditScreenState();
}

class _EmpleadoEditScreenState extends State<EmpleadoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Empleado _editedEmpleado;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editedEmpleado = widget.empleado;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    
    try {
      await Provider.of<EmpleadoProvider>(context, listen: false).updateEmpleado(_editedEmpleado);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      // Error handling
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Empleado'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(_editedEmpleado.nombreCompleto, style: Theme.of(context).textTheme.headlineSmall),
                    Text("CI: ${_editedEmpleado.ci}", style: Theme.of(context).textTheme.bodyMedium),
                    const Divider(height: 32, thickness: 1),
                    TextFormField(
                      initialValue: _editedEmpleado.direccion,
                      decoration: const InputDecoration(labelText: 'Dirección', prefixIcon: Icon(Icons.home_outlined)),
                      onSaved: (v) => _editedEmpleado.direccion = v ?? '',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: _editedEmpleado.telefono,
                      decoration: const InputDecoration(labelText: 'Teléfono', prefixIcon: Icon(Icons.phone_outlined)),
                      keyboardType: TextInputType.phone,
                      onSaved: (v) => _editedEmpleado.telefono = v ?? '',
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        Chip(avatar: const Icon(Icons.work_outline), label: Text('Cargo: ${_editedEmpleado.cargoNombre}')),
                        Chip(avatar: const Icon(Icons.business_outlined), label: Text('Depto: ${_editedEmpleado.departamentoNombre}')),
                      ],
                    ),
                     const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveForm,
                      child: const Text('Guardar Cambios'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}