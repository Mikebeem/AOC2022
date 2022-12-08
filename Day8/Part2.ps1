$Day=8
#$puzzleInput  = Get-Content ./Day$Day/sample.txt
$puzzleInput = Get-Content ./Day$Day/input.txt
$width = $puzzleInput[0].Length
$height = $puzzleInput.Count
function fillGrid {
    param (
        $puzzleInput,
        $width,
        $height
    )
    $global:grid = New-object -TypeName 'object[,]' -ArgumentList ($height),($width)

    for($i=0;$i -lt $height; $i++){
        for($j=0;$j -lt $width; $j++){
            $grid[($i),($j)] = $puzzleInput[$i][$j]
        }
    }
}

fillGrid $puzzleInput $width $height

function checkDown {
    Param(
        $x,
        $y,
        $height
    )
    $counter=0
    $top = $grid[$y,$x]
    if($y -lt ($height-1)){
        for($i=($y+1);$i -lt $height; $i++){
            if($grid[$i,$x] -lt $top){
                $counter++
            }
            if($grid[$i,$x] -ge $top){
                $counter++
                break
            }
        }
    }
    return $counter
}
function checkUp {
    Param(
        $x,
        $y
    )
    $counter=0
    $top = $grid[$y,$x]
    if($y -gt 0){
        for($i=($y-1);$i -ge 0; $i--){
            if($grid[$i,$x] -lt $top){
                $counter++
            }
            if($grid[$i,$x] -ge $top){
                $counter++
                break
            }
        }
    }
    return $counter
}
function checkRight {
    Param(
        $x,
        $y,
        $width
    )
    $counter=0
    $top = $grid[$y,$x]
    if($x -lt ($width-1)){
        for($i=($x+1);$i -lt $width; $i++){
            if($grid[$y,$i] -lt $top){
                $counter++
            }
            if($grid[$y,$i] -ge $top){
                $counter++
                break
            }
        }
    }
    return $counter
}
function checkLeft {
    Param(
        $x,
        $y
    )
    $counter=0
    $top = $grid[$y,$x]
    if($x -gt 0){
        for($i=($x-1);$i -ge 0; $i--){
            if($grid[$y,$i] -lt $top){
                $counter++
            }
            if($grid[$y,$i] -ge $top){
                $counter++
                break
            }
        }
    }
    return $counter
}

$highestScenicScore=0
for($i=0;$i -lt $height; $i++){
    for($j=0;$j -lt $width; $j++){
        $up = checkUp -x $j -y $i
        $left = checkLeft -x $j -y $i
        $right = checkRight -x $j -y $i -width $width
        $down = checkDown -x $j -y $i -height $height
        $scenicScore = $up * $left * $right * $down
        if($scenicScore -gt $highestScenicScore){
            $highestScenicScore = $scenicScore
        }
    }
}

$highestScenicScore