$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=17

#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)

<#

####

.#.
###
.#.

..#
..#
###

#
#
#
#

##
##

#>

$shapes = [System.Collections.ArrayList]::new()
# "-"
$shapes.Add(@(@(2,0),@(3,0),@(4,0),@(5,0))) | Out-Null
# "+"
$shapes.Add(@(@(2,1),@(3,0),@(3,2),@(3,1),@(4,1))) | Out-Null
# "J"
$shapes.Add(@(@(2,0),@(3,0),@(4,0),@(4,1),@(4,2))) | Out-Null
# "l"
$shapes.Add(@(@(2,0),@(2,1),@(2,2),@(2,3))) | Out-Null
# "O"
$shapes.Add(@(@(2,0),@(3,0),@(2,1),@(3,1))) | Out-Null
$jetCounter=0
$highestPoint=0
$width=7
$height=20000
$max = 1000000000000
$seen=@{}
$foundCycle=$false
$grid = New-object -TypeName 'object[,]' -ArgumentList $height,$width
for($y=0;$y -lt $height; $y++){
    for($x=0;$x -lt $width; $x++){
        $grid[$y,$x] = "."
        if($y -eq 0){
            $grid[$y,$x] = "-"
        }
    }
}

#Turn 10 = 16 high
for ($i = 0; $i -lt $max; $i++) {
    $shape = [System.Collections.ArrayList]::new()
    $shapes[0] | ForEach-Object {
        $shape.Add(@($_[0],$_[1])) | Out-Null
    }
    $shapes.Add($shapes[0]) | Out-Null
    $shapes.RemoveAt(0)
    $hitBottom=$stop=$false
    foreach($item in $shape){
        $item[1] += ($highestPoint + 4)
    }

    while($stop -eq $false){
        $jet = $puzzleInput[$jetCounter]
        $hitSide=$false
        if ($jet -eq ">") {
            $x=1
        }
        else{
            $x=-1
        }

        foreach($item in $shape){
            if(($item[0]+$x) -eq -1 -or ($item[0]+$x) -eq 7 -or $grid[$item[1],($item[0]+$x)] -eq "#"){
                # "$i $jet Hit side!"
                $hitSide=$true
            }
            if($grid[($item[1]-1),$item[0]] -in ("#","-")){
                # "$i $jet Hit bottom!"
                $hitBottom=$true
            }
        }
        if($jetCounter -eq $puzzleInput.Length-1){
            $jetCounter=0
        } else{
            $jetCounter++
        }
        if($hitSide -eq $false){
            $hitBottom=$false
            # "$i Jet pushes $jet"
            foreach($item in $shape){
                $item[0] += $x
                if($grid[($item[1]-1),$item[0]] -in ("#","-")){
                    $hitBottom=$true
                }
            }
        }
        if($hitBottom -eq $true){

            foreach($item in $shape){
                $grid[($item[1]),$item[0]] = "#"
                if($highestPoint -lt $item[1]){
                    $highestPoint = $item[1]
                }
            }
            # Check for repeating cycles
            $topRow = ""
            if($highestPoint -gt 5){
                for ($copyRow = 0; $copyRow -lt 7; $copyRow++) {
                    $topRow += $grid[($highestPoint),$copyRow]
                    $topRow += $grid[($highestPoint-1),$copyRow]
                    $topRow += $grid[($highestPoint-2),$copyRow]
                    $topRow += $grid[($highestPoint-3),$copyRow]
                    $topRow += $grid[($highestPoint-5),$copyRow]
                }
            }

            $rock = ($i+1) % 5
            if($foundCycle -eq $false -and $seen.ContainsKey("$topRow,$rock,$jetCounter")){
                $foundCycle=$true
                $heightIncrease = $highestPoint - $seen["$topRow,$rock,$jetCounter"][1]
                $newRocks = $i - $seen["$topRow,$rock,$jetCounter"][0]
                [int]$multiply = [Math]::Floor(($max-$i) / $newRocks)

                $i += $newRocks * $multiply
                $highestPointToAdd=(($heightIncrease*$multiply))
            } else{
                $seen["$topRow,$rock,$jetCounter"] = @($i,$highestPoint)
            }
            $stop=$true
        }
        else{
            # "$i Rock falls 1 unit to $($item[1]-1)"
            foreach($item in $shape){
                $item[1] -= 1
            }
        }
    }
}
$highestPointToAdd+$highestPoint
$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
