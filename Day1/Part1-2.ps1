function ImportInput {
    param (
        [Switch]$Sample
    )
    if($Sample){
        return (Get-Content $PSScriptRoot/sample.txt -Raw) -split '(?:\r?\n){2,}'
    }
    else{
        return (Get-Content $PSScriptRoot/input.txt -Raw) -split '(?:\r?\n){2,}'
    }
}
$stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

$inputVal = ImportInput

[int64[]]$calArr = $()
foreach($elf in $inputVal){
    $elfsCalorieArray = $elf.Split([System.Environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries)
    $callories = 0
    foreach($elfsCalorie in $elfsCalorieArray){
        $callories += [int]$elfsCalorie
    }
    $calArr += $callories
}
$calArr = $calArr | Sort-Object
$max = $calArr | Measure-Object -Maximum
Write-Host ("Answer for part one: {0}" -f $max.Maximum)

$topThree = $calArr[($calArr.length-1)..($calArr.length-3)]
$sum = $topThree | Measure-Object -Sum
Write-Host ("Answer for part two: {0}" -f $sum.Sum)

$stopwatch.Stop()
Write-Host ("This run took: {0} ms" -f $stopwatch.ElapsedMilliseconds)
