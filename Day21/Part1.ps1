$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=21

#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)

$monkeys = [ordered]@{}
$monkeykeys = [System.Collections.ArrayList]@()
foreach($monkey in $puzzleInput){
    $monkeyName,$monkeyJob = $monkey.Split(": ")
    $monkeys[$monkeyName] = $monkeyJob
    $monkeykeys.Add($monkeyName) | Out-Null
}

foreach($indexMonk in $monkeykeys){
    $matched = $monkeys[$indexMonk] | Select-String -Pattern '\w{4}' -AllMatches
    if($matched){
        foreach($match in $matched.Matches.GetEnumerator()){
            if($monkeys[$match.Value] -match "^\d+$"){
                $monkeys[$indexMonk] = $monkeys[$indexMonk] -replace $match.Value,$monkeys[$match.Value]
            }
        }
    }

}
while ($monkeys["root"] -notmatch "^\d+$") {
    for($i = 0; $i -lt $monkeykeys.Count; $i++){
        $indexMonk = $monkeykeys[$i]
        $matched = $monkeys[$indexMonk] | Select-String -Pattern '\w{4}' -AllMatches
        if($matched){
            foreach($match in $matched.Matches.GetEnumerator()){
                #Numeric value
                if($monkeys[$match.Value] -match "^\d+$"){
                    $monkeys[$indexMonk] = $monkeys[$indexMonk] -replace $match.Value,$monkeys[$match.Value]
                }
            }
        }
        $matchedNrs = $monkeys[$indexMonk] | Select-String -Pattern '\d+' -AllMatches
        if($matchedNrs.Matches.Count -eq 2){
            $monkeys[$indexMonk] = $monkeys[$indexMonk] | Invoke-Expression
        }
    }
}
$monkeys["root"]

$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
