#! bin/bash
#find /usr/share/applications/*.desktop

for i in /usr/share/applications/*.desktop; do
    [ -f "$i" ] || break


done
