/**
 * @file server.c
 * @author slaborde
 * @brief Archivo principal del servidor
 * @date 2021-09-14
 */

#include "../inc/server.h"
#include <sys/types.h>
#include <sys/wait.h>

int RUNNING= 1;

int main()
{
	int valread;
	char buffer[1024] = {0};
	char *ack = "Message Received";
	
	/*---------------- INIT CONFIG FILE ---------------*/
	int file_fd = 0;
	
	/*------------------ INIT SOCKET ------------------*/
	int server_fd = init_socket();	// file descriptor del server socket
	
	if(server_fd == -1)
	{
		exit(EXIT_FAILURE);
	}
	
	/*------------- WACTH FILE DESCRIPTORS ------------*/	
	int time= -1;			// 
	int childs= 0;			// child counter
	pid_t new_pid;
	int pid_status;
	int sensor_value;

	int ready_fd;
	int greater_fd;

	if(file_fd > server_fd)
		greater_fd = file_fd;
	else
		greater_fd = server_fd;		

	/*------------------- MAIN LOOP ------------------*/
	while(RUNNING) 					// main loop
	{
		fd_set read_fds;			// list of readable file descriptors for being watched
		FD_ZERO(&read_fds);
		FD_SET(file_fd, &read_fds);
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
			case -1: 	/* ERROR  chequear EINTR*/
				perror("[SERVER] select");
				exit(EXIT_FAILURE);
				break;
			
			case 0:		/* TIME OUT */
				// waiting(time);
				time++;
			 	break;

			default:	/* FD READY */
				time= -1;
				/*--------------- CONFIG FILE READY --------------*/
			 	if(FD_ISSET(file_fd, &read_fds))
				{

				}
				/*---------------- SOCKET READY ------------------*/
				else if(FD_ISSET(server_fd, &read_fds))
				{
					int new_socket = accept_client(server_fd);

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

							if (childs > MAX_CLIENT)
							{
								perror("[SERVER] Too many clients connected, try again later");
								exit(EXIT_FAILURE);
							}
							
							while(CLIENT_CONNECTED)
							{
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
											printf("[SERVER] Se desconecto el cliente %d\n", childs+1);
											buffer[0]='\0';
										}
										break; 
									
									default:
										printf("[CLIENT%d] %s\n", childs+1, buffer);

										if(!strcmp(buffer,REQUEST_DATA))
										{
											sensor_value= rand();
											send(new_socket , &sensor_value , sizeof(int) , 0 );
										}
										break;
								}

								/* ENVIA DATOS */
								send(new_socket , ack , strlen(ack) , 0 );
							}
							
							break;

						default:		/* PARENT */
							childs++; 	
							printf("[SERVER] Cliente: %d atendido por PID: %d\n", childs, new_pid);		
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

    	new_pid=waitpid(0, &pid_status, 1);

    	if (new_pid>0)
		{
			childs--;   
			printf("[SERVER] Cantidad actual de clientes: %d \n", childs);
		}
	}

    close(server_fd);
	
	return EXIT_SUCCESS;
}

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
			// printf("\033[3D");
			printf("[SERVER] Waiting for conections...\n");
			break;

		default:
		break;
	}

	fflush(stdout);       /* Actualizamos la pantalla */
}