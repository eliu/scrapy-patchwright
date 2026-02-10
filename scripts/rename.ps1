Get-ChildItem -Path "..\src\scrapy_patchwright\*.py" -Recurse | ForEach-Object {
    Write-Output "Processing $_"
   $content = Get-Content -Path $_.FullName -Raw
   $content = $content -replace 'import playwright', 'import patchright'
   $content = $content -replace 'from playwright', 'from patchright'
   $content = $content -replace 'scrapy_playwright', 'scrapy_patchwright'
   $content = $content -replace 'scrapy-playwright', 'scrapy-patchwright'
   Set-Content -Path $_.FullName -Value $content
}