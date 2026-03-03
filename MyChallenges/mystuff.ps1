# Task 1
Get-ADUser -Filter * -Properties * |  Select-Object Name, @{n="NameLength"; e={$_.name.length}} | sort NameLength -Descending | select -Last 10

# Task 2
Get-ADUser -Filter * -Properties * | select lastlogon @{n="lastlogon"; e={