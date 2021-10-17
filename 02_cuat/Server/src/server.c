/**
 * @file server.c
 * @author slaborde
 * @brief Archivo principal del servidor
 * @date 2021-09-14
 */

#include "../inc/server.h"

int RUNNING= 1;
int CLIENTS= 0;
int new_socket;

int main()
{
	/*---------------- INIT CONFIG FILE --------------*/
	int status= load_config();

	if (status == -1) 
	{   
		exit(EXIT_FAILURE);
	} 

	printf("*****************************\n");
	printf("*** Loading configuration ***\n");
	printf("-----------------------------\n");
	printf("| -MAX_CLIENTS= %d\n", MAX_CLIENTS);
	printf("| -BACKLOG_SRV= %d\n", BACKLOG_SRV);            
	printf("| -SIZE_WINDOW= %d\n", SIZE_WINDOW);
	printf("| -CLT_TIMEOUT= %d\n", CLT_TIMEOUT);
	printf("-----------------------------\n");
	
	/*---------------- INIT SIGNALS ------------------*/
	status= init_signals();

	if(status == -1)
	{
		exit(EXIT_FAILURE);
	}

	/**
     * @brief Crea una llave, apartir del id de un archivo y del proj_id, para utilizar una memoria compartida.
     * @param File: archivo con su respectiva ruta.
     * @param proj_id: se utilizan solo los 8 bits menos significativos.
     */
    key_t key = ftok(KEY_FILE, 'S');

    if (key == -1)
    {
        perror("ftok failed");
        exit(1);
    }

    /*---------------- INIT SHARED MEMORY ------------*/
	int *memoryAddress;
	int shmid = init_shared_memory(key, &memoryAddress);
	
	if (shmid < 0)
	{
		exit(EXIT_FAILURE);
	}

	/*---------------- INIT SEMAPHORES ------------*/
	// int *memoryAddress;
	// int shmid = init_semaphores(key);
	
	// if (shmid < 0)
	// {
	// 	exit(EXIT_FAILURE);
	// }

	/*---------------- INIT SOCKET -------------------*/
	int server_fd = init_socket();	// file descriptor del server socket
	
	if(server_fd == -1)
	{
		exit(EXIT_FAILURE);
	}
	
	/*------------- WACTH FILE DESCRIPTORS ------------*/	
	int time= -1;			 
	pid_t new_pid;
	int sensor_value;

	int ready_fd;
	int greater_fd= server_fd;

	int valread;
	char buffer[1024] = {0};
	char *ack = "Message Received";	

	/*------------------- MAIN LOOP ------------------*/
	while(RUNNING) 					// main loop
	{
		fd_set read_fds;			// list of readable file descriptors for being watched
		FD_ZERO(&read_fds);
		FD_SET(server_fd, &read_fds);

		struct timeval timeout;
		timeout.tv_sec =  1;
		timeout.tv_usec = 0;

		/**
		 * @brief Monitorea múltiples file descriptors, esperando a que uno este READY
		 */
		ready_fd = select(greater_fd+1, &read_fds, NULL, NULL, &timeout);

		switch(ready_fd)
		{
			case -1: 	/* ERROR */
				if (errno != EINTR)	// SIGNAL no capturada
				{
					perror("[SERVER] select");
					exit(EXIT_FAILURE);
				}
				break;
			
			case 0:		/* TIME OUT */
				if(!CLIENTS)		// Mensaje de esperando conexión
				{
					waiting(time);
					time++;
				}
			 	break;

			default:	/* FD READY */
				time= -1;
				
				/*---------------- SOCKET READY ------------------*/
				if(FD_ISSET(server_fd, &read_fds))
				{
					new_socket = accept_client(server_fd);

					/*----------------- MULTIPROCESO ------------------*/
					/**
					 * @brief crea un proceso hijo duplicado del proceso padre que lo llama.
					 */
					new_pid = fork();

					switch (new_pid)
					{
						case FORK_ERROR:	/* ERROR */
							perror("[SERVER] fork:\n");
							exit(EXIT_FAILURE);
							break;

						case CHILD:			/* CHILD */

							if (CLIENTS > MAX_CLIENTS)
							{
								perror("[SERVER] Too many clients connected, try again later\n");
								exit(EXIT_FAILURE);
							}
							
							while(CLIENT_CONNECTED)
							{
								alarm(CLT_TIMEOUT);  // Cuenta el tiempo de inactividad del cliente 

								/* RECIBE DATOS */
								valread= recv(new_socket , buffer, 1024, 0);
								
								switch (valread)
								{
									case -1:
										perror("[SERVER] recv:\n");
										break;

									case 0:
										if(buffer[0]!='\0')
										{
											printf("new_socket is %d\n", new_socket);
											printf("[SERVER] Client %d disconnected\n", CLIENTS+1);
											buffer[0]='\0';																					

											exit(EXIT_SUCCESS);	// Termina el proceso hijo que atendió al cliente
										}
										break; 
									
									default:
										alarm(0);  // Reinicia el tiempo de inactividad del cliente 

										/* IMPRIME DATOS */
										printf("El pid del hijo es: %d\n", getpid());
										printf("[CLIENT%d] %s\n", CLIENTS+1, buffer);
										
										/* ENVIA DATOS SENSOR */
										if(!strcmp(buffer,REQUEST_DATA))
										{
											sensor_value= rand();
											send(new_socket, &sensor_value , sizeof(int) , 0 );
										}

										/* ENVIA ACKNOWLEDGEMENT */
										send(new_socket , ack , strlen(ack) , 0 );
										break;
								}
							}

							break;

						default:		/* PARENT */
							CLIENTS++; 	
							printf("[SERVER] Client: %d assisted by the PID: %d\n", CLIENTS, new_pid);		
							close(new_socket);
							break;
					}
				}
				/*--------------------- ERROR ---------------------*/
           		else
				{

				}
               
			   	break;
		}
	}

    close(server_fd);
	
	return EXIT_SUCCESS;
}

/**
 * @brief Imprime el mensaje de esperando conexiones
 * @param time 
 */
void waiting(int time)
{
	switch (time%4)
	{
		case -1:  
			printf("[SERVER] Waiting for conections   \n");
			break;

		case 0:  
			printf("\033[F");
			printf("[SERVER] Waiting for conections   \n");
			break;

		case 1: 
			printf("\033[F");
			printf("[SERVER] Waiting for conections.  \n");
			break;
		
		case 2: 
			printf("\033[F");
			printf("[SERVER] Waiting for conections.. \n");
			break;
		
		case 3: 
			printf("\033[F");
			printf("[SERVER] Waiting for conections...\n");
			break;

		default:
		break;
	}

	fflush(stdout);       /* Actualizamos la pantalla */
}