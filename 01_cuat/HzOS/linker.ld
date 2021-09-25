SECTIONS
{
  /*Output section*/
  .Init16 0xFFFF0000 :    /*Virtual Memory Address*/
      AT( 0xFFFF0000 )    /*Local Memory Address*/
  {
      *(.Init16); /*Input section*/
  }

  /*Output section*/
  .Init32 0xFFFF4000 :    /*Virtual Memory Address*/
      AT( 0xFFFF4000 )    /*Local Memory Address*/
  {
      *(.Init32); /*Input section*/
  }

  /*Output section*/
  .Reset 0xFFFFFFF0 :    /*Virtual Memory Address*/
      AT( 0xFFFFFFF0 )    /*Local Memory Address*/
  {
      *(.Reset); /*Input section*/
  }
}


