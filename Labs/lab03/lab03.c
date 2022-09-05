#define MAX_INPUT 13 // Max numbers of characters on input
#define MAX_BIN 36 // 32 bits + 0b + \0 = 35
#define MAX_HEX 12 // 8 bits + 0b + \0 = 11

//Input and Output
int read(int __fd, const void *__buf, int __n){
  int bytes;
  __asm__ __volatile__(
    "mv a0, %1           # file descriptor\n"
    "mv a1, %2           # buffer \n"
    "mv a2, %3           # size \n"
    "li a7, 63           # syscall read (63) \n"
    "ecall \n"
    "mv %0, a0"
    : "=r"(bytes)  // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
  return bytes;
}
 
void write(int __fd, const void *__buf, int __n){
  __asm__ __volatile__(
    "mv a0, %0           # file descriptor\n"
    "mv a1, %1           # buffer \n"
    "mv a2, %2           # size \n"
    "li a7, 64           # syscall write (64) \n"
    "ecall"
    :   // Output list
    :"r"(__fd), "r"(__buf), "r"(__n)    // Input list
    : "a0", "a1", "a2", "a7"
  );
}


// Backside functions
void inicializate(char bin[], char hex[], char dec[], char end[]){

  bin[MAX_BIN-1] ='\0';
  hex[MAX_HEX-1] = '\0';
  dec[MAX_INPUT-1] = '\0';
  end[MAX_INPUT-1] = '\0';

  bin[MAX_BIN-2] ='\n';
  hex[MAX_HEX-2] = '\n';
  dec[MAX_INPUT-2] = '\n';
  end[MAX_INPUT-2] = '\n';

  for(int i = 0; i < MAX_BIN - 2;i++) {bin[i] = '0';}
  for(int i = 0; i < MAX_HEX - 2;i++) {hex[i] = '0';}
  for(int i = 0; i < MAX_INPUT - 2;i++) {dec[i] = '0';}
  for(int i = 0; i < MAX_INPUT - 2;i++) {end[i] = '0';}
  
}

int stringlen(char str[]){
  int i;
  for( i = 0; str[i] != '\0'; i++) ;
  return i;
}

unsigned long int power(int base, int exp){
  unsigned long int num =1;
  for(int i = 0 ; i < exp; i++)
    num = num*base;
  return num;
}

void copy(char str[],char hex[], int n){
  int len = n;
  for(int i = 0; str[len -1 -i] != 'x'; i++)
    hex[MAX_HEX-2-i] = str[len -1 -i];
}


// Main converting functions
unsigned long int number(char str[]){
    int cont = stringlen(str) - 2, a = 0;
    unsigned long int  num = 0;

    if (str[0] == '-') a = 1;

    for(int i = a; i < stringlen(str)-1;i++){
      
        num += (str[i]-48)*power(10,cont-i);
    }
    return num;
}

void Dec_Bin(unsigned long int dec, char str[]){
    int cont = MAX_BIN-3;
    while(dec > 0){
      
      str[cont] = (dec % 2) + 48;
      cont--;
      dec = dec / 2;
    }
}

void Dec_Hex(unsigned long int dec, char str[]){
    int cont = MAX_HEX-3, aux;
    while(dec > 0){

      aux = (dec % 16);
      if(aux <= 9) aux = aux + 48;
      else aux = aux - 10 + 97;

      str[cont] = aux ;
      cont--;
      dec = dec / 16;
    }
}

unsigned long int Hex_Dec(char str[]){
    int  aux, index = MAX_HEX-3, cont = 0;
    unsigned long int num=0;
    while(index > 1){

      aux = str[index];
      if(aux >= 97) aux = 10 + aux - 97;
      else aux = aux - 48; 

      num += aux*power(16, cont);
      
      index--;
      cont++;
      
    }
    return num;
}

void Complement_Bin(char bin[]){
  int i;
  for(i = 2; i <= MAX_BIN - 2; i++) bin[i] = 49 - bin[i] + 48;

  for(i = MAX_BIN - 2; bin[i] != '0'; i--) bin[i] = 48;

  bin[i] = 49;

}

void Complement_Hex(char hex[]){
  int i;
  for(i = 2; i <= MAX_HEX - 3; i++){
    if(hex[i] >= 97) hex[i] = 102 - hex[i] ;
    else hex[i] = 6 + (57 - hex[i]) ;   
  }

  for(i = MAX_HEX - 3; hex[i] == 15; i--)
    hex[i]= 0;
  hex[i]++;

 for(i = 2; i < MAX_HEX - 2; i++){
    if(hex[i] > 9) hex[i] = 96 -9 + hex[i] ;
    else hex[i] = 48 + hex[i] ;   
  }
}

unsigned long int Endianess(char hex[]){
  int aux, i;
  
  char space[1] ={"\n"};
  char end[MAX_HEX];
  end[MAX_HEX-1]='\0';
  end[MAX_HEX-2]='\n';
  for(int i = 0; i < MAX_HEX - 2;i++) {end[i] = '0';}

  for(i = 2; i < 10;i++){
    end[i] = hex[MAX_HEX-i-1];
  }

  i = 2;
  while(i <= MAX_HEX -2){
    aux = end[i];
    end[i] = end[i+1];
    end[i+1] = aux;
    i+=2;
  }
   return Hex_Dec(end);
}

// Format

void int_str(char str[], unsigned long int num){
    int cont = stringlen(str) - 2; 
    unsigned long int dec = num;
  
    while(dec != 0){
      
      str[cont] = dec % 10 + 48;
  
      cont--;
      dec = dec / 10;
    }
}

int str_cut(char str[]){
  int i, a, j=0, ini =2;

  

  if(str[1] == 'b') a = MAX_BIN-1 ;
  else if(str[1] == 'x') a = MAX_HEX-2;
  else if( str[0] == '-') {a = MAX_INPUT-2; ini = 1;}
  else{a = MAX_INPUT-2; ini = 0;}
  
  for(i = ini; str[i] == '0'; i++);
  
  while(i+j < a){
    str[ini+j] = str[i+j];
    j++;
    }
  
  str[ini+j] ='\n';
  return ini+j+1;
}


int main()
{
  char str[MAX_INPUT] , space[1] ={'\n'};
  unsigned long int num;
  char bin[MAX_BIN], hex[MAX_HEX], dec[MAX_INPUT], end_dec[MAX_INPUT];

  //Inicialization and Input
  inicializate(bin ,hex, dec, end_dec);
  int n = read(0, str, MAX_INPUT);

  // Converting Numbers

  if(str[1] == 'x'){

     copy(str,hex,n);
     num = Hex_Dec(hex);
     Dec_Bin(num, bin);
  } 
  else {
    num = number(str);

    Dec_Bin(num, bin); 
    Dec_Hex(num, hex);
    
    if(str[0] == '-'){Complement_Bin(bin); Complement_Hex(hex);}
  }
 
  //Modifying string

 int_str(dec,num);
 int_str(end_dec,  Endianess(hex));
 
 if(bin[2] == '1') dec[0] = '-'; 
 bin[1] = 'b';
 hex[1] = 'x';

 int i_bin = str_cut(bin);
 int i_dec = str_cut(dec);
 int i_hex = str_cut(hex);
 int i_end_dec = str_cut(end_dec);

  //Output

  write(1,bin,i_bin);

  if(str[1] != 'x') write(1,str,n); else write(1,dec,i_dec);

  if(str[1] == 'x') write(1,str,n); else write(1,hex,i_hex);
  
  write(1,end_dec,i_end_dec);

  return 0;
}

void _start(){
  main();
}
