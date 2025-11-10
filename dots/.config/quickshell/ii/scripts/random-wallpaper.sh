#!/usr/bin/env bash

# Script para seleccionar un wallpaper aleatorio al iniciar
WALLPAPER_DIR="$HOME/Imágenes/Wallpaper"
SCRIPT_DIR="$HOME/.config/quickshell/ii/scripts/colors"

# Verificar si existe el directorio de wallpapers
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Directorio de wallpapers no encontrado: $WALLPAPER_DIR"
    exit 1
fi

# Obtener lista de wallpapers (imágenes y videos)
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.mp4" -o -iname "*.webm" -o -iname "*.mkv" \) 2>/dev/null)

if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No se encontraron wallpapers en $WALLPAPER_DIR"
    exit 1
fi

# Seleccionar un wallpaper aleatorio
random_wallpaper="${wallpapers[RANDOM % ${#wallpapers[@]}]}"

echo "Aplicando wallpaper aleatorio: $random_wallpaper"

# Aplicar el wallpaper usando switchwall.sh
"$SCRIPT_DIR/switchwall.sh" --image "$random_wallpaper"
