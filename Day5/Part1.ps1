#$content = (Get-Content ./Day5/sample.txt -Raw) -split '(?:\r?\n){2,}'
$content = (Get-Content ./Day5/input.txt -Raw) -split '(?:\r?\n){2,}'
$stacks = $content[0].Split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)

$stack = @{}
for($i=1;$i -le 9; $i++){
    $stack[$i] = new-object 'System.Collections.Generic.List[string]'
}
foreach($line in $stacks){
    if($line[1] -ne "1"){
        for($i=1; $i -le $line.Length; $i+=4){
            if($line[$i] -ne " "){
                [int]$stackNr = ([math]::floor($i/4)+1)
                $stack[$stackNr].Add($line[$i])
            }
        }
    }
}

$procedure = $content[1].Split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
foreach($step in $procedure){
    $calls = $step.Split(" ")
    [int]$nrOfCrates = $calls[1]
    [int]$fromStack = $calls[3]
    [int]$toStack = $calls[5]

    for($i=1;$i -le $nrOfCrates; $i++){
        $crate = $stack[$fromStack][0]
        $stack[$fromStack].RemoveAt(0)
        $stack[$toStack].Insert(0,$crate)
    }
}
$answer=""
for($i=1;$i -le 9; $i++){
    $answer += $stack[$i][0]
}
$answer