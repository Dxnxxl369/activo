// lib/screens/proveedor/proveedor_edit_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/proveedor.dart';
import '../../providers/proveedor_provider.dart';

class ProveedorEditScreen extends StatefulWidget {
  final Proveedor proveedor;

  const ProveedorEditScreen({super.key, required this.proveedor});

  @override
  State<ProveedorEditScreen> createState() => _ProveedorEditScreenState();
}

class _ProveedorEditScreenState extends State<ProveedorEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late Proveedor _editedProveedor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _editedProveedor = widget.proveedor;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    
    try {
      await Provider.of<ProveedorProvider>(context, listen: false)
          .updateProveedor(_editedProveedor);
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar'), backgroundColor: Colors.red));
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
        title: const Text('Editar Proveedor'),
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
                    children: [
                      TextFormField(
                        initialValue: _editedProveedor.nombre,
                        decoration: const InputDecoration(labelText: 'Nombre del Proveedor'),
                        validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
                        onSaved: (v) => _editedProveedor.nombre = v!,
                      ),
                      TextFormField(
                        initialValue: _editedProveedor.direccion,
                        decoration: const InputDecoration(labelText: 'Dirección'),
                        onSaved: (v) => _editedProveedor.direccion = v!,
                      ),
                      TextFormField(
                        initialValue: _editedProveedor.telefono,
                        decoration: const InputDecoration(labelText: 'Teléfono'),
                        keyboardType: TextInputType.phone,
                        onSaved: (v) => _editedProveedor.telefono = v!,
                      ),
                      TextFormField(
                        initialValue: _editedProveedor.email,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v != null && v.isNotEmpty && !v.contains('@')) {
                            return 'Email no válido';
                          }
                          return null;
                        },
                        onSaved: (v) => _editedProveedor.email = v!,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}