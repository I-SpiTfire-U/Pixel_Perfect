param ([String[]]$imagePaths)

Add-Type -AssemblyName "System.Drawing"

Function Get-LargestDimension([String] $path)
{
    $image = [System.Drawing.Image]::FromFile($path)
    return [Math]::Max($image.Width, $image.Height)
}

Function Add-ImageBorders([String] $path, [Int32] $size)
{
    [String] $fileName = [System.IO.Path]::GetFileNameWithoutExtension($path)
    [String] $extension = [System.IO.Path]::GetExtension($path)
    [String] $outputPath = "${fileName}_Bordered$extension"

    Write-Host "Adding borders to: ${fileName}$extension" -ForegroundColor Cyan
    magick.exe "$path" -resize "${size}x${size}" -gravity center -extent "${size}x${size}" "$outputPath"
    Write-Host "Bordered image saved to: $outputPath" -ForegroundColor Green
}

foreach ($imagePath in $imagePaths)
{
    [Int32] $imageSize = Get-LargestDimension -path $imagePath
    Add-ImageBorders -path $imagePath -size $imageSize
}