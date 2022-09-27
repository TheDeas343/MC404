#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

#define MAX 200000
#define MAX_HEX 9 // 8 espaços + '\0'


typedef struct
{
    unsigned char e_ident[16];  // Magic number and other info
    unsigned short e_type;      // Object file type
    unsigned short e_machine;   // Architecture
    unsigned int e_version;     // Object file version
    unsigned int e_entry;       // Entry point virtual address
    unsigned int e_phoff;       // Program header table file offset
    unsigned int e_shoff;       // Section header table file offset
    unsigned int e_flags;       // Processor-specific flags
    unsigned short e_ehsize;    // ELF header size in bytes
    unsigned short e_phentsize; // Program header table entry size
    unsigned short e_phnum;     // Program header table entry count
    unsigned short e_shentsize; // Section header table entry size
    unsigned short e_shnum;     // Section header table entry count
    unsigned short e_shstrndx;  // Section header string table index
} Elf32_Ehdr;

typedef struct
{
    unsigned int sh_name;      // Section name (string tbl index)
    unsigned int sh_type;      // Section type
    unsigned int sh_flags;     // Section flags
    unsigned int sh_addr;      // Section virtual addr at execution
    unsigned int sh_offset;    // Section file offset
    unsigned int sh_size;      // Section size in bytes
    unsigned int sh_link;      // Link to another section
    unsigned int sh_info;      // Additional section information
    unsigned int sh_addralign; // Section alignment
    unsigned int sh_entsize;   // Entry size if section holds table
} Elf32_Shdr;

typedef struct
{
    unsigned int st_name;  // Symbol name (string tbl index)
    unsigned int st_value; // Symbol value
    unsigned int st_size;  // Symbol size
    unsigned char st_info; // Symbol type and binding
    unsigned char st_other;
    unsigned short st_shndx; // Section index
} Elf32_Sym;

// Complementar Functions
int compareString( unsigned char ELF[], int count, char cmp[]){
    char comp[100], c;
    int a = 0;

    c = ELF[count];

    while(c != '\0'){
        comp[a] = c;
        c = ELF[count + a + 1];
        a++;
    }   
    comp[a] = '\0';
    
    for(int i =0; i < a;i++) if (comp[i] != cmp[i]) return 1;
     return 0;

}

int stringlen(char string[]){
    int i;
    for(i = 0; string[i] != '\0'; i++);
    return i;
}

void Dec_Hex(unsigned long int dec, char str[]){
    int aux, cont = MAX_HEX - 2;
    while(dec > 0){

      aux = (dec % 16);
      if(aux <= 9) aux = aux + 48;
      else aux = aux - 10 + 97;

      str[cont] = aux ;
      cont--;
      dec = dec / 16;
    }
}

void IntinString(char print[], int * a, unsigned long int Num){
    char Hex[MAX_HEX];
    for(int i = 0 ; i< MAX_HEX-1; i++) Hex[i] = '0';


    Dec_Hex(Num,Hex);

    for(int i = 0 ; i< MAX_HEX-1; i++) print[*a + i] = Hex[i];

    *a += MAX_HEX - 1;

}

void copy(char print[], int * a, char copy[]){
    for(int i = 0; i < stringlen(copy); i++) print[*a+i] = copy[i];
    *a += stringlen(copy); 
}

int menorIndex(int addresSymbols[],int symtab_size){
    int menor;
    for(int i = 1; i < symtab_size; i++) if(addresSymbols[i] != -1) {menor = i; break;}

    for(int i = menor; i < symtab_size; i++)
        if(addresSymbols[i] < addresSymbols[menor] && addresSymbols[i] != -1 )
            menor = i;
    return menor;
}

// SECTIONS
void printLinhaSections(int count, Elf32_Shdr  *SecHead, unsigned char ELF[], int index){
    char print[100], c;
    int a = 4;

    c = ELF[count];

    print[0] = ' '; print[1] = ' ';
    print[2] = index +'0'; print[3] = ' ';
    if(index == 0){ print[4] = '\t'; a++;}

    while(c != '\0'){
        print[a] = c;
        c = ELF[count + a-3];
        a++;
    }
    
    print[a] = '\t'; a++;
    IntinString(print, &a, SecHead[index].sh_size);
    print[a] = ' '; a++;
    IntinString(print, &a, SecHead[index].sh_addr);

    print[a] = '\n';
    print[a+1] = '\0';

    write(1, print, stringlen(print));
}

//SYMBOL TABLE

void printLinhaSymbols(Elf32_Sym * SymbolTable, unsigned char ELF[], int index, int aux, Elf32_Shdr * SecHead, int count){
    char print[100];
    int addr = SymbolTable[index].st_value, a = 0;

    //Addres
    IntinString(print, &a, addr);
    print[a] = ' '; a++;

    //flag bits
    if(SymbolTable[index].st_info >> 4 == 0) print[a] = 'l';
    else print[a] = 'g';
    a++;

    //Section
    print[a] = '\t'; a++;

    if(count != -1){
        int n = 1;
        char c = ELF[count];
        while(c != '\0'){
            print[a] = c;
            c = ELF[count + n];
            n++; a++;
        }   
    } else copy(print, &a, "*ABS*");

    //Symbol name
    print[a] = '\t'; a++;
    int n = 1;
    char c = ELF[aux];
    while(c != '\0'){
        print[a] = c;
        c = ELF[aux + n];
        n++; a++;
    }

    print[a] = '\n';
    print[a+1] ='\0';
    write(1, print, stringlen(print));

}

