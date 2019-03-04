Start-process \\fred\Data2\INSTALL\SparkDeploymentKit\spark_2_8_3.exe -ArgumentList "-q" -verb RunAs -wait
If (-NOT(Test-path $env:APPDATA\spark)){
Write-Host "oops no folder, making one now"
New-Item -ItemType Directory -Path $env:APPDATA\spark
}
get-childitem \\fred\Data2\INSTALL\SparkDeploymentKit\Settings -Recurse | Copy-Item -Destination $env:APPDATA\spark -Force
