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
    
    $app_name = isset($_GET['app_name']) ? trim($_GET['app_name']) : '';
    
    if(empty($app_name)) {
        throw new Exception("App name is required");
    }
    
    // Get revenue breakdown by ad type
    $breakdown_query = $db->sql_query("
        SELECT 
            ad_type,
            SUM(revenue) as total_revenue,
            SUM(impressions) as total_impressions,
            SUM(clicks) as total_clicks
        FROM ads_revenue 
        WHERE app_name = '" . $db->SanitizeForSQL($app_name) . "'
        GROUP BY ad_type
    ");
    
    $banner_revenue = 0;
    $interstitial_revenue = 0;
    $rewarded_revenue = 0;
    $native_advanced_revenue = 0;
    $app_open_revenue = 0;
    $total_impressions = 0;
    $total_clicks = 0;
    
    while($row = $db->sql_fetchrow($breakdown_query)) {
        switch($row['ad_type']) {
            case 'banner':
                $banner_revenue = $row['total_revenue'];
                break;
            case 'interstitial':
                $interstitial_revenue = $row['total_revenue'];
                break;
            case 'rewarded':
                $rewarded_revenue = $row['total_revenue'];
                break;
            case 'native_advanced':
                $native_advanced_revenue = $row['total_revenue'];
                break;
            case 'app_open':
                $app_open_revenue = $row['total_revenue'];
                break;
        }
        $total_impressions += $row['total_impressions'];
        $total_clicks += $row['total_clicks'];
    }
    
    // Calculate average CTR
    $average_ctr = $total_impressions > 0 ? ($total_clicks / $total_impressions) * 100 : 0;
    
    $values = array(
        'response' => 1,
        'app_name' => $app_name,
        'banner_revenue' => number_format($banner_revenue, 2),
        'interstitial_revenue' => number_format($interstitial_revenue, 2),
        'rewarded_revenue' => number_format($rewarded_revenue, 2),
        'native_advanced_revenue' => number_format($native_advanced_revenue, 2),
        'app_open_revenue' => number_format($app_open_revenue, 2),
        'total_impressions' => number_format($total_impressions),
        'total_clicks' => number_format($total_clicks),
        'average_ctr' => number_format($average_ctr, 2)
    );
    
} catch (Exception $e) {
    $values = array(
        'response' => 0,
        'error' => $e->getMessage()
    );
}

// Clean any unwanted output
ob_clean();

// Set proper headers
header('Content-Type: application/json');
echo json_encode($values);
?>
