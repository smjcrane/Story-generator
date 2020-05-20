package Character;
use experimental 'smartmatch';

use Math::Random::Discrete;
use Array::Utils qw(:all);

require Exporter;
@ISA = qw(Exporter);

@EXPORT = qw(newRandom, describe, act_intransitively, act_transitively);

$available_names = ["duck", "piano", "cat", "spy", "burglar", "firefighter", "robot"];
$all_attrs = [
    ["unusual", "lovely", "beautiful"],  
    ["big", "little", "tiny"], 
    ["clever", "silly"],  
    ["mean", "kind"],  
    ["happy", "bored"], 
    ["young", "ancient"], 
    ["purple", "green"], 
    ["metal", "wooden", "plastic"],
];
$all_intransitive_actions = ["laughs", "smiles", "studies", "dances", "snores", "hesitates", "does nothing"];
$all_transitive_actions = ["likes", "hits", "jumps over", "surprises", "murders", "watches", "greets", "hugs", "forgives", "ignores", "eats", "pokes"];
$forbidden_actions = {
    "happy" => ["hits", "pokes"],
    "bored" => ["laughs", "smiles", "dances", "hugs"],
    "dead" => ["pokes", "laughs", "smiles", "studies", "dances", "snores", "hesitates", "surprises", "likes", "hits", "jumps over", "murders", "watches", "greets", "hugs", "eats"],
    "mean" => ["hugs", "forgives"],
    "kind" => ["hits", "murders", "ignores"],
    "silly" => ["studies"],
};
$effects = {
    "surprises" => {"add"=> [], "remove"=> ["bored", "asleep"]},
    "murders" => {"add"=> ["dead"], "remove"=> ["happy", "bored", "asleep"]},
    "hugs" => {"add"=> ["happy"], "remove"=> []},
    "eats" => {"add"=> ["dead"], "remove"=> ["happy", "bored", "asleep"]},
    "forgives" => {"add"=> ["happy"], "remove"=> []},
    "likes" => {"add"=> ["happy"], "remove"=> []},
    # "" => {"add"=> [], "remove"=> []},
};

sub new {
    shift;
    my $name = $_[0] // "character";
    my $attrs = $_[1] // ["mysterious"];
    my $this = {
        "name" => $name, 
        "attrs" => $attrs,
        "introduced" => "",
    };
    bless $this;
    return $this;
}

sub newRandom {
    my $index = int(rand(scalar @$available_names));
    my $name = $available_names->[$index];
    splice(@$available_names, $index, 1);
    # get 2 orthogonal attrs
    my $attr_1_index = int(rand((scalar @$all_attrs)));
    my $attr_2_index = -1;
    do {
        $attr_2_index = int(rand((scalar @$all_attrs)));
    } while ($attr_1_index == $attr_2_index);
    if ($attr_1_index > $attr_2_index){
        my $temp = $attr_1_index;
        $attr_1_index = $attr_2_index;
        $attr_2_index = $temp;
    }
    my $attr_1_options = $all_attrs->[$attr_1_index];
    my $attr1 = $attr_1_options->[int(rand(scalar @$attr_1_options))];
    my $attr_2_options = $all_attrs->[$attr_2_index];
    my $attr2 = $attr_2_options->[int(rand(scalar @$attr_2_options))];
    my $attrs = [$attr1, $attr2];
    return new(Character, $name, $attrs)
}

sub describe {
    my $this = shift;
    my $name = $this->{"name"};
    if ($this->{"introduced"}){
        return "the $name";
    }
    $this->{"introduced"} = 1;
    my $attrs = $this->{"attrs"};
    if ("@$attrs" =~ /^[aeiou]+/){
        return "an @$attrs $name";
    }
    return "a @$attrs $name";
}

sub act_intransitively {
    my $this = shift;
    my @allowed = @$all_intransitive_actions;
    my $attrs = $this->{"attrs"};
    foreach $attr (@$attrs) {
        my $forbidden = $forbidden_actions->{$attr};
        if (defined $forbidden){
            @allowed = array_minus(@allowed, @$forbidden)
        }
    }
    my $verb_index = int(rand(scalar @allowed));
    my $verb = @allowed[$verb_index];
    return describe($this)." ".$verb;
}

sub act_transitively {
    my $this = shift;
    my $object = $_[0];
    bless $object;
    my @allowed = @$all_transitive_actions;
    my $attrs = $this->{"attrs"};
    foreach $attr (@$attrs) {
        my $forbidden = $forbidden_actions->{$attr};
        if (defined $forbidden){
            @allowed = array_minus(@allowed, @$forbidden)
        }
    }
    my $verb_index = int(rand(scalar @allowed));
    my $verb = @allowed[$verb_index];
    my $out = describe($this)." ".$verb." ".describe($object);
    $object->update_attrs($effects->{$verb});
    my $adds = $effects->{$verb}->{"add"};
    if (scalar @$adds){
        return $out.". ".ucfirst(describe($object))." is ".join(" and ", @$adds);
    }
    return $out;
}

sub update_attrs {
    my $this = shift;
    my $updates = $_[0];
    my $adds = $updates->{"add"};
    my $removes = $updates->{"remove"};
    my $attrs = $this->{"attrs"};
    $this->{"attrs"} = [unique(@$adds, array_minus(@$attrs, @$removes))];
}

1;