use lib 'S:\Programming fun\perl\story generator';

use ProbCFG;

my $pcfg = ProbCFG->new();
$pcfg->addRule("S", ["a", "b"]);

$generated = join(" ", $pcfg->generateFrom("S"));
print "generated $generated\n";
if ($generated eq "a"){
    print "Generation test passed!"
} elsif ($generated eq "b"){
    print "Generation test passed!";
} else {
    print "Generation test failed!";
}

print "\n";

$parsed = $pcfg->isInstance("a", "S");
if ($parsed){
    print "Parse test passed!";
} else {
    print "Parse test failed!";
}

print "\n";

my $pcfg = ProbCFG->new();
$pcfg->addRule("S", ["a", "b", "T"]);
$pcfg->addRule("T", ["c"]);

$parsed = $pcfg->isInstance("c", "S");
if ($parsed){
    print "Nested parse test passed!";
} else {
    print "Nested parse test failed!";
}

print "\n";


my $pcfg = ProbCFG->new();
$pcfg->addRule("S", [["a", "b"]]);

$parsed = $pcfg->isInstance("a b", "S");
if ($parsed){
    print "Array parse test passed!";
} else {
    print "Array parse test failed!";
}

print "\n";

my $pcfg = ProbCFG->new();
$pcfg->addRule("S", [["T", "b"]]);
$pcfg->addRule("T", ["a", ["c", "d"]]);

$parsed = $pcfg->isInstance("c d b", "S");
if ($parsed){
    print "Nested array parse test passed!";
} else {
    print "Nested array parse test failed!";
}

print "\n";

my $pcfg = ProbCFG->new();
$pcfg->addRule("S", [["T", "U"]]);
$pcfg->addRule("T", ["a"]);
$pcfg->addRule("U", ["b"]);

$parsed = $pcfg->isInstance("a b", "S");
if ($parsed){
    print "Final parse test passed!";
} else {
    print "Final parse test failed!";
}

print "\n";

