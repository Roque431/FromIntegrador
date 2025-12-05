# Imágenes de Oficinas de Tránsito

## Instrucciones para agregar imágenes reales

Para usar las imágenes reales de Google Maps como las que mostraste:

### Opción 1: Imágenes locales (Recomendado)
1. Guarda las imágenes en `assets/images/transit_offices/`
2. Nombra los archivos como: `smyt-tuxtla.jpg`, `transito-municipal-tuxtla.jpg`, etc.
3. Actualiza las URLs en el datasource

### Opción 2: URLs de Street View
Reemplaza las URLs actuales con:
```
https://maps.googleapis.com/maps/api/streetview?size=600x400&location=LATITUD,LONGITUD&heading=90&pitch=0&key=TU_API_KEY
```

### Opción 3: URLs directas de Google Maps
Si tienes las URLs directas de las imágenes, puedes usarlas directamente.

## Ejemplo de la imagen real de SMYT que mostraste:
- Edificio blanco de una planta
- Letrero negro: "SECRETARÍA DE MOVILIDAD Y TRANSPORTE"
- Ubicación: 2da Avenida Sur Poniente No. 1391, Tuxtla Gutiérrez