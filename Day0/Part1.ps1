#Change if you run this on another day
$day=(Get-Date).Day
$Year=(Get-Date).Year

if(Test-Path ./env.ps1){
    . ./env.ps1
    $session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $cookie = [System.Net.Cookie]::new('session', $sessionToken)
    $session.Cookies.Add('https://adventofcode.com/', $cookie)

    $puzzleInput = ((Invoke-WebRequest -Uri ("https://adventofcode.com/{0}/day/{1}/input" -f $Year, $day) -WebSession $session).Content -split "`n")
}
#Comment next line for run with input
$puzzleInput  = Get-Content ./Day$day/sample.txt