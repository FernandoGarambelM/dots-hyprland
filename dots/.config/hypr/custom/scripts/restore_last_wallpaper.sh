#!/usr/bin/env bash

# Script para restaurar el último wallpaper (video o imagen) después de reiniciar
CONFIG_FILE="$HOME/.config/illogical-impulse/config.json"
RESTORE_SCRIPT="$HOME/.config/hypr/custom/scripts/__restore_video_wallpaper.sh"

# Verificar si existe el archivo de configuración
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found: $CONFIG_FILE"
    exit 1
fi

# Obtener el último wallpaper usado
wallpaper_path=$(jq -r '.background.wallpaperPath' "$CONFIG_FILE" 2>/dev/null)

if [ -z "$wallpaper_path" ] || [ "$wallpaper_path" == "null" ]; then
    echo "No wallpaper path found in config"
    exit 0
fi

# Verificar si existe el archivo
if [ ! -f "$wallpaper_path" ]; then
    echo "Wallpaper file not found: $wallpaper_path"
    exit 0
fi

# Determinar si es un video
extension="${wallpaper_path##*.}"
if [[ "$extension" == "mp4" || "$extension" == "webm" || "$extension" == "mkv" || "$extension" == "avi" || "$extension" == "mov" ]]; then
    echo "Restoring video wallpaper: $wallpaper_path"
    
    # Ejecutar el script de restauración si tiene contenido válido
    if [ -f "$RESTORE_SCRIPT" ] && [ -x "$RESTORE_SCRIPT" ]; then
        # Check if script has actual content (more than just comments)
        if grep -q "mpvpaper" "$RESTORE_SCRIPT"; then
            "$RESTORE_SCRIPT"
        else
            # Regenerate the restore script and apply
            VIDEO_OPTS="no-audio loop hwdec=auto scale=bilinear interpolation=no video-sync=display-resample panscan=1.0 video-scale-x=1.0 video-scale-y=1.0 video-align-x=0.5 video-align-y=0.5 load-scripts=no"
            pkill -f -9 mpvpaper
            sleep 0.5
            for monitor in $(hyprctl monitors -j | jq -r '.[] | .name'); do
                mpvpaper -o "$VIDEO_OPTS" "$monitor" "$wallpaper_path" &
                sleep 0.1
            done
        fi
    fi
else
    echo "Last wallpaper was an image, hyprpaper should handle it: $wallpaper_path"
fi
