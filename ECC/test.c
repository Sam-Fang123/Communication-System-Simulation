
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
	}
	printf("%d\n",sum);
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
	int a=0b111111111;
	int b=0b111011111;
	
	show_binary(a&b);
	printf("%d\n",a&b);
 	printf("%d\n",mod_2(a&b));
	system("pause");
	return 0;
}
