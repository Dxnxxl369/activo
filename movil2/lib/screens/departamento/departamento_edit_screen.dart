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
  late String _nombre;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nombre = widget.departamento.nombre;
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      final updatedDept = Departamento(id: widget.departamento.id, nombre: _nombre);
      await Provider.of<DepartamentoProvider>(context, listen: false).updateDepartamento(updatedDept);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar los cambios'), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Departamento'),
        // --- CORRECCIÓN: Eliminamos el botón duplicado de guardar ---
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: _nombre,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Departamento',
                        prefixIcon: Icon(Icons.business_center_outlined),
                      ),
                      validator: (v) => v!.isEmpty ? 'Ingrese un nombre' : null,
                      onSaved: (v) => _nombre = v!,
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