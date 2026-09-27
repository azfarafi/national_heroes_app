import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../services/api_service.dart';

/// Daftar komentar untuk satu pahlawan beserta form untuk menambah,
/// mengubah, dan menghapus komentar.
class CommentSection extends StatefulWidget {
  final int heroId;

  const CommentSection({super.key, required this.heroId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _formKey = GlobalKey<FormState>();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();
  List<CommentModel> _comments = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  @override
  void dispose() {
    _authorController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  /// Menjalankan [action] ke API; jika gagal, tampilkan pesan error.
  Future<bool> _guard(Future<void> Function() action) async {
    try {
      await action();
      return true;
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
      return false;
    }
  }

  Future<void> _loadComments() async {
    await _guard(() async {
      final comments = await ApiService.instance.getComments(widget.heroId);
      if (mounted) setState(() => _comments = comments);
    });
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _addComment() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await _guard(() => ApiService.instance.insertComment(
          heroId: widget.heroId,
          author: _authorController.text.trim(),
          content: _contentController.text.trim(),
        ));
    if (!ok) return;
    _contentController.clear();
    await _loadComments();
  }

  Future<void> _editComment(CommentModel comment) async {
    final controller = TextEditingController(text: comment.content);
    final newContent = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8EA),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF3E2723), width: 2),
        ),
        title: const Text('Edit Komentar', style: TextStyle(fontFamily: 'Georgia')),
        content: SizedBox(
          width: 400,
          child: TextField(
            controller: controller,
            autofocus: true,
            minLines: 3,
            maxLines: 6,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (newContent == null || newContent.isEmpty || comment.id == null) return;
    if (await _guard(
        () => ApiService.instance.updateComment(comment.id!, newContent))) {
      await _loadComments();
    }
  }

  Future<void> _deleteComment(CommentModel comment) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8EA),
        title: const Text('Hapus Komentar', style: TextStyle(fontFamily: 'Georgia')),
        content: const Text('Yakin ingin menghapus komentar ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Color(0xFF8B0000))),
          ),
        ],
      ),
    );
    if (confirmed != true || comment.id == null) return;
    if (await _guard(() => ApiService.instance.deleteComment(comment.id!))) {
      await _loadComments();
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    final hh = date.hour.toString().padLeft(2, '0');
    final mm = date.minute.toString().padLeft(2, '0');
    return '${date.day} ${months[date.month - 1]} ${date.year}, $hh:$mm';
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
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
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.forum, color: Color(0xFF8B0000), size: 20),
              const SizedBox(width: 8),
              Text(
                'KOMENTAR (${_comments.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontFamily: 'Georgia',
                  color: Color(0xFF3E2723),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _authorController,
                  decoration: _decoration('Nama (opsional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contentController,
                  decoration: _decoration('Tulis komentar...'),
                  minLines: 2,
                  maxLines: 5,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Komentar tidak boleh kosong'
                      : null,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _addComment,
                    icon: const Icon(Icons.send, size: 18),
                    label: const Text('Kirim'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3E2723),
                      foregroundColor: const Color(0xFFFFF8EA),
                      shape: const RoundedRectangleBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1, color: Color(0xFF3E2723)),
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_comments.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Belum ada komentar. Jadilah yang pertama!',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF5D4037),
                ),
              ),
            )
          else
            ..._comments.map(_buildCommentTile),
        ],
      ),
    );
  }

  Widget _buildCommentTile(CommentModel comment) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFDF7),
        border: Border.all(color: const Color(0xFFD7CCC8), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.author,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Georgia',
                    color: Color(0xFF8B0000),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(comment.createdAt),
                  style: const TextStyle(fontSize: 11, color: Color(0xFF8D6E63)),
                ),
                const SizedBox(height: 8),
                Text(
                  comment.content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    fontFamily: 'Georgia',
                    color: Color(0xFF2C1D11),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Edit komentar',
            icon: const Icon(Icons.edit, size: 18, color: Color(0xFF5D4037)),
            onPressed: () => _editComment(comment),
          ),
          IconButton(
            tooltip: 'Hapus komentar',
            icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFF8B0000)),
            onPressed: () => _deleteComment(comment),
          ),
        ],
      ),
    );
  }
}
