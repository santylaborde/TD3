/**
 * @file sockets.c
 * @author slaborde
 * @brief funciones para la comunicación via socket
 * @date 2021-09-14
 */

#include "../inc/sockets.h"

/**
 * @brief inicializa la comunicación del cliente
 * @return int (file descriptor or error)
 */
int init_socket(void)
{
    /*************************  CREA LA CONEXIÓN    *************************/
    /**
     * @brief Crea un objeto "socket" en el sistema y obtiene su file descriptor.
     * SOCKET = Es un canal de comunicación bidireccional entre dos procesos que puede manejarse mediante un simple file descriptor.
     * @param domain: especifica la familia del protocolo de comunicación. 
     * AF_INET = IPv4 Internet protocols
     * @param type: especifica el tipo de socket. 
     * SOCK_STREAM =  Para comunicaciones confiables en modo conectado, de dos vías y con tamaño variable de los mensajes de datos. Cuando transmitimos recibimos si llego bien paquete. Importante para transmitir archivos.
     * @param protocol: en caso de querer usar múltiples protocolos.
     * @return file descriptor del socket 
     * client_fd = Se comporta como un conector a un canal de comunicaciones bidireccional.
     */
    int client_fd= socket(AF_INET, SOCK_STREAM, 0);
    
	if (client_fd < 0)
	{
		perror("socket failed");
		return -1;
	}

    return client_fd;
}

/**
 * @brief Conecta con el servidor
 * @return Resultado de la función
 */
int connect_server(int client_fd)
{
    /**
     * @brief Carga la estructura sockaddr_in la cual simplifica el acceso a los diferentes elementos que deben completarse para definir un socket y su direccion y puerto.
     * 
     */
    struct sockaddr_in addrServer;
    addrServer.sin_family = AF_INET;
    addrServer.sin_port = htons(PORT);
       
    /**
     * @brief Convierte direcciones IPv4 e IPv6 de texto a formato binario
     * 
     */
    int status = inet_pton(AF_INET, IP, &addrServer.sin_addr);
    if (status <= 0) 
    {
        printf("\nInvalid address/ Address not supported \n");
        return -1;
    }
   
    /*************************  CONECTA AL SERVIDOR *************************/
    /**
     * @brief Pone al proceso en escucha de conexiones provenientes del socket pasado como argumento
     * @param File descriptor del socket creado por la sys call "socket()"
     * @param Puntero a estructura sockaddr, en donde se escribe el par ip:port del server al que se desea conectar
     * @param Longitud en bytes de la estructura sockadrr.
     * @return file descriptor del socket 
     * client_fd = Se comporta como un conector a un canal de comunicaciones bidireccional.
     */
    status = connect(client_fd, (struct sockaddr *)&addrServer, sizeof(addrServer));

    if (status < 0)
    {
        printf("\nConnection Failed \n");
        return -1;
    }

    return 0;
}