#!/bin/bash

EXECS_CONF="$HOME/.config/hypr/custom/execs.conf"
LINE_NUMBER=8

# Verificar si la línea 8 está comentada
if sed -n "${LINE_NUMBER}p" "$EXECS_CONF" | grep -q "^#exec-once"; then
    echo "disabled"
else
    echo "enabled"
fi
