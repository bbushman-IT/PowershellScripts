$sourcePaths = @(
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Excel.lnk",
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OneNote.lnk",
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PowerPoint.lnk",
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Word.lnk"
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Outlook (Classic).lnk"
    "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk"
)

$destination = [System.IO.Path]::Combine($env:USERPROFILE, "Desktop")

foreach ($file in $sourcePaths) {
    Copy-Item -Path $file -Destination $destination -Force
}

