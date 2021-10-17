/**
 * @file sockets.c
 * @author slaborde
 * @brief funciones para la comunicación via socket
 * @date 2021-09-14
 */

#include "../inc/sockets.h"

/**
 * @brief inicializa la comunicación del servidor
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
     * server_fd = Se comporta como un conector a un canal de comunicaciones bidireccional.
     */
    int server_fd= socket(AF_INET, SOCK_STREAM, 0);
    
	if (server_fd < 0)
	{
		perror("socket failed");
		return -1;
	}

    /**
     * @brief Carga la estructura sockaddr_in la cual simplifica el acceso a los diferentes elementos que deben completarse para definir un socket y su direccion y puerto.
     * 
     */
    struct sockaddr_in addrServer;
    addrServer.sin_family = AF_INET;
	addrServer.sin_addr.s_addr = INADDR_ANY;    // Dirección IP
	addrServer.sin_port = htons(PORT);          // Puerto
                                                // htons() [host to network short] convierte un número en formato "host order byte" a "network order byte".
    

    /**
     * @brief Evita que el puerto del server quede bloqueado en caso de cerrar el server sin close
     * 
     */
    int activated= 1;
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &activated, sizeof(activated));

    /*************************  ASIGNA EL PUERTO    *************************/
    /**
     * @brief Le asigna al objeto "socket" que recibe en el primer argumento, una direccion ip y un puerto.
     * @param File descriptor del socket creado por la sys call "socket()"
     * @param Puntero a la estructura sockadrr, en donde se escribe el par ip:puerto.
     * @param Longitud en bytes de la estructura sockadrr.
     * @return Resultado de la función
     */
    int status = bind(server_fd, (struct sockaddr*)&addrServer, sizeof(addrServer));

	if (status < 0)
	{
		perror("bind failed");
        close(server_fd);
		return -1;
	}

    /*************************  ESCUCHA CONEXIONES ENTRANTES    *************************/
    /**
     * @brief Configura cuantas conexiones podemos escuchar por puerto.
     * @param File descriptor del socket creado por la sys call "socket()"
     * @param Cantidad de pedidos de conexión que el proceso almacenará mientras se responde al pedido de conexión en curso de ser aceptado.
     * @return Resultado de la función
     */
    status = listen(server_fd, BACKLOG_SRV);

	if (status < 0)
	{
		perror("listen failed");
        close(server_fd);
		return -1;
	}

    // printf("*********** SERVER **********\n");
    // printf("IP:\t %s\n", inet_ntoa(addrClient.sin_addr));
    // printf("PORT:\t %d\n", addrClient.sin_port);
    // printf("-----------------------------\n");

    return server_fd;
}

/**
 * @brief acepta conexión entrante de clientes
 * @param File descriptor del socket creado por la sys call "socket()"
 * @param Current number of childs accepting clients
 * @return int (file descriptor or error)
 */
int accept_client(int server_fd)
{
    struct sockaddr_in addrClient;
    int addrClient_len = sizeof(addrClient);

    /*************************  ACEPTA CONEXIÓN ENTRANTE    *************************/
    /**
     * @brief Extrae el primer pedido de conexión de la cola de conexiones pendientes del socket "server_fd" y le reserva un nuevo file descriptor.
     * @param File descriptor del socket creado por la sys call "socket()"
     * @param Puntero a la estructura "sockaddr" vacia para que la función la llene con los datos ip:puerto del cliente.
     * @param Longitud en bytes de la estructura sockadrr.
     * @return Resultado de la función
     */
    int new_socket = accept(server_fd, (struct sockaddr*)&addrClient, (socklen_t*)&addrClient_len );

	if (new_socket < 0)
	{
		perror("accept failed");
		return -1;
	}
    
    return new_socket;
}