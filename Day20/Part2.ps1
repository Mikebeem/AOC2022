$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=(Get-Date).Day

#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)

$numberList = [System.Collections.ArrayList]@()
for($i=0; $i -lt $puzzleInput.Count; $i++){
    [bigint]$number = [int]$puzzleInput[$i]*811589153
    $numberList.Add("$i,$number") | Out-Null
    if($puzzleInput[$i] -eq 0){
        $zeroIndex = $i
    }
}

for($j=0; $j -lt 10; $j++)
{
    for($i=0; $i -lt $puzzleInput.Count; $i++){
        [bigint]$number = [int]$puzzleInput[$i]*811589153
        $index = $numberList.IndexOf("$i,$number")
        $numberList.RemoveAt($index)

        if(($index+$number) -gt 0){
            $newIndex = (($index+$number) % $numberList.Count)
        } else{
            $newIndex = (($index+$number) % $numberList.Count) + $numberList.Count
        }
        $numberList.Insert($newIndex,"$i,$($number)")
    }
}
$zeroIndex = $numberList.IndexOf("$zeroIndex,0")
[bigint]$1000 = $numberList[($zeroIndex+1000) % $numberList.Count].Split(",")[1]
[bigint]$2000 = $numberList[($zeroIndex+2000) % $numberList.Count].Split(",")[1]
[bigint]$3000 = $numberList[($zeroIndex+3000) % $numberList.Count].Split(",")[1]

$1000+$2000+$3000
$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
