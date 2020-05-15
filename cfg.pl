use Math::Random::Discrete;

my $grammar = {
    "S" => [["NP_SING", "VP_SING"], ["NP_PL", "VP_PL"]],
    "NP_SING" => [["DET_SING", "ADJ", "N_SING"], ["DET_SING", "N_SING"]],
    "NP_PL" => [["DET_PL", "ADJ", "N_PL"], ["DET_PL", "N_PL"]],
    "VP_SING" => ["IV_SING", ["TV_SING", "NP"]],
    "VP_PL" => ["IV_PL", ["TV_PL", "NP"]],
    "DET_SING" => ["a", "the", "this"],
    "DET_PL" => ["the", "these", "those", "some"],
    "NP" => ["NP_SING", "NP_PL"],
    "N_SING" => ["duckling", "piano", "cat", "spy", "robot", "cake"],
    "N_PL" => ["ducklings", "pianos", "cats", "spies", "robots", "cakes"],
    "ADJ" => ["purple", "mean", "clever", "big", "lost"],
    "IV_SING" => ["skis", "studies", "cries", "thinks", "laughs"],
    "IV_PL" => ["ski", "study", "cry", "think", "laugh"],
    "TV_SING" => ["likes", "hits", "jumps over", "suprises", "murders", "watches", "greets"],
    "TV_PL" => ["like", "hit", "jump over", "surprise", "murder", "watch", "greet"],
};

sub generate {
    my $grammar = $_[0];
    my @sentence = ("S");
    my $i = 0;
    while ($i < scalar @sentence){
        $word = $sentence[$i];
        $options = $grammar->{$word};
        $replacement = $options->[rand(scalar @$options)];
        if (ref($replacement) eq 'ARRAY'){
            splice(@sentence, $i, 1, @$replacement);
        } else {
            splice(@sentence, $i, 1, $replacement);
        }
        if (!(exists $grammar->{$sentence[$i]})){
            $i++;
        }
    }
    return (@sentence);
};

$story = "";
for (1..10){
    @fnord = generate($grammar);
    $story = $story.ucfirst("@fnord. ");
}
print "$story";