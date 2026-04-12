$protocPath = "C:\Users\USER\protoc\bin\protoc.exe"
$projectRoot = $PSScriptRoot
$protoPath = Join-Path $projectRoot "lib\protos"
$outputPath = Join-Path $projectRoot "lib\protos"

# Create output directory if it doesn't exist
if (-not (Test-Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath
}

# Run protoc with absolute paths
& $protocPath --dart_out=grpc:$outputPath --proto_path=$protoPath "$protoPath\passenger.proto"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Proto files compiled successfully" -ForegroundColor Green
} else {
    Write-Host "Failed to compile proto files" -ForegroundColor Red
}