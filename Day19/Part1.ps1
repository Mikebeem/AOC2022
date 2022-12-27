$stopwatch = [System.Diagnostics.Stopwatch]::new()
$Stopwatch.Start()

#Change if you run this on another day
$day=19

#Comment next line for run with input
$puzzleInput = (Get-Content ./Day$day/sample.txt)
$puzzleInput = (Get-Content ./Day$day/input.txt)
foreach($blueprint in $puzzleInput){
    [int]$bluePrintId, [int]$oreCosts, [int]$clayCosts, [int]$obsidianOre, [int]$obsidianClay, [int]$geodeOre, [int]$geodeObsidian = (($blueprint.toCharArray() | ForEach-Object {
            if($_ -Match '\d' -or $_-match " "){
                $_
            }
        }) -Join "") -split " " | ForEach-Object {
            if($_ -match '\d'){
                $_
            }
        }
    $maxOreBots = [System.Math]::Max($clayCosts,[System.Math]::Max($obsidianOre,$geodeOre))
    $maxClayBots = $obsidianClay
    $maxObsidianBots = $geodeObsidian

    $oreRobots = 1
    $clayRobots = $obsidianRobots = 0
    $ore=$clay=0
    $topGeo = 0

    $resources = @($oreRobots,$clayRobots,$obsidianRobots,0,0,0,0,0)
    $minutesLeft = 24
    $q = New-Object System.Collections.Queue
    $q.Enqueue($resources)

    while ($q.Count -gt 0) {
        $resource = $q.Dequeue()
        $oreRobots,$clayRobots,$obsidianRobots,$ore,$clay,$obs,$geo,$minutes = $resource
        
        $oreTime = [System.Math]::Max([System.Math]::Ceiling(($oreCosts - $ore)/$oreRobots) + 1,1)
        $clayTime = [System.Math]::Max([System.Math]::Ceiling(($clayCosts - $ore)/$oreRobots) + 1,1)
        if($clayRobots -gt 0){
            $obsidianCosts = [System.Math]::Max([System.Math]::Max([System.Math]::Ceiling(($obsidianOre-$ore)/$oreRobots),[System.Math]::Ceiling(($obsidianClay-$clay)/$clayRobots)) + 1,1)
        }            
        if($obsidianRobots -gt 0){
            $geodeCosts = [System.Math]::Max([System.Math]::Max([System.Math]::Ceiling(($geodeOre-$ore)/$oreRobots),[System.Math]::Ceiling(($geodeObsidian-$obs)/$obsidianRobots)) + 1,1)
        }
        if($minutes -eq 0){
            $q.Enqueue(@(($oreRobots+1),$clayRobots,$obsidianRobots,($ore+1),$clay,$obs,$geo,($minutes+$oreTime)))
            $q.Enqueue(@($oreRobots,($clayRobots+1),$obsidianRobots,($ore+1),$clay,$obs,$geo,($minutes+$clayCosts+1)))
        }
        elseif($oreRobots -lt $maxOreBots -and ($minutes+$oreTime) -le 12){
            $q.Enqueue(@(($oreRobots+1),$clayRobots,$obsidianRobots,($ore+($oreRobots*$oreTime)-$oreCosts),($clay+($clayRobots*$oreTime)),($obs+($obsidianRobots*$clayTime)),$geo,($minutes+$oreTime)))
        }
        if($clayRobots -lt $maxClayBots -and ($minutes+$clayTime) -le 18){
            #When clayrobots > 0, choose to buy more
            $q.Enqueue(@($oreRobots,($clayRobots+1),$obsidianRobots,($ore+($oreRobots*$clayTime)-$clayCosts),($clay+($clayRobots*$clayTime)),($obs+($obsidianRobots*$clayTime)),$geo,($minutes+$clayTime)))
        }
        if($clayRobots -ge 1 -and $obsidianRobots -eq 0 -and ($minutes+$obsidianCosts) -le 23){
            #When clayrobots, build obs robot
            $q.Enqueue(@($oreRobots,$clayRobots,($obsidianRobots+1),($ore+($oreRobots*$obsidianCosts)-$obsidianOre),($clay+($clayRobots*$obsidianCosts)-$obsidianClay),($obs+($obsidianRobots*$obsidianCosts)),$geo,($minutes+$obsidianCosts)))
        }
        if($obsidianRobots -ge 1 -and $obsidianRobots -lt $maxObsidianBots -and ($minutes+$obsidianCosts) -le 23){
            #When clayrobots, build obs robot
            $q.Enqueue(@($oreRobots,$clayRobots,($obsidianRobots+1),($ore+($oreRobots*$obsidianCosts)-$obsidianOre),($clay+($clayRobots*$obsidianCosts)-$obsidianClay),($obs+($obsidianRobots*$obsidianCosts)),$geo,($minutes+$obsidianCosts)))
        }
        if($obsidianRobots -ge 1){
            #When obsidianRobots, build geo cracking bots
            $geo = ($geo+($minutesLeft-($minutes+$geodeCosts)))
            if(($minutes+$geodeCosts) -lt 24){
                $q.Enqueue(@($oreRobots,$clayRobots,$obsidianRobots,($ore+($oreRobots*$geodeCosts)-$geodeOre),($clay+($clayRobots*$geodeCosts)),($obs+($obsidianRobots*$geodeCosts)-$geodeObsidian),$geo,($minutes+$geodeCosts)))
            }
            if(($minutes+$geodeCosts) -le 24){
                if($topGeo -le $geo){
                    $topGeo = $geo
                }
            }
        }
    }
    $total+=($topGeo*$bluePrintId)
    "Blueprint: $bluePrintId - topGeo: $topGeo ; $($topGeo*$bluePrintId) - totaal $total"
}
$qualityLevels
$Stopwatch.Stop()
write-host ("That took {0} Milliseconds, {1} seconds" -f $Stopwatch.Elapsed.TotalMilliseconds, $stopwatch.Elapsed.TotalSeconds)
