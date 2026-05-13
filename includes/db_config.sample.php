<?php
/**
 * Database Configuration Sample
 * 
 * INSTRUCTIONS:
 * 1. Copy this file to db_config.php
 * 2. Run the installer at /install/ to configure automatically
 * 
 * OR manually edit the values below:
 */

// IMPORTANT: This file triggers the installer
// Do NOT modify this line - it indicates config is not complete
$INSTALL_REQUIRED = true;

// Database credentials (will be set by installer)
$DB_host = "";
$DB_user = "";
$DB_pass = "";
$DB_name = "";

// Do not connect if not configured
if (empty($DB_host) || empty($DB_user) || empty($DB_name) || $INSTALL_REQUIRED) {
    // Installer will handle this
    return;
}
