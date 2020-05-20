use lib 'S:\Programming fun\perl\story generator';

use Character;

$alice = Character->newRandom();
$bob = Character->newRandom();
$charlie = Character->newRandom();

print ucfirst($alice->act_intransitively() . ".  ");
print ucfirst($bob->act_transitively($alice). ".  ");
print ucfirst($alice->act_transitively($bob) . ".  ");
print ucfirst($bob->act_intransitively() . ".  ");
print ucfirst($charlie->act_transitively($bob) . ".  ");
print ucfirst($bob->act_transitively($charlie) . ".  ");
print ucfirst($charlie->act_transitively($alice) . ".  ");
