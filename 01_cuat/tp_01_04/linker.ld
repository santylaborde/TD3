ENTRY (Entry)
	STACK_START_16    = 0x6000; 
	STACK_END_16	  = 0x8000;
	STACK_START_32    = 0x2FFF8000;
	STACK_END_32	  = 0x2FFF8FFF;
	STACK_SIZE_32     = ((STACK_END_32 - STACK_START_32) / 4); 

	/* VMA */
	FUNCTION_VMA	  = 0x00010000; 
	KERNEL_32_VMA     = 0x00020200;
	INIT_16_VMA       = 0xFFFF0000; 
	INIT_32_VMA  	  = 0xFFFFF800; 
	FUNCIONES_ROM_VMA = 0xfffffc00; 
	SYS_TABLES_VMA	  = 0xfffffd00; 
	RESET_VMA     	  = 0xFFFFFFF0;

	/* LMA */
	FUNCTION_LMA	  = 0xFFF10000; 
	KERNEL_32_LMA     = 0xFFF20200;
	INIT_16_LMA       = 0xFFFF0000;
	INIT_32_LMA	      = 0xfffff800; 
	FUNCIONES_ROM_LMA = 0xfffffc00; 
	SYS_TABLES_LMA    = 0xfffffd00; 
	RESET_LMA		  = 0xFFFFFFF0;
	
MEMORY
{
    ram (!x) : ORIGIN = 0x00000000, LENGTH = 0xFFFF0000 /*4GB - 64KB*/
    rom (rx) : ORIGIN = 0xFFFF0000, LENGTH = 0xFFFF	/*64KB*/
}

SECTIONS
{
	/* FUNCIONES */ 						/*Output section*/
	.functions FUNCTION_VMA :				/*Virtual Memory Address*/
			AT ( FUNCTION_LMA )				/*Loadable Memory Address*/
			{ 
				*(.functions); 				/*Input section*/
			} > ram
	FUNCTION_SIZE = SIZEOF (.functions);

	/* KERNEL */							/*Output section*/
	.codigo_kernel32 KERNEL_32_VMA :		/*Virtual Memory Address*/
			AT ( KERNEL_32_LMA )			/*Loadable Memory Address*/
			{ 
				*(.kernel32); 				/*Input section*/
			} > ram
	KERNEL_32_SIZE = SIZEOF(.codigo_kernel32);

	/* INIT_16 */							/*Output section*/
	.init16 INIT_16_VMA : 					/*Virtual Memory Address*/
		AT ( INIT_16_LMA )					/*Loadable Memory Address*/
		{ 
			*(.ROM_init); 					/*Input section*/
		} > rom

	/* INIT_32 */							/*Output section*/
	.codigo_init32 INIT_32_VMA :			/*Virtual Memory Address*/
		AT ( INIT_32_LMA )					/*Loadable Memory Address*/
		{ 
			*(.init32); 					/*Input section*/
		} > rom
	
	/* FUNCIONES_ROM */						/*Output section*/
	.functions_rom FUNCIONES_ROM_VMA :		/*Virtual Memory Address*/
		AT ( FUNCIONES_ROM_LMA )			/*Loadable Memory Address*/
		{ 
			*(.functions_rom); 				/*Input section*/
		} > rom

	/* SYS_TABLES */						/*Output section*/
	.data_lucia SYS_TABLES_VMA :			/*Virtual Memory Address*/
		AT ( SYS_TABLES_LMA )				/*Loadable Memory Address*/
		{ 
			*(.sys_tables); 				/*Input section*/
		} > rom

	/* RESET */								/*Output section*/
	.reset RESET_VMA :						/*Virtual Memory Address*/
		AT ( RESET_LMA ) 					/*Loadable Memory Address*/
		{ 
			*(.reset); 						/*Input section*/
		} 
}