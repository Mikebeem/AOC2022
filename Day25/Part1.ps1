$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=25

#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)

# Snafu
# 3125, 625, 125, 25's, 5's, 1's
# 2, 1, 0, -1, -2

$total=0
foreach($snafu in $puzzleInput){
    [string]$sign=""
    $toDecimal=0
    for ($i = 0; $i -lt $snafu.Length; $i++) {
        $sign = $snafu[$i].ToString()
        if($sign -eq "-"){
            $sign = -1
        }
        if($sign -eq "="){
            $sign = -2
        }
        $number = [int]$sign
        [int64]$number *= [System.Math]::Pow(5,($snafu.Length-($i+1)))
        $toDecimal += $number
    }
    $total += $toDecimal
}
$total

$result = ""
while($total -gt 0){
    <#
    4890/5 = 978
    4890%0 = 0
    result = 0

    978/5  = 195.5
    978%5  = 3 (check -> 196)
    result = =0

    196/5  = 39.5
    196%5  = 1
    result = 1=0

    39/5   = 7.8
    39%5   = 4 (check -> 8)
    result = -1=0

    8/5    = 1.6
    8%5    = 3 (check -> 2)
    result = =-1=0

    2/5    = 0
    2%5    = 2
    result = 2=-1=0
    #>

    $check = [System.Math]::Floor(($total / 5))
    $rest = $total % 5

    if($rest -gt 2){
        $check++
    }
    if($rest -eq 3){
        $rest = "=" # 5-2 -> 1=
    }
    if($rest -eq 4){
        $rest = "-" #5-1 -> 1-
    }
    $result = "{0}{1}" -f $rest,$result
    $total = $check
}
$result

$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
