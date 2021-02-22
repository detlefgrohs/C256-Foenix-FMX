$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Set-Location $scriptDir

function Assemble-Project() {
    param($project)

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

    if ($success) { Write-Host -ForegroundColor Green "Success!" }
    else          { Write-Host -ForegroundColor Red "Failure!" }

    # if ((hostname) -eq "My64Bot") {
    #     Copy-Item "$project\bin\$project.pgx" "F:\"
    # }

    # python C256Mgr\c256mgr.py --send Heap\bin\heap.hex
}

Write-Host -ForegroundColor Yellow "============================================================================"

Assemble-Project "Heap"

Write-Host -ForegroundColor Yellow "============================================================================"
