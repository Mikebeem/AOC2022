$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=(Get-Date).Day

#Comment next line for run with input
# $puzzleInput = (Get-Content ./Day$day/sample.txt)
# $getRow=10
$puzzleInput = (Get-Content ./Day$day/input.txt)
$getRow=2000000

$beaconList=@()
$hash = @{}
foreach($position in $puzzleInput){
    [int]$sensorX, [int]$sensorY, [int]$beaconX, [int]$beaconY = $position.Replace("Sensor at ","").Replace(" closest beacon is at ","").Replace("y=","").Replace("x=","").Split(":").Split(", ")
    $beaconList += "$beaconY,$beaconX"

    [int]$distanceX = $beaconX-$sensorX
    [int]$distanceY = $beaconY-$sensorY
    [int]$distance = [System.Math]::Abs($distanceX) + [System.Math]::Abs($distanceY)

    if($getRow -in ($sensorY-$distance)..($sensorY+$distance)){
        $rest = $distance - [System.Math]::Abs($getRow - $sensorY)
        for($j=($sensorX-$rest); $j -le ($sensorX+$rest); $j++){
            $hash.Set_Item("$getRow,$j",$j)
        }
    }
}
"Remove beacons"
$beaconList -like "$getRow,*" | Get-Unique | ForEach-Object {
    $hash.Remove($_)
}
"TotalRange now is: $($hash.Count)"

$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
