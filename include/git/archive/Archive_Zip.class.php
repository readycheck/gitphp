<?php
/**
 * Zip archive creation class
 *
 * @author Christopher Han <xiphux@gmail.com>
 * @copyright Copyright (c) 2012 Christopher Han
 * @package GitPHP
 * @subpackage Git\Archive
 */
class GitPHP_Archive_Zip implements GitPHP_ArchiveStrategy_Interface
{
	/**
	 * Executable
	 *
	 * @var GitPHP_GitExe
	 */
	protected $exe;

	/**
	 * Process handle
	 *
	 * @var resource
	 */
	protected $handle;

	/**
	 * Compression level
	 *
	 * @var integer
	 */
	protected $compressLevel;

	/**
	 * Constructor
	 *
	 * @param integer $compressLevel compression level
	 */
	public function __construct($compressLevel = null)
	{
		if (!(($compressLevel === null) || (is_int($compressLevel) && ($compressLevel >= 1) && ($compressLevel <= 9))))
			throw new Exception('Invalid compression level');

		$this->compressLevel = $compressLevel;
	}

	/**
	 * Set executable for this archive
	 *
	 * @param GitPHP_GitExe $exe git exe
	 */
	public function SetExe($exe)
	{
		$this->exe = $exe;
	}

	/**
	 * Open a descriptor for this archive
	 *
	 * @param GitPHP_Archive $archive archive
	 * @return boolean true on success
	 */
	public function Open($archive)
	{
		if (!$archive)
			return false;

		if ($this->handle) {
			return true;
		}

		$args = array();
		$args[] = '--format=zip';
		if ($this->compressLevel)
			$args[] = '-' . $this->compressLevel;
		$args[] = "--prefix='" . $archive->GetPrefix() . "'";
		$args[] = $archive->GetObject()->GetHash();

		$this->handle = $this->exe->Open($archive->GetProject()->GetPath(), GIT_ARCHIVE, $args);

		return ($this->handle !== false);
	}

	/**
	 * Read a chunk of the archive data
	 *
	 * @param int $size size of data to read
	 * @return string|boolean archive data or false
	 */
	public function Read($size = 1048576)
	{
		if (!$this->handle)
			return false;

		if (feof($this->handle))
			return false;

		return fread($this->handle, $size);
	}

	/**
	 * Close archive descriptor
	 */
	public function Close()
	{
		if (!$this->handle)
			return true;

		pclose($this->handle);

		$this->handle = null;

		return true;
	}

	/**
	 * Gets the file extension for this format
	 *
	 * @return string extension
	 */
	public function Extension()
	{
		return 'zip';
	}

	/**
	 * Gets the mime type for this format
	 *
	 * @return string mime type
	 */
	public function MimeType()
	{
		return 'application/x-zip';
	}

	/**
	 * Gets whether this archiver is valid
	 *
	 * @return boolean true if valid
	 */
	public function Valid()
	{
		// TODO check for git > 1.4.3 for zip
		return true;
	}
}
