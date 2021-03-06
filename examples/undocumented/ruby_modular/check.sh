#!/bin/bash

if test -z "$1"
then
	for i in *.rb;
	do
		echo -n $i

		if ruby -I../../../src/interfaces/ruby_modular $i >/dev/null 2>&1
		then
			echo " OK"
		else
			echo " FAIL"
		fi
	done
else
	ruby -I../../../src/interfaces/ruby_modular $1
fi
