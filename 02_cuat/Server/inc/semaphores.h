/**
 * @file semaphores.h
 * @author slaborde
 * @brief Archivo de cabecera para IPC (comunicación entre procesos) mediante semáforos.
 * Orquesta el acceso de los procesos a un recurso compartido.
 * @date 2021-10-16
 */


/* INCLUDES */
#include <sys/shm.h>    // shmget()

int init_semaphores(key_t key);