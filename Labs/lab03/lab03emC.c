#include <stdio.h>

#define MAX_INPUT 12 // Max numbers of characters on input
#define MAX_BIN 35 // 32 bits + 0b + \0 = 35
#define MAX_HEX 11 // 8 bits + 0b + \0 = 11

//Input and Output
void read(char str[]){
    scanf("%s", str);
}

// Backside functions
void inicializate(char bin[], char hex[], char dec[], char end_dec[]){

  bin[MAX_BIN-1] ='\0';
  hex[MAX_HEX-1] = '\0';
  dec[MAX_INPUT-1] = '\0';
  end_dec[MAX_INPUT-1] = '\0';

  for(int i = 0; i < MAX_BIN - 1;i++) {bin[i] = '0';}
  for(int i = 0;i < MAX_HEX - 1;i++) {hex[i] = '0';}
  for(int i = 0;i < MAX_INPUT - 1;i++) {dec[i] = '0';}
  for(int i = 0;i < MAX_INPUT - 1;i++) {end_dec[i] = '0';}
  
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

void copy(char str[],char hex[]){
  int len = stringlen(str);
  for(int i = 0; str[len -1 -i] != 'x'; i++)
    hex[MAX_HEX-2-i] = str[len -1 -i];
}

int abs(int i){
  return i ? i<0:i; }

// Main converting functions
unsigned long int number(char str[]){
    int cont = stringlen(str) - 1, a = 0, num = 0;

    if (str[0] == '-') a = 1;

    for(int i = a; i < stringlen(str);i++){
        num += (str[i]-48)*power(10,cont-i);
    }
      
    return num;
}

void Dec_Bin(unsigned long int dec, char str[]){
    int cont = MAX_BIN-2;
    while(dec > 0){
      
      str[cont] = (dec % 2) + 48;
      cont--;
      dec = dec / 2;
    }
}

void Dec_Hex(unsigned long int dec, char str[]){
    int cont = MAX_HEX-2, aux;
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
    int  aux, index = stringlen(str)-1, cont = 0;
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
  for(i = 2; i < MAX_BIN - 1; i++)
    bin[i] = 49 - bin[i] + 48;
  for(i = MAX_BIN - 2; bin[i] != '0'; i--)
    bin[i] = 48;
  bin[i] = 49;
}

void Complement_Hex(char hex[]){
  int i;
  for(i = 2; i < MAX_HEX - 1; i++){
    if(hex[i] >= 97) hex[i] = 102 - hex[i] ;
    else hex[i] = 6 + (57 - hex[i]) ;   
  }

  for(i = MAX_HEX - 2; hex[i] == 15; i--)
    hex[i]= 0;
  hex[i]++;

 for(i = 2; i < MAX_HEX - 1; i++){
    if(hex[i] > 9) hex[i] = 96 -9 + hex[i] ;
    else hex[i] = 48 + hex[i] ;   
  }
}

unsigned long int Endianess(char hex[]){
  int aux, i;
  

  char end[MAX_HEX];
  end[MAX_HEX-1]='\0';
  for(int i = 0; i < MAX_HEX - 1;i++) {end[i] = '0';}

  for(i = 2; i < 10;i++){
    end[i] = hex[MAX_HEX-i];
  }

  i = 2;
  while(i < MAX_HEX -1){
    aux = end[i];
    end[i] = end[i+1];
    end[i+1] = aux;
    i+=2;
  }
   return Hex_Dec(end);
}

// Format

void int_str(char str[], unsigned long int num){
    int cont = MAX_INPUT-2;
    unsigned long int dec = num;
    
    while(dec != 0){
      
      str[cont] = abs(dec % 10) + 48;
      cont--;
      dec = abs(dec / 10);
    }
    
    
}

int main()
{
  char str[MAX_INPUT];
  unsigned long int num;
  char bin[MAX_BIN], hex[MAX_HEX], dec[MAX_INPUT], end_dec[MAX_INPUT];

 
  //Inicialization and Input
  inicializate(bin ,hex, dec, end_dec);
  read(str);

  // Converting Numbers

  if(str[1] == 'x'){

     copy(str,hex);
     num = Hex_Dec(hex);

     if(num < 0)  {bin[2] = '1';}
     else Dec_Bin(num, bin);
  } 
  else {
    num = number(str);

    if(num < 0){ bin[2] = '1'; hex[2] = '8';}
    else{ Dec_Bin(num, bin); Dec_Hex(num, hex);}
  
    if(str[0] == '-' && num >= 0){ 
      Complement_Bin(bin); 
      Complement_Hex(hex);}
  }
 
  //Modifying string

 int_str(dec,num);
 int_str(end_dec,  Endianess(hex));

  //Output

  printf("%s\n", bin);
  printf("%s\n", dec);
  if(str[1] == 'x') printf("%s\n", str); else printf("%s\n", hex);
  printf("%s\n", end_dec);

  return 0;
}
 

