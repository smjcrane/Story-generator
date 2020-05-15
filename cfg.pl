use Math::Random::Discrete;

my $grammar = {
    "S" => Math::Random::Discrete->new([0.7,0.3], [["NP_SING", "VP_SING"], ["NP_PL", "VP_PL"]]),
    "NP_SING" => Math::Random::Discrete->new([0.3, 0.7], [["DET_SING", "ADJ", "N_SING"], ["DET_SING", "N_SING"]]),
    "NP_PL" => Math::Random::Discrete->new([0.3, 0.7], [["DET_PL", "ADJ", "N_PL"], ["DET_PL", "N_PL"]]),
    "VP_SING" => Math::Random::Discrete->new([0.1, 0.9], ["IV_SING", ["TV_SING", "NP"]]),
    "VP_PL" => Math::Random::Discrete->new([0.1, 0.9], ["IV_PL", ["TV_PL", "NP"]]),
    "DET_SING" => Math::Random::Discrete->new([0.2, 0.7, 0.1], ["a", "the", "this"]),
    "DET_PL" => Math::Random::Discrete->new([0.6, 0.1, 0.1, 0.2], ["the", "these", "those", "some"]),
    "NP" => Math::Random::Discrete->new([0.5, 0.5],["NP_SING", "NP_PL"]),
    "N_SING" => Math::Random::Discrete->new([0.1,0.1,0.2,0.4,0.3,0.2],["duckling", "piano", "cat", "spy", "robot", "cake"]),
    "N_PL" => Math::Random::Discrete->new([0.1,0.1,0.2,0.4,0.3,0.2],["ducklings", "pianos", "cats", "spies", "robots", "cakes"]),
    "ADJ" => Math::Random::Discrete->new([0.1,0.2,0.4,0.4,0.2],["purple", "mean", "clever", "big", "lost"]),
    "IV_SING" => Math::Random::Discrete->new([0.1,0.2,0.4,0.3,0.5],["skis", "studies", "cries", "thinks", "laughs"]),
    "IV_PL" => Math::Random::Discrete->new([0.1,0.2,0.4,0.3,0.5],["ski", "study", "cry", "think", "laugh"]),
    "TV_SING" => Math::Random::Discrete->new([0.1,0.1,0.1,0.2,0.3,0.4,0.1],["likes", "hits", "jumps over", "suprises", "murders", "watches", "greets"]),
    "TV_PL" => Math::Random::Discrete->new([0.1,0.1,0.1,0.2,0.3,0.4,0.1],["like", "hit", "jump over", "surprise", "murder", "watch", "greet"]),
};

sub generate {
    my $grammar = $_[0];
    my @sentence = ("S");
    my $i = 0;
    while ($i < scalar @sentence){
        $word = $sentence[$i];
        $options = $grammar->{$word};
        $replacement = $options->rand;
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