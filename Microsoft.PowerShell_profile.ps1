function prompt {
    $arrow = [char]0x2192  # Unicode right arrow character
    $currentDirectory = (Get-Location).Path | Split-Path -Leaf

    $gitBranch = ""
    $gitDirectory = (Get-Command git -ErrorAction SilentlyContinue).Path
    if ($gitDirectory) {
        $gitStatus = & git rev-parse --is-inside-work-tree 2>$null
        if ($gitStatus -eq 'true') {
            $gitBranch = & git symbolic-ref --short HEAD 2>$null
        }
    }

    $arrowColor = 'Green'
    $directoryColor = 'Cyan'
    $gitLabelColor = 'Blue'
    $gitBranchColor = 'Red'

    Write-Host -NoNewline "$arrow " -ForegroundColor $arrowColor
    Write-Host -NoNewline "$currentDirectory" -ForegroundColor $directoryColor
    if ($gitBranch) {
        Write-Host -NoNewline " git:(" -ForegroundColor $gitLabelColor
        Write-Host -NoNewline "$gitBranch" -ForegroundColor $gitBranchColor
        Write-Host -NoNewline ")" -ForegroundColor $gitLabelColor
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