//DISASSEMBLY

void printDisassembly(Elf32_Sym * SymbolTable, unsigned char ELF[], int index, int aux){
    char print[100];
    int addr = SymbolTable[index].st_value, a = 0;

    //Initial Addres
    IntinString(print, &a, addr);
    print[a] = ' '; a++;

    //Symbol name
    print[a] = '<'; a++;
    int n = 1;
    char c = ELF[aux];
    while(c != '\0'){
        print[a] = c;
        c = ELF[aux + n];
        n++; a++;
    }
    print[a] = '>'; print[a+1] = ':'; print[a+3] = '\n'; a+=2;
     
    print[a] = '\n';
    print[a+1] ='\0';
    write(1, print, stringlen(print));

}

int indextext(Elf32_Sym * SymbolTable, unsigned char ELF[], Elf32_Shdr* SecHead, int Tab_offset, int size){
    int aux;

    for(int i = 1; i < size; i++){
        if(SymbolTable[i].st_shndx <= size){
            aux = Tab_offset + SecHead[SymbolTable[i].st_shndx].sh_name;
            if(compareString(ELF, aux, ".text") == 0) return SymbolTable[i].st_shndx;
        }
    }
    return -1;
}
int main(int argc, char *argv[]){

    unsigned char ELF[MAX];

    //Leitura do arquivo de entrada
    int file_descriptor = open(argv[2],  O_RDONLY), count;
    read(file_descriptor, ELF, MAX);
    
    Elf32_Ehdr * Header = (Elf32_Ehdr*) &ELF; // Struct da File Header começando do inicio do arquivo ELF
    Elf32_Shdr  * SecHead = (Elf32_Shdr *) &ELF[Header->e_shoff]; // Vetor de section headers comecando do inicio da Section Headers
    
    int Tab_offset = SecHead[Header->e_shstrndx].sh_offset;

    //Impressao Base
    char File[100] = {"\tfile format elf32-littleriscv\n"};
    write(1,argv[2],stringlen(argv[2]));
    write(1,File, stringlen(File));

    if(argv[1][1] == 'h'){
        char Section[100] = {"\nSections:\nIdx Name\tSize\t VMA\n\0"};
        write(1,Section, stringlen(Section));

        for(int i = 0; i < Header->e_shnum; i++){
            int count = Tab_offset + SecHead[i].sh_name;
            printLinhaSections(count, SecHead, ELF, i);} 
    } 
    
    else {

        int symtab_offset, symtab_size ,strtab_offset;

        for(int i = 0; i < Header->e_shnum; i++){
            count = Tab_offset + SecHead[i].sh_name;
            if(compareString(ELF, count, ".symtab") == 0){
                symtab_offset = SecHead[i].sh_offset;
                symtab_size = SecHead[i].sh_size/16;
            }
            else if (compareString(ELF, count, ".strtab") == 0){
                strtab_offset = SecHead[i].sh_offset;
            }
        }

        Elf32_Sym  * SymbolTable = (Elf32_Sym *) &ELF[symtab_offset];

        
        if(argv[1][1] == 't') {
            char Symbol[100] = {"\nSYMBOL TABLE:\n\0"};
            write(1,Symbol, stringlen(Symbol));

            for(int i = 1; i < symtab_size; i++)  {
                int index = SymbolTable[i].st_shndx;
                if(index > Header->e_shnum) count = -1;
                else count = Tab_offset + SecHead[index].sh_name;
                int aux = strtab_offset + SymbolTable[i].st_name;

                printLinhaSymbols(SymbolTable, ELF, i, aux, SecHead, count);
            }
        }

        else if(argv[1][1] == 'd'){
            char Disassembly[100] = {"\nDisassembly of section .text:\n\n\0"};
            write(1, Disassembly, stringlen(Disassembly));

            int text_index = indextext(SymbolTable, ELF, SecHead, Tab_offset, Header->e_shnum);
            int addresSymbols[symtab_size];
            for(int i = 0; i < symtab_size; i++) addresSymbols[i] = -1;

            count = 0;
            for(int i = 1; i < symtab_size; i++)
                if(SymbolTable[i].st_shndx == text_index) {
                    addresSymbols[i] = SymbolTable[i].st_value; count++;}

            while(count > 0){
                
                int index = menorIndex(addresSymbols, symtab_size );
                int aux = strtab_offset + SymbolTable[index].st_name;
                printDisassembly(SymbolTable, ELF, index, aux);
                addresSymbols[index] = -1;
                count--;
            }

        }

    }

    return 0;
}