#Change if you run this on another day
$day=(Get-Date).Day
$Year=(Get-Date).Year

#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt -Raw) -split '(?:\r?\n){2,}'
$puzzleInput = (Get-Content ./Day$day/input.txt -Raw) -split '(?:\r?\n){2,}'
$pairIndex=0
$rightOrdered=@()
foreach($pair in $puzzleInput){
    $pairIndex++
    #$pair = $puzzleInput[0]
    #$pair = $puzzleInput[15]
    $leftList, $rightList = $pair.Split([System.Environment]::NewLine)
    [System.Collections.ArrayList]$leftPacket = $leftList.Replace(10,"A").ToCharArray()
    [System.Collections.ArrayList]$rightPacket = $rightList.Replace(10,"A").ToCharArray()


    #$item = $left[0]
    for($i=0; $i -lt [Math]::Min($leftPacket.Count,$rightPacket.Count); $i++){
        #$i++
        $left = $leftPacket[$i]
        $right = $rightPacket[$i]
        if($left -eq $right){
            #Do noting, move to next item
            continue
        }
        if([int]$left -in 48..65 -and [int]$right -in 48..65){
            if(($right-$left) -ge 1) {
                $rightOrdered += $pairIndex
                break
            }
            elseif(($right-$left) -lt 0){
                break
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
            $rightOrdered += $pairIndex
            break
        }
        if($right -eq "]" -and $left -ne "]"){
            #Right runned out of items, order is not correct
            break
        }
    }
}
$rightOrdered | Measure-Object -Sum