use lib 'S:\Programming fun\perl\story generator';

use Character;

$alice = Character->newRandom();
$bob = Character->new("robot", ["shiny", "metal"]);
$charlie = Character->newRandom();

print ucfirst($alice->describe()) ." ". $alice->act_intransitively() . ".  ";
print ucfirst($alice->describe()) . " ".$alice->act_transitively($bob) . ".  ";
print ucfirst($bob->describe()) ." ". $bob->act_transitively($alice). ".  ";
print ucfirst($alice->describe()) . " ".$alice->act_transitively($bob) . ".  ";
print ucfirst($bob->describe()) ." ". $bob->act_intransitively() . ".  ";
print ucfirst($charlie->describe()) . " ".$charlie->act_transitively($bob) . ".  ";
print ucfirst($bob->describe()) . " ".$bob->act_transitively($charlie) . ".  ";






