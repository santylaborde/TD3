/**
 * @file memory.c
 * @author slaborde
 * @brief funciones para IPC (comunicación entre procesos) mediante memoria compartida
 * Permitirá que los cambios que realice un proceso puedan ser consumidos por el resto de los procesos.
 * @date 2021-10-04
 */
#include "../inc/memory.h"

/**
 * @brief inicializa la memoria compartida
 * @return int (id de la memoria compartida)
 */
int init_shared_memory(key_t key, int **data)
{
    /**
     * @brief Crea un area de memoria compartida
     * @param key: llave para acceder a la memoria compartida, generada con ftok().
     * @param size: tamaño de la memoria compartida
     * @param flag: para acceder o crear la memoria compartida
     */
    int shmid= shmget(key, SHM_SIZE, PERMISSIONS | IPC_CREAT);
    
    if (shmid == -1) 
    {
        perror("shmget failed");
        return -1;
    }
    
    /**
     * @brief Une al proceso actual a la memoria compartida para poder utilizarla
     * @param shmid: identificador de la memoria compartida
     * @param shmaddr: dirección de la memoria compartida (el SO la resuelve)
     * @param shmflg
     */
    *data = shmat(shmid, NULL, 0);
    if (*data == (int*)-1)
    {
        perror("shmat failed");
        return -1;
    }

    return shmid;
}
