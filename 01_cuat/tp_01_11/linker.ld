ENTRY (Entry)

	/************************* PHYSICAL MEM **************************/
	/*----------------------------- RAM -----------------------------*/
	/* STACK 16 */
	STACK_START_16_PHY = 0x6000; 
	STACK_END_16_PHY   = 0x8000;
	/* SYSTABLES */
	SYS_TABLES_PHY	   = 0x00000000;
	/* FUNCTIONS */
	FUNCTIONS_PHY	   = 0x00005000;
	/* PAGING */
	DPT_KERNEL_PHY	   = 0x00010000; /* Es la base de la page directory (Hay que guardarlo en CR3) */
	DPT_TASK01_PHY	   = 0x00360000; /* Es la base de la page directory de task01  (Guardarlo en el CR3 de task01) */
	DPT_TASK02_PHY	   = 0x00460000; /* Es la base de la page directory de task02  (Guardarlo en el CR3 de task02) */
	DPT_TASK03_PHY	   = 0x00560000; /* Es la base de la page directory de task03  (Guardarlo en el CR3 de task03) */
	DPT_TASK04_PHY	   = 0x00660000; /* Es la base de la page directory de task04  (Guardarlo en el CR3 de task04) */
	/* VIDEO */
	VIDEO_PHY          = 0x000B8000;
	/* ISR */
	ISR_HANDLER_PHY    = 0x00100000;
	/* DATA */
	DATA_PHY	       = 0x00200000;
	RING_BUFFER_PHY    = 0x00200000;
	TIMER_PHY 		   = 0x00200050;
	DIGITS_TABLE_PHY   = 0x00210000;
	/* KERNEL */
	KERNEL_32_PHY      = 0x00220000;
	/* TASK01 */
    TASK01_TEXT_PHY    = 0x00310000;
    TASK01_BSS_PHY     = 0x00320000;
    TASK01_DATA_PHY    = 0x00330000;
    TASK01_RODATA_PHY  = 0x00340000;
	/* TASK02 */
    TASK02_TEXT_PHY    = 0x00410000;
    TASK02_BSS_PHY     = 0x00420000;
    TASK02_DATA_PHY    = 0x00430000;
    TASK02_RODATA_PHY  = 0x00440000;
	/* TASK03 */
    TASK03_TEXT_PHY    = 0x00510000;
    TASK03_BSS_PHY     = 0x00520000;
    TASK03_DATA_PHY    = 0x00530000;
    TASK03_RODATA_PHY  = 0x00540000;
	/* TASK04 */
    TASK04_TEXT_PHY    = 0x00610000;
    TASK04_BSS_PHY     = 0x00620000;
    TASK04_DATA_PHY    = 0x00630000;
    TASK04_RODATA_PHY  = 0x00640000;
	/* TSS */
    TASK01_TSS_PHY     = 0x00350000;
    TASK02_TSS_PHY     = 0x00450000;
    TASK03_TSS_PHY     = 0x00550000;
    TASK04_TSS_PHY     = 0x00650000;
	/* ENUNCIADO TP10 */
	START_NEW_PAGES_PHY = 0x0A000000;
	/* STACK 32 */
	STACK_START_32_PHY = 0x1FFF8000;
	STACK_END_32_PHY   = 0x1FFF8FFF;
	/* STACK TASK01 */
	STACK_TASK01_START_PHY = 0x1FFFF000;
    STACK_TASK01_END_PHY   = 0x1FFFFFFF;
	/* STACK TASK02 */
	STACK_TASK02_START_PHY = 0x1FFF1000;
    STACK_TASK02_END_PHY   = 0x1FFF1FFF;
	/* STACK TASK03 */
	STACK_TASK03_START_PHY = 0x1FFF2000;
    STACK_TASK03_END_PHY   = 0x1FFF2FFF;
	/* STACK TASK04 */
	STACK_TASK04_START_PHY = 0x1FFF3000;
    STACK_TASK04_END_PHY   = 0x1FFF3FFF;

	/*----------------------------- ROM -----------------------------*/	
	INIT_16_PHY       = 0xFFFF8000; 
	INIT_32_PHY  	  = 0xFFFFA000; 
	FUNCTIONS_ROM_PHY = 0xFFFFFC00;  
	RESET_PHY     	  = 0xFFFFFFF0;

	/*************************** LINEAR VMA **************************/
	/*----------------------------- RAM -----------------------------*/
	/* STACK 16 */
	STACK_START_16_VMA = 0x6000; 
	STACK_END_16_VMA   = 0x8000;
	/* SYSTABLES */
	SYS_TABLES_VMA	   = 0x00000000;
	/* FUNCTIONS */
	FUNCTIONS_VMA  	   = 0x00005000;
	/* PAGING */
	DPT_KERNEL_VMA	   = 0x00010000; /* Es la base de la page directory del kernel (Guardarlo en el CR3 del kernel) */
	DPT_TASK01_VMA	   = 0x01360000; /* Es la base de la page directory de task01  (Guardarlo en el CR3 de task01) */
	DPT_TASK02_VMA	   = 0x01460000; /* Es la base de la page directory de task02  (Guardarlo en el CR3 de task02) */
	DPT_TASK03_VMA	   = 0x01560000; /* Es la base de la page directory de task03  (Guardarlo en el CR3 de task03) */
	DPT_TASK04_VMA	   = 0x01660000; /* Es la base de la page directory de task04  (Guardarlo en el CR3 de task04) */
	/* VIDEO */
	VIDEO_VMA	       = 0x00E80000;
	/* ISR */
	ISR_HANDLER_VMA    = 0x00100000;
	/* DATA */
	DATA_VMA	       = 0x01200000;
	RING_BUFFER_VMA    = 0x01200000;
	TIMER_VMA 		   = 0x01200050;
	DIGITS_TABLE_VMA   = 0x01210000;
	/* KERNEL */
	KERNEL_32_VMA      = 0x01220000;
	/* TASK01 */
    TASK01_TEXT_VMA    = 0x01310000;
    TASK01_BSS_VMA     = 0x01320000;
    TASK01_DATA_VMA    = 0x01330000;
    TASK01_RODATA_VMA  = 0x01340000;
	/* TASK02 */
    TASK02_TEXT_VMA    = 0x01410000;
    TASK02_BSS_VMA     = 0x01420000;
    TASK02_DATA_VMA    = 0x01430000;
    TASK02_RODATA_VMA  = 0x01440000;
	/* TASK03 */
    TASK03_TEXT_VMA    = 0x01510000;
    TASK03_BSS_VMA     = 0x01520000;
    TASK03_DATA_VMA    = 0x01530000;
    TASK03_RODATA_VMA  = 0x01540000;
	/* TASK04 */
    TASK04_TEXT_VMA    = 0x01610000;
    TASK04_BSS_VMA     = 0x01620000;
    TASK04_DATA_VMA    = 0x01630000;
    TASK04_RODATA_VMA  = 0x01640000;
	/* TSS */
    TASK01_TSS_VMA     = 0x01350000;
    TASK02_TSS_VMA     = 0x01450000;
    TASK03_TSS_VMA     = 0x01550000;
    TASK04_TSS_VMA     = 0x01650000;
	/* STACK 32 */
	STACK_START_32_VMA = 0x1FFF8000;
	STACK_END_32_VMA   = 0x1FFF8FFF;
	/* STACK TASK01 */
	STACK_TASK01_START_VMA = 0x0078F000;
    STACK_TASK01_END_VMA   = 0x0078FFFF;
	/* STACK TASK02 */
	STACK_TASK02_START_VMA = 0x00790000;
    STACK_TASK02_END_VMA   = 0x00790FFF;
	/* STACK TASK03 */
	STACK_TASK03_START_VMA = 0x00791000;
    STACK_TASK03_END_VMA   = 0x00791FFF;
	/* STACK TASK04 */
	STACK_TASK04_START_VMA = 0x00792000;
    STACK_TASK04_END_VMA   = 0x00792FFF;

	/*----------------------------- ROM -----------------------------*/	
	INIT_16_VMA        = 0xFFFF8000; 
	INIT_32_VMA  	   = 0xFFFFA000; 
	FUNCTIONS_ROM_VMA  = 0xFFFFFC00;  
	RESET_VMA     	   = 0xFFFFFFF0;

	/****************************** LMA ******************************/
	/*----------------------------- ROM -----------------------------*/
	FUNCTIONS_LMA	   = 0xFFFF0000;
	INIT_16_LMA        = 0xFFFF8000;
	INIT_32_LMA	       = 0xFFFFA000; 
	FUNCTIONS_ROM_LMA  = 0xFFFFFC00; 
	SYS_TABLES_LMA     = 0xFFFFFD00; 
	RESET_LMA		   = 0xFFFFFFF0;

	/* STACK SIZES */
	STACK_SIZE_32 	   = ((STACK_END_32_PHY - STACK_START_32_PHY) / 4); 
	STACK_TASK01_SIZE  = ((STACK_TASK01_END_PHY - STACK_TASK01_START_PHY) / 4);
	STACK_TASK02_SIZE  = ((STACK_TASK02_END_PHY - STACK_TASK02_START_PHY) / 4);
	STACK_TASK03_SIZE  = ((STACK_TASK03_END_PHY - STACK_TASK03_START_PHY) / 4);
	STACK_TASK04_SIZE  = ((STACK_TASK04_END_PHY - STACK_TASK04_START_PHY) / 4);

	/* ISR */
	ISR0_handler_DE_L  = (ISR0_handler_DE & 0x0000FFFF);
	ISR0_handler_DE_H  = ((ISR0_handler_DE >> 16) & 0x0000FFFF);

	ISR2_handler_NMI_L = (ISR2_handler_NMI & 0x0000FFFF);
	ISR2_handler_NMI_H = ((ISR2_handler_NMI >> 16) & 0x0000FFFF);

	ISR3_handler_BP_L  = (ISR3_handler_BP & 0x0000FFFF);
	ISR3_handler_BP_H  = ((ISR3_handler_BP >> 16) & 0x0000FFFF);

	ISR4_handler_OF_L  = (ISR4_handler_OF & 0x0000FFFF);
	ISR4_handler_OF_H  = ((ISR4_handler_OF >> 16) & 0x0000FFFF);

	ISR5_handler_BR_L  = (ISR5_handler_BR & 0x0000FFFF);
	ISR5_handler_BR_H  = ((ISR5_handler_BR >> 16) & 0x0000FFFF);

	ISR6_handler_UD_L  = (ISR6_handler_UD & 0x0000FFFF);
	ISR6_handler_UD_H  = ((ISR6_handler_UD >> 16) & 0x0000FFFF);

	ISR7_handler_NM_L  = (ISR7_handler_NM & 0x0000FFFF);
	ISR7_handler_NM_H  = ((ISR7_handler_NM >> 16) & 0x0000FFFF);

	ISR8_handler_DF_L  = (ISR8_handler_DF & 0x0000FFFF);
	ISR8_handler_DF_H  = ((ISR8_handler_DF >> 16) & 0x0000FFFF);

	ISR10_handler_TS_L = (ISR10_handler_TS & 0x0000FFFF);
	ISR10_handler_TS_H = ((ISR10_handler_TS >> 16) & 0x0000FFFF);

	ISR11_handler_NP_L = (ISR11_handler_NP & 0x0000FFFF);
	ISR11_handler_NP_H = ((ISR11_handler_NP >> 16) & 0x0000FFFF);

	ISR12_handler_SS_L = (ISR12_handler_SS & 0x0000FFFF);
	ISR12_handler_SS_H = ((ISR12_handler_SS >> 16) & 0x0000FFFF);

	ISR13_handler_GP_L = (ISR13_handler_GP & 0x0000FFFF);
	ISR13_handler_GP_H = ((ISR13_handler_GP >> 16) & 0x0000FFFF);

	ISR14_handler_PF_L = (ISR14_handler_PF & 0x0000FFFF);
	ISR14_handler_PF_H = ((ISR14_handler_PF >> 16) & 0x0000FFFF);

	ISR16_handler_MF_L = (ISR16_handler_MF & 0x0000FFFF);
	ISR16_handler_MF_H = ((ISR16_handler_MF >> 16) & 0x0000FFFF);

	ISR17_handler_AC_L = (ISR17_handler_AC & 0x0000FFFF);
	ISR17_handler_AC_H = ((ISR17_handler_AC >> 16) & 0x0000FFFF);

	ISR18_handler_MC_L = (ISR18_handler_MC & 0x0000FFFF);
	ISR18_handler_MC_H = ((ISR18_handler_MC >> 16) & 0x0000FFFF);

	ISR19_handler_XF_L = (ISR19_handler_XF & 0x0000FFFF);
	ISR19_handler_XF_H = ((ISR19_handler_XF >> 16) & 0x0000FFFF);

	ISR32_handler_PIT_L = (ISR32_handler_PIT & 0x0000FFFF);
	ISR32_handler_PIT_H = ((ISR32_handler_PIT >> 16) & 0x0000FFFF);

	ISR33_handler_KEYBOARD_L = (ISR33_handler_KEYBOARD & 0x0000FFFF);
	ISR33_handler_KEYBOARD_H = ((ISR33_handler_KEYBOARD >> 16) & 0x0000FFFF);

