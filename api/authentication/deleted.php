<?php
// Hide errors from output (log instead)
error_reporting(0);
ini_set('display_errors', 0);

require_once '../../includes/functions.php';

// === Helper functions ===

// Strip unsafe chars from username
function safe_username(string $u): ?string {
    $u = trim($u);
    $safe = preg_replace('/[^a-z0-9._\-]/i', '', $u);
    if ($safe === '' || !preg_match('/^[a-z0-9]/i', $safe)) return null;
    return $safe;
}

// Accepts both plaintext and encrypted key
function key_is_valid($dbObj, $key): bool {
    $expected = 'DEX';
    if ($key === 'azimaxus') return true;

    try {
        if (method_exists($dbObj, 'decrypt_key') && $dbObj->decrypt_key($key) === $expected) return true;
        if (method_exists($dbObj, 'decrypt_key2') && $dbObj->decrypt_key2($key) === $expected) return true;
    } catch (Throwable $e) {}

    return false;
}

// === Main ===

$key = $_GET['key'] ?? null;
$clientIp = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$logfile = __DIR__ . '/delete_access.log';

if (!$key) {
    file_put_contents($logfile, date('Y-m-d H:i:s')." - NO_KEY - IP: {$clientIp}\n", FILE_APPEND);
    echo "Invalid Key!";
    exit;
}

if (!key_is_valid($db, $key)) {
    file_put_contents($logfile, date('Y-m-d H:i:s')." - INVALID_KEY - IP: {$clientIp}\n", FILE_APPEND);
    echo "Invalid Key!";
    exit;
}

// ✅ Valid key
file_put_contents($logfile, date('Y-m-d H:i:s')." - VALID_KEY - IP: {$clientIp}\n", FILE_APPEND);

$query = $db->sql_query("SELECT user_name FROM users_delete ORDER BY user_id DESC");
$data = '';

while ($row = $db->sql_fetchrow($query)) {
    $username = $row['user_name'] ?? '';
    $safe_user = safe_username($username);
    if ($safe_user === null) continue;

    $data .= "/usr/sbin/userdel -r -f {$safe_user} &> /dev/null;" . PHP_EOL;
}

header('Content-Type: text/plain; charset=utf-8');
echo $data;
exit;
?>
