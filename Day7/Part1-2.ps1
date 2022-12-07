$Day=7
#$puzzleInput  = Get-Content ./Day$Day/sample.txt
$puzzleInput = Get-Content ./Day$Day/input.txt
$dirStructure = @{}

foreach($line in $puzzleInput){
    switch -regex ($line ) {
        "^\$\scd\s\/" {
            $level=0
            $currentDir = "root"
            if(-not $dirStructure.ContainsKey($currentDir)){
                $dirStructure[$currentDir] = 0
            }
        }
        "^\$\scd\s\w" {
            $level++
            if($currentDir -eq "root" -or $level -eq 1){
                $currentDir = $($line.Split(" ")[2])
            }
            else{
                $currentDir = ("{0}-{1}" -f $currentDir, $($line.Split(" ")[2]))
            }
            if(-not $dirStructure.ContainsKey($currentDir)){
                $dirStructure[$currentDir] = 0
            }
        }
        "^\$\scd\s\.\." {
            $level--
            if($level -gt 1){
                $currentDir = $currentDir.Substring(0,$currentDir.LastIndexOf("-"))
            }
        }
        "^[0-9]" {
            $dirStructure["root"] += [int]$line.Split(" ")[0]
            if($level -ge 1){
                $dirStructure[$currentDir] += [int]$line.Split(" ")[0]
            }
            if($level -ge 2){
                $breakDown = $currentDir
                for($i=0;$i -lt (($currentDir.ToCharArray() -eq '-').count); $i++){
                    $breakDown = $breakDown.Substring(0,$breakDown.LastIndexOf("-"))
                    $dirStructure[$breakDown] += [int]$line.Split(" ")[0]
                }
            }
         }
    }
}
#Part 1:
(($dirStructure.Values | Where-Object {$_ -le 100000}) | Measure-Object -Sum).Sum

#Part 2
$fileSystem = 70000000
$needed = 30000000
$unused = ($fileSystem - $dirStructure["root"])
$toBeDeleted = $needed - $unused

($dirStructure.Values | Where-Object {$_ -ge $toBeDeleted}) | Sort-Object | Select-Object -First 1