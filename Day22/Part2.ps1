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
        #numeric
        for([int]$i=0;$i -lt [int]$direction; $i++){
            $newfacing = ""
            switch ($facing) {
                ">" {
                        $length = $puzzleInput[$row].LastIndexOfAny(".#")
                        $start = $puzzleInput[$row].IndexOfAny(".#")

                        if($column -eq 149 -and $row -in 0..49){
                            # > 6 -> < 5
                            $newRow = [System.Math]::Abs($row + -149)
                            $newColumn = 99
                            $newfacing = "<"
                        }
                        elseif($column -eq 99 -and $row -in 50..99){
                            # > 4 -> ^ 6
                            $newRow = 49
                            $newColumn = $row + 50
                            $newfacing = "^"
                        }
                        elseif($column -eq 99 -and $row -in 100..149){
                            # > 5 -> < 6
                            $newRow = [System.Math]::Abs($row + -149)
                            $newColumn = 149
                            $newfacing = "<"
                        }
                        elseif($column -eq 49 -and $row -in 150..199){
                            # > 2 -> ^ 5
                            $newRow = 149
                            $newColumn = $row - 100
                            $newfacing = "^"
                        }
                        if($newfacing -ne ""){
                            if($puzzleInput[$newRow][$newColumn] -eq "."){
                                $row = $newRow
                                $column = $newColumn
                                $facing = $newFacing
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

                    if($column -eq 50 -and $row -in 0..49){
                        # < 1 -> > 3
                        $newRow = [System.Math]::Abs($row + -149)
                        $newColumn = 0
                        $newfacing = ">"
                    }
                    elseif($column -eq 50 -and $row -in 50..99){
                        # < 4 -> v 3
                        $newRow = 100
                        $newColumn = $row - 50
                        $newfacing = "v"
                    }
                    elseif($column -eq 0 -and $row -in 100..149){
                        # < 3 -> > 1
                        $newRow = [System.Math]::Abs($row + -149)
                        $newColumn = 50
                        $newfacing = ">"
                    }
                    elseif($column -eq 0 -and $row -in 150..199){
                        # < 2 -> v 1
                        $newRow = 0
                        $newColumn = $row - 100
                        $newfacing = "v"
                    }
                    if($newfacing -ne ""){
                        if($puzzleInput[$newRow][$newColumn] -eq "."){
                            $row = $newRow
                            $column = $newColumn
                            $facing = $newFacing
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
                    if($column -in 50..99 -and $row -eq 0){
                        # ^ 1 -> > op 2
                        $newRow = $column + 100
                        $newColumn = 0
                        $newfacing = ">"
                    }
                    elseif($column -in 0..49 -and $row -eq 100){
                        # ^ 3 -> > op 4
                        $newRow = $column + 50
                        $newColumn = 50
                        $newfacing = ">"
                    }
                    elseif($column -in 100..149 -and $row -eq 0){
                        # ^ 6 -> ^ op 2
                        $newRow = 199
                        $newColumn = $column - 100
                        $newfacing = "^"
                    }

                    if($newfacing -ne ""){
                        if($puzzleInput[$newRow][$newColumn] -eq "."){
                            $row = $newRow
                            $column = $newColumn
                            $facing = $newFacing
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
                        if($column -in 50..99 -and $row -eq 149){
                            # v 5 -> < 2
                            $newRow = $column + 100
                            $newColumn = 49
                            $newfacing = "<"
                        }
                        elseif($column -in 100..149 -and $row -eq 49){
                            # v 6 -> < 4
                            $newRow = $column - 50
                            $newColumn = 99
                            $newFacing = "<"
                        }
                        elseif($column -in 0..49 -and $row -eq 199){
                            # v 2 -> v 6
                            $newRow = 0
                            $newColumn = $column + 100
                            $newFacing = "v"
                        }
                        if($newfacing -ne ""){
                            if($puzzleInput[$newRow][$newColumn] -eq "."){
                                $row = $newRow
                                $column = $newColumn
                                $facing = $newFacing
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
