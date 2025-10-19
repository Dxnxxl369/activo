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
      await Provider.of<EmpleadoProvider>(context, listen: false)
          .updateEmpleado(_editedEmpleado);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar empleado'), backgroundColor: Colors.red));
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar ${_editedEmpleado.nombreCompleto}'),
        actions: [IconButton(icon: const Icon(Icons.save), onPressed: _saveForm)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nombre: ${_editedEmpleado.nombreCompleto}", style: Theme.of(context).textTheme.titleMedium),
                      Text("CI: ${_editedEmpleado.ci}"),
                      const Divider(height: 20),
                      TextFormField(
                        initialValue: _editedEmpleado.direccion,
                        decoration: const InputDecoration(labelText: 'Dirección'),
                        onSaved: (v) => _editedEmpleado.direccion = v ?? '',
                      ),
                      TextFormField(
                        initialValue: _editedEmpleado.telefono,
                        decoration: const InputDecoration(labelText: 'Teléfono'),
                        keyboardType: TextInputType.phone,
                        onSaved: (v) => _editedEmpleado.telefono = v ?? '',
                      ),
                      const SizedBox(height: 20),
                      // Los cargos y departamentos no son editables en esta versión simple
                      Chip(label: Text('Cargo: ${_editedEmpleado.cargoNombre}')),
                      Chip(label: Text('Departamento: ${_editedEmpleado.departamentoNombre}')),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}