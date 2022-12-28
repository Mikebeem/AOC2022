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
$total = $puzzleInput.Count * 6
foreach($droplet in $droplets){
    [int]$x, [int]$y, [int]$z = $droplet.Split(",")

    $checks = [System.Collections.ArrayList]::new()
    $checks.Add(@(($x-1),$y,$z) -join ",") | Out-Null
    $checks.Add(@(($x+1),($y),($z)) -join ",") | Out-Null
    $checks.Add(@(($x),($y-1),($z)) -join ",") | Out-Null
    $checks.Add(@(($x),($y+1),($z)) -join ",") | Out-Null
    $checks.Add(@(($x),($y),($z-1)) -join ",") | Out-Null
    $checks.Add(@(($x),($y),($z+1)) -join ",") | Out-Null

    foreach($toCheck in $checks){
        if($droplets.Contains($toCheck)){
            $total -= 1
        }
    }
}
$total


$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
