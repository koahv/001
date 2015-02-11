#!/bin/bash
(cd dwm-6.0;		make clean install)
(cd st-0.5;		make clean install)
(cd tmux-1.9a;		./configure && make; make install )
(cd tmux-mem-cpu-load	cmake .; make; make install)
