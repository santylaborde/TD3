/* Includes */
#include "sockets.h"
#include "fork.h"

#include <stdlib.h>
#include <string.h>
// #include <sys/select.h>

/* Defines */
#define CLIENT_CONNECTED 1
#define REQUEST_DATA "sensor"

/* Prototypes */
void waiting(int);

