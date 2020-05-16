use lib 'S:\Programming fun\perl\story generator';

use ProbCFG;

my $pcfg = ProbCFG->new();
$pcfg->addRule("S", [["NP_SING", "VP_SING"], ["NP_PL", "VP_PL"]], [7, 3]);
$pcfg->addRule("NP_SING", [["DET_SING", "ADJ", "N_SING"], ["DET_SING", "N_SING"]], [3, 7]);
$pcfg->addRule("NP_PL", [["DET_PL", "ADJ", "N_PL"], ["DET_PL", "N_PL"]], [3, 7]);
$pcfg->addRule("VP_SING", ["IV_SING", ["TV_SING", "NP"]], [1, 9]);
$pcfg->addRule("VP_PL", ["IV_PL", ["TV_PL", "NP"]], [1, 9]);
$pcfg->addRule("DET_SING", ["a", "the", "this"], [2, 7, 1]);
$pcfg->addRule("DET_PL", ["the", "these", "those", "some"], [6, 1, 1, 2]);
$pcfg->addRule("NP", ["NP_SING", "NP_PL"]);
$pcfg->addRule("N_SING", ["duckling", "piano", "cat", "spy", "robot", "cake"], [1, 1, 2, 4, 3, 2]);
$pcfg->addRule("N_PL", ["ducklings", "pianos", "cats", "spies", "robots", "cakes"], [1, 1, 2, 4, 3, 2]);
$pcfg->addRule("ADJ", ["purple", "mean", "clever", "big", "lost"], [1, 2, 4, 4, 2]);
$pcfg->addRule("IV_SING", ["skis", "studies", "cries", "thinks", "laughs"], [1, 2, 4, 3, 5]);
$pcfg->addRule("IV_PL", ["ski", "study", "cry", "think", "laugh"], [1, 2, 4, 3, 5]);
$pcfg->addRule("TV_SING", ["likes", "hits", "jumps over", "suprises", "murders", "watches", "greets"], [1, 1, 1, 2, 3, 4, 1]);
$pcfg->addRule("TV_PL", ["like", "hit", "jump over", "surprise", "murder", "watch", "greet"], [1, 1, 1, 2, 3, 4, 1]);

$story = "";
for (1..10){
    @fnord = $pcfg->generateFrom("S");
    $story = $story.ucfirst("@fnord. ");
}
print "$story\n";