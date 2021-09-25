ENTRY (Entry)
	/* STACK */
	STACK_START_16    = 0x6000; 
	STACK_END_16	  = 0x8000;
	STACK_START_32    = 0x1FFF8000;
	STACK_END_32	  = 0x1FFF8FFF;
	STACK_SIZE_32     = ((STACK_END_32 - STACK_START_32) / 4); 

	/* VMA */
	FUNCTION_VMA	  = 0x00010000; 
	KERNEL_32_VMA     = 0x00020200;
	INIT_16_VMA       = 0xFFFF0000; 
	INIT_32_VMA  	  = 0xFFFFF800; 
	FUNCIONES_ROM_VMA = 0xFFFFFC00; 
	SYS_TABLES_VMA	  = 0xFFFFFD00; 
	RESET_VMA     	  = 0xFFFFFFF0;
	ISR_HANDLER_VMA   = 0x00100000;

	/* LMA */
	FUNCTION_LMA	  = 0xFFF10000; 
	KERNEL_32_LMA     = 0xFFF20200;
	INIT_16_LMA       = 0xFFFF0000;
	INIT_32_LMA	      = 0xFFFFF800; 
	FUNCIONES_ROM_LMA = 0xFFFFFC00; 
	SYS_TABLES_LMA    = 0xFFFFFD00; 
	RESET_LMA		  = 0xFFFFFFF0;
	ISR_HANDLER_LMA   = 0xFFF1C000;
	DIGITS       	  = 0x00310000;

	/* ISR */
	ISR0_handler_L = (ISR0_handler & 0x0000FFFF);
	ISR0_handler_H  = ((ISR0_handler >> 16) & 0x0000FFFF);

	ISR2_handler_L = (ISR2_handler & 0x0000FFFF);
	ISR2_handler_H = ((ISR2_handler >> 16) & 0x0000FFFF);

	ISR3_handler_L = (ISR3_handler & 0x0000FFFF);
	ISR3_handler_H = ((ISR3_handler >> 16) & 0x0000FFFF);

	ISR4_handler_L = (ISR4_handler & 0x0000FFFF);
	ISR4_handler_H = ((ISR4_handler >> 16) & 0x0000FFFF);

	ISR5_handler_L = (ISR5_handler & 0x0000FFFF);
	ISR5_handler_H = ((ISR5_handler >> 16) & 0x0000FFFF);

	ISR6_handler_L = (ISR6_handler & 0x0000FFFF);
	ISR6_handler_H = ((ISR6_handler >> 16) & 0x0000FFFF);

	ISR7_handler_L = (ISR7_handler & 0x0000FFFF);
	ISR7_handler_H = ((ISR7_handler >> 16) & 0x0000FFFF);

	ISR8_handler_L = (ISR8_handler & 0x0000FFFF);
	ISR8_handler_H = ((ISR8_handler >> 16) & 0x0000FFFF);

	ISR10_handler_L = (ISR10_handler & 0x0000FFFF);
	ISR10_handler_H = ((ISR10_handler >> 16) & 0x0000FFFF);

	ISR11_handler_L = (ISR11_handler & 0x0000FFFF);
	ISR11_handler_H = ((ISR11_handler >> 16) & 0x0000FFFF);

	ISR12_handler_L = (ISR12_handler & 0x0000FFFF);
	ISR12_handler_H = ((ISR12_handler >> 16) & 0x0000FFFF);

	ISR13_handler_L = (ISR13_handler & 0x0000FFFF);
	ISR13_handler_H = ((ISR13_handler >> 16) & 0x0000FFFF);

	ISR14_handler_L = (ISR14_handler & 0x0000FFFF);
	ISR14_handler_H = ((ISR14_handler >> 16) & 0x0000FFFF);

	ISR16_handler_L = (ISR16_handler & 0x0000FFFF);
	ISR16_handler_H = ((ISR16_handler >> 16) & 0x0000FFFF);

	ISR17_handler_L = (ISR17_handler & 0x0000FFFF);
	ISR17_handler_H = ((ISR17_handler >> 16) & 0x0000FFFF);

	ISR18_handler_L = (ISR18_handler & 0x0000FFFF);
	ISR18_handler_H = ((ISR18_handler >> 16) & 0x0000FFFF);

	ISR19_handler_L = (ISR19_handler & 0x0000FFFF);
	ISR19_handler_H = ((ISR19_handler >> 16) & 0x0000FFFF);


MEMORY
{
    ram (!x) : ORIGIN = 0x00000000, LENGTH = 0xFFFF0000 /*4GB - 64KB*/
    rom (rx) : ORIGIN = 0xFFFF0000, LENGTH = 64k	/*64KB*/
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

	/* ISR_HANDLER */	
	.isr_handler ISR_HANDLER_VMA :
		AT ( ISR_HANDLER_LMA ) 
		{ 
			*(.isr_handler); 
			*(.isr_keyboard); 
		} > ram
	ISR_HANDLER_SIZE = SIZEOF(.isr_handler);


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
	.sys_tables SYS_TABLES_VMA :			/*Virtual Memory Address*/
		AT ( SYS_TABLES_LMA )				/*Loadable Memory Address*/
		{ 
			*(.sys_tables); 				/*Input section*/
		} > rom
		SYS_TABLES_SIZE = SIZEOF (.sys_tables);

	/* RESET */								/*Output section*/
	.reset RESET_VMA :						/*Virtual Memory Address*/
		AT ( RESET_LMA ) 					/*Loadable Memory Address*/
		{ 
			*(.reset); 						/*Input section*/
		} 
}