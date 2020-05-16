package ProbCFG;  # probabilistic context-free grammar
use Math::Random::Discrete;

use List::MoreUtils qw(first_index);

require Exporter;

@ISA = qw(Exporter);

@EXPORT = qw(addRule, generateFrom, observe, isInstance);

sub new {
    my $this = {"generate"=> {}, "parse"=>{}, "max_phrase_lenght"=>0};
    bless $this;
    return $this;
}

sub addRule {
    my $this = shift;
    my $lhs = $_[0];
    my $outs = $_[1];
    my $probs = $_[2] // [(1) x scalar @$outs];
    $this->{"generate"}->{$lhs} = [$probs, $outs];
    foreach $phrase (@$outs){
        my $long_string = "";
        if (ref($phrase) eq 'ARRAY'){
            $long_string = join(" ", @$phrase);
            #$this->{"max_phrase_length"} = max($this->{"max_phrase_length"}, scalar @$phrase);
        } else {
            $long_string = $phrase;
        }
        # print "phrase $long_string is an example of a $lhs\n";
        my $rules = $this->{"parse"}->{$long_string};
        if (!(defined $rules)){
            # print "never seen that before\n";
            $this->{"parse"}->{$long_string} = [$lhs];
        } else {
            # print "a new rule for an old word\n";
            my $arr = $this->{"parse"}->{$long_string};
            push(@$arr, $lhs);
        }
    }
}

sub generateFrom {
    my $this = shift;
    my $start = $_[0];
    my @sentence = ($start);
    my $i = 0;
    while ($i < scalar @sentence){
        my $word = $sentence[$i];
        if (!(exists $this->{"generate"}->{$word})){
            $i++;
            next;
        }
        my $outputs = $this->{"generate"}->{$word};
        my $options = $outputs->[2];
        if (!( defined $options)){
           $options = Math::Random::Discrete->new(@$outputs[0], @$outputs[1]);
           $this->{"generate"}->{$word}->[2] = $options
        }
        my $replacement = $options->rand;
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
    my $probs = $this->{"generate"}->{$input}->[0];
    my $all_items = $this->{"generate"}->{$input}->[1];
    my $index = first_index { $_ eq $output } @$all_items;
    $probs->[$index]+=$freq;
    $this->{"generate"}->{$input}->[2] = undef;
}

sub isInstance {
    my $this = shift;
    my $text = $_[0];
    my $rule = $_[1];
    # print "testing $text for $rule\n";
    if ($text eq $rule){
        return 1;
    }
    my @words = split(" ",$text);
    foreach $j (0.. scalar @words){
        foreach $i ($j.. (1+scalar @words)){
            my @sentence = @words;
            my $word = join(" ", @words[$j.. $i]);
            # print "my word is $word\n";
            if (!(exists $this->{"parse"}->{$word})){
                # print "no such word\n";
                next;
            }
            my $rules = $this->{"parse"}->{$word};
            # print "I will allow $word to be any of @$rules\n";
            foreach my $replacement (@$rules){
                if (($i+1 == scalar @sentence) && ($j == 0)){
                    # print "replacing whole thing\n";
                    @sentence = ($replacement);
                } elsif ($j == 0) {
                    @sentence = ($replacement, @sentence[$i + 1.. scalar @sentence],);
                } else {
                    @sentence = (@sentence[$0..$j-1], $replacement, @sentence[$i + 1.. scalar @sentence],);
                }
                #splice(@sentence, $j, $i, $replacement);
                # print "my replaced sentence is @sentence\n";
                if ($this->isInstance(join(" ", @sentence), $rule)){
                    return 1;
                }
            }
        }
    }
    
    return "";
}

1;