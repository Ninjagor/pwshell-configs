
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -Chord Tab -Function Complete
Set-PSReadLineKeyHandler -Chord Ctrl-r -Function ReverseSearchHistory -ViMode Insert
Set-PSReadLineKeyHandler -Chord Ctrl-r -Function ReverseSearchHistory -ViMode Command

function prompt {
    $arrow = [char]0x2192  # Unicode right arrow character
    $currentDirectory = (Get-Location).Path | Split-Path -Leaf

    $gitBranch = ""
    $gitDirectory = (Get-Command git -ErrorAction SilentlyContinue).Path
    $gitChanges = $null

    if ($gitDirectory) {
        $gitStatus = & git rev-parse --is-inside-work-tree 2>$null
        if ($gitStatus -eq 'true') {
            $gitBranch = & git symbolic-ref --short HEAD 2>$null
            $gitChanges = & git status --short 2>$null
        }
    }

    $arrowColor = 'Green'
    $directoryColor = 'Cyan'
    $gitLabelColor = 'Blue'
    $gitBranchColor = 'Red'
    $changesColor = 'Yellow'

    $xicon = [char]0x2718  # Unicode character for X

    Write-Host -NoNewline "$arrow " -ForegroundColor $arrowColor
    Write-Host -NoNewline "$currentDirectory" -ForegroundColor $directoryColor
    if ($gitBranch) {
        Write-Host -NoNewline " git:(" -ForegroundColor $gitLabelColor
        Write-Host -NoNewline "$gitBranch" -ForegroundColor $gitBranchColor

        if ($gitChanges) {
            Write-Host -NoNewline ")" -ForegroundColor $gitLabelColor
            Write-Host -NoNewline " " -ForegroundColor $changesColor
            Write-Host -NoNewline "$xicon" -ForegroundColor $changesColor
        } else {
            Write-Host -NoNewline ")" -ForegroundColor $gitLabelColor
        }
    }

    return ' '  # Prevents "PS>"
}


function touch {
    param(
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -ItemType File
    } else {
        (Get-Item $Path).LastWriteTime = Get-Date
    }
}
