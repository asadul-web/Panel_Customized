<?php
ob_start();
error_reporting(E_ALL);
ini_set('display_errors', '0');
ini_set('log_errors', '1');

try {
    require_once '../../includes/functions.php';
    chkSession();
} catch (Exception $e) {
    if (ob_get_length()) { ob_clean(); }
    header('Content-Type: application/json');
    echo json_encode(['response' => 0, 'msg' => 'Error: ' . $e->getMessage()]);
    exit;
}

if (ob_get_length()) { ob_clean(); }
header('Content-Type: application/json');

$values = array();

// Check if user is developer
if($user_id_2 != 2 && $user_level_2 != 'developer'){
	$values['response'] = 0;
	$values['msg'] = 'Permission denied. User: ' . ($user_id_2 ?? 'unknown') . ', Level: ' . ($user_level_2 ?? 'unknown');
	echo json_encode($values);
	exit;
}

$action = $_POST['action'] ?? '';
$logs_dir = dirname(__DIR__, 2) . DIRECTORY_SEPARATOR . 'logs';

if ($action === 'delete_all') {
	// Delete all API log files
	$log_files = [
		'licenses_api.log',
		'notice_api.log',
		'api_debug.log'
	];
	
	$deleted = 0;
	foreach ($log_files as $file) {
		$file_path = $logs_dir . DIRECTORY_SEPARATOR . $file;
		if (file_exists($file_path)) {
			if (@unlink($file_path)) {
				$deleted++;
			}
		}
	}
	
	if ($deleted > 0) {
		$values['response'] = 1;
		$values['msg'] = 'Successfully deleted ' . $deleted . ' log file(s)';
	} else {
		$values['response'] = 0;
		$values['msg'] = 'No log files found to delete';
	}
	
} elseif ($action === 'delete_single') {
	$log_type = $_POST['log_type'] ?? '';
	
	$log_files_map = [
		'licenses_api' => 'licenses_api.log',
		'notice_api' => 'notice_api.log',
		'api_debug' => 'api_debug.log'
	];
	
	if (!isset($log_files_map[$log_type])) {
		$values['response'] = 0;
		$values['msg'] = 'Invalid log type';
	} else {
		$file_path = $logs_dir . DIRECTORY_SEPARATOR . $log_files_map[$log_type];
		
		if (file_exists($file_path)) {
			if (@unlink($file_path)) {
				$values['response'] = 1;
				$values['msg'] = 'Log file deleted successfully';
			} else {
				$values['response'] = 0;
				$values['msg'] = 'Failed to delete log file';
			}
		} else {
			$values['response'] = 0;
			$values['msg'] = 'Log file not found';
		}
	}
	
} else {
	$values['response'] = 0;
	$values['msg'] = 'Invalid action';
}

echo json_encode($values);
?>

