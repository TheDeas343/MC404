#include <fcntl.h>
#include <unistd.h>

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

void Dec_Hex(unsigned long int dec, char str[], int size){
    int aux, cont = size -2;
    while(dec > 0){

      aux = (dec % 16);
      if(aux <= 9) aux = aux + 48;
      else aux = aux - 10 + 97;

      str[cont] = aux ;
      cont--;
      dec = dec / 16;
    }
}

void IntinString(char print[], int * a, unsigned long int Num, int size){
    char base[size];
    for(int i = 0 ; i< size; i++) base[i] = '0';


    Dec_Hex(Num,base,size);

    for(int i = 0 ; i< size; i++) print[*a + i] = base[i];

    *a += size - 1;

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

int power(int base, int exp){
    int res = 1;
    for(int i = 0; i < exp; i++) res = res*base;
    return res;
}

void Complement_Bin(char bin[], int size){
  int i;
  for(i = 0; i < size; i++) bin[i] = 49 - bin[i] + 48;

  for(i = size-1; bin[i] != '0'; i--) bin[i] = 48;

  bin[i] = 49;

}

// SECTIONS
void printLinhaSections(int count, Elf32_Shdr  *SecHead, unsigned char ELF[], int index){
    char print[100], c;
    int a = 4;

    c = ELF[count];
    //Index
    print[0] = ' '; print[1] = ' ';
    print[2] = index +'0'; print[3] = ' ';
    if(index == 0){ print[4] = '\t'; a++;}

    //Section Name
    while(c != '\0'){
        print[a] = c;
        c = ELF[count + a-3];
        a++;
    }
    
    //Size
    print[a] = '\t'; a++;
    IntinString(print, &a, SecHead[index].sh_size, MAX_HEX);

    //Addres
    print[a] = ' '; a++;
    IntinString(print, &a, SecHead[index].sh_addr, MAX_HEX);

    print[a] = '\n';
    print[a+1] = '\0';

    write(1, print, stringlen(print));
}

//SYMBOL TABLE

void printLinhaSymbols(Elf32_Sym * SymbolTable, unsigned char ELF[], int index, int aux, Elf32_Shdr * SecHead, int count){
    char print[100];
    int addr = SymbolTable[index].st_value, a = 0;

    //Addres
    IntinString(print, &a, addr, MAX_HEX);
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

    print[a] = ' '; a++;print[a] = ' '; a++;

    IntinString(print, &a, SymbolTable[index].st_size, MAX_HEX);

    //Symbol name
    print[a] = ' '; a++;
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

// INSTRUCTION NAME
int compareInstruction(char binario[], int fim, int ini, char cmp[]){
    int a = 0;
    for(int i = (31-ini); i <= (31-fim); i ++){
        if(binario[i] != cmp[a]) return 1;
        a++;
    }
    return 0;

}

void putInstruction(char print[], int * a, char put[]){
    for(int i = 0; i < stringlen(put); i++) {print[*a + i] = put[i];}
    *a += stringlen(put);
    print[*a] = ' '; *a+=1;
}

char nameInstruction(char print[], int * a, char binario[]){
    char Type = '0';

    //Type U
    if(compareInstruction(binario,0,6,"0110111") == 0){
       putInstruction(print, a, "lui"); Type = 'U';}

    else if(compareInstruction(binario,0,6,"0010111") == 0){
       putInstruction(print, a, "auipc"); Type = 'U';}   

    //jal
    else if(compareInstruction(binario,0,6,"1101111") == 0){
       putInstruction(print, a, "jal"); Type = 'J';}  

    //jalr
    else if(compareInstruction(binario,0,6,"1100111") == 0){
       putInstruction(print, a, "jalr"); Type = 'A';}

    // Type B
    else if(compareInstruction(binario,0,6,"1100011") == 0){
        Type = 'B';
        if(compareInstruction(binario,12,14,"000") == 0)
            putInstruction(print, a, "beq"); 
        else if(compareInstruction(binario,12,14,"001") == 0)
            putInstruction(print, a, "bne"); 
        else if(compareInstruction(binario,12,14,"100") == 0)
            putInstruction(print, a, "blt"); 
        else if(compareInstruction(binario,12,14,"101") == 0)
            putInstruction(print, a, "bge"); 
        else if(compareInstruction(binario,12,14,"110") == 0)
            putInstruction(print, a, "bltu"); 
        else if(compareInstruction(binario,12,14,"111") == 0)
            putInstruction(print, a, "bgeu");     
        else Type = '0';
    }  

    //Type I pt.1
    else if(compareInstruction(binario,0,6,"0000011") == 0){
        Type = 'A';
        if(compareInstruction(binario,12,14,"000") == 0)
            putInstruction(print, a, "lb"); 
        else if(compareInstruction(binario,12,14,"001") == 0)
            putInstruction(print, a, "lh"); 
        else if(compareInstruction(binario,12,14,"010") == 0)
            putInstruction(print, a, "lw"); 
        else if(compareInstruction(binario,12,14,"100") == 0)
            putInstruction(print, a, "lbu"); 
        else if(compareInstruction(binario,12,14,"101") == 0)
            putInstruction(print, a, "lhu"); 
        else Type = '0';
            
    }

    //Type S 

    else if(compareInstruction(binario,0,6,"0100011") == 0){
        Type = 'S';
        if(compareInstruction(binario,12,14,"000") == 0)
            putInstruction(print, a, "sb"); 
        else if(compareInstruction(binario,12,14,"001") == 0)
            putInstruction(print, a, "sh"); 
        else if(compareInstruction(binario,12,14,"010") == 0)
            putInstruction(print, a, "sw"); 
        else Type = '0';
    }

    //Type I pt.2 
    else if(compareInstruction(binario,0,6,"0010011") == 0){
        Type = 'I';
        if(compareInstruction(binario,12,14,"000") == 0)
            putInstruction(print, a, "addi"); 
        else if(compareInstruction(binario,12,14,"010") == 0)
            putInstruction(print, a, "slti"); 
        else if(compareInstruction(binario,12,14,"011") == 0)
            putInstruction(print, a, "sltiu"); 
        else if(compareInstruction(binario,12,14,"100") == 0)
            putInstruction(print, a, "xori"); 
        else if(compareInstruction(binario,12,14,"110") == 0)
            putInstruction(print, a, "ori"); 
        else if(compareInstruction(binario,12,14,"111") == 0)
            putInstruction(print, a, "andi");
        else{
            Type = 'i';
            if((compareInstruction(binario,12,14,"001") == 0) & (compareInstruction(binario,25,31,"0000000") == 0))
                putInstruction(print, a, "slli"); 
            else if((compareInstruction(binario,12,14,"101") == 0 )& (compareInstruction(binario,25,31,"0000000") == 0))
                putInstruction(print, a, "srli"); 
            else if((compareInstruction(binario,12,14,"101") == 0 )& (compareInstruction(binario,25,31,"0100000") == 0))
                putInstruction(print, a, "srai");
            else Type = '0';}
    }

    //Type R

    else if(compareInstruction(binario,0,6,"0110011") == 0){
        Type = 'R';

        if(compareInstruction(binario,12,14,"000") == 0){
            if(compareInstruction(binario,25,31,"0000000") == 0)
                 putInstruction(print, a, "add");
            else if(compareInstruction(binario,25,31,"0100000") == 0)
                 putInstruction(print, a, "sub");}
        else if((compareInstruction(binario,12,14,"001") == 0 )& (compareInstruction(binario,25,31,"0000000") == 0))
            putInstruction(print, a, "sll"); 
        else if((compareInstruction(binario,12,14,"010") == 0 )& (compareInstruction(binario,25,31,"0000000") == 0))
            putInstruction(print, a, "slt"); 
        else if((compareInstruction(binario,12,14,"011") == 0 )& (compareInstruction(binario,25,31,"0000000") == 0))
            putInstruction(print, a, "sltu"); 
        else if((compareInstruction(binario,12,14,"100") == 0) & (compareInstruction(binario,25,31,"0000000") == 0))
            putInstruction(print, a, "xor"); 
        else if(compareInstruction(binario,12,14,"101") == 0){
            if(compareInstruction(binario,25,31,"0000000") == 0)
                 putInstruction(print, a, "srl");
            else if(compareInstruction(binario,25,31,"0100000") == 0)
                 putInstruction(print, a, "sra");}
        else if((compareInstruction(binario,12,14,"110") == 0 )& (compareInstruction(binario,25,31,"0000000") == 0))
            putInstruction(print, a, "or");
        else if((compareInstruction(binario,12,14,"111") == 0 )& (compareInstruction(binario,25,31,"0000000") == 0))
            putInstruction(print, a, "and");  
        else Type = '0';
    }
    

    //Fence

    else if((compareInstruction(binario,0,19,"00000000000000001111") == 0 )& (compareInstruction(binario,27,21,"0000") == 0)){
       putInstruction(print, a, "fence"); Type = 'F';}  

    //Type I - Complete

    else if(compareInstruction(binario,0,31,"00000000000000000001000000001111") == 0){
       putInstruction(print, a, "fence.i"); Type = 'C';}    
    
    else if(compareInstruction(binario,0,31,"00000000000000000000000001110011") == 0){
       putInstruction(print, a, "ecall"); Type = 'C';}  

    else if(compareInstruction(binario,0,31,"00000000000100000000000001110011") == 0){
       putInstruction(print, a, "ebreak"); Type = 'C';}

    //Type I pt.3 - csr

    else if(compareInstruction(binario,0,6,"1110011") == 0){
        Type = 'X';
        if(compareInstruction(binario,12,14,"001") == 0)
            putInstruction(print, a, "csrrw"); 
        else if(compareInstruction(binario,12,14,"010") == 0)
            putInstruction(print, a, "csrrs"); 
        else if(compareInstruction(binario,12,14,"011") == 0)
            putInstruction(print, a, "csrrc"); 
        else{
            Type = 'x';
            if(compareInstruction(binario,12,14,"101") == 0)
                putInstruction(print, a, "csrrwi"); 
            else if(compareInstruction(binario,12,14,"110") == 0)
                putInstruction(print, a, "csrrsi");
            else if(compareInstruction(binario,12,14,"111") == 0)
                putInstruction(print, a, "csrrci"); 
            else Type = '0';}
    }
    if (Type == '0') Type = 'K';

    return Type;
}

// REGISTRADORES E IMEDIATOS
int returnDec(char binario[], int fim, int ini){
    int dec = 0, a = 0;

    for(int i = 31 - fim; i >= 31 - ini; i--){
        dec += power(2,a) * (binario[i] - '0'); a++;}
    return dec;
}

void putRegister( char print[], int * a, char registers[32][5], int r){
    int i = 0;
    while(registers[r][i] !=  '\0'){
        print[*a] = registers[r][i]; *a += 1; i++;
    }
}

void immSeq(char binario[], char imm[], int fim, int ini, int * count){
    
    for(int i = 31 - ini; i <= 31 - fim; i++){
        imm[*count] = binario[i]; *count += 1;}
}

void int_str(char print[], int *a, int dec){
    int num, rec = 0;
    for(int i = 5; i >=0 ; i--){
        num = (dec / (power(10,i))) % 10;
        if(num > 0 || rec != 0){
            print[*a] = num +'0'; *a += 1; rec++;
        }
    }
    if(rec == 0){print[*a] = '0'; *a += 1;}
}

void printImm( char imm[], char print[], int *a){
    int dec = 0, n = 0;

    if(imm[0] == '1') {Complement_Bin(imm, stringlen(imm)); print[*a] ='-'; *a += 1;}

    for(int i = stringlen(imm) -1 ; i >= 0 ; i--){
        dec += power(2,n) * (imm[i] - '0'); n++;}

    int_str(print,a,dec);

}

void registerInstruction(char print[], int * a, char binario[], char Type, int addr,Elf32_Shdr * SecHead, int symtab_size, unsigned char ELF[],int strtab_offset, Elf32_Sym * SymbolTable) {

    char registers[32][5] = {"zero","ra","sp","gp","tp","t0","t1","t2","s0","s1","a0","a1","a2","a3","a4","a5",
    "a6","a7","s2","s3","s4","s5","s6","s7","s8","s9","s10","s11","t3","t4","t5","t6"};
    char imm[33];

    int r, count = 0;
    
    //Type U
    if(Type == 'U'){
        r = returnDec(binario,7,11);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1; print[*a] =' ';*a += 1;

        immSeq(binario,imm,12,31,&count); imm[count] = '\0';
        printImm(imm, print, a);
    }

    //JAL
    if(Type =='J'){
        r = returnDec(binario,7,11);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1; print[*a] =' ';*a += 1;

        for(int i = 0; i < 12; i++) {imm[i] = binario[0];}
        count += 11;
        immSeq(binario,imm,31-19,31-12,&count);
        imm[count] = binario[11]; count++;
        immSeq(binario,imm,31-10,31-1,&count);
        imm[count] = '0'; count++; imm[count] ='\0';

        if(imm[0] == '1') Complement_Bin(imm,stringlen(imm));

        print[*a] = '0'; print[*a+1] = 'x'; *a += 2;
        
        int num = returnDec(imm,31-stringlen(imm)+1, 31 - 0);
        if(binario[0] == '1') num *= -1;

        int i;
        for(i = 1; i < symtab_size; i++) if(SymbolTable[i].st_value == (addr+num)) break;

        IntinString(print,a,(addr+num),6);

        //Symbol name

        print[*a] = ' '; *a+=1; print[*a] = '<'; *a+=1;
        
        int n = 1; int aux = strtab_offset + SymbolTable[i].st_name;
        char c = ELF[aux];
        while(c != '\0'){
            print[*a] = c;
            c = ELF[aux + n];
            n++; *a+=1;
        }
        print[*a] = '>'; *a+=1;
    
    }
    
    //Type B
    else if(Type == 'B'){
        r = returnDec(binario,15,19);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1; print[*a] =' ';*a += 1;

        r = returnDec(binario,20,24);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1; print[*a] =' ';*a += 1;
        
        imm[count] = binario[31-7]; count++;
        immSeq(binario,imm,27,30,&count);
        immSeq(binario,imm,25,26,&count);
        immSeq(binario,imm,8,11,&count);

        imm[count] = '0'; count++; imm[count] ='\0';

        if(imm[0] == '1') Complement_Bin(imm,stringlen(imm));

        print[*a] = '0'; print[*a+1] = 'x'; *a += 2;

        int num = returnDec(imm,31-stringlen(imm)+1, 31 - 0);
        if(binario[0] == '1') num *= -1;

        int i;
        for(i = 1; i < symtab_size; i++) if(SymbolTable[i].st_value == (addr+num)) break;

        IntinString(print,a,(addr+num),6);

        //Symbol name

        print[*a] = ' '; *a+=1; print[*a] = '<'; *a+=1;
        
        int n = 1; int aux = strtab_offset + SymbolTable[i].st_name;
        char c = ELF[aux];
        while(c != '\0'){
            print[*a] = c;
            c = ELF[aux + n];
            n++; *a+=1;
        }
        print[*a] = '>'; *a+=1;
    }

    //Type I pt.1
    else if(Type == 'A'){
        r = returnDec(binario,7,11);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1;print[*a] =' ';*a += 1;

        immSeq(binario,imm,20,31,&count); imm[count] = '\0';
        printImm(imm, print, a);


        print[*a] ='(';*a += 1;
        r = returnDec(binario,15,19);
        putRegister(print, a, registers, r);
        print[*a] =')';*a += 1;
    }

    //Type S
    else if(Type == 'S'){
        r = returnDec(binario,20,24);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1;print[*a] =' ';*a += 1;

    
        immSeq(binario,imm,31-4,31-0,&count);
        immSeq(binario,imm,25,31-5,&count);
        immSeq(binario,imm,11-4,11,&count);
        imm[count] = '\0';
        printImm(imm, print, a);

        print[*a] ='(';*a += 1;
        r = returnDec(binario,15,19);
        putRegister(print, a, registers, r);
        print[*a] =')';*a += 1;
    }

    //Type I pt.2
    else if(Type == 'I' || Type == 'i'){
        r = returnDec(binario,7,11);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1;print[*a] =' ';*a += 1;

        r = returnDec(binario,15,19);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1;print[*a] =' ';*a += 1;

        if(Type == 'I') {immSeq(binario,imm,20,31,&count); imm[count] = '\0';}
        else{ immSeq(binario,imm,20,25,&count); imm[count] = '\0'; imm[0] = '0';}

        printImm(imm, print, a);
    }
    
    //FENCE
    else if(Type == 'F'){
        char fenc[4] = {'i','o','r','w'};

        immSeq(binario,imm,24,27,&count); imm[count] = '\0';
        for(int i = 0; i< 4; i++)
            if(imm[i] == '1') {print[*a] = fenc[i];*a+=1;}
        
        print[*a] =',';*a += 1;print[*a] =' ';*a += 1;

        char imm[32]; count = 0;
        immSeq(binario,imm,20,23,&count); imm[count] = '\0';
        for(int i = 0; i< 4; i++)
            if(imm[i] == '1') {print[*a] = fenc[i];*a+=1;}

    }

    //Type i pt.2
    else if(Type == 'R'){
        r = returnDec(binario,7,11);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1;print[*a] =' ';*a += 1;

        r = returnDec(binario,15,19);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1;print[*a] =' ';*a += 1;

        r = returnDec(binario,20,24);
        putRegister(print, a, registers, r);
    }

    //Csr
     else if(Type == 'X' || Type == 'x'){
        r = returnDec(binario,7,11);
        putRegister(print, a, registers, r);
        print[*a] =',';*a += 1;print[*a] =' ';*a += 1;

        immSeq(binario,imm,20,31,&count); imm[count] = '\0';
        printImm(imm, print, a);
        print[*a] =',';*a += 1;print[*a] =' ';*a += 1;

        if(Type == 'X'){
            r = returnDec(binario,15,19);
            putRegister(print, a, registers, r);}
        else{
            char imm[32]; count = 0;
            immSeq(binario,imm,15,19,&count); imm[count] = '\0';
            printImm(imm, print, a);
        } 
    }

    else if(Type == 'K'){
        copy(print,a,"<unknown>");
    }
}

void printInstructions(char print[], int * a, unsigned char ELF[], int offset, int addr,Elf32_Shdr * SecHead, int symtab_size,int strtab_offset, Elf32_Sym * SymbolTable){
    char binario[33]; 
    int index = 0;
    char Type;

    //Binario da instrução
    for(int j = 3; j >= 0; j--)
        for(int i = 7; i >=0; i--){
            binario[index] = (ELF[offset+j] >> i) % 2 + '0';
            index++;
        }
    binario[index] = '\0';

    print[*a] = ' ';*a += 1;
    Type = nameInstruction(print, a, binario);
    print[*a] = ' ';*a += 1;

    registerInstruction(print, a, binario, Type, addr,SecHead,symtab_size,ELF, strtab_offset,SymbolTable);
      
}

// PRINT DISASSEMBLY

void printAddress(Elf32_Sym * SymbolTable, unsigned char ELF[], int index, int deadline,int max, int * offset, int Taddr,Elf32_Shdr * SecHead, int symtab_size, int strtab_offset) {
    int addr = SymbolTable[index].st_value, last = 0;
    if(deadline == -1) {last = 1; deadline =  Taddr + max;}

    while(addr < deadline){
        char print[100];
        int a = 0;
    
        // Imprimindo os endereços atuais
        IntinString(print, &a, addr, 6);
        print[a] = ':'; a++; print[a]=' '; a++;
        
        // Imprimindo os hexadecimal das instruções
        
        for(int i = 0; i < 4; i ++){
            IntinString(print, &a, ELF[*offset + i],3);
            print[a] = ' '; a++;
        }

        printInstructions(print, &a, ELF, *offset, addr, SecHead,symtab_size, strtab_offset,SymbolTable);
        
        print[a] = '\n';
        print[a+1] = '\0';

        write(1,print,stringlen(print));

        *offset+=4;
        addr+=4;
    }

    
    
    if(last == 0) write(1,"\n",1);
}

void printDisassembly(Elf32_Sym * SymbolTable, unsigned char ELF[], int index, int aux, int deadline,int max, int *offset, int Taddr, Elf32_Shdr * SecHead, int symtab_size, int strtab_offset){
    char print[100];
    int addr = SymbolTable[index].st_value, a = 0;


    //Initial Addres
    IntinString(print, &a, addr,MAX_HEX);
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

    //Imprimir as 3 Colunas
    printAddress(SymbolTable, ELF,index, deadline, max, offset, Taddr, SecHead, symtab_size, strtab_offset);

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

// MAIN

int main(int argc, char *argv[]){

    unsigned char ELF[MAX];

    //Leitura do arquivo de entrada
    int file_descriptor = open(argv[2],  O_RDONLY), count;
    read(file_descriptor, ELF, MAX);
    
    Elf32_Ehdr * Header = (Elf32_Ehdr*) &ELF; // Struct da File Header começando do inicio do arquivo ELF
    Elf32_Shdr  * SecHead = (Elf32_Shdr *) &ELF[Header->e_shoff]; // Vetor de section headers comecando do inicio da Section Headers
    
    int Tab_offset = SecHead[Header->e_shstrndx].sh_offset;

    //Impressao Base
    char File[100] = {":\tfile format elf32-littleriscv\n"};

    write(1,"\n", 1);
    write(1,argv[2],stringlen(argv[2]));
    write(1,File, stringlen(File));


    //Arquivo -h

    if(argv[1][1] == 'h'){
        char Section[100] = {"\nSections:\nIdx Name\tSize\t VMA\n\0"};
        write(1,Section, stringlen(Section));

        for(int i = 0; i < Header->e_shnum; i++){
            int count = Tab_offset + SecHead[i].sh_name;
            printLinhaSections(count, SecHead, ELF, i);} 
        write(1,"\n", 1);} 
    
    else {

        // Informacoes a serem utilizadas em -t e -d

        int symtab_offset, symtab_size ,strtab_offset;

        for(int i = 0; i < Header->e_shnum; i++){
            count = Tab_offset + SecHead[i].sh_name;
            if(compareString(ELF, count, ".symtab") == 0){
                symtab_offset = SecHead[i].sh_offset;
                symtab_size = SecHead[i].sh_size/16;
            }
            else if (compareString(ELF, count, ".strtab") == 0){
                strtab_offset = SecHead[i].sh_offset;
            }}

        Elf32_Sym  * SymbolTable = (Elf32_Sym *) &ELF[symtab_offset];

        
        // Arquivo -t

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

        // Arquivo -d

        else if(argv[1][1] == 'd'){

            char Disassembly[100] = {"\n\nDisassembly of section .text:\n\n\0"};
            write(1, Disassembly, stringlen(Disassembly));

            //Informações sobre .text
            int addresSymbols[symtab_size], text_index = indextext(SymbolTable, ELF, SecHead, Tab_offset, symtab_size);
            for(int i = 0; i < symtab_size; i++) addresSymbols[i] = -1;

            //Vetor de enderecos das Symbols
            count = 0;
            for(int i = 1; i < symtab_size; i++) {if(SymbolTable[i].st_shndx == text_index) { addresSymbols[i] = SymbolTable[i].st_value; count++;}}
           
            //Endereco maximo da .text
            int Taddr, max, offset ,index = menorIndex(addresSymbols, symtab_size );
            for(int i = 0; i < Header->e_shnum; i++) if(SecHead[i].sh_addr == addresSymbols[index]){
                offset = SecHead[i].sh_offset; max = SecHead[i].sh_size; Taddr = SecHead[i].sh_addr;}

            //Iteracao pelas Symbols Imprimindo
            while(count > 0){
                
                
                index = menorIndex(addresSymbols, symtab_size );
                addresSymbols[index] = -1;
                
                int deadline = addresSymbols[menorIndex(addresSymbols, symtab_size )];
                int aux = strtab_offset + SymbolTable[index].st_name;
                
                printDisassembly(SymbolTable, ELF, index, aux, deadline, max, &offset , Taddr, SecHead, symtab_size, strtab_offset);
                
                count--;
    }}}

    return 0;
}