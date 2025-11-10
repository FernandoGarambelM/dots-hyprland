#!/bin/bash

EXECS_CONF="$HOME/.config/hypr/custom/execs.conf"
LINE_NUMBER=8

# Verificar si la línea 8 está comentada
if sed -n "${LINE_NUMBER}p" "$EXECS_CONF" | grep -q "^#exec-once"; then
    # Está comentada, descomentar
    sed -i "${LINE_NUMBER}s/^#//" "$EXECS_CONF"
    echo "enabled"
else
    # Está descomentada, comentar
    sed -i "${LINE_NUMBER}s/^/#/" "$EXECS_CONF"
    echo "disabled"
fi
