#If your 7-Zip is installed elsewhere, change the path below
Set-Alias 7zip "C:\Program Files\7-Zip\7z.exe"

$root = $args[0]

function ZipFiles{
	param (
		$Path,
		$Pass
	)

	$target = get-item $Path
	if ( $target.PSIsContainer )
	{	
		$filesinside = Get-ChildItem -Path $Path
		foreach ($file in $filesinside)
		{
			ZipFiles -Path $file.FullName -Pass $Pass
		}
	}
	else
	{
		if ( $Pass -like "" )
		{
			7zip a "$Path.7z" $Path | Out-Null
		}
		else
		{
			7zip a "$Path.7z" $Path -p"$Pass" | Out-Null
		}

		#The line below is what you want to comment (add a # before it) to make the files not delete automatically
		Remove-Item -Path $Path
	}
}

if ( $root -like "" )
{
	$execname = $MyInvocation.MyCommand.Name;
	echo "Usage: $execname FileOrRootFolder [Password]";
	exit 1;
}

ZipFiles -Path $root -Pass $args[1]