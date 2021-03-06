﻿$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $scriptDir

function Assemble-Project() {
    param($project)

    'Version .NULL "HeapManager ' + [System.DateTime]::Now.ToString("yyyyMMdd-hhmmss") + '", 13' | Set-Content ".\$project\Version.asm"

    # Write-Host -ForegroundColor Green "Compiling $project to PGX..."

    # $arguments = @();
    # $arguments += "--long-address";
    # $arguments += "--flat";
    # $arguments += "-b";
    # $arguments += "--m65816";
    # $arguments += "-o$project\bin\$project.pgx";
    # $arguments += "--list=$project\bin\$project.lst";
    # $arguments += "--labels=$project\bin\$project.lbl";
    # $arguments += ".\$project\$project.asm";
    # $success = $true

    # (& ".\64tass.exe" $arguments *>&1) | ForEach-Object {
    #     "   $($_)"
    #     if ($_ -match "Error messages: (.*)") {
    #         if ($Matches[1].Trim() -ne "None") { $success = $false }
    #     }
    # }

    # if ($success) {
        Write-Host -ForegroundColor Green "Compiling $project to HEX..."

        $arguments = @();
        $arguments += "--long-address";
        $arguments += "--flat";
        $arguments += "-b";
        $arguments += "--m65816";
        $arguments += "--intel-hex";
        $arguments += "-o$project\bin\$project.hex";
        $arguments += "--list=$project\bin\$project.lst";
        $arguments += "--labels=$project\bin\$project.lbl";
        $arguments += ".\$project\$project.asm";
        $success = $true
    
        (& ".\64tass.exe" $arguments *>&1) | ForEach-Object {
            "   $($_)"
            if ($_ -match "Error messages: (.*)") {
                if ($Matches[1].Trim() -ne "None") { $success = $false }
            }
        }
    # }


    if (((hostname) -eq "My64Bot") -and $success) {
        # Copy-Item "$project\bin\$project.pgx" "F:\"
        Write-Host -ForegroundColor Green "Sending to C256 Foenix FMX"
        python C256Mgr\c256mgr.py --port COM3 --send Heap\bin\heap.hex
    }
    
    if ($success) { 
        Write-Host -ForegroundColor Green "Success!" 
        & 'C:\Program Files\blink1-tool.exe' --rgb=#00ff00 --blink 4
    } else { 
        Write-Host -ForegroundColor Red "Failure!" 
        & 'C:\Program Files\blink1-tool.exe' --rgb=#FF0000 --blink 4
    }
}

Write-Host -ForegroundColor Yellow "============================================================================"

Assemble-Project "Heap"

Write-Host -ForegroundColor Yellow "============================================================================"
