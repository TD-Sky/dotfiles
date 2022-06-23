#!/usr/bin/sh

if [ -z "$(procs 'xwinwrap' | rg 'xwinwrap ')" ] ; then
    size=1920x1080
    video_wp="${HOME}/Videos/哲♂学/浪子♂回头.flv"
    _mute_=yes

    xwinwrap -g ${size} -ni -s -nf -b -un -ov -fdt -argb \
            -- mpv --mute=${_mute_} --no-osc --no-osd-bar \
            --quiet --screen=0 --geometry=${size}+0+0 -wid WID \
            --loop ${video_wp}
fi

