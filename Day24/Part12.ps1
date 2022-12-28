$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=24

#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)

$blizzards = @{}
$allFields = [System.Collections.ArrayList]@()
$start = [PSCustomObject]@{
    X         = 1
    Y         = 0
}
$allFields.Add(("{0},{1}" -f $start.X, $start.Y)) | Out-Null
$goal = [PSCustomObject]@{
    X         = $puzzleInput[0].Length-2
    Y         = $puzzleInput.Count-1
}
$allFields.Add(("{0},{1}" -f $goal.X, $goal.Y)) | Out-Null

$maxX = $puzzleInput[0].Length-2
$maxY = $puzzleInput.Count-2

for($y=1; $y -lt $puzzleInput.Count-1; $y++){
    for ($x = 1; $x -lt $puzzleInput[0].Length-1; $x++) {
        $allFields.Add("$x,$y") | Out-Null
        if($puzzleInput[$y][$x] -ne "."){
            $blizzards["$x,$y"] = @{ X = $x 
                                     Y =$y
                                     Direction = $puzzleInput[$y][$x]}
        }
    }
}

$freeFields = @{}
for ($i = 0; $i -lt 800; $i++) {
    $freeFields[$i] = $allFields.Clone()
    foreach($blizzard in $blizzards.GetEnumerator()){
        $freeFields[$i].Remove(("{0},{1}" -f $blizzard.Value.X,$blizzard.Value.Y))
        switch ($blizzard.Value.Direction) {
            "<" { 
                $blizzard.Value.X--
                if($blizzard.Value.X -eq 0){
                    $blizzard.Value.X = $maxX
                }
            }
            ">" { 
                $blizzard.Value.X++
                if($blizzard.Value.X -gt $maxX){
                    $blizzard.Value.X = 1
                }
            }
            "v" { 
                $blizzard.Value.Y++
                if($blizzard.Value.Y -gt $maxY){
                    $blizzard.Value.Y = 1
                }
            }
            "^" {
                $blizzard.Value.Y--
                if($blizzard.Value.Y -eq 0){
                    $blizzard.Value.Y = $maxY
                }
            }
        }
    }
}
"Freefields calculated"
$stopwatch.Elapsed
$me = [PSCustomObject]@{
    X         = 1
    Y         = 0
    Steps     = 0
    Path      = ""
}

#move Me
$minSteps = 0
$q = New-Object System.Collections.Queue
$q.Enqueue($me)

$biggestManDistance=0
$seen = [System.Collections.ArrayList]@()
$goalReached = 0
while($q.Count -gt 0){
    $me = $q.Dequeue()
    #  $me
    if($goalReached -eq 0 -or $goalReached -eq 2){
        $manDistance = ($me.Y - $start.Y) + ($me.X - $start.X)
    }
    else{
        $manDistance = ($goal.Y - $me.Y) + ($goal.X - $me.X)
    }
    if($biggestManDistance -gt 10 -and ($manDistance -lt ($biggestManDistance*0.5) -or ($biggestManDistance - $manDistance) -ge 30)){
        #stop here
    }
    else{
        if($manDistance -gt $biggestManDistance){
            $biggestManDistance = $manDistance
        }
        if(($minSteps -gt 1 -and $me.Steps -lt $minSteps) -or $minSteps -eq 0){
            if($freeFields[($me.Steps + 1)].IndexOf("$($me.X + 1),$($me.Y)") -gt -1){            
                #Free spot to the right
                $next = [PSCustomObject]@{
                    X         = $me.X + 1
                    Y         = $me.Y
                    Steps     = $me.Steps + 1
                }
                if($seen.IndexOf(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) -eq -1){
                    $seen.Add(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) | Out-Null
                    $q.Enqueue($next)
                }
                
            }
            if($freeFields[($me.Steps + 1)].IndexOf("$($me.X - 1),$($me.Y)") -gt -1){
                #Free spot to the left
                $next = [PSCustomObject]@{
                    X         = $me.X - 1
                    Y         = $me.Y
                    Steps     = $me.Steps + 1
                }
                if($seen.IndexOf(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) -eq -1){
                    $seen.Add(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) | Out-Null
                    $q.Enqueue($next)
                }
            }
            if($freeFields[($me.Steps + 1)].IndexOf("$($me.X),$($me.Y - 1)") -gt -1){
                #Free spot to the top
                $next = [PSCustomObject]@{
                    X         = $me.X 
                    Y         = $me.Y - 1
                    Steps     = $me.Steps + 1
                }
                if($seen.IndexOf(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) -eq -1){
                    $seen.Add(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) | Out-Null
                    $q.Enqueue($next)
                }
            }
            if($freeFields[($me.Steps + 1)].IndexOf("$($me.X),$($me.Y + 1)") -gt -1){
                #Free spot to the bottom
                $next = [PSCustomObject]@{
                    X         = $me.X 
                    Y         = $me.Y + 1
                    Steps     = $me.Steps + 1
                }
                if($seen.IndexOf(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) -eq -1){
                    $seen.Add(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) | Out-Null
                    $q.Enqueue($next)
                }
            }
            if($freeFields[($me.Steps + 1)].IndexOf("$($me.X),$($me.Y)") -gt -1){
                # Wait
                $next = [PSCustomObject]@{
                    X         = $me.X 
                    Y         = $me.Y
                    Steps     = $me.Steps + 1
                }
                if($seen.IndexOf(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) -eq -1){
                    $seen.Add(("{0},{1},{2}" -f $next.X, $next.Y, $next.Steps)) | Out-Null
                    $q.Enqueue($next)
                }
            }
    
            if($me.Y -eq $goal.Y -and $goalReached -in (0,2)){
                $goalReached++
                $biggestManDistance=0
                "Goal $goalReached is reached in {0} steps! X: {1} Y: {2}" -f $me.Steps, $me.X, $me.Y
                $stopwatch.Elapsed
                $q = New-Object System.Collections.Queue
                $seen = [System.Collections.ArrayList]@()
                $next = [PSCustomObject]@{
                    X         = $me.X 
                    Y         = $me.Y
                    Steps     = $me.Steps
                }
                if($goalReached -lt 3){
                    $q.Enqueue($next)
                } else{
                    if($minSteps -gt $me.Steps -or $minSteps -eq 0){
                        $minSteps = $me.Steps
                    }
                }
            }
            if($me.Y -eq $start.Y -and $me.X -eq $start.X -and $goalReached -eq 1){
                # $minSteps = $me.Steps
                $goalReached++
                $biggestManDistance=0
                "Start is reached in {0} steps! X: {1} Y: {2}" -f $me.Steps, $me.X, $me.Y
                $stopwatch.Elapsed
                $q = New-Object System.Collections.Queue
                $seen = [System.Collections.ArrayList]@()
                $next = [PSCustomObject]@{
                    X         = $me.X 
                    Y         = $me.Y
                    Steps     = $me.Steps
                }
                $q.Enqueue($next)
            }
        }
      }
}
"Goal is reached in {0} steps!" -f $minSteps

$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
