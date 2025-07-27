#! /bin/bash

balena device ssh $1 <<+
balena-engine container stop browser_1_1_10ca12e1ea5e
+

balena push --nolive --detached $1
