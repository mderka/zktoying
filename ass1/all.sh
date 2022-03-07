#!/bin/bash

npx snarkjs powersoftau new bn128 15 pot15_0000.ptau -v
npx snarkjs powersoftau contribute pot15_0000.ptau pot15_0001.ptau --name="First contribution" -v
npx snarkjs powersoftau prepare phase2 pot15_0001.ptau pot15_final.ptau -v
npx snarkjs groth16 setup tree.r1cs pot15_final.ptau tree_0000.zkey
npx snarkjs zkey contribute tree_0000.zkey tree_0001.zkey --name="1st Contributor Name" -v
npx snarkjs zkey export verificationkey tree_0001.zkey verification_key.json
npx snarkjs groth16 prove tree_0001.zkey tree_js/witness.wtns proof.json public.json
