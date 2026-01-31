# WSA Installation Script
# Copies batch files to Android platform-tools and creates Start Menu shortcuts

# Define paths
$sourceDir = $PSScriptRoot
$installBat = Join-Path $sourceDir "install.bat"
$shareToWSABat = Join-Path $sourceDir "share to wsa.bat"
$platformToolsDir = Join-Path $env:LOCALAPPDATA "Android\sdk\platform-tools"
$startMenuPrograms = Join-Path $env:APPDATA "Microsoft\Windows\Start Menu\Programs"

# Ensure platform-tools directory exists
if (-not (Test-Path $platformToolsDir)) {
    Write-Host "Error: Android platform-tools directory not found at: $platformToolsDir" -ForegroundColor Red
    Write-Host "Please ensure Android SDK is installed." -ForegroundColor Yellow
    exit 1
}

# Copy batch files to platform-tools
Write-Host "Copying batch files to platform-tools..." -ForegroundColor Cyan
try {
    Copy-Item $installBat -Destination $platformToolsDir -Force
    Copy-Item $shareToWSABat -Destination $platformToolsDir -Force
    Write-Host "Batch files copied successfully." -ForegroundColor Green
} catch {
    Write-Host "Error copying batch files: $_" -ForegroundColor Red
    exit 1
}

# Create shortcuts in Start Menu
Write-Host "Creating Start Menu shortcuts..." -ForegroundColor Cyan

$WScriptShell = New-Object -ComObject WScript.Shell

# Create shortcut for install.bat
$installShortcut = $WScriptShell.CreateShortcut((Join-Path $startMenuPrograms "WSA Install.lnk"))
$installShortcut.TargetPath = Join-Path $platformToolsDir "install.bat"
$installShortcut.WorkingDirectory = $platformToolsDir
$installShortcut.Description = "Install to WSA"
# Set icon (you can change this to a custom .ico file path)
$installShortcut.IconLocation = "$env:SystemRoot\System32\SHELL32.dll,21"  # Installation icon
$installShortcut.Save()

# Create shortcut for share to wsa.bat
$shareShortcut = $WScriptShell.CreateShortcut((Join-Path $startMenuPrograms "Share to WSA.lnk"))
$shareShortcut.TargetPath = Join-Path $platformToolsDir "share to wsa.bat"
$shareShortcut.WorkingDirectory = $platformToolsDir
$shareShortcut.Description = "Share files to WSA"
# Set icon (you can change this to a custom .ico file path)
$shareShortcut.IconLocation = "$env:SystemRoot\System32\SHELL32.dll,28"  # Share/network icon
$shareShortcut.Save()

Write-Host "Shortcuts created successfully in Start Menu." -ForegroundColor Green
Write-Host "`nInstallation complete!" -ForegroundColor Green
Write-Host "You can now find 'WSA Install' and 'Share to WSA' in your Start Menu." -ForegroundColor Cyan
