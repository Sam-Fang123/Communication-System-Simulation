
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define SIZE 8
void show_binary(int num){
	
	int i,b[10]={0};

	for(i=1;i<=10;i++){
		b[10-i]=num%2;
		num=num/2;
	}
	for(i=0;i<10;i++)
		printf("%d",b[i]);
	printf("\n");
	
}

int mod_2(int num){
	int i;
	int sum=0;
	for(i=1;i<=10;i++){
		sum=sum+num%2;
		num=num/2;
		printf("%d ",num);
	}
	printf("\n");
	return sum%2;
}
int limit_output(int num){
	int i;
	int result=0;
	int pow=1;
	for(i=1;i<=SIZE;i++){
		result=result+(num%2)*pow;
		num=num/2;
		pow=pow*2; 
	}
	return result;
}
int main(){

	int s_num=256;
	//g1=561=1 0111 0001, g2=1 1110 1011
	int g1=0b100011101;
	int g2=0b110101111;
	int a2=0b111001111;
	
	show_binary(a2&g1);
	show_binary(a2&g2);
	int a,b;
	a=mod_2(a2&g1);
	b=mod_2(a2&g2);
 	printf("%d",a);
 	printf("%d\n",b);
	system("pause");
	return 0;
}
