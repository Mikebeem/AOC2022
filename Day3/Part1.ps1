#$rucksacks = Get-Content ./Day3/sample.txt
$rucksacks = Get-Content ./Day3/input.txt
$prioritySum = 0
$priority = [char[]]([int][char]'a'..[int][char]'z') + [char[]]([int][char]'A'..[int][char]'Z')

foreach($rucksack in $rucksacks){
    $firstCompartment = $rucksack.Substring(0,($rucksack.Length/2))
    $secondCompartment = $rucksack.Substring(($rucksack.Length/2))
    
    for($i=0;$i -lt $firstCompartment.Length; $i++){
        if($secondCompartment -cmatch $firstCompartment[$i]){
            $prioritySum+=$priority.IndexOf([char]$firstCompartment[$i])+1
            break
        }
    }
}
$prioritySum