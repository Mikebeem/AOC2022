$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=18

#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)
$droplets = [System.Collections.ArrayList]::new()
foreach($droplet in $puzzleInput){
    $droplets.Add($droplet) | Out-Null
}
$seen = [System.Collections.ArrayList]::new()
$q = New-Object System.Collections.Queue
$q.Enqueue("0,0,0")

while($q.Count -gt 0){
    $droplet = $q.Dequeue()
    $seen.Add($droplet) | Out-Null

    [int]$x, [int]$y, [int]$z = $droplet.Split(",")

    $checks = [System.Collections.ArrayList]::new()
    if($x -ge 0){
        $checks.Add(@(($x-1),$y,$z) -join ",") | Out-Null
    }
    if($x -le 21){
        $checks.Add(@(($x+1),($y),($z)) -join ",") | Out-Null
    }
    if($y -ge 0){
        $checks.Add(@(($x),($y-1),($z)) -join ",") | Out-Null
    }
    if($y -le 21){
        $checks.Add(@(($x),($y+1),($z)) -join ",") | Out-Null
    }
    if($z -ge 0){
        $checks.Add(@(($x),($y),($z-1)) -join ",") | Out-Null
    }
    if($z -le 21){
        $checks.Add(@(($x),($y),($z+1)) -join ",") | Out-Null
    }

    foreach($toCheck in $checks){
        if(-not $q.Contains($toCheck) -and -not $seen.Contains($toCheck)){
            if($droplets.Contains($toCheck)){
                $total += 1
            }
            else{
                $q.Enqueue($toCheck)
            }
        }
    }

}

$total

$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
