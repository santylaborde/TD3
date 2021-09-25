/**
 * @file sockets.h
 * @author slaborde
 * @brief Archivo de cabecera para la comunicación via sockets
 * @date 2021-09-14
 */

/* INCLUDES */
#include <sys/socket.h>     // socket();
#include <arpa/inet.h>
#include <unistd.h>         // close();
#include <stdio.h>          // perror();


/* PROTOTYPES */
int init_socket(void);
int connect_server(int client_fd);

/* DEFINES */
#define PORT    8080
#define IP      "127.0.0.1"