import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/api_service.dart';
import '../widgets/hero_image.dart';

/// Form untuk menambah pahlawan baru atau mengubah data pahlawan yang ada.
/// Mengembalikan [HeroModel] yang tersimpan melalui `Navigator.pop`.
class HeroFormPage extends StatefulWidget {
  final HeroModel? hero;

  const HeroFormPage({super.key, this.hero});

  @override
  State<HeroFormPage> createState() => _HeroFormPageState();
}

class _HeroFormPageState extends State<HeroFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _originController;
  late final TextEditingController _lifeTimeController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageController;
  bool _saving = false;

  bool get _isEdit => widget.hero != null;

  @override
  void initState() {
    super.initState();
    final hero = widget.hero;
    _nameController = TextEditingController(text: hero?.name);
    _originController = TextEditingController(text: hero?.origin);
    _lifeTimeController = TextEditingController(text: hero?.lifeTime);
    _descriptionController = TextEditingController(text: hero?.description);
    _imageController = TextEditingController(text: hero?.imagePath);
    _imageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _originController.dispose();
    _lifeTimeController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? 'Wajib diisi' : null;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = HeroModel(
      id: widget.hero?.id,
      name: _nameController.text.trim(),
      origin: _originController.text.trim(),
      lifeTime: _lifeTimeController.text.trim(),
      description: _descriptionController.text.trim(),
      imagePath: _imageController.text.trim(),
    );

    final api = ApiService.instance;
    final HeroModel saved;
    try {
      saved = _isEdit ? await api.updateHero(data) : await api.insertHero(data);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isEdit
            ? 'Data ${saved.name} berhasil diperbarui'
            : '${saved.name} berhasil ditambahkan'),
      ),
    );
    Navigator.pop(context, saved);
  }

  InputDecoration _decoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFFFFDF7),
      labelStyle: const TextStyle(fontFamily: 'Georgia', color: Color(0xFF3E2723)),
      border: const OutlineInputBorder(borderRadius: BorderRadius.zero),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Color(0xFF3E2723), width: 1.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Color(0xFF8B0000), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EAE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: const Color(0xFFFFF8EA),
        title: Text(
          _isEdit ? 'Edit Pahlawan' : 'Tambah Pahlawan',
          style: const TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EA),
                border: Border.all(color: const Color(0xFF3E2723), width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(6, 6),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 180,
                      height: 240,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEBE9),
                        border: Border.all(color: const Color(0xFF3E2723), width: 3),
                      ),
                      child: HeroImage(
                        path: _imageController.text.trim(),
                        placeholder: '[ Pratinjau Foto ]',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nameController,
                            decoration: _decoration('Nama Pahlawan'),
                            validator: _required,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _originController,
                            decoration: _decoration('Daerah Asal',
                                hint: 'contoh: Blitar, Jawa Timur'),
                            validator: _required,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _lifeTimeController,
                            decoration: _decoration('Masa Hidup',
                                hint: 'contoh: 6 Juni 1901 – 21 Juni 1970'),
                            validator: _required,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _imageController,
                            decoration: _decoration('Foto (path aset atau URL)',
                                hint: 'assets/images/nama.jpg atau https://...'),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: _decoration('Biografi'),
                            minLines: 4,
                            maxLines: 8,
                            validator: _required,
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: _saving ? null : _save,
                              icon: const Icon(Icons.save),
                              label: Text(_isEdit ? 'Simpan Perubahan' : 'Tambah'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B0000),
                                foregroundColor: const Color(0xFFFFF8EA),
                                shape: const RoundedRectangleBorder(),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
