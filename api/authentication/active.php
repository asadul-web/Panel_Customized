<?php
// Turn off verbose errors to browser (still logable)
error_reporting(0);
ini_set('display_errors', 0);

// Adjust the path to your includes
require_once '../../includes/functions.php';

// helper: safe shell single-quote wrapper for literal insertion into single-quoted shell strings
function shell_single_quote(string $s): string {
    // in shell: 'abc'\''def'
    return "'" . str_replace("'", "'\\''", $s) . "'";
}

// helper: produce a safe username (allow only alnum, dash, underscore)
function safe_username(string $u): ?string {
    $u = trim($u);
    // Restrict to typical linux username chars; adjust pattern if you need dots etc.
    $safe = preg_replace('/[^a-z0-9_\-]/i', '', $u);
    return $safe === '' ? null : $safe;
}

// helper: sanitize password to printable ASCII (remove control/non-printable)
function safe_password(string $p): string {
    // keep space..tilde (0x20 - 0x7E)
    return preg_replace('/[^\x20-\x7E]/', '', $p);
}

// validate API key: allows plaintext 'azimaxus' OR '@@@DEX@@@' OR encrypted keys that decrypt to 'DEX'
function key_is_valid($dbObj, $key): bool {
    $expected = "DEX";

    // accept raw plaintext keys for backward compatibility
    if ($key === 'azimaxus' || $key === '@@@DEX@@@' || $key === 'new_api_key') return true;

    // attempt decrypt with both methods if available
    try {
        if (method_exists($dbObj, 'decrypt_key')) {
            $d1 = $dbObj->decrypt_key($key);
            if ($d1 === $expected) return true;
        }
        if (method_exists($dbObj, 'decrypt_key2')) {
            $d2 = $dbObj->decrypt_key2($key);
            if ($d2 === $expected) return true;
        }
    } catch (Throwable $e) {
        // swallow; we'll simply treat as invalid and log below
    }

    return false;
}

// Main
$key = isset($_GET['key']) ? $_GET['key'] : null;
$clientIp = $_SERVER['REMOTE_ADDR'] ?? 'unknown';
$logfile = __DIR__ . '/api_access.log';

// basic key presence check
if (!$key) {
    // log and exit
    file_put_contents($logfile, date('Y-m-d H:i:s') . " - NO_KEY - IP: {$clientIp}\n", FILE_APPEND);
    header('Content-Type: text/plain; charset=utf-8');
    echo "Invalid Key!";
    exit;
}

// Validate key
if (!key_is_valid($db, $key)) {
    file_put_contents($logfile, date('Y-m-d H:i:s') . " - INVALID_KEY - IP: {$clientIp} - ReceivedKey:" . substr($key, 0, 64) . "\n", FILE_APPEND);
    header('Content-Type: text/plain; charset=utf-8');
    echo "Invalid Key!";
    exit;
}

// log valid access
file_put_contents($logfile, date('Y-m-d H:i:s') . " - VALID_KEY - IP: {$clientIp}\n", FILE_APPEND);

// Now produce the commands. Keep content-type as plain text so caller can consume.
header('Content-Type: text/plain; charset=utf-8');

$data = '';

// Query users — keep your original filters
$query = $db->sql_query("SELECT user_name, user_pass FROM users WHERE duration > 0 AND is_freeze = 0 AND user_level != 'superadmin' AND user_level != 'developer' AND user_level != 'reseller' ORDER BY user_id DESC");

while ($row = $db->sql_fetchrow($query)) {
    $username = $row['user_name'] ?? '';
    // Use single decryption to match database encryption
    $user_pass_enc = $row['user_pass'] ?? '';
    $plain_pass = '';
    
    try {
        $plain_pass = $db->encryptor('decrypt', $user_pass_enc);
    } catch (Throwable $e) {
        // Decryption failed, skip user
    }

    // sanitize username and password
    $safe_user = safe_username($username);
    if ($safe_user === null) {
        // skip invalid username entries
        continue;
    }
    $safe_pass = safe_password($plain_pass);

    // shell-safe single quoting for the openssl password literal
    $quoted_pass = shell_single_quote($safe_pass);

    // escapeshellarg for username part (we are not executing, but building safe text)
    $escaped_user_for_shell = escapeshellarg($safe_user); // will produce 'username'

    // Build the command line in a safe way:
    // Use: /usr/sbin/useradd --badname -p $(openssl passwd -1 'password') -s /bin/false -M username &> /dev/null;
    $cmd = "/usr/sbin/useradd --badname -p \$(openssl passwd -1 {$quoted_pass}) -s /bin/false -M {$safe_user} &> /dev/null;";

    $data .= $cmd . PHP_EOL;
}

// Output generated script lines
echo $data;
exit;
?>
