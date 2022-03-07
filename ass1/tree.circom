pragma circom 2.0.0;

include "mimcsponge.circom";

template MerkleTree(n) {
  signal input values[n];
  signal output root;
  
  var hashedLeafs[n];
  component hashers[n];
  for (var i = 0; i < n; i++) {
    // a component to hash one input to a single hash
    hashers[i] = MiMCSponge(1, 220, 1);
    hashers[i].k <== 0;
    hashers[i].ins[0] <== values[i];
    hashedLeafs[i] = hashers[i].outs[0];
  }

  // declares more components than needed, could be optimized
  // by calculating the number of nodes in the tree
  component doubleHashers[n];

  var nodesAtCurrentLevel = n;
  var whichHasher = 0;
  while (nodesAtCurrentLevel > 1) {
    // step counter moving one step per iteration
    // marks where to write the result to
    var singleStep = 0;
    for (var node = 0; node < nodesAtCurrentLevel; node += 2) {
      // a component to hash two inputs to a single hash
      doubleHashers[whichHasher] = MiMCSponge(2, 220, 1);
      doubleHashers[whichHasher].k <== 0;
      doubleHashers[whichHasher].ins[0] <== hashedLeafs[node];
      doubleHashers[whichHasher].ins[1] <== hashedLeafs[node + 1];
      hashedLeafs[singleStep] = doubleHashers[whichHasher].outs[0];
      whichHasher++;
      singleStep++;
    }
    nodesAtCurrentLevel = singleStep;
  }

  root <== hashedLeafs[0];
  
}

component main = MerkleTree(8);
