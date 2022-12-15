$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=(Get-Date).Day

#Comment next line for run with input
# $puzzleInput = (Get-Content ./Day$day/sample.txt)
# $max=20
$puzzleInput = (Get-Content ./Day$day/input.txt)
$max=4000000

# $curX=14
# $curY=11
function checkCurrentPosition($curX, $curY) {
    # Als huidige positie < 0 of > max, is het niet de locatie die we zoeken
    if ($curX -lt 0 -or $curY -lt 0){ return $false }
    if ($curX -gt $max -or $curY -gt $max){ return $false }
    # Voor alle sensors kijken of het huidige punt binnen bereik valt
    foreach($sensor in $sensorList){
        [int]$sensorX,[int]$sensorY,[int]$distance = $sensor.Split(",")
        [int]$distanceX = $sensorX-$curX
        [int]$distanceY = $sensorY-$curY

        [int]$curDistance = [System.Math]::Abs($distanceX) + [System.Math]::Abs($distanceY)
        if ($curDistance -le $distance) {
            return $false
        }
    }
    # Huidige positie is buiten bereik van alle sensors!
    #Write-Host ("Hey, $curX, $curY")
    Write-Host ("{0}" -f [bigint](($curX*4000000)+$curY))
    $Stopwatch.Stop()
    write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
    exit
}
$sensorList = @()
$distanceList = @()
$orderedSensorList = @()
foreach($position in $puzzleInput){
    # $position = $puzzleInput[6]
    [int]$sensorX, [int]$sensorY, [int]$beaconX, [int]$beaconY = $position.Replace("Sensor at ","").Replace(" closest beacon is at ","").Replace("y=","").Replace("x=","").Split(":").Split(", ")
    [int]$distanceX = $beaconX-$sensorX
    [int]$distanceY = $beaconY-$sensorY
    [int]$distance = [System.Math]::Abs($distanceX) + [System.Math]::Abs($distanceY)

    $sensorList += "$sensorX,$sensorY,$distance"
    $distanceList += $distance

}
# Sorteren op afstand, hopelijk ten goede van de snelheid
$distanceList | Sort-Object | ForEach-Object {
    $dist = $_
    $orderedSensorList += ($sensorList | Where-Object { $_ -like "*,$dist"})
}
$counter=0
foreach($sensor in $orderedSensorList){
    #$sensor = $orderedSensorList[7]
    $counter++
    [int]$sensorX,[int]$sensorY,[int]$distance = $sensor.Split(",")
    "{0} out of {1} - distance: {2}" -f $counter, $sensorList.Count, $distance
    # Voor iedere sensor weten we de afstand tot een beacon
    # Voor ieder punt om dat bereik heen, kijken of het binnen een andere sensor valt
    $distance++
    for ($i=0; $i -le $distance; $i++) {
        if (checkCurrentPosition ($sensorX+$i) ($sensorY-$distance+$i)){exit}
        if (checkCurrentPosition ($sensorX+$distance-$i) ($sensorY+$i)){exit}
        if (checkCurrentPosition ($sensorX-$i) ($sensorY+$distance-$i)){exit}
        if (checkCurrentPosition ($sensorX-$distance+$i) ($sensorY-$i)){exit}
    }
}
