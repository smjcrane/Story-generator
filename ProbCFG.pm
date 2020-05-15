package ProbCFG;  # probabilistic context-free grammar

use List::MoreUtils qw(first_index);

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw(addRule, generateFrom, observe);

sub new {
    my $this = {};
    bless $this;
    return $this;
}

sub addRule {
    my $this = shift;
    my $lhs = $_[0];
    my $outs = $_[1];
    my $probs = $_[2] // [(1) x scalar @$outs];
    $this->{$lhs} = [$probs, $outs];
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
        $outputs = $this->{$word};
        $options = $outputs->[2];
        if (!( defined $options)){
           $options = Math::Random::Discrete->new(@$outputs[0], @$outputs[1]);
           $this->{$word}->[2] = $options
        }
        $replacement = $options->rand;
        if (ref($replacement) eq 'ARRAY'){
            splice(@sentence, $i, 1, @$replacement);
        } else {
            splice(@sentence, $i, 1, $replacement);
        }
        
    }
    return (@sentence);
}

sub observe {
    my $this = shift;
    my $input = @_[0];
    my $output = @_[1];
    my $freq = @_[2] // 1;
    $probs = $this->{$input}->[0];
    $all_items = $this->{$input}->[1];
    $index = first_index { $_ eq $output } @$all_items;
    $probs->[$index]+=$freq;
    $this->{$input}->[2] = undef;
}

1;