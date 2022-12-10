#Change if you run this on another day
$day=(Get-Date).Day
$Year=(Get-Date).Year

if(Test-Path ./env.ps1){
    . ./env.ps1
    $session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $cookie = [System.Net.Cookie]::new('session', $sessionToken)
    $session.Cookies.Add('https://adventofcode.com/', $cookie)

    $puzzleInput = ((Invoke-WebRequest -Uri ("https://adventofcode.com/{0}/day/{1}/input" -f $Year, $day) -WebSession $session -UseBasicParsing).Content -split "`n")
}
#Comment next line for run with input
#$puzzleInput  = Get-Content ./Day$day/sample.txt
#$puzzleInput  = Get-Content ./Day$day/sampleSmall.txt
$X=1
$cycles=1
$signalStrength = @{
    $cycles = $cycles*$X
}
foreach($instruction in $puzzleInput){
    #$instruction
    if($instruction[0] -eq "n"){
        #noob does nothing, takes 1 cycle to complete
        $cycles++
        $signalStrength += @{
            $cycles = $cycles*$X
        }
    }
    else{
        #addx, takes 2 cycles to complete, after de second cycle, in/decreases X
        $increaseBy = $instruction.Split(" ")[1]
                
        for($i=1;$i -le 2; $i++){
            $cycles++
            if($i -eq 2){
                $X+=$increaseBy
            }
            $signalStrength += @{
                $cycles = $cycles*$X
            }
        }
    }
}

$signalStrength[20] + $signalStrength[60] + $signalStrength[100] + $signalStrength[140]+ $signalStrength[180]+$signalStrength[220]