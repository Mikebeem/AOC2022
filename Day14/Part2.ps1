$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=(Get-Date).Day
$Year=(Get-Date).Year

#Comment next line for run with input
$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)
$minX = 0
$maxX = 1000

$coordinateListX = @()
$coordinateListY = @()
foreach($coordinates in $puzzleInput){
    $coordinates.Replace(" -> ", " ").Split(" ")| ForEach-Object {
        $coordinateListX += $_.Split(",")[0]
        $coordinateListY += $_.Split(",")[1]
    }
}

$maxY = ($coordinateListY | Measure-Object -Maximum).Maximum

$height = $maxY+3
$width = ($maxX-$minX)+2
$grid = New-object -TypeName 'object[,]' -ArgumentList $height,$width
for($i=0;$i -lt $height; $i++){
    if($i -eq ($height-1)){
        for($j=0;$j -lt $width; $j++){
            $grid[$i,$j] = "#"
        }
    }
    else{
        for($j=0;$j -lt $width; $j++){
            $grid[$i,$j] = "."
        }
    }
}

$coordinates = $puzzleInput[0].Replace(" -> ", " ").Split(" ")
foreach($coordinates in $puzzleInput){
    $coordinate = $coordinates.Replace(" -> ", " ").Split(" ")
    for($coordinateIndex=0; $coordinateIndex -lt ($coordinate.Count-1); $coordinateIndex++){
        $fromX,$fromY = $coordinate[$coordinateIndex].Split(",")
        $toX, $toY = $coordinate[$coordinateIndex+1].Split(",")

        #reset to grid index
        $fromX -= $minX
        $toX -= $minX

        if($fromX - $toX -ne 0){
            foreach($x in $fromX..$toX){
                $grid[$fromY,$x] = "#"
            }
        }
        if($fromY - $toY -ne 0){
            foreach($y in $fromY..$toY){
                $grid[$y,$fromX] = "#"
            }
        }
    }
}
$grid[0,(500-$minX)] = "+"
$stop=$false
$unitCount=0
while($stop -eq $false){
    $unitCount++
    $unitX = (500-$minX)
    $unitY = 0
    $rest=$false

    while($rest -eq $false){
        $moved=$false
        if($grid[($unitY+1),($unitX)] -eq "."){
            #zolang er lucht is, blijf naar beneden vallen
            $unitY++
            #write-host "We vallen $unitY - $unitX"
            $moved=$true
        }
        elseif($grid[($unitY+1),($unitX)] -in ("#","o")){
            #Als er zand of steen is, eerst naar links onder kijken
            #Write-Host "Zand of steen bereikt $unitY - $unitX"
            if($grid[($unitY+1),($unitX-1)] -eq "."){ # -and $grid[($unitY),($unitX-1)] -eq "."
                $unitY++
                $unitX--
                #write-host "We kijken linksonder $unitY - $unitX"
                $moved=$true
            }
            #Anders rechtsonder kijken
            elseif($grid[($unitY+1),($unitX+1)] -eq ".") { # -and $grid[($unitY),($unitX+1)] -eq "."
                $unitY++
                $unitX++
                #write-host "We kijken rechtsonder $unitY - $unitX"
                $moved=$true
            }
        }
        if($moved -eq $false -and $unitY -eq 0){
            Write-Host ("Blokking Source {0}" -f ($unitCount))
            $rest=$true
            $stop=$true
        }
        if($unitX -lt 0 -or $unitX -eq ($width-1)){
            #Write-Host "Flow out of the bottom!"
            $rest=$true
            $stop=$true
        }
        if($moved -eq $false){
            $grid[$unitY,$unitX] = "o"
            $rest = $true
        }
        #write-host "Einde while, doorgaan $unitY - $unitX - $rest"
    }
}
$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)