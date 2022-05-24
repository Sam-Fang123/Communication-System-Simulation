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

int limit_output(int L,int num){
	int i;
	int result=0;
	int pow=1;
	for(i=1;i<=L;i++){
		result=result+(num%2)*pow;
		num=num/2;
		pow=pow*2; 
	}
	return result;
}

int main(){

	int s_num=256;
	struct state{
		int next_s_0;
		int next_s_1;
		int next_out_0;
		int next_out_1;
		
	}S[s_num];
	
	int i;
	for(i=0;i<256;i++){
		S[i].next_s_0=limit_output(8,i<<1);
		S[i].next_s_1=limit_output(8,(i<<1)+1);
		S[i].next_out_0=
	}
	
	system("pause");
	return 0;
}
