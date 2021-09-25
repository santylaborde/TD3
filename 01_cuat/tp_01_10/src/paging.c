#include "../inc/functions.h"

__attribute__((section(".functions"))) dword set_CR3(dword DPT, byte PCD, byte PWT)
{
    dword CR3 = 0;

//  Se queda con todos los bits excepto los 3 menos significativos (OFFSET)
    CR3 |= (DPT & 0xFFFFF000);      // Direccion fisica del directorio de tablas de paginas
//  Setea los atributos de CR3
    CR3 |= (PCD << 4);              // BIT 4: Page Level Cache Disable
    CR3 |= (PWT << 3);              // BIT 3: Page Level Write Through

    return CR3;
}

__attribute__((section(".functions"))) void set_PDE(dword DPT, word ENTRY, dword PT, byte PS, byte A, byte PCD, byte PWT, byte US, byte RW, byte P)
{
    dword PDE = 0;                  // Page directory entry
    dword* dst = (dword*) DPT;

    //  Se queda con todos los bits excepto los 3 menos significativos (OFFSET)
    PDE |= (PT & 0xFFFFF000);      // Direccion fisica de la tabla de paginas
    //  Setea los atributos de la PDE
    PDE |= (PS << 7);               // BIT 7: Page size
    PDE |= (0 << 6);                // BIT 6: IGNORE
    PDE |= (A << 5);                // BIT 5: Accessed
    PDE |= (PCD << 4);              // BIT 4: Page Level Cache Disable
    PDE |= (PWT << 3);              // BIT 3: Page Level Write Through
    PDE |= (US << 2);               // BIT 2: User or Supervisor
    PDE |= (RW << 1);               // BIT 1: Read and Writeable
    PDE |= (P << 0);                // BIT 0: Presence

    *(dst+ENTRY)= PDE;              // Guardamos el descriptor del DPT
}

__attribute__((section(".functions"))) void set_PTE(dword PT, word ENTRY, dword SRC, byte G, byte PAT, byte D, byte A, byte PCD, byte PWT, byte US, byte RW, byte P)
{
    dword PTE = 0;                  // Page table entry
    dword* dst = (dword*) PT;

//  Se queda con todos los bits excepto los 3 menos significativos (OFFSET)
    PTE |= (SRC & 0xFFFFF000);      // Direccion fisica de la tabla de paginas
//  Setea los atributos de la PTE
    PTE |= (0 << 11);               // BIT 11: IGNORE
    PTE |= (0 << 10);               // BIT 10: IGNORE
    PTE |= (0 << 9);                // BIT 9:  IGNORE
    PTE |= (G << 8);                // BIT 8:  Global
    PTE |= (PAT << 7);              // BIT 7:  Page table attribute
    PTE |= (D << 6);                // BIT 6:  Dirty
    PTE |= (A << 5);                // BIT 5:  Accessed
    PTE |= (PCD << 4);              // BIT 4:  Page Level Cache Disable
    PTE |= (PWT << 3);              // BIT 3:  Page Level Write Through
    PTE |= (US << 2);               // BIT 2:  User or Supervisor
    PTE |= (RW << 1);               // BIT 1:  Read and Writeable
    PTE |= (P << 0);                // BIT 0:  Presence

    *(dst+ENTRY)= PTE;              // Guardamos el descriptor de la PT
}