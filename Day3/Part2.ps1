#$rucksacks = Get-Content ./Day3/sample.txt
$rucksacks = Get-Content ./Day3/input.txt
$prioritySum = 0
$priority = [char[]]([int][char]'a'..[int][char]'z') + [char[]]([int][char]'A'..[int][char]'Z')

for($i=0; $i -lt $rucksacks.Count-1; $i++){
    if($i -eq 0 -or (($i) % 3)-eq 0){
        for($j=0;$j -lt $rucksacks[$i].Length; $j++){
            if($rucksacks[$i+1] -cmatch $rucksacks[$i][$j] -and $rucksacks[$i+2] -cmatch $rucksacks[$i][$j] ){
                $prioritySum+=$priority.IndexOf([char]$rucksacks[$i][$j])+1
                break
            }
        }
    }
}
$prioritySum