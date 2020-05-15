package ProbCFG;  # probabilistic context-free grammar

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw(addRule, generateFrom);

sub new {
    my $this = {};
    bless $this;
    return $this;
}

sub addRule {
    my $this = shift;
    my $lhs = $_[0];
    my $outs = $_[1];
    my $probs = $_[2];
    $this->{$lhs} = Math::Random::Discrete->new($probs, $outs);
}

sub generateFrom {
    my $this = shift;
    my $start = $_[0];
    my @sentence = ($start);
    my $i = 0;
    while ($i < scalar @sentence){
        $word = $sentence[$i];
        if (!(exists $this->{$word})){
            $i++;
            next;
        }
        $options = $this->{$word};
        $replacement = $options->rand;
        if (ref($replacement) eq 'ARRAY'){
            splice(@sentence, $i, 1, @$replacement);
        } else {
            splice(@sentence, $i, 1, $replacement);
        }
        
    }
    return (@sentence);
}

1;