$characters = Invoke-RestMethod -Uri "https://thronesapi.com/api/v2/Characters"
 
$characters | Select-Object fullName, title, family
 