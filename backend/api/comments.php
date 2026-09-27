<?php
// CRUD tabel `comments`.
//   GET    comments.php?hero_id=1  -> komentar milik satu pahlawan (terbaru dulu)
//   POST   comments.php            -> tambah (body JSON: hero_id, author, content)
//   PUT    comments.php?id=1       -> ubah isi (body JSON: content)
//   DELETE comments.php?id=1       -> hapus
require __DIR__ . '/config.php';

function find_comment(int $id): ?array
{
    $stmt = db()->prepare('SELECT * FROM comments WHERE id = ?');
    $stmt->execute([$id]);
    return $stmt->fetch() ?: null;
}

$id = query_int('id');

switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        $heroId = query_int('hero_id');
        if ($heroId === null) fail('Parameter hero_id wajib diisi');
        $stmt = db()->prepare('SELECT * FROM comments WHERE hero_id = ? ORDER BY created_at DESC, id DESC');
        $stmt->execute([$heroId]);
        respond($stmt->fetchAll());

    case 'POST':
        $b = json_body(['hero_id', 'content']);
        $author = trim((string) ($b['author'] ?? ''));
        $stmt = db()->prepare('INSERT INTO comments (hero_id, author, content) VALUES (?, ?, ?)');
        try {
            $stmt->execute([(int) $b['hero_id'], $author === '' ? 'Anonim' : $author, $b['content']]);
        } catch (PDOException $e) {
            // 23000 = pelanggaran foreign key (hero_id tidak ada).
            if ($e->getCode() === '23000') fail('Pahlawan tidak ditemukan', 404);
            throw $e;
        }
        respond(find_comment((int) db()->lastInsertId()), 201);

    case 'PUT':
        if ($id === null) fail('Parameter id wajib diisi');
        if (!find_comment($id)) fail('Komentar tidak ditemukan', 404);
        $b = json_body(['content']);
        $stmt = db()->prepare('UPDATE comments SET content = ? WHERE id = ?');
        $stmt->execute([$b['content'], $id]);
        respond(find_comment($id));

    case 'DELETE':
        if ($id === null) fail('Parameter id wajib diisi');
        $stmt = db()->prepare('DELETE FROM comments WHERE id = ?');
        $stmt->execute([$id]);
        $stmt->rowCount() ? respond(['deleted' => $id]) : fail('Komentar tidak ditemukan', 404);

    default:
        fail('Method tidak didukung', 405);
}
