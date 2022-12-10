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

$grid = New-object -TypeName 'object[,]' -ArgumentList 7,40

$X=1
$cycles=0
$row=0
$position=0
foreach($instruction in $puzzleInput){
    #$instruction
    if($instruction[0] -eq "n"){
        #noob does nothing, takes 1 cycle to complete
        #Draw
        $pixel="."
        if($position -ge ($X-1) -and $position -le ($X+1)){
            $pixel="#"
        }
        
        $grid[$row,$position] = $pixel
        $cycles++
        if($cycles%40 -eq 0){
            $row++
            $position=0
        }else{
            $position++
        }
    }
    else{
        #addx, takes 2 cycles to complete, after de second cycle, in/decreases X
        $increaseBy = $instruction.Split(" ")[1]
                
        for($i=1;$i -le 2; $i++){
            #Draw
            $pixel="."
            if($position -ge ($X-1) -and $position -le ($X+1)){
                $pixel="#"
            }
            $grid[$row,$position] = $pixel
            $cycles++
            if($cycles%40 -eq 0){
                $row++
                $position=0
            } else{
                $position++
            }
            if($i -eq 2){
                $X+=$increaseBy
            }

        }
    }
}
for($i=0;$i -lt $height; $i++){
    $line = ""
    for($j=0;$j -lt $size; $j++){
        $line += $grid[$i,$j]
    }
    write-host $line
}