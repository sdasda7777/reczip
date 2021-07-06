<#
.SYNOPSIS
Recursively goes through given folders and archives every file individually using 7-Zip using supplied password
#>

Param(
    [string]$Pass = "",
	[string[]]$Paths
)

#If your 7-Zip is installed elsewhere, change the path below
Set-Alias 7zip "C:\Program Files\7-Zip\7z.exe"

function ZipFiles{
	param (
		$Path,
		$Pass
	)

	$target = Get-Item $Path
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
		
		if( $? -eq $True )
		{
			#The line below is what you want to comment (add a # before it) to make the files not delete automatically
			Remove-Item -Path $Path
		}
	}
}

if ( $Paths.Length -eq 0 )
{
	$execname = $MyInvocation.MyCommand.Name;
	echo "Usage: $execname [-Pass Password] -Paths FileOrRootFolder[, FileOrRootFolder2...]";
	exit 1;
}

ForEach ($Path in $Paths)
{ 
	ZipFiles -Path $Path -Pass $Pass
}