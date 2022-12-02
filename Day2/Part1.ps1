$strategy = Get-Content ./Day2/input.txt

$score = 0
foreach($round in $strategy){
    $opponent = $round.Split()[0]
    $me = $round.Split()[1]
    switch($opponent){
        "A" { # Rock
            switch($me){
                "Y" {$score += (6+2)} # Paper = 2
                "X" {$score += (3+1)} # Rock = 1
                "Z" {$score += (0+3)} # Scissors = 3
            }
        }
        "B" { # Paper
            switch($me){
                "Y" {$score += (3+2)}
                "X" {$score += (0+1)}
                "Z" {$score += (6+3)}
            }
        }
        "C" { # Scissors
            switch($me){
                "Y" {$score += (0+2)}
                "X" {$score += (6+1)}
                "Z" {$score += (3+3)}
            }
        }
    }
}

write-host $score