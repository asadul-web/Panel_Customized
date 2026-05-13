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
    
    // Get filter parameters
    $app_filter = isset($_GET['app']) && !empty($_GET['app']) ? $_GET['app'] : '';
    $period_filter = isset($_GET['period']) && !empty($_GET['period']) ? (int)$_GET['period'] : 30;
    
    // Build query with filters
    $where_conditions = array();
    $where_conditions[] = "r.date >= DATE_SUB(CURDATE(), INTERVAL $period_filter DAY)";
    
    if(!empty($app_filter)) {
        $where_conditions[] = "r.app_name = '" . $db->SanitizeForSQL($app_filter) . "'";
    }
    
    $where_clause = implode(' AND ', $where_conditions);
    
    $query = $db->sql_query("
        SELECT 
            r.date,
            r.app_name,
            r.ad_type,
            r.revenue,
            r.impressions,
            r.clicks,
            r.ctr
        FROM ads_revenue r
        WHERE $where_clause
        ORDER BY r.date DESC, r.app_name ASC
        LIMIT 1000
    ");
    
    $data = array();
    
    while($row = $db->sql_fetchrow($query)) {
        $data[] = array(
            'date' => date('Y-m-d', strtotime($row['date'])),
            'app_name' => $row['app_name'],
            'ad_type' => ucfirst($row['ad_type']),
            'revenue' => number_format($row['revenue'], 2),
            'impressions' => number_format($row['impressions']),
            'clicks' => number_format($row['clicks']),
            'ctr' => number_format($row['ctr'], 2)
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
