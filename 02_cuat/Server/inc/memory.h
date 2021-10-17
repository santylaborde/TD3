/**
 * @file memory.h
 * @author slaborde
 * @brief Archivo de cabecera para IPC (comunicación entre procesos) mediante memoria compartida.
 * Permitirá que los cambios que realice un proceso puedan ser consumidos por el resto de los procesos.
 * @date 2021-10-04
 */

/* INCLUDES */
#include <sys/shm.h>    // shmget()
#include <stdlib.h>     // null
#include <stdio.h>      // perror();

/* DEFINES */
#define SHM_SIZE    1024
#define PERMISSIONS 0666 /* READ & WRITE in octal format*/
#define KEY_FILE    "./conf/ftok_key.txt"

/* PROTOTYPES */
int init_shared_memory(key_t key, int **data);