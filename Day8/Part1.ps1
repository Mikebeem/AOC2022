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
    #return $grid
}

fillGrid $puzzleInput $width $height

#$grid.Length
$arr=@()

for($i=0;$i -lt $height; $i++){
    $nr=0
    $top=0
    for($j=0;$j -lt $width; $j++){
        $prev = $nr
        if($nr -eq 9){
            break;
        }
        $nr = $grid[$i,$j]
        if($prev -gt $top){
            $top=$prev
        }
        if($nr -gt $top){
            $val="{0}-{1}" -f $i, $j
            if(-not $arr.Contains($val)){
                $arr+=($val)
            }
        }
    }
}

for($i=0;$i -lt $height; $i++){
    $nr=0
    $top=0
    for($j=($width-1);$j -ge 0; $j--){
        $prev = $nr
        if($nr -eq 9){
            break;
        }
        $nr = $grid[$i,$j]
        if($prev -gt $top){
            $top=$prev
        }
        if($nr -gt $top){
            $val="{0}-{1}" -f $i, $j
            if(-not $arr.Contains($val)){
                $arr+=($val)
            }
        }
    }
}

for($j=0;$j -lt $width; $j++){
    $nr=0
    $top=0
    for($i=0;$i -lt $height; $i++){
        $prev = $nr
        if($nr -eq 9){
            break;
        }
        $nr = $grid[$i,$j]
        if($prev -gt $top){
            $top=$prev
        }
        if($nr -gt $top){
            $val="{0}-{1}" -f $i, $j
            if(-not $arr.Contains($val)){
                $arr+=($val)
            }
        }
    }
}

for($j=0;$j -lt $width; $j++){
    $nr=0
    $top=0
    for($i=($height);$i -ge 0; $i--){
        $prev = $nr
        if($nr -eq 9){
            break;
        }
        $nr = $grid[$i,$j]
        if($prev -gt $top){
            $top=$prev
        }
        if($nr -gt $top){
            $val="{0}-{1}" -f $i, $j
            if(-not $arr.Contains($val)){
                $arr+=($val)
            }
        }
    }
}

$arr.Count