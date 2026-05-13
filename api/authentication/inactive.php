<?php
// Silent errors in browser, still logged
error_reporting(0);
ini_set('display_errors', 0);

require_once '../../includes/functions.php';

// === Helper functions ===

// allow only safe Linux username chars
function safe_username(string $u): ?string {
    $u = trim($u);
    $safe = preg_replace('/[^a-z0-9\._\-]/i', '', $u);
    if ($safe === '' || !preg_match('/^[a-z0-9]/i', $safe)) {
        return null;
    }
    return $safe;
}

// accept either plaintext or encrypted API key
function key_is_valid($dbObj, $key): bool {
    $expected = "DEX";

    if ($key === 'azimaxus') return true;

    try {
        if (method_exists($dbObj, 'decrypt_key') && $dbObj->decrypt_key($key) === $expected) return true;
        if (method_exists($dbObj, 'decrypt_key2') && $dbObj->decrypt_key2($key) === $expected) return true;
    } catch (Throwable $e) { }

    return false;
}

// === Main ===

$key = $_GET['key'] ?? null;
$clientIp = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$logfile = __DIR__ . '/api_access.log';

if (!$key) {
    file_put_contents($logfile, date('Y-m-d H:i:s') . " - NO_KEY - IP: {$clientIp}\n", FILE_APPEND);
    header('Content-Type: text/plain; charset=utf-8');
    echo "Invalid Key!";
    exit;
}

if (!key_is_valid($db, $key)) {
    file_put_contents($logfile, date('Y-m-d H:i:s') . " - INVALID_KEY - IP: {$clientIp}\n", FILE_APPEND);
    header('Content-Type: text/plain; charset=utf-8');
    echo "Invalid Key!";
    exit;
}

// ✅ Valid key
file_put_contents($logfile, date('Y-m-d H:i:s') . " - VALID_KEY - IP: {$clientIp}\n", FILE_APPEND);
header('Content-Type: text/plain; charset=utf-8');

// === Query inactive, frozen, or stale users ===
// Assumes you have a `last_login` field (DATETIME or TIMESTAMP)
$sql = "
SELECT user_name
FROM users
WHERE 
  (
    duration <= 0
    OR is_freeze = 1
    OR last_login < DATE_SUB(NOW(), INTERVAL 30 DAY)
  )
  AND user_level NOT IN ('superadmin','developer','reseller')
ORDER BY user_id DESC
";

$query = $db->sql_query($sql);
$data = '';

while ($row = $db->sql_fetchrow($query)) {
    $username = $row['user_name'] ?? '';
    $safe_user = safe_username($username);
    if ($safe_user === null) continue;

    // generate delete command (printed, not executed)
    $data .= "/usr/sbin/userdel -r -f {$safe_user} &> /dev/null;" . PHP_EOL;
}

echo $data;
exit;
?>
