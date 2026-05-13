<?php
// Clear any previous output buffers to ensure clean JSON
ob_start();

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET');
header('Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With');

// Production error handling
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', 0);

try {
    require_once '../includes/functions.php';
    
    global $db;
    
    if(!$db) {
        throw new Exception('Database connection error');
    }

    // Determine base URL dynamically
    $protocol = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on') ? "https://" : "http://";
    $baseUrl = $protocol . $_SERVER['HTTP_HOST'];
    $uploadPath = '/uploads/slider/';
    
    // Fetch active slider images
    $query = $db->sql_query("SELECT id, title, description, image_url, link_url, sort_order FROM slider_images WHERE status = 'active' ORDER BY sort_order ASC, id DESC LIMIT 10");
    
    $sliders = array();
    
    if($query) {
        while($row = $db->sql_fetchrow($query)) {
            // Check if file actually exists
            $physicalPath = '..' . $uploadPath . $row['image_url'];
            
            // Construct full URL
            $fullImageUrl = $baseUrl . $uploadPath . $row['image_url'];
            
            // Clean data
            $sliderItem = [
                'id' => (int)$row['id'],
                'title' => html_entity_decode($row['title']),
                'description' => html_entity_decode($row['description']),
                'image' => $fullImageUrl, // Simplified key name for apps
                'url' => $row['link_url'], // Simplified key name for apps
                'sort_order' => (int)$row['sort_order']
            ];
            
            $sliders[] = $sliderItem;
        }
    }
    
    // Clear buffer before outputting JSON
    ob_clean();
    
    echo json_encode([
        'status' => true,
        'message' => 'Data retrieved successfully',
        'count' => count($sliders),
        'data' => $sliders
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);

} catch (Exception $e) {
    ob_clean();
    http_response_code(500);
    echo json_encode([
        'status' => false,
        'message' => $e->getMessage(),
        'data' => []
    ]);
}

// End buffering
ob_end_flush();
?>
