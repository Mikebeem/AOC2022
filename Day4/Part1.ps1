#$assignmentPairs = Get-Content ./Day4/sample.txt
$assignmentPairs = Get-Content ./Day4/input.txt

$fullyContains=0
foreach($assignmentPair in $assignmentPairs){
    $elveOneMin,$elveOneMax,$elveTwoMin,$elveTwoMax = $assignmentPair -split(",") -split("-")
    $elveOne = $elveOneMin..$elveOneMax
    $elveTwo = $elveTwoMin..$elveTwoMax
    $check = Compare-Object $elveOne $elveTwo

    if($null -eq $check -or -not ($check.SideIndicator.Contains("=>") -and $check.SideIndicator.Contains("<="))){
        $fullyContains++
    }
}
$fullyContains