MEMORY
{
    ram (!x) : ORIGIN = 0x00000000, LENGTH = 0xFFFF0000 /*4GB - 64KB*/
    rom (rx) : ORIGIN = 0xFFFF0000, LENGTH = 64k	/*64KB*/
}

SECTIONS
{
	/****************************** RAM ******************************/
	/* FUNCIONES */ 						/*Output section*/
	.functions FUNCTIONS_VMA :			/*Virtual Memory Address*/
			AT ( FUNCTIONS_LMA )			/*Loadable Memory Address*/
			{ 
				*(.functions); 				/*Input section*/
          		./bin/functions_ram.elf(.note*);
          		./bin/functions_ram.elf(.text);
				./bin/functions_ram.elf(.bss);
          		./bin/functions_ram.elf(.data);
          		./bin/functions_ram.elf(.rodata);

				./bin/paging.elf(.note*);
				./bin/paging.elf(.text);
				./bin/paging.elf(.bss);
          		./bin/paging.elf(.data);
          		./bin/paging.elf(.rodata);	
			} > ram
	FUNCTIONS_SIZE = SIZEOF (.functions);

	/* ISR_HANDLER */						/*Output section*/
	ISR_HANDLER_LMA = LOADADDR(.functions) + FUNCTIONS_SIZE;
	.isr_handler ISR_HANDLER_VMA :		/*Virtual Memory Address*/	
		AT ( ISR_HANDLER_LMA ) 				/*Loadable Memory Address*/
		{ 
			*(.isr_handler); 				/*Input section*/
			*(.my_scheduler);
			./bin/scheduler.elf(.data);
			./bin/isr_handler_C.elf(.note*);
          	./bin/isr_handler_C.elf(.text);
			./bin/isr_handler_C.elf(.bss);
          	./bin/isr_handler_C.elf(.data);
          	./bin/isr_handler_C.elf(.rodata);
		} > ram
	ISR_HANDLER_SIZE = SIZEOF(.isr_handler);

	/* DATA */		 						/*Output section*/
	DATA_LMA = LOADADDR(.isr_handler) + ISR_HANDLER_SIZE;
	.data DATA_VMA :					/*Virtual Memory Address*/
			AT ( DATA_LMA )					/*Loadable Memory Address*/
			{ 							
				*(.data); 					/*Input section*/
			} > ram
	DATA_SIZE = SIZEOF (.data);

	/* KERNEL */							/*Output section*/
	KERNEL_32_LMA = LOADADDR(.data) + DATA_SIZE;
	.kernel32 KERNEL_32_VMA :			/*Virtual Memory Address*/
			AT ( KERNEL_32_LMA )			/*Loadable Memory Address*/
			{ 
				*(.kernel32); 				/*Input section*/
			} > ram
	KERNEL_32_SIZE = SIZEOF(.kernel32);

	/* TASK01 */							/*Output section*/
	TASK01_TEXT_LMA = LOADADDR(.kernel32) + KERNEL_32_SIZE;
	.task01_text TASK01_TEXT_VMA :		/*Virtual Memory Address*/
			AT ( TASK01_TEXT_LMA )			/*Loadable Memory Address*/
			{ 
				*(.task01);					/*Input section*/
				./bin/task01.elf(.text);
				./bin/task01.elf(.note*); 				

			} > ram
	TASK01_TEXT_SIZE = SIZEOF(.task01_text);

	TASK01_BSS_LMA = LOADADDR(.task01_text) + TASK01_TEXT_SIZE;
	.task01_bss TASK01_BSS_VMA :		/*Virtual Memory Address*/
			AT ( TASK01_BSS_LMA )			/*Loadable Memory Address*/
			{ 
				./bin/task01.elf(.bss);		/*Input section*/
			} > ram
	TASK01_BSS_SIZE = SIZEOF(.task01_bss);

	TASK01_DATA_LMA = LOADADDR(.task01_bss) + TASK01_BSS_SIZE;
	.task01_data TASK01_DATA_VMA :		/*Virtual Memory Address*/
			AT ( TASK01_DATA_LMA )			/*Loadable Memory Address*/
			{ 
				./bin/task01.elf(.data);		/*Input section*/
			} > ram
	TASK01_DATA_SIZE = SIZEOF(.task01_data);

	TASK01_RODATA_LMA = LOADADDR(.task01_data) + TASK01_DATA_SIZE;
	.task01_rodata TASK01_RODATA_VMA :	/*Virtual Memory Address*/
			AT ( TASK01_RODATA_LMA )		/*Loadable Memory Address*/
			{ 
				./bin/task01.elf(.rodata);	/*Input section*/
			} > ram
	TASK01_RODATA_SIZE = SIZEOF(.task01_rodata);

	/* TASK02 */						/*Output section*/
	TASK02_TEXT_LMA = LOADADDR(.task01_rodata) + TASK01_RODATA_SIZE;
	.task02_text TASK02_TEXT_VMA :		/*Virtual Memory Address*/
			AT ( TASK02_TEXT_LMA )			/*Loadable Memory Address*/
			{ 
				*(.task02); 				/*Input section*/
				./bin/task02.elf(.text);
				./bin/task02.elf(.note*);
			} > ram
	TASK02_TEXT_SIZE = SIZEOF(.task02_text);

	TASK02_BSS_LMA = LOADADDR(.task02_text) + TASK02_TEXT_SIZE;
	.task02_bss TASK02_BSS_VMA :		/*Virtual Memory Address*/
			AT ( TASK02_BSS_LMA )			/*Loadable Memory Address*/
			{ 
				./bin/task02.elf(.bss);		/*Input section*/
			} > ram
	TASK02_BSS_SIZE = SIZEOF(.task02_bss);

	TASK02_DATA_LMA = LOADADDR(.task02_bss) + TASK02_BSS_SIZE;
	.task02_data TASK02_DATA_VMA :		/*Virtual Memory Address*/
			AT ( TASK02_DATA_LMA )			/*Loadable Memory Address*/
			{ 
				./bin/task02.elf(.data);		/*Input section*/
			} > ram
	TASK02_DATA_SIZE = SIZEOF(.task02_data);

	TASK02_RODATA_LMA = LOADADDR(.task02_data) + TASK02_DATA_SIZE;
	.task02_rodata TASK02_RODATA_VMA :	/*Virtual Memory Address*/
			AT ( TASK02_RODATA_LMA )		/*Loadable Memory Address*/
			{ 
				./bin/task02.elf(.rodata);	/*Input section*/
			} > ram
	TASK02_RODATA_SIZE = SIZEOF(.task02_rodata);

	/* TASK03 */							/*Output section*/
	TASK03_TEXT_LMA = LOADADDR(.task02_rodata) + TASK02_RODATA_SIZE;
	.task03_text TASK03_TEXT_VMA :		/*Virtual Memory Address*/
			AT ( TASK03_TEXT_LMA )			/*Loadable Memory Address*/
			{ 
				*(.task03); 				/*Input section*/
			} > ram
	TASK03_TEXT_SIZE = SIZEOF(.task03_text);

	TASK03_BSS_LMA = LOADADDR(.task03_text) + TASK03_TEXT_SIZE;
	.task03_bss TASK03_BSS_VMA :		/*Virtual Memory Address*/
			AT ( TASK03_BSS_LMA )			/*Loadable Memory Address*/
			{ 
				./bin/task03.elf(.bss);		/*Input section*/
			} > ram
	TASK03_BSS_SIZE = SIZEOF(.task03_bss);

	TASK03_DATA_LMA = LOADADDR(.task03_bss) + TASK03_BSS_SIZE;
	.task03_data TASK03_DATA_VMA :		/*Virtual Memory Address*/
			AT ( TASK03_DATA_LMA )			/*Loadable Memory Address*/
			{ 
				./bin/task03.elf(.data);		/*Input section*/
			} > ram
	TASK03_DATA_SIZE = SIZEOF(.task03_data);

	TASK03_RODATA_LMA = LOADADDR(.task03_data) + TASK03_DATA_SIZE;
	.task03_rodata TASK03_RODATA_VMA :	/*Virtual Memory Address*/
			AT ( TASK03_RODATA_LMA )		/*Loadable Memory Address*/
			{ 
				./bin/task03.elf(.rodata);	/*Input section*/
			} > ram
	TASK03_RODATA_SIZE = SIZEOF(.task03_rodata);

		/* TASK04 */							/*Output section*/
	TASK04_TEXT_LMA = LOADADDR(.task03_rodata) + TASK03_RODATA_SIZE;
	.task04_text TASK04_TEXT_VMA :		/*Virtual Memory Address*/
			AT ( TASK04_TEXT_LMA )			/*Loadable Memory Address*/
			{ 
				*(.task04); 				/*Input section*/
			} > ram
	TASK04_TEXT_SIZE = SIZEOF(.task04_text);

	TASK04_BSS_LMA = LOADADDR(.task04_text) + TASK04_TEXT_SIZE;
	.task04_bss TASK04_BSS_VMA :		/*Virtual Memory Address*/
			AT ( TASK04_BSS_LMA )			/*Loadable Memory Address*/
			{ 
				./bin/task04.elf(.bss);		/*Input section*/
			} > ram
	TASK04_BSS_SIZE = SIZEOF(.task04_bss);

	TASK04_DATA_LMA = LOADADDR(.task04_bss) + TASK04_BSS_SIZE;
	.task04_data TASK04_DATA_VMA :		/*Virtual Memory Address*/
			AT ( TASK04_DATA_LMA )			/*Loadable Memory Address*/
			{ 
				./bin/task04.elf(.data);		/*Input section*/
			} > ram
	TASK04_DATA_SIZE = SIZEOF(.task04_data);

	TASK04_RODATA_LMA = LOADADDR(.task04_data) + TASK04_DATA_SIZE;
	.task04_rodata TASK04_RODATA_VMA :	/*Virtual Memory Address*/
			AT ( TASK04_RODATA_LMA )		/*Loadable Memory Address*/
			{ 
				./bin/task04.elf(.rodata);	/*Input section*/
			} > ram
	TASK04_RODATA_SIZE = SIZEOF(.task04_rodata);

	/****************************** ROM ******************************/
	/* INIT_16 */							/*Output section*/
	.init16 INIT_16_VMA :				/*Virtual Memory Address*/
		AT ( INIT_16_LMA )					/*Loadable Memory Address*/
		{ 
			*(.init16); 					/*Input section*/
			*(.video_rom);
		} > rom

	/* INIT_32 */							/*Output section*/
	.init32 INIT_32_VMA :				/*Virtual Memory Address*/
		AT ( INIT_32_LMA )					/*Loadable Memory Address*/
		{ 
			*(.init32); 					/*Input section*/
		} > rom
	
	/* FUNCIONES_ROM */						/*Output section*/
	.functions_rom FUNCTIONS_ROM_VMA :	/*Virtual Memory Address*/
		AT ( FUNCTIONS_ROM_LMA )			/*Loadable Memory Address*/
		{ 
			*(.functions_rom); 				/*Input section*/
          	./bin/functions_rom.elf(.data);
          	./bin/functions_rom.elf(.bss);
         	./bin/functions_rom.elf(.rodata);
		} > rom

	/* SYS_TABLES */						/*Output section*/
	.sys_tables SYS_TABLES_VMA :		/*Virtual Memory Address*/
		AT ( SYS_TABLES_LMA )				/*Loadable Memory Address*/
		{ 
			*(.sys_tables); 				/*Input section*/
		} 
	SYS_TABLES_SIZE = SIZEOF(.sys_tables);

	/* RESET */								/*Output section*/
	.reset RESET_VMA :					/*Virtual Memory Address*/
		AT ( RESET_LMA ) 					/*Loadable Memory Address*/
		{ 
			*(.reset); 						/*Input section*/
		} 
}