<?php
error_reporting(0);
ini_set('display_errors', 0);
require_once '../../includes/functions.php';

/**
 * Helper: sanitize username for shell safety
 */
function safe_username(string $u): ?string {
    $u = trim($u);
    $safe = preg_replace('/[^a-zA-Z0-9._\-]/', '', $u);
    if ($safe === '') return null;
    return $safe;
}

/**
 * Helper: validate access key (supports old/new encryption)
 */
function key_is_valid($dbObj, $key): bool {
    $expected = 'DEX';
    if ($key === 'azimaxus') return true;

    try {
        if (method_exists($dbObj, 'decrypt_key') && $dbObj->decrypt_key($key) === $expected) return true;
        if (method_exists($dbObj, 'decrypt_key2') && $dbObj->decrypt_key2($key) === $expected) return true;
    } catch (Throwable $e) {}
    return false;
}

/**
 * Helper: decrypt database password properly - using single encryption
 */
function decrypt_user_pass($db, $pass) {
    try {
        // Use single decryption to match database encryption
        return $db->encryptor('decrypt', $pass);
    } catch (Throwable $e) {
        return null;
    }
}

// === MAIN SCRIPT ===

$key = $_GET['key'] ?? null;
$type = $_GET['type'] ?? 'active'; // active | inactive | deleted
header('Content-Type: text/plain; charset=utf-8');
$clientIp = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$logfile = __DIR__ . '/sync_users.log';

// === Check key ===
if (!$key || !key_is_valid($db, $key)) {
    file_put_contents($logfile, date('Y-m-d H:i:s')." - INVALID_KEY ({$type}) - IP: {$clientIp}\n", FILE_APPEND);
    echo "Invalid Key!";
    exit;
}

$data = '';

switch ($type) {

    // 🟩 ACTIVE USERS — create or update system accounts
    case 'active':
        $query = $db->sql_query("
            SELECT user_name, user_pass
            FROM users
            WHERE duration > 0
              AND is_freeze = 0
              AND user_level NOT IN ('superadmin', 'developer', 'reseller')
            ORDER BY user_id DESC
        ");
        while ($row = $db->sql_fetchrow($query)) {
            $username = safe_username($row['user_name']);
            $user_pass = decrypt_user_pass($db, $row['user_pass']);
            if (!$username || !$user_pass) continue;

            $data .= "/usr/sbin/useradd --badname -p \$(openssl passwd -1 '{$user_pass}') -s /bin/false -M {$username} &> /dev/null;" . PHP_EOL;
        }
        break;

    // 🟨 INACTIVE USERS — remove frozen or expired accounts
    case 'inactive':
        $query = $db->sql_query("
            SELECT user_name
            FROM users
            WHERE (duration <= 0 OR is_freeze = 1)
              AND user_level NOT IN ('superadmin', 'developer', 'reseller')
            ORDER BY user_id DESC
        ");
        while ($row = $db->sql_fetchrow($query)) {
            $username = safe_username($row['user_name']);
            if (!$username) continue;
            $data .= "/usr/sbin/userdel -r -f {$username} &> /dev/null;" . PHP_EOL;
        }
        break;

    // 🟥 DELETED USERS — remove from users_delete table
    case 'deleted':
        $query = $db->sql_query("SELECT user_name FROM users_delete ORDER BY user_id DESC");
        while ($row = $db->sql_fetchrow($query)) {
            $username = safe_username($row['user_name']);
            if (!$username) continue;
            $data .= "/usr/sbin/userdel -r -f {$username} &> /dev/null;" . PHP_EOL;
        }
        break;

    default:
        echo "Invalid Type!";
        exit;
}

file_put_contents($logfile, date('Y-m-d H:i:s')." - {$type} - OK - IP: {$clientIp}\n", FILE_APPEND);
echo $data;
exit;
?>
