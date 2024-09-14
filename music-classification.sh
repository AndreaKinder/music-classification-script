#!/bin/bash
carpeta="/home/$user/Música/"

# Buscamos todos los archivos .mp3 dentro de la carpeta y sus subcarpetas
find "$carpeta" -type f -name "*.mp3" -exec bash -c '
    archivo_mp3="$1"
    ruta_archivo_mp3=$(realpath "$archivo_mp3")

    # Intentamos obtener el artista y el álbum de los metadatos del archivo
    artista=$(ffprobe -v error -show_entries format_tags=artist -of default=noprint_wrappers=1:nokey=1 "$archivo_mp3" 2>/dev/null)
    album=$(ffprobe -v error -show_entries format_tags=album -of default=noprint_wrappers=1:nokey=1 "$archivo_mp3" 2>/dev/null)

    # Si no se pudo obtener la información de los metadatos, preguntamos al usuario
    if [ -z "$artista" ] || [ -z "$album" ]; then
        echo "No se pudo obtener el artista y/o álbum de los metadatos para $archivo_mp3"
        echo "Por favor, introduce el artista:"
        read artista
        echo "Por favor, introduce el álbum:"
        read album
    fi

    # Creamos los directorios necesarios si no existen
    directorio_album="/home/$user/Música/$artista/$album"
    mkdir -p "$directorio_album"

    # Movemos el archivo al directorio correspondiente
    mv "$ruta_archivo_mp3" "$directorio_album"
    echo "Movido $archivo_mp3 a $directorio_album"
' _ {} \;
