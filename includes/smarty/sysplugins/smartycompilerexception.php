<?php

/**
 * Smarty compiler exception class
 *
 * @package Smarty
 */
class SmartyCompilerException extends SmartyException
{
    /**
     * ✅ FIX: PHP 7.4+ compatibility - Override constructor to set line properly
     */
    public function __construct($message = "", $code = 0, Exception $previous = null, $line = 0)
    {
        parent::__construct($message, $code, $previous);
        // Set line using reflection to access protected property
        if ($line > 0) {
            $reflection = new ReflectionClass($this);
            $lineProperty = $reflection->getProperty('line');
            $lineProperty->setAccessible(true);
            $lineProperty->setValue($this, $line);
        }
    }

    public function __toString()
    {
        return ' --> Smarty Compiler: ' . $this->message . ' <-- ';
    }
    /**
     * The template source snippet relating to the error
     *
     * @type string|null
     */
    public $source = null;
    /**
     * The raw text of the error message
     *
     * @type string|null
     */
    public $desc = null;
    /**
     * The resource identifier or template name
     *
     * @type string|null
     */
    public $template = null;
}
