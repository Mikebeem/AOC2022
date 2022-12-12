#Change if you run this on another day
$day=(Get-Date).Day
$Year=(Get-Date).Year

# if(Test-Path ./env.ps1){
#     . ./env.ps1
#     $session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
#     $cookie = [System.Net.Cookie]::new('session', $sessionToken)
#     $session.Cookies.Add('https://adventofcode.com/', $cookie)

#     $puzzleInput = ((Invoke-WebRequest -Uri ("https://adventofcode.com/{0}/day/{1}/input" -f $Year, $day) -UseBasicParsing -WebSession $session).Content -split "`n")
# }
#Comment next line for run with input
#$puzzleInput  = Get-Content ./Day$day/sample.txt
$puzzleInput  = Get-Content ./Day$day/input.txt
$q = New-Object System.Collections.Queue

$width = $puzzleInput[0].Length
$height = $puzzleInput.Count
for($y=0;$y -lt $height; $y++){
    for($x=0;$x -lt $width; $x++){
        if($puzzleInput[$y][$x].ToString() -ceq "S" -or $puzzleInput[$y][$x].ToString() -ceq "a"){
            #$start = 
            $q.Enqueue("$x,$y,0")
            $seen = @{"$x,$y" = 1}
        }
        if($puzzleInput[$y][$x].ToString() -ceq "E"){
            $end = "$x,$y"
        }
    }
}

function checkToQueue ([int]$x, [int]$y, [char]$altitude){
    if([char]$puzzleInput[$y][$x] -ceq "S"){
        $thisAltitude = [char]"a"
    } elseif([char]$puzzleInput[$y][$x] -ceq "E"){
        $thisAltitude = [char]"z"
    } else{
        $thisAltitude = [char]$puzzleInput[$y][$x]
    }
    
    if($seen.ContainsKey("$x,$y")){
        return $false
    }
    elseif(($thisAltitude - $altitude) -le 1){
        $seen["$x,$y"] = 1
        return $true
    }
    else{
        return $false
    }
}

# $grid = New-object -TypeName 'object[,]' -ArgumentList $height,$width
# for($i=0;$i -lt $height; $i++){
#     for($j=0;$j -lt $width; $j++){
#         $grid[$i,$j] = "."
#     }
# }

while ($q.Count -gt 0) {
    $item = $q.Dequeue()

    [int]$x, [int]$y, [int]$dist = $item -split ","
    # $grid[$y,$x] = [string]($puzzleInput[$y][$x]).ToString()
    if([char]$puzzleInput[$y][$x] -ceq "S"){
        $altitude = [char]"a"
    } elseif([char]$puzzleInput[$y][$x] -ceq "E"){
        $altitude = [char]"z"
        Write-host "The end! $dist"
        break
    } else{
        $altitude = [char]$puzzleInput[$y][$x]
    }
    
    $newdist = ($dist+1)
    switch ($x) {
        0 { 
            if(checkToQueue ($x+1) $y $altitude) {
                $q.Enqueue("$($x+1),$y,$newdist")
            } 
        }
        ($width-1) { if(checkToQueue ($x-1) $y $altitude) {$q.Enqueue("$($x-1),$y,$newdist")}  }
        Default {
            if(checkToQueue ($x+1) $y $altitude) {$q.Enqueue("$($x+1),$y,$newdist")}
            if(checkToQueue ($x-1) $y $altitude) {$q.Enqueue("$($x-1),$y,$newdist")}
        }
    }
    switch ($y) {
        0 { if(checkToQueue $x ($y+1) $altitude) {$q.Enqueue("$x,$($y+1),$newdist")} }
        ($height-1) { if(checkToQueue $x ($y-1) $altitude) {$q.Enqueue("$x,$($y-1),$newdist")}  }
        Default {
            if(checkToQueue $x ($y+1) $altitude) {$q.Enqueue("$x,$($y+1),$newdist")}
            if(checkToQueue $x ($y-1) $altitude) {$q.Enqueue("$x,$($y-1),$newdist")}
        }
    }
}

# "Oops, queueu is empty! Checked $($seen.Count) out of $($height*$width)"

# for($i=0;$i -lt $height; $i++){
#     $line = ""
#     for($j=0;$j -lt $width; $j++){
#         $line += $grid[$i,$j]
#     }
#     write-host $line
# }
