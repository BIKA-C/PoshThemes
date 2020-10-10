#requires -Version 2 -Modules posh-git

function Write-Theme {
    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    $admin = [char]::ConvertFromUtf32(128274)
    If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        $admin = [char]::ConvertFromUtf32(128275)
    }

    $promtSymbolColor = [ConsoleColor]::Green
    If ($lastCommandFailed) {
        $promtSymbolColor = [ConsoleColor]::Red
    }

    $user = $sl.CurrentUser
    $prompt += Write-Prompt  -Object ($admin +' '+$user)
    $prompt += Write-Prompt  -Object (' @ ') -ForegroundColor  $sl.Colors.WithForegroundColor
    #check the last command state and indicate if failed and change the colors of the arrows
    # If ($lastCommandFailed) {
    #     $prompt += Write-Prompt -Object (' '+$sl.PromptSymbols.PromptIndicator+'  ')  -ForegroundColor  $sl.Colors.WithForegroundColor   
    # }else{
    #     $prompt += Write-Prompt -Object (' '+$sl.PromptSymbols.PromptIndicator+'  ') -ForegroundColor  $sl.Colors.PromptSymbolColor  
    # }

    # $dir = Get-FullPath -dir $pwd
    # If ($lastCommandFailed) {
    #     $prompt += Write-Prompt -Object $dir -ForegroundColor $sl.Colors.WithForegroundColor
    # }
    # else {
    #     $prompt += Write-Prompt -Object $dir -ForegroundColor $sl.Colors.DriveForegroundColor
    # }

    # Writes the drive portion
    # $drive = $sl.PromptSymbols.HomeSymbol
    $drive = $sl.PromptSymbols.HomeSymbol + "Home"
    if ($pwd.Path -ne $HOME) 
    {
        $drive = "$(Split-Path -path $(Split-Path -path $pwd -Parent) -Leaf)"
        if ($drive -ne "$(Split-Path -path $pwd -Qualifier)\")
        {
            $drive += "\"
        }
        $drive += "$(Split-Path -path $pwd -Leaf)"
    }
    $prompt += Write-Prompt -Object $drive -ForegroundColor $sl.Colors.DriveForegroundColor

    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $info = "$($themeInfo.VcInfo)".Split(" ")[1].TrimStart()
        $prompt += Write-Prompt -Object " on " -ForegroundColor $sl.Colors.PromptForegroundColor
        $prompt += Write-Prompt -Object "$($sl.GitSymbols.BranchSymbol+' ')" -ForegroundColor $sl.Colors.GitDefaultColor
        $prompt += Write-Prompt -Object "$($status.Branch)" -ForegroundColor $sl.Colors.GitDefaultColor
        $prompt += Write-Prompt -Object " [$($info)]" -ForegroundColor $sl.Colors.PromptHighlightColor
        $filename = 'package.json'
        if (Test-Path -path $filename) {
            $prompt += Write-Prompt -Object (" via node") -ForegroundColor $sl.Colors.PromptSymbolColor
        }
    }

    if ($with) {
        $prompt += Write-Prompt -Object "$($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
    }

   
    $prompt += Set-Newline
    # $prompt += Write-Prompt -Object ($sl.PromptSymbols.PromptIndicator) -ForegroundColor  $sl.Colors.PromptSymbolColor  
    $prompt += Write-Prompt -Object ($sl.PromptSymbols.PromptIndicator) -ForegroundColor  $promtSymbolColor
    $prompt += ' '
    $prompt
}


$sl = $global:ThemeSettings #local settings
$sl.GitSymbols.BranchSymbol = [char]::ConvertFromUtf32(0xE0A0)
$sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(128293)
# $sl.PromptSymbols.PromptIndicator = [char]::ConvertFromUtf32(128204)
$sl.PromptSymbols.HomeSymbol = [char]::ConvertFromUtf32(127757)
$sl.PromptSymbols.GitDirtyIndicator = [char]::ConvertFromUtf32(10007)
$sl.Colors.PromptSymbolColor = [ConsoleColor]::Green
$sl.Colors.PromptHighlightColor = [ConsoleColor]::Blue
$sl.Colors.DriveForegroundColor = [ConsoleColor]::DarkCyan
$sl.Colors.WithForegroundColor = [ConsoleColor]::Red
$sl.Colors.GitDefaultColor = [ConsoleColor]::Yellow
$SL.Options.ConsoleTitle = $false