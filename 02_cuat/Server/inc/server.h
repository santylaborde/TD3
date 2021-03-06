/**
 * @file server.h
 * @author slaborde
 * @brief Archivo de cabecera del servidor
 * @date 2021-09-14
 */

/* INCLUDES */
#include "sockets.h"
#include "fork.h"
#include "memory.h"
#include "config.h"
#include "signals.h"

#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <time.h>

/* EXTERNS */
extern int MAX_CLIENTS;  // Cantidad Máxima de Conexiones
extern int BACKLOG_SRV;  // Cantidad de pedidos de conexión que bufferea
extern int SIZE_WINDOW;  // Tamaño de la ventana del filtro
extern int CLT_TIMEOUT;  // Tiempo máximo de inactividad del cliente

/* DEFINES */
#define CLIENT_CONNECTED    1
#define REQUEST_DATA        "sensor"

/* PROTOTYPES */
void waiting(int);
