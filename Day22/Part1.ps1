$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=22

#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)

$directions = ($puzzleInput[$puzzleInput.Count-1] -replace "R"," R " -replace "L"," L ").Split(" ")
$row=0
$column=$puzzleInput[0].IndexOfAny(".")

$columns=@()
for($rowI=0;$rowI -lt $puzzleInput.Count - 2;$rowI++){

    for ($j = 0; $j -lt $puzzleInput[$rowI].Length; $j++) {
        if($j -ge $columns.Count){
            $columns += ""
        }
        $columns[$j] += $puzzleInput[$rowI][$j]
    }
}
$facing=">"
foreach($direction in $directions){
    if($direction -match "^\d+$"){
        for([int]$i=0;$i -lt [int]$direction; $i++){
            switch ($facing) {
                ">" {
                        $length = $puzzleInput[$row].LastIndexOfAny(".#")
                        $start = $puzzleInput[$row].IndexOfAny(".#")
                        if($column+1 -gt $length){
                            if($puzzleInput[$row][$start] -eq "."){
                                $column=$start
                            }
                            else{
                                # Wall
                                $i=$direction
                                continue
                            }
                        }
                        elseif($puzzleInput[$row][($column+1)] -eq "."){
                            $column++
                        } elseif ($puzzleInput[$row][($column+1)] -eq "#") {
                            $i=$direction
                            continue
                        }
                    }
                "<" {
                    $length = $puzzleInput[$row].LastIndexOfAny(".#")
                    $start = $puzzleInput[$row].IndexOfAny(".#")
                    if($column-1 -lt $start){
                        if($puzzleInput[$row][$length] -eq "."){
                            $column=$length
                        }
                        else{
                            # Wall
                            $i=$direction
                            continue
                        }
                    }
                    elseif($puzzleInput[$row][($column-1)] -eq "."){
                        $column--
                    } elseif ($puzzleInput[$row][($column-1)] -eq "#") {
                        $i=$direction
                        continue
                    }
                 }
                "^" {
                    $length = $columns[$column].LastIndexOfAny(".#")
                    $start = $columns[$column].IndexOfAny(".#")
                    if($row - 1 -lt $start){
                        if($columns[$column][$length] -eq "."){
                            $row=$length
                        }
                        else{
                            # Wall
                            $i=$direction
                            continue
                        }
                    }
                    elseif($columns[$column][($row - 1)] -eq "."){
                        $row--
                    } elseif ($columns[$column][($row - 1)] -eq "#") {
                        $i=$direction
                        continue
                    }
                 }
                "v" {
                        $length = $columns[$column].LastIndexOfAny(".#")
                        $start = $columns[$column].IndexOfAny(".#")
                        if($row + 1 -gt $length){
                            if($columns[$column][$start] -eq "."){
                                $row=$start
                            }
                            else{
                                # Wall
                                $i=$direction
                                continue
                            }
                        }
                        elseif($columns[$column][($row + 1)] -eq "."){
                            $row++
                        } elseif ($columns[$column][($row + 1)] -eq "#") {
                            $i=$direction
                            continue
                        }
                 }
            }


        }
    } elseif($direction -eq "R"){
        #clockwise
        switch ($facing) {
            ">" { $facing = "v" }
            "<" { $facing = "^" }
            "^" { $facing = ">" }
            "v" { $facing = "<" }
        }
    } elseif($direction -eq "L"){
        #counterclockwise
        switch ($facing) {
            ">" { $facing = "^" }
            "<" { $facing = "v" }
            "^" { $facing = "<" }
            "v" { $facing = ">" }
        }
    }
}

switch ($facing) {
    ">" { $facingCount = 0 }
    "<" { $facingCount = 2 }
    "^" { $facingCount = 3 }
    "v" { $facingCount = 1 }
}

(1000*($row+1)) + (4*($column+1)) + $facingCount

$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
