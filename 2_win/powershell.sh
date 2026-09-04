#background colour #038387

#check ssd
#https://tekcookie.com/ssd-health-with-powershell/
Get-PhysicalDisk -DeviceNumber 0 | Get-StorageReliabilityCounter | Select DeviceId, Temperature, Wear

#list disks before selecting a DeviceNumber
Get-PhysicalDisk | Format-Table DeviceId, FriendlyName, MediaType, BusType, HealthStatus, OperationalStatus, Size

#show useful SSD/HDD reliability counters for all devices
#Wear is device-reported consumed wear; 100 means the estimated limit is reached.
#A field can be empty when the controller does not expose it to Windows.
Get-PhysicalDisk | Get-StorageReliabilityCounter | Select DeviceId, Temperature, TemperatureMax, Wear, PowerOnHours, ReadErrorsUncorrected, WriteErrorsUncorrected

#show every counter reported by one device; unsupported fields can be empty
Get-PhysicalDisk -DeviceNumber 0 | Get-StorageReliabilityCounter | Format-List *
#https://learn.microsoft.com/powershell/module/storage/get-storagereliabilitycounter

#check battery
powercfg /batteryreport /output "C:\battery-report.html"

#check wsl version
wsl -l -v
