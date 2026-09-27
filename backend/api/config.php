<?php
// Konfigurasi koneksi MySQL (default XAMPP: user root tanpa password).
const DB_HOST = '127.0.0.1';
const DB_NAME = 'national_heroes';
const DB_USER = 'root';
const DB_PASS = '';

// Izinkan aplikasi Flutter web (beda port/origin) memanggil API ini.
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header('Content-Type: application/json; charset=utf-8');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

function db(): PDO
{
    static $pdo = null;
    if ($pdo === null) {
        $pdo = new PDO(
            'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
            DB_USER,
            DB_PASS,
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                // Agar kolom INT dikembalikan sebagai angka, bukan string.
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::ATTR_STRINGIFY_FETCHES => false,
            ]
        );
    }
    return $pdo;
}

function respond($data, int $status = 200): void
{
    http_response_code($status);
    echo json_encode($data, JSON_UNESCAPED_UNICODE);
    exit;
}

function fail(string $message, int $status = 400): void
{
    respond(['error' => $message], $status);
}

/** Membaca body JSON dan memastikan field wajib terisi. */
function json_body(array $required = []): array
{
    $body = json_decode(file_get_contents('php://input'), true);
    if (!is_array($body)) {
        fail('Body harus berupa JSON');
    }
    foreach ($required as $field) {
        if (!isset($body[$field]) || trim((string) $body[$field]) === '') {
            fail("Field '$field' wajib diisi");
        }
    }
    return $body;
}

/** Mengambil parameter ?id= sebagai integer, atau null jika tidak ada. */
function query_int(string $name): ?int
{
    if (!isset($_GET[$name])) {
        return null;
    }
    $value = filter_var($_GET[$name], FILTER_VALIDATE_INT);
    if ($value === false) {
        fail("Parameter '$name' harus berupa angka");
    }
    return $value;
}

set_exception_handler(function (Throwable $e) {
    respond(['error' => 'Kesalahan server: ' . $e->getMessage()], 500);
});
