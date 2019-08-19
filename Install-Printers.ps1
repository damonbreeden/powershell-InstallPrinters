<#
.SYNOPSIS
    This function installs a print driver and a printer
.PARAMETER 
    
.EXAMPLE
    Install-Printer
.NOTES
    Author: Damon Breeden
    Github: https://github.com/damonbreeden
#>

[CmdletBinding()]
param (
    # path to folder with inf files
    [string]$driverPath = "\\VBOXSVR\vagrant\upd-pcl5-x64-6.1.0.20062",
    # the name of the printer driver
    [string]$driverName = "HP Universal Printing PCL 5",
    #the name of the printer when it's installed
    [string]$printerName = "Platform",
    #the ip address or hostname of the print server
    [string]$printerPort = "127.0.0.1",
    # the name of the print server, this can be a friendly name or the IP address
    [string]$portName = "printServer"
)

#Install the print drivers in the driver store
$infFiles = Get-ChildItem -LiteralPath $driverPath -Filter "*.inf" -Recurse
foreach ($i in $infFiles) {
    Unblock-File $i.FullName
    pnputil -i -a $i.FullName
}
Add-PrinterDriver -Name $driverName
#get a unique printer port name
$i = 0
$basePortName = $portName
while ([bool](Get-PrinterPort $portName -ErrorAction SilentlyContinue)) {
    $i++
    $portName = "$basePortName`_$i"
}
Write-Host $portName
Add-PrinterPort -Name $portname -PrinterHostAddress $printerPort
#get a unique printer name
$i = 0
$basePrinterName = $printerName
while ([bool](Get-Printer -Name $printerName -ErrorAction SilentlyContinue)) {
    $i++
    $printerName = "$basePrinterName`_$i"
}
Add-Printer -Name $printerName -DriverName $driverName -PortName $portName
    