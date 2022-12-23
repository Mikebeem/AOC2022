$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day="16"

#Comment next line for run with input
#$puzzleInput  = Get-Content ./Day$day/sample.txt
$puzzleInput  = Get-Content ./Day$day/input.txt
$valves = @{}
foreach($valve in $puzzleInput){
    $valve -match 'Valve (?<valve>.+) has flow rate=(?<rate>.+); tunnel*\w lead*\w to valve*\w (?<leads>.+)' | Out-Null

    $valveObject = New-Object PSObject -Property @{
        Name       = $matches.valve
        Rate       = [int]$matches.rate
        LeadTo     = $matches.leads.Replace(" ","").Split(",")
    }
    $valves[$valveObject.Name] = $valveObject
}

$paths=@{}
[System.Collections.ArrayList]$valvesToOpen = ($valves.Values | Sort-Object -Property Rate -Descending | Where-Object { $_.Rate -gt 0} | Select -First 15)

# Get paths from all valves to all valves with pressure
foreach($valveTo in $valvesToOpen){
    foreach($valveFrom in ($valvesToOpen + $valves["AA"])){

        if($valveFrom.Name -ne $valveTo.Name){
            $seen = @{$valveFrom.Name = 1}
            $paths[("{0}{1}" -f $valveFrom.Name, $valveTo.Name)] = @()
            $q = New-Object System.Collections.Queue

            $valvePath = New-Object PSObject -Property @{
                Valve      = $valveFrom
                Path       = $valveFrom.Name
                Rate       = 0
                Count      = 0
                Seen       = $seen
            }

            $q.Enqueue($valvePath)
            while ($q.Count -gt 0) {
                $valvePath = $q.Dequeue()
                foreach($lead in $valvePath.Valve.LeadTo){
                    if($lead -eq $valveTo.Name){
                        $valvePathQ = New-Object PSObject -Property @{
                            Path       = "{0},{1}" -f $valvePath.Path, $valveTo.Name
                            Rate       = $valveTo.Rate
                            Count      = ($valvePath.Count + 1)
                        }
                        if($paths[("{0}{1}" -f $valveFrom.Name, $valveTo.Name)].Count -gt 0){
                            if($paths[("{0}{1}" -f $valveFrom.Name, $valveTo.Name)][0].Count -gt $valvePathQ.Count){
                                $paths[("{0}{1}" -f $valveFrom.Name, $valveTo.Name)] = $valvePathQ
                            }
                        } else{
                            $paths[("{0}{1}" -f $valveFrom.Name, $valveTo.Name)] = $valvePathQ
                        }
                    }
                    elseif(-not $valvePath.Seen.ContainsKey($lead)){
                        $seen = $valvePath.Seen.PSObject.Copy()
                        $seen[$lead] = 1
                        $valvePathQ = New-Object PSObject -Property @{
                            Valve      = $valves[$lead]
                            Path       = "{0},{1}" -f $valvePath.Path, $lead
                            Rate       = 0
                            Count      = ($valvePath.Count + 1)
                            Seen      = $seen
                        }
                        if(($valvePath.Count + 1) -le 8){
                            $q.Enqueue($valvePathQ)
                        }
                    }
                }
            }
        }
    }
}

"Found paths $($paths.Count)"
$stopwatch.Elapsed

$current = $valves["AA"]
$q = New-Object System.Collections.Queue
$minutesLeft = 30

$pathsCalculated = @{}
($paths.Values | Where-Object {$_.Path -like "AA,*"} | Sort-Object -Property Rate -Descending | ForEach-Object {
    $pathsCalculated += @{($_.Path).Substring(($_.Path).LastIndexOf(",")+1,2) = ((($minutesLeft-($_.Count+1)) * $_.Rate)/($_.Count+1))}
})
$pathsCalculated.GetEnumerator() | Sort Value -Descending | Select-Object -First 4 | ForEach-Object {
    $count = $paths["{0}{1}" -f $current.Name, $_.Key].Count + 1
    $rate = $paths["{0}{1}" -f $current.Name, $_.Key].Rate
    $pressure = (($minutesLeft-$count) * $rate)

    $toQ = "{0},{1},{2},{3}" -f $_.Key,$_.Key, $pressure,($minutesLeft-$count)
    $q.Enqueue($toQ)
}
$higestFound=0
while ($q.Count -gt 0) {
    $valvePath = $q.Dequeue()
    
    $current, $openValve,[int]$pressure,[int]$minutesLeft = $valvePath.Split(",")
    if($minutesLeft -eq 0){
        if($pressure -gt $higestFound){
            $higestFound = $pressure
        }
    }
    elseif($minutesLeft -gt 0){
        $pathsCalculated = @{}
        ($paths.Values | Where-Object {$_.Path -like "$current,*"} | Sort-Object -Property Rate -Descending | ForEach-Object {
            $pathsCalculated += @{($_.Path).Substring(($_.Path).LastIndexOf(",")+1,2) = ((($minutesLeft-($_.Count+1)) * $_.Rate)/($_.Count+1))}
        })
        $pathsCalculated.GetEnumerator() | Sort Value -Descending | Where-Object { $openValve -notlike "*$($_.Key)*" } | Select-Object -First 3 | ForEach-Object {
            $count = $paths["{0}{1}" -f $current, $_.Key].Count + 1
            $rate = $paths["{0}{1}" -f $current, $_.Key].Rate
            [int]$pressureToQ = $pressure + (($minutesLeft-$count) * $rate)
    
            $toQ = ("{0},{1},{2},{3}" -f $_.Key,($openValve + ";" + $_.Key), $pressureToQ,($minutesLeft-$count))
            
            $q.Enqueue($toQ)
        }
    }
    if($valvesToOpenQ.Count -eq 0){
        $minutesLeft = $clock

        if($pressure -gt $higestFound){
            $higestFound = $pressure
        }
    }
}

$higestFound

$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)