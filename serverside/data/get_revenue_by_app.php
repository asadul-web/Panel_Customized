<?php
// Suppress warnings for clean JSON output
error_reporting(0);
ini_set('display_errors', '0');

// Start output buffering to catch any unwanted output
ob_start();

try {
    require_once '../../includes/config.php';
    
    // Simple authentication check - just check if we can access the database
    if(!isset($db) || !is_object($db)) {
        throw new Exception("Database not available");
    }
    
    // Get revenue data grouped by app
    $query = $db->sql_query("
        SELECT 
            a.id,
            a.app_name,
            a.package_name,
            a.status,
            COALESCE(SUM(r.revenue), 0) as total_revenue,
            COALESCE(SUM(CASE WHEN r.date = CURDATE() THEN r.revenue ELSE 0 END), 0) as today_revenue,
            COALESCE(SUM(CASE WHEN YEAR(r.date) = YEAR(CURDATE()) AND MONTH(r.date) = MONTH(CURDATE()) THEN r.revenue ELSE 0 END), 0) as month_revenue,
            MAX(r.updated_date) as last_updated
        FROM ads_apps a
        LEFT JOIN ads_revenue r ON a.id = r.app_id
        GROUP BY a.id, a.app_name, a.package_name, a.status
        ORDER BY total_revenue DESC
    ");
    
    $data = array();
    
    while($row = $db->sql_fetchrow($query)) {
        $data[] = array(
            'id' => $row['id'],
            'app_name' => $row['app_name'],
            'package_name' => $row['package_name'],
            'status' => $row['status'],
            'total_revenue' => number_format($row['total_revenue'], 2),
            'today_revenue' => number_format($row['today_revenue'], 2),
            'month_revenue' => number_format($row['month_revenue'], 2),
            'last_updated' => $row['last_updated'] ? date('Y-m-d H:i', strtotime($row['last_updated'])) : 'Never'
        );
    }
    
    $values['data'] = $data;
    
} catch (Exception $e) {
    $values['data'] = array();
    $values['error'] = $e->getMessage();
}

// Clean any unwanted output
ob_clean();

// Set proper headers
header('Content-Type: application/json');
echo json_encode($values);
?>
