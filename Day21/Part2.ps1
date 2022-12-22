$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=21

#Comment next line for run with input
# $puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)

$monkeys = [ordered]@{}
$monkeykeys = [System.Collections.ArrayList]@()
foreach($monkey in $puzzleInput){
    $monkeyName,$monkeyJob = $monkey.Split(": ")
    $monkeys[$monkeyName] = $monkeyJob
    $monkeykeys.Add($monkeyName) | Out-Null
}
$monkeys["humn"] = "unknown"
$monkeys["root"] = $monkeys["root"] -replace "\+", "-eq"

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
"Start while"
while ($monkeys["root"] -notmatch "\d+" -or $replaced -ne $true) {
    $replaced = $false
    $replacedList = 0
    for($i = 0; $i -lt $monkeykeys.Count; $i++){
        $indexMonk = $monkeykeys[$i]
        $matched = $monkeys[$indexMonk] | Select-String -Pattern '\w{4}' -AllMatches
        if($matched){
            foreach($match in $matched.Matches.GetEnumerator()){
                #Numeric value
                if($monkeys[$match.Value] -match "^\d+$"){
                    $monkeys[$indexMonk] = $monkeys[$indexMonk] -replace $match.Value,$monkeys[$match.Value]

                    $replacedList++
                }
            }
        }
        $matchedNrs = $monkeys[$indexMonk] | Select-String -Pattern '\d+' -AllMatches
        if($matchedNrs.Matches.Count -eq 2){
            $monkeys[$indexMonk] = $monkeys[$indexMonk] | Invoke-Expression
            $replacedList++
        }

    }
    if($replacedList -eq 0){
        $replaced = $true
    }
}
$monkeys["root"] -match '\d+' | Out-Null
[bigint]$neededValue = $Matches[0]

$monkeys["root"] -match '\w{4}' | Out-Null
$toSearch = $Matches[0]

while($toSearch -ne "humn"){
    $left,$operator,$right = $monkeys[$toSearch].Split(" ")

    switch ($operator) {
        "/" {
            if($left -match "^\d+$"){
                $neededValue = $left / $neededValue
                $was = $toSearch
                $toSearch = $right
            }
            else{
                $neededValue = $neededValue * $right
                $was = $toSearch
                $toSearch = $left
            }
         }
        "-" {
            if($left -match "^\d+$"){
                $neededValue = $left - $neededValue
                $was = $toSearch
                $toSearch = $right
            }
            else{
                $neededValue = $neededValue + $right
                $was = $toSearch
                $toSearch = $left
            }
        }
        "+" {
            if($left -match "^\d+$"){
                $neededValue = $neededValue - $left
                $was = $toSearch
                $toSearch = $right
            }
            else{
                $neededValue = $neededValue - $right
                $was = $toSearch
                $toSearch = $left
            }
        }
        "*" {
            if($left -match "^\d+$"){
                $neededValue = $neededValue / $left
                $was = $toSearch
                $toSearch = $right
            }
            else{
                $neededValue = $neededValue / $right
                $was = $toSearch
                $toSearch = $left
            }
        }
    }
    # "{0}: {1}    -  {2}" -f $was, $monkeys[$was], $neededValue
}
$neededValue
$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)