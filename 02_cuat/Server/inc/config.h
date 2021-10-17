/**
 * @file config.h
 * @author slaborde
 * @brief Archivo de cabecera para el manejo de archivos de configuración
 * @date 2021-10-05
 */

/* INCLUDES */
#include <stdio.h>      // fopen()
#include <string.h>     // strcmp()
#include <stdlib.h>     // malloc()

/* DEFINES */
#define CONFIG_FILE "./conf/server.yml"

/* PROTOTYPES */
int load_config(void);
