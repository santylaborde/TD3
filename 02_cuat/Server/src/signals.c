/**
 * @file signals.c
 * @author slaborde
 * @brief funciones para el manejo de señales
 * @date 2021-10-05
 */

#include "../inc/signals.h"

/**
 * @brief inicializa las señales que utilizará el servidor
 */
int init_signals(void)
{
    if(signal(SIGUSR1, my_handler) == SIG_ERR)
    {
        perror("Signal");
        return -1;
    }

    if(signal(SIGUSR2, my_handler) == SIG_ERR)
    {
        perror("Signal");
        return -1;
    }

    if(signal(SIGCHLD, my_handler) == SIG_ERR)
    {
        perror("Signal");
        return -1;
    }

    if(signal(SIGALRM, my_handler) == SIG_ERR)
    {
        perror("Signal");
        return -1;
    }

    return 0;
}

/**
 * @brief analiza si se trata de una SIGUSR1, SIGUSR2 o SIGCHLD y actua
 * @param signum 
 */
void my_handler(int signum)
{
    if (signum == SIGUSR1)
    {
        printf("Received SIGUSR1!\n");
    }
    else if (signum == SIGUSR2)
    {
        load_config();
        printf("*****************************\n");
	    printf("** Reloading configuration **\n");
	    printf("-----------------------------\n");
	    printf("| -MAX_CLIENTS= %d\n", MAX_CLIENTS);
	    printf("| -BACKLOG_SRV= %d\n", BACKLOG_SRV);            
	    printf("| -SIZE_WINDOW= %d\n", SIZE_WINDOW);
        printf("| -CLT_TIMEOUT= %d\n", CLT_TIMEOUT);
	    printf("-----------------------------\n");
    }
    else if (signum == SIGCHLD)
    {
        close(new_socket);
        CLIENTS--;  
        printf("[SERVER] Process %d finished\n", waitpid(0, NULL, WNOHANG));
        printf("[SERVER] Number of connected clients: %d\n", CLIENTS);
    }
    else if (signum == SIGALRM)
    {
        printf("[SERVER] Client %d was %d seconds inactive\n", CLIENTS+1, CLT_TIMEOUT);
        exit(EXIT_SUCCESS);
    }
}

