<?php
/**
 * Front Controller - Entry point for the application
 * Routes to the main index page
 */

// Ensure errors are visible during development
error_reporting(E_ALL);
ini_set('display_errors', '1');

$mainPage = __DIR__ . '/views/comunes/index.php';

if (!file_exists($mainPage)) {
    http_response_code(500);
    die('Error: Main page not found at: ' . $mainPage);
}

require $mainPage;
