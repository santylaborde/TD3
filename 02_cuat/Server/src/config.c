/**
 * @file config.c
 * @author slaborde
 * @brief funciones para el manejo de archivos de configuración
 * @date 2021-10-05
 */

#include "../inc/config.h"

/* GLOBAL VARIABLES */
int MAX_CLIENTS= 0; // Cantidad Máxima de Conexiones
int BACKLOG_SRV= 0; // Cantidad de pedidos de conexión que bufferea
int SIZE_WINDOW= 0; // Tamaño de la ventana del filtro
int CLT_TIMEOUT= 0; // Tiempo máximo de inactividad del cliente

int load_config(void)
{
    FILE* config_file = fopen(CONFIG_FILE,"r");   
	
    if (config_file == NULL) 
    {   
        perror("fopen failed"); 
        return -1;
    } 
    
    int KEY_LEN= strlen("MAX_CLIENTS")+1; // Todas las keys son del mismo largo
    char* KEY= malloc(KEY_LEN);

    while (!feof(config_file))
    {  
        fgets(KEY, KEY_LEN, config_file); 

        if(!strcmp(KEY,"MAX_CLIENTS"))
        {
            fgetc(config_file); // Lee el ":"
            fscanf(config_file, "%d", &MAX_CLIENTS); // Lee el value de la key
        }   
        else if(!strcmp(KEY,"BACKLOG_SRV"))
        {
            fgetc(config_file); // Lee el ":"
            fscanf(config_file, "%d", &BACKLOG_SRV); // Lee el value de la key
        }
        else if(!strcmp(KEY,"SIZE_WINDOW"))
        {
            fgetc(config_file); // Lee el ":"
            fscanf(config_file, "%d", &SIZE_WINDOW); // Lee el value de la key
        }   
        else if(!strcmp(KEY,"CLT_TIMEOUT"))
        {
            fgetc(config_file); // Lee el ":"
            fscanf(config_file, "%d", &CLT_TIMEOUT); // Lee el value de la key
        } 
    }

    free(KEY);
    fclose(config_file);   

    return 0;
}
