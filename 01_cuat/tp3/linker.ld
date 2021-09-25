ENTRY (Entry)

    STACK_START_16  = 0x6000; 
	STACK_END_16    = 0x8000;

SECTIONS 
{
   /*Output section*/
  .ROM_init 0xFFFF0000 :  /*Virtual Memory Address*/
      AT ( 0xFFFF0000 )    /*Loadable Memory Address*/
  {
      *(.ROM_init); /*Input section*/
      *(.FUNCTION); /*Input section*/
  }

  /*Output section*/
  .reset 0xFFFFFFF0 :    /*Virtual Memory Address*/
      AT ( 0xFFFFFFF0 )   /*Loadable Memory Address*/
  {
      *(.reset); /*Input section*/
  }

}


