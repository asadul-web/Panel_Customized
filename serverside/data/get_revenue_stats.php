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
    
    // Get total revenue
    $total_query = $db->sql_query("SELECT COALESCE(SUM(revenue), 0) as total FROM ads_revenue");
    $total_result = $db->sql_fetchrow($total_query);
    $total_revenue = number_format($total_result['total'], 2);
    
    // Get today's revenue
    $today_query = $db->sql_query("SELECT COALESCE(SUM(revenue), 0) as today FROM ads_revenue WHERE date = CURDATE()");
    $today_result = $db->sql_fetchrow($today_query);
    $today_revenue = number_format($today_result['today'], 2);
    
    // Get this month's revenue
    $month_query = $db->sql_query("SELECT COALESCE(SUM(revenue), 0) as month FROM ads_revenue WHERE YEAR(date) = YEAR(CURDATE()) AND MONTH(date) = MONTH(CURDATE())");
    $month_result = $db->sql_fetchrow($month_query);
    $month_revenue = number_format($month_result['month'], 2);
    
    // Get active apps count
    $active_apps_query = $db->sql_query("SELECT COUNT(*) as count FROM ads_apps WHERE status = 'active'");
    $active_apps_result = $db->sql_fetchrow($active_apps_query);
    $active_apps = $active_apps_result['count'];
    
    // Get chart data (last 7 days)
    $chart_query = $db->sql_query("
        SELECT 
            DATE(date) as chart_date,
            SUM(revenue) as daily_revenue
        FROM ads_revenue 
        WHERE date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
        GROUP BY DATE(date)
        ORDER BY chart_date ASC
    ");
    
    $chart_labels = array();
    $chart_data = array();
    
    while($chart_row = $db->sql_fetchrow($chart_query)) {
        $chart_labels[] = date('M d', strtotime($chart_row['chart_date']));
        $chart_data[] = floatval($chart_row['daily_revenue']);
    }
    
    // Get top performing apps
    $top_apps_query = $db->sql_query("
        SELECT 
            a.app_name,
            a.package_name,
            SUM(r.revenue) as total_revenue
        FROM ads_apps a
        LEFT JOIN ads_revenue r ON a.id = r.app_id
        GROUP BY a.id, a.app_name, a.package_name
        ORDER BY total_revenue DESC
        LIMIT 5
    ");
    
    $top_apps = array();
    while($top_app = $db->sql_fetchrow($top_apps_query)) {
        $top_apps[] = array(
            'app_name' => $top_app['app_name'],
            'package_name' => $top_app['package_name'],
            'revenue' => $top_app['total_revenue'] ?: 0
        );
    }
    
    $values = array(
        'response' => 1,
        'total_revenue' => $total_revenue,
        'today_revenue' => $today_revenue,
        'month_revenue' => $month_revenue,
        'active_apps' => $active_apps,
        'chart_data' => array(
            'labels' => $chart_labels,
            'data' => $chart_data
        ),
        'top_apps' => $top_apps
    );
    
} catch (Exception $e) {
    $values = array(
        'response' => 0,
        'total_revenue' => '0.00',
        'today_revenue' => '0.00',
        'month_revenue' => '0.00',
        'active_apps' => 0,
        'chart_data' => array(
            'labels' => array(),
            'data' => array()
        ),
        'top_apps' => array(),
        'error' => $e->getMessage()
    );
}

// Clean any unwanted output
ob_clean();

// Set proper headers
header('Content-Type: application/json');
echo json_encode($values);
?>
