
function Set-SymbolicLink ($target, $link) {
    <#
    .SYNOPSIS
        Create a symbolic link
    .EXAMPLE
        Set-SymbolicLink E:\my\file\is.here B:\my\link\is.there
    #>
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

function Get-PromptPath {
    $settings = $global:GitPromptSettings
    $abbrevHomeDir = $settings -and $settings.DefaultPromptAbbreviateHomeDirectory

    # A UNC path has no drive so it's better to use the ProviderPath e.g. "\\server\share".
    # However for any path with a drive defined, it's better to use the Path property.
    # In this case, ProviderPath is "\LocalMachine\My"" whereas Path is "Cert:\LocalMachine\My".
    # The latter is more desirable.
    $pathInfo = $ExecutionContext.SessionState.Path.CurrentLocation
    $currentPath = if ($pathInfo.Drive) { $pathInfo.Path } else { $pathInfo.ProviderPath }

    $stringComparison = Get-PathStringComparison

    # Abbreviate path by replacing beginning of path with ~ *iff* the path is under the user's home dir
    if ($abbrevHomeDir -and $currentPath -and !$currentPath.Equals($Home, $stringComparison) -and
        $currentPath.StartsWith($Home, $stringComparison)) {

        $currentPath = "~" + $currentPath.SubString($Home.Length)
    }

    return $currentPath
}

function mpv-yta ($search) {
    mpv --ytdl-format=bestaudio ytdl://ytsearch:"$search"
}


function Set-MyPSReadLineOptions {
    Set-PSReadlineOption -BellStyle None
    Set-PSReadlineOption -EditMode Emacs
    Set-PSReadlineKeyHandler -Chord UpArrow -Function HistorySearchBackward
    Set-PSReadlineKeyHandler -Chord DownArrow -Function HistorySearchForward
    Set-PSReadlineKeyHandler -Chord Ctrl+LeftArrow -Function ShellBackwardWord
    Set-PSReadlineKeyHandler -Chord Ctrl+RightArrow -Function ShellForwardWord
}

$hosts = @(
    'Visual Studio Code Host',
    'ConsoleHost'
)

if ($hosts.Contains($host.Name)) {
    Import-Module PSReadLine
    Import-Module posh-git
    Set-MyPSReadLineOptions
    $GitPromptSettings.DefaultPromptAbbreviateHomeDirectory = $true
}

