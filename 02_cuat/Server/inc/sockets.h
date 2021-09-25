/**
 * @file sockets.h
 * @author slaborde
 * @brief Archivo de cabecera para la comunicación via sockets
 * @date 2021-09-14
 */

/* INCLUDES */
#include <sys/socket.h>     // socket();
#include <netinet/in.h>     // struct sockaddr_in
#include <unistd.h>         // close();
#include <stdio.h>          // perror();
#include <arpa/inet.h>      // inet_ntoa()


/* PROTOTYPES */
int init_socket(void);
int accept_client(int server_fd);

/* DEFINES */
#define PORT        8080
#define BACKLOG     3
#define MAX_CLIENT  2