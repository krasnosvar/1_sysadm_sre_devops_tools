#background colour #038387

#check ssd
#https://tekcookie.com/ssd-health-with-powershell/
Get-PhysicalDisk -DeviceNumber 0 | Get-StorageReliabilityCounter | Select DeviceId, Temperature, Wear

#check battery
powercfg /batteryreport /output "C:\battery-report.html"

#check wsl version
wsl -l -v
