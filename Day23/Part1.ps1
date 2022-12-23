$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=23

#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)

$elves=[System.Collections.ArrayList]@()
for($y=0; $y -lt $puzzleInput.Count; $y++){
    for ($x = 0; $x -lt $puzzleInput[0].Length; $x++) {
        if($puzzleInput[$y][$x] -eq "#"){
            $elves.Add("$x,$y") | Out-Null
        }
    }
}

$directions = [System.Collections.ArrayList]@("N","S","W","E")
$round=0
$stop = $false
while($stop -eq $false){
    $round++
    $proposals = @{}
    foreach($elf in $elves){
        #Start proposal with current, then look to every direction to change it
        $proposals[$elf] = $elf
        [int]$x, [int]$y = $elf.Split(",")
        $free = @()
        foreach($direction in $directions){
            switch ($direction) {
                "N" {
                    $look = ("{1},{0}:{2},{0}:{3},{0}" -f ($y-1),($x-1),$x,($x+1)).Split(":")
                    if($elves.IndexOf($look[0]) -eq -1 -and $elves.IndexOf($look[1]) -eq -1 -and $elves.IndexOf($look[2]) -eq -1){
                        #Found north, next elve
                        $free += $direction
                    }
                }
                "S" {
                    $look = ("{1},{0}:{2},{0}:{3},{0}" -f ($y+1),($x-1),$x,($x+1)).Split(":")
                    if($elves.IndexOf($look[0]) -eq -1 -and $elves.IndexOf($look[1]) -eq -1 -and $elves.IndexOf($look[2]) -eq -1){
                        #Found south, next elve
                        $free += $direction
                    }
                 }
                "W" {
                    $look = ("{0},{1}:{0},{2}:{0},{3}" -f ($x-1),($y-1),$y,($y+1)).Split(":")
                    if($elves.IndexOf($look[0]) -eq -1 -and $elves.IndexOf($look[1]) -eq -1 -and $elves.IndexOf($look[2]) -eq -1){
                        #Found west, next elve
                        $free += $direction
                    }
                 }
                "E" {
                    $look = ("{0},{1}:{0},{2}:{0},{3}" -f ($x+1),($y-1),$y,$($y+1)).Split(":")
                    if($elves.IndexOf($look[0]) -eq -1 -and $elves.IndexOf($look[1]) -eq -1 -and $elves.IndexOf($look[2]) -eq -1){
                        #Found east, next elve
                        $free += $direction
                    }
                 }
            }

        }
        if($free.Count -gt 0 -and $free.Count -lt 4){
            $direction = $free[0]
            switch ($direction) {
                "N" { $proposals["$x,$y"] = ("{0},{1}" -f $x,($y-1)) }
                "S" { $proposals["$x,$y"] = ("{0},{1}" -f $x,($y+1)) }
                "W" { $proposals["$x,$y"] = ("{0},{1}" -f ($x-1),$y) }
                "E" { $proposals["$x,$y"] = ("{0},{1}" -f ($x+1),$y) }
            }
        }
    }

    # Look for double proposals
    $doubles = $proposals.GetEnumerator() | Group-Object Value | Where-Object { $_.Count -gt 1 }
    if($null -ne $doubles){
        $doubles.Group | ForEach-Object {
            $proposals[$_.Name] = $_.Name
        }
    }
    # Repopulate $elves
    $elves=[System.Collections.ArrayList]@()
    foreach($elf in $proposals.Values){
        $elves.Add($elf) | Out-Null
    }

    #switch directions for next round
    $toEnd = $directions[0]
    $directions.RemoveAt(0)
    $directions.Add($toEnd) | Out-Null

    if($round -eq 10){
        $stop = $true
    }
}

$minY=$minX=$maxY=$maxX=0
foreach($elf in $elves){
    [int]$x,[int]$y = $elf.Split(",")
    if($x -lt $minX){ $minX = $x}
    if($x -gt $maxX){ $maxX = $x}
    if($y -lt $minY){ $minY = $y}
    if($y -gt $maxY){ $maxY = $y}
}
$height = $maxY-$minY
$width = $maxX-$minX

for($y=$minY;$y -lt $height; $y++){
    $line = ""
    for($x=$minX;$x -lt $width; $x++){
        if($elves.IndexOf("$x,$y") -ge 0){
            $line += "#"
        }
        else{
            $line += "."
        }
    }
    write-host $line
}
(($width+1) * ($height+1)) - $elves.Count

$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
