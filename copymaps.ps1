# Define source and destination folders
$SourceFolder = "out\maps_with_npcs\grayscale"
$DestinationFolder = "C:\Users\Mike\Downloads\poptracker_0-32-1_win64\poptracker\packs\rb_tracker_debug\images\maps\maps_with_npcs\grayscale"

# Path to the text file containing filenames (one per line)
$FileList = "relevantmaps.txt"

# Read the list of filenames
$FilesToCopy = Get-Content $FileList

# Make sure the destination folder exists
if (!(Test-Path -Path $DestinationFolder)) {
    New-Item -ItemType Directory -Path $DestinationFolder | Out-Null
}

foreach ($File in $FilesToCopy) {
    $SourceFile = Join-Path $SourceFolder $File
    if (Test-Path $SourceFile) {
        $LowercaseName = $File.ToLower()
        $DestinationFile = Join-Path $DestinationFolder $LowercaseName
        Copy-Item $SourceFile -Destination $DestinationFile -Force
        Write-Host "Copied as lowercase: $DestinationFile"
    }
    else {
        Write-Host "File not found: $File"
    }
}
