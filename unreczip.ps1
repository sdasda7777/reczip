#If your 7-Zip is installed elsewhere, change the path below
Set-Alias 7zip "C:\Program Files\7-Zip\7z.exe"

$root = $args[0]

function UnzipFiles{
	param (
		$Path,
		$Pass,
		$Parent
	)

	$target = get-item $Path
	if ( $target.PSIsContainer )
	{	
		$filesinside = Get-ChildItem -Path $Path
		foreach ($file in $filesinside)
		{
			UnzipFiles -Path $file.FullName -Pass $Pass -Parent $Path
		}
	}
	else
	{
		if ( $Pass -like "" )
		{
			7zip e $Path -o"$Parent" | Out-Null
		}
		else
		{
			7zip e $Path -o"$Parent" -p"$Pass" | Out-Null
		}

		if ( $? -eq $True )
  		{
			#Comment the line below to stop automatic archive removal
			Remove-Item -Path $Path
		}
	}
}

if ( $root -like "" )
{
	$execname = $MyInvocation.MyCommand.Name;
	echo "Usage: $execname FileOrRootFolder [Password]";
	exit 1;
}

UnzipFiles -Path $root -Pass $args[1]