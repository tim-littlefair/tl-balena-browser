#!/bin/sh

upstream_base_commit=2a79288
tl_beta_seq=$1
beta_suffix=$upstream_base_commit.$tl_beta_seq

sed -e "/version:/s/$/.$beta_suffix/" -i balena.yml
sed -e "1s/$/.$beta_suffix/" -i VERSION
git diff


git restore balena.yml VERSION


