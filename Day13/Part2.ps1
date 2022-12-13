$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=(Get-Date).Day
$Year=(Get-Date).Year

#Comment next line for run with input
[System.Collections.ArrayList]$puzzleInput = (Get-Content ./Day$day/input.txt) | Where-Object {
    $_.Trim() -ne ""
}
$puzzleInput.Add("[[2]]") | Out-Null
$puzzleInput.Add("[[6]]") | Out-Null
$puzzleInput = $puzzleInput | Sort-Object

function rightOrder ($leftList, $rightList){
    [System.Collections.ArrayList]$leftPacket = $leftList.Replace(10,"A").ToCharArray()
    [System.Collections.ArrayList]$rightPacket = $rightList.Replace(10,"A").ToCharArray()

    for($i=0; $i -lt [Math]::Min($leftPacket.Count,$rightPacket.Count); $i++){
        $left = $leftPacket[$i]
        $right = $rightPacket[$i]
        if($left -eq $right){
            #Do noting, move to next item
            continue
        }
        if([int]$left -in 48..65 -and [int]$right -in 48..65){
            if(($right-$left) -ge 1) {
                return $true
            }
            elseif(($right-$left) -lt 0){
                return $false
            }
        }
        #If left or right numeric and the other is a list, change 1 to [1]
        if($left -eq "[" -and [int]$right -in 48..65){
            $rightPacket.Insert($i+1,[char]"]")
            $rightPacket.Insert($i,[char]"[")
            continue
        }
        if($right -eq "[" -and [int]$left -in 48..65){
            $leftPacket.Insert($i+1,[char]"]")
            $leftPacket.Insert($i,[char]"[")
            continue
        }
        #If left closes before right is closed
        if($left -eq "]" -and $right -ne "]"){
            #Left runned out of items, order is correct
            return $true
        }
        if($right -eq "]" -and $left -ne "]"){
            #Right runned out of items, order is not correct
            return $false
        }
    }
}

for($inputIndex=0; $inputIndex -lt ($puzzleInput.Count-1); $inputIndex++){
    if(-not (rightOrder $puzzleInput[$inputIndex] $puzzleInput[$inputIndex+1])){
        $toMove = $puzzleInput[$inputIndex+1]
        $puzzleInput.RemoveAt($inputIndex+1)
        $puzzleInput.Insert($inputIndex, $toMove)
        #start from the beginning again
        $inputIndex=-1
    }
    if($puzzleInput[$inputIndex] -eq "[[2]]"){
        $decoder = ($inputIndex+1)
    }
    if($puzzleInput[$inputIndex] -eq "[[6]]"){
        $decoder = $decoder * ($inputIndex+1)
    }
}
$decoder
$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)