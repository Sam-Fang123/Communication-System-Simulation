
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
void show_binary(int num){
	
	int i,b[10]={0};

	for(i=1;i<10;i++){
		b[10-i]=num%2;
		num=num/2;
	}
	for(i=0;i<10;i++)
		printf("%d",b[i]);
	printf("\n");
	
}

void limit_output(int L,int num){
	int i;
	int result=0;
	int pow=1;
	for(i=1;i<=L;i++){
		result=result+(num%2)*pow;
		num=num/2;
		pow=pow*2; 
	}
	printf("%d\n",result);
}
int main(){

	int s_num=256;
 	show_binary(255);
 	show_binary((255<<1)+1);
 	printf("%d\n",(255<<1)+1);
 	limit_output(8,(255<<1)+1);
 	show_binary(255<<1);
 	printf("%d\n",255<<1);
 	limit_output(8,(255<<1));
	system("pause");
	return 0;
}
