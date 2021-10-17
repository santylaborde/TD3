/**
 * @file signals.h
 * @author slaborde
 * @brief Archivo de cabecera para el manejo de señales
 * @date 2021-10-05
 */

/* INCLUDES */
#include "config.h"

#include <signal.h>
#include <stdio.h>
#include <sys/wait.h>   // waitpid()
#include <unistd.h>     // close()

/* EXTERNS */
extern int MAX_CLIENTS;  // Cantidad Máxima de Conexiones
extern int BACKLOG_SRV;  // Cantidad de pedidos de conexión que bufferea
extern int SIZE_WINDOW;  // Tamaño de la ventana del filtro
extern int CLT_TIMEOUT;  // Tiempo máximo de inactividad del cliente
extern int CLIENTS;      // Número actual de clientes
extern int new_socket;   // Socket del cliente

/* PROTOTYPES */
int init_signals(void);
void my_handler(int signum);