<?php
error_reporting(E_ALL);
ini_set('display_errors', '0');

// Set content type for JSON response
header('Content-Type: application/json');

try {
    require_once '../../includes/functions.php';
    
    $values = array();
    
    // Get parameters
    $page_name = isset($_GET['page_name']) ? trim($_GET['page_name']) : 'site-info';
    $customization_type = isset($_GET['customization_type']) ? trim($_GET['customization_type']) : '';
    
    // Escape data for database
    $page_name_escaped = addslashes($page_name);
    
    $where_clause = "WHERE page_name = '$page_name_escaped'";
    if(!empty($customization_type)) {
        $customization_type_escaped = addslashes($customization_type);
        $where_clause .= " AND customization_type = '$customization_type_escaped'";
    }
    
    // Get customizations
    $query = "SELECT customization_type, customization_data, updated_date 
              FROM page_customizations 
              $where_clause 
              ORDER BY updated_date DESC";
    
    $result = $db->sql_query($query);
    
    $customizations = array();
    
    if($db->sql_numrows($result) > 0) {
        while($row = $db->sql_fetchrow($result)) {
            $customization_data = json_decode($row['customization_data'], true);
            
            $customizations[$row['customization_type']] = array(
                'data' => $customization_data,
                'updated_date' => $row['updated_date']
            );
        }
    }
    
    $values['response'] = 1;
    $values['customizations'] = $customizations;
    $values['page_name'] = $page_name;
    
} catch(Exception $e) {
    $values['response'] = 2;
    $values['msg'] = 'Error: ' . $e->getMessage();
} catch(Error $e) {
    $values['response'] = 2;
    $values['msg'] = 'Fatal Error: ' . $e->getMessage();
}

echo json_encode($values);
?>

