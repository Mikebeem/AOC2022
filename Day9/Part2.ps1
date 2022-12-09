#Change if you run this on another day
$day=(Get-Date).Day
$year=(Get-Date).Year

if(Test-Path ./env.ps1){
    . ./env.ps1
    $session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $cookie = [System.Net.Cookie]::new('session', $sessionToken)
    $session.Cookies.Add('https://adventofcode.com/', $cookie)

    $puzzleInput = ((Invoke-WebRequest -Uri ("https://adventofcode.com/{0}/day/{1}/input" -f $year, $day) -WebSession $session).Content -split "`n")
}
# $puzzleInput  = Get-Content ./Day$day/sample.txt
$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

function getNewPosition ([int]$XH, [int]$YH, [int]$XT, [int]$YT){
    $distanceX = $XH-$XT
    $distanceY = $YH-$YT

    if(($distanceX -ne 0 -and $distanceY -ne 0) -and ([System.Math]::Abs($distanceX) -eq 2 -or [System.Math]::Abs($distanceY) -eq 2)){
        #Diagonaal
        $XT += [System.Math]::Sign($distanceX)
        $YT += [System.Math]::Sign($distanceY)
    } elseif ([System.Math]::Abs($distanceX) -eq 2) {
        #Hor
        $XT += [System.Math]::Sign($distanceX)
    } elseif ([System.Math]::Abs($distanceY) -eq 2) {
        #Vert
        $YT += [System.Math]::Sign($distanceY)
    }
    return $XT,$YT
}

$XH=$YH=$X1=$Y1=$X2=$Y2=$X3=$Y3=$X4=$Y4=$X5=$Y5=$X6=$Y6=$X7=$Y7=$X8=$Y8=$X9=$Y9=0
$visitedT=@{"$X9,$Y9" = 0}

foreach($motion in $puzzleInput){
    $direction, [int]$nrSteps = $motion.Split(" ")

    for($i=0; $i -lt $nrSteps; $i++){
        switch ($direction) {
            "L" {$XH--}
            "R" {$XH++}
            "U" {$YH--}
            "D" {$YH++}
        }
        $X1, $Y1 = getNewPosition $XH $YH $X1 $Y1
        $X2, $Y2 = getNewPosition $X1 $Y1 $X2 $Y2
        $X3, $Y3 = getNewPosition $X2 $Y2 $X3 $Y3
        $X4, $Y4 = getNewPosition $X3 $Y3 $X4 $Y4
        $X5, $Y5 = getNewPosition $X4 $Y4 $X5 $Y5
        $X6, $Y6 = getNewPosition $X5 $Y5 $X6 $Y6
        $X7, $Y7 = getNewPosition $X6 $Y6 $X7 $Y7
        $X8, $Y8 = getNewPosition $X7 $Y7 $X8 $Y8
        $X9, $Y9 = getNewPosition $X8 $Y8 $X9 $Y9
        $positionT = ("{0},{1}" -f $X9, $Y9)
        $visitedT[$positionT] = 0
    }
}

$visitedT.Count
$Stopwatch.Stop()
write-host ("That took {0} Milliseconds" -f $Stopwatch.Elapsed.TotalMilliseconds)