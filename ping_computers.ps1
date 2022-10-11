# SystemIPs.txt file incluedes computer IP address or system names 
# 192.168.30.31
# DC01
# DnsServ
# WebServ
# Abdurrahim-PC
# ...

# clear the screen
Clear 
$Systems = Get-Content “SystemIPs.txt”
# To convert Hard Disk info to GB
$ConvertToGB = (1024 * 1024 * 1024)  
foreach ($sys in $Systems)
{
if ( Test-Connection $sys -Count 1 -ErrorAction SilentlyContinue )
    {    
        $FreeMemory=(systeminfo /S $sys  | Select-String ‘Available Physical Memory:’).ToString().Split(‘:’)[1].Trim()
        $SystemName=(systeminfo /S $sys  | Select-String ‘OS Name:’).ToString().Split(‘:’)[1].Trim()
        $SystemBootTime=[datetime]::ParseExact($(systeminfo /S $sys | find “System Boot Time:”).substring(27,20),”dd/MM/yyyy, HH:mm:ss”,$null)
        $Disk = Get-WmiObject Win32_LogicalDisk -ComputerName $sys -Filter “DeviceID=’C:'” | Select-Object Size,FreeSpace
        $Disk= “{0:N1}” -f ($Disk.Size / $ConvertToGB) + “gb”
        Write-Host $sys “Sistem OK “, $SystemName ,”FreeRam:” $FreeMemory, “C: FreeDisk”  $Disk, “BootTime:” $SystemBootTime  -ForegroundColor DarkGreen
    }
else
    {
        Write-Host “There is Problem ???” $sys -ForegroundColor DarkRed
    }
}
