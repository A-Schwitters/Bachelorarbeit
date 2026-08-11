param(
    [Parameter(Mandatory = $true)]
    [string]$Document
)

$ErrorActionPreference = 'Continue'
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($Document)

# Einige noch nicht vorhandene Abbildungen lassen pdflatex mit Code 1 enden,
# obwohl eine PDF erzeugt wird. Die Folgeprozesse muessen trotzdem laufen:
# Erst sie fuellen Verzeichnisse, Literatur, Glossare und Gesamtseitenzahl.
& pdflatex -synctex=1 -interaction=nonstopmode -file-line-error $Document
& makeglossaries $baseName
& biber $baseName
& pdflatex -synctex=1 -interaction=nonstopmode -file-line-error $Document
& pdflatex -synctex=1 -interaction=nonstopmode -file-line-error $Document

if (Test-Path "$baseName.pdf") {
    exit 0
}

exit 1
