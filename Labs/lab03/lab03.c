#include <stdio.h>
#include <string.h>
#include <math.h>

#define MAX_INPUT 11 // Max numbers of characters on input


void read(char str[]){
    scanf("%s", str);
}

// int number(char str[]){
//     int cont = strlen(str) - 1, a = 0, num = 0;

//     if(str[0] == '0') a = 2;
//     else if (str[0] == '-') a = 1;

//     for(int i = a; i < strlen(str);i++)
//         num += (str[i]-48)*pow(10,cont-i);

//     if(a == 1) return (-1)*num;
//     return num;
// }

int Dec_Bin(int dec){
    if(dec < 2) return dec % 2;
    return 10*Dec_Bin(dec/2) + (dec%2);
}


// int Hex_Bin(int num){
//     int cont = 0;
//     while(num > 0){
//         bin = Dec_Bin(num%10)*pow(10,cont);
//         cont +=4;
//         num = num / 10;
//     }


// }
int decimal(char str[]);
void hexadecimal(char bin[],char hex[]);
int endianness_dec(char hex[]);


int main()
{
  //Declaration  
  char str[MAX_INPUT];
  int num, bin , end_dec;
    int dec;
  //Input
//   read(str);
    scanf("%d",&num);

  // Functions Execution 

  //num = number(str);

//   if(strcmp(str[0],'0') == 0){
//     bin = Hex_Bin(num);
//     }

//   if(strcmp(str[0],0) == 0){
//     dec = decimal(str);
//     printf("%d\n",dec);
//   } else printf("%s\n",str);
    
//   hexadecimal(bin,hex);
//   printf("%s\n",hex);


//   end_dec= endianness_dec(hex);
//   printf("%d\n",end_dec);

    // printf("%d\n", num);
    printf("%d\n", Dec_Bin(num));


  return 0;
}
 

