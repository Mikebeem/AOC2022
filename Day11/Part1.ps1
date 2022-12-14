#Change if you run this on another day
$day=(Get-Date).Day
$Year=(Get-Date).Year

if(Test-Path ./env.ps1){
    . ./env.ps1
    $session = [Microsoft.PowerShell.Commands.WebRequestSession]::new()
    $cookie = [System.Net.Cookie]::new('session', $sessionToken)
    $session.Cookies.Add('https://adventofcode.com/', $cookie)

    $puzzleInput = ((Invoke-WebRequest -Uri ("https://adventofcode.com/{0}/day/{1}/input" -f $Year, $day) -UseBasicParsing -WebSession $session).Content) -split '(?:\r?\n){2,}'
}
#Comment next line for run with input
#$puzzleInput = (Get-Content ./Day$day/sample.txt -Raw) -split '(?:\r?\n){2,}'
$monkey = $puzzleInput[0]
$monkeys = @()
for($monkey=0 ; $monkey -lt $puzzleInput.Count; $monkey++){
    $lines = $puzzleInput[$monkey] -split '\n'
    $items = $lines[1].Split(":")[1].Split(",").Trim()
    $operation = $lines[2].Split("=")[1].Split(" ")[2..3]
    $test = $lines[3].Split(" ")[-1]
    $testTrue = $lines[4].Split(" ")[-1]
    $testFalse = $lines[5].Split(" ")[-1]

    $monkeyObject = [PSCustomObject]@{
        Id     = $monkey
        Items  = $items
        Operation = $operation
        Test = $test
        TestTrue = $testTrue
        TestFalse = $testFalse
        Inspections = 0
    }
    $monkeys += $monkeyObject
}

for($round=1; $round -le 20; $round++){
    for($monkey=0; $monkey -lt $monkeys.Count; $monkey++){
        $monkeyTurn = $monkeys[$monkey]
        $items = $monkeyTurn.Items
        #$inspection = 79
        foreach($inspection in $items){
            [int]$monkeys[$monkey].Inspections++ | Out-Null
            $first, $monkeys[$monkey].Items = $monkeys[$monkey].Items
            if($monkeyTurn.Operation[1] -like "*old*"){
                [int]$value = $inspection
            } else{
                [int]$value = $monkeyTurn.Operation[1]
            }
            switch($monkeyTurn.Operation[0]){
                "*" {[int]$worryLevel = [System.Math]::Floor((([int]$inspection * $value)/3))}
                "+" {[int]$worryLevel = [System.Math]::Floor(([int]$inspection + $value)/3)}
            }
            if($worryLevel % [int]$monkeyTurn.Test -eq 0){
                [int]$toMonkey = $monkeyTurn.TestTrue
            }
            else{
                [int]$toMonkey = $monkeyTurn.TestFalse
                
            }
            if($monkeys[$toMonkey].Items.Count -eq 1){
                $monkeys[$toMonkey].Items = @($monkeys[$toMonkey].Items, $worryLevel)
            }
            else{
                $monkeys[$toMonkey].Items += $worryLevel
            }
        }
    }
}
$topTwo = $monkeys.Inspections | Sort-Object -Descending | Select-Object -First 2 
$topTwo[0] * $topTwo[1]