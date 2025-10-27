#!/bin/bash -e
for conffile in ~/.{conkysysrc,conkyrc,conkynetrc}; do
	( conky -p 2 -c "$conffile" ) &
done
