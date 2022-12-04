#$assignmentPairs = Get-Content ./Day4/sample.txt
$assignmentPairs = Get-Content ./Day4/input.txt
$overlap=0
foreach($assignmentPair in $assignmentPairs){
    $elveOneMin,$elveOneMax,$elveTwoMin,$elveTwoMax = $assignmentPair -split(",") -split("-")
    $elveOne = $elveOneMin..$elveOneMax
    $elveTwo = $elveTwoMin..$elveTwoMax
    $check = Compare-Object $elveOne $elveTwo -ExcludeDifferent -IncludeEqual

    if($null -ne $check){
        $overlap++
    }
}
$overlap