#$datastreamBuffer = Get-Content ./Day6/sample.txt
$datastreamBuffer = Get-Content ./Day6/input.txt

# 4 for Part 1, 14 for Part 2
$nrCharacters=14
$marker=""
for($i=0;$i -lt $datastreamBuffer.Length; $i++){
    $potentialMarker = $datastreamBuffer.Substring($i,$nrCharacters)
    for($j=0;$j -lt $nrCharacters; $j++){
        if(([regex]::Matches($potentialMarker, $potentialMarker[$j] )).count -gt 1){
            $marker=""
            break
        }
        else{
            $marker += $potentialMarker[$j]
        }
    }
    if($marker.Length -eq $nrCharacters){
        ($i+$nrCharacters)
        break
    }
}
