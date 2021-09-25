/**
 * @file client.c
 * @author slaborde
 * @brief Archivo principal del cliente
 * @date 2021-09-14
 */

#include "../inc/client.h"

int main(int argc, char const *argv[])
{
	int valread;
	char *hello = "Hello from client";
	char buffer[1024] = {0};
	int sensor_value;

	/*--------------- SOCKETS ---------------*/
	/* INICIALIZA CLIENTE */
	int client_fd = init_socket(); // file descriptor del socket del cliente

	if(client_fd == -1)
	{
		exit(EXIT_FAILURE);
	}

	/* CONECTA AL SERVIDOR */
	int conection= connect_server(client_fd);

	if(conection == -1)
	{
		exit(EXIT_FAILURE);
	}

	while(1)
	{
		/* INGRESAN DATOS*/
		printf("[CLIENT] Send a message: ");
		scanf("%s",buffer);

		/* ENVIA DATOS */
		send(client_fd, buffer, strlen(hello) , 0 );
		printf("[CLIENT] Message sent\n");

		if(!strcmp(buffer,REQUEST_DATA))
		{
			/* RECIBE DATOS */
			valread = read(client_fd, &sensor_value, sizeof(int));
			if(valread != -1)
				printf("[SERVER] %d\n", sensor_value);
		}
		else
		{
			/* RECIBE DATOS */
			valread = read(client_fd, buffer, 1024);
			if(valread != -1)
				printf("[SERVER] %s\n", buffer);
		}
	}

	// close the socket
    close(client_fd);

	return 0;
}
