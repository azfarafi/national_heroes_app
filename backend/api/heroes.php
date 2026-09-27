<?php
// CRUD tabel `heroes`.
//   GET    heroes.php          -> daftar semua pahlawan
//   GET    heroes.php?id=1     -> satu pahlawan
//   POST   heroes.php          -> tambah (body JSON)
//   PUT    heroes.php?id=1     -> ubah (body JSON)
//   DELETE heroes.php?id=1     -> hapus (komentar ikut terhapus)
require __DIR__ . '/config.php';

const HERO_FIELDS = ['name', 'origin', 'life_time', 'description'];

function find_hero(int $id): ?array
{
    $stmt = db()->prepare('SELECT * FROM heroes WHERE id = ?');
    $stmt->execute([$id]);
    return $stmt->fetch() ?: null;
}

$id = query_int('id');

switch ($_SERVER['REQUEST_METHOD']) {
    case 'GET':
        if ($id === null) {
            respond(db()->query('SELECT * FROM heroes ORDER BY id')->fetchAll());
        }
        $hero = find_hero($id);
        $hero ? respond($hero) : fail('Pahlawan tidak ditemukan', 404);

    case 'POST':
        $b = json_body(HERO_FIELDS);
        $stmt = db()->prepare(
            'INSERT INTO heroes (name, origin, life_time, description, image_path)
             VALUES (?, ?, ?, ?, ?)'
        );
        $stmt->execute([$b['name'], $b['origin'], $b['life_time'], $b['description'], $b['image_path'] ?? '']);
        respond(find_hero((int) db()->lastInsertId()), 201);

    case 'PUT':
        if ($id === null) fail('Parameter id wajib diisi');
        if (!find_hero($id)) fail('Pahlawan tidak ditemukan', 404);
        $b = json_body(HERO_FIELDS);
        $stmt = db()->prepare(
            'UPDATE heroes SET name = ?, origin = ?, life_time = ?, description = ?, image_path = ?
             WHERE id = ?'
        );
        $stmt->execute([$b['name'], $b['origin'], $b['life_time'], $b['description'], $b['image_path'] ?? '', $id]);
        respond(find_hero($id));

    case 'DELETE':
        if ($id === null) fail('Parameter id wajib diisi');
        $stmt = db()->prepare('DELETE FROM heroes WHERE id = ?');
        $stmt->execute([$id]);
        $stmt->rowCount() ? respond(['deleted' => $id]) : fail('Pahlawan tidak ditemukan', 404);

    default:
        fail('Method tidak didukung', 405);
}
