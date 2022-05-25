#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define SIZE 3

// Used to show binary representation of a decimal number
void show_binary(int num){
	
	int i,b[SIZE]={0};

	for(i=1;i<=SIZE;i++){
		b[SIZE-i]=num%2;
		num=num/2;
	}
	for(i=0;i<SIZE;i++)
		printf("%d",b[i]);
	/*printf("\n");*/
	
}

// Used to calculate convolution of g and input state
int mod_2(int num){
	int i;
	int sum=0;
	for(i=1;i<=10;i++){
		sum=sum+num%2;
		num=num/2;
	}
	return sum%2;
}

int main(){

	int s_num=4;
	int g1=0b011;
	int g2=0b101;
	int g3=0b111;
	struct state{
		int next_s[2];
		int next_out[2];
		
	}S[s_num];
	
	int i,j;
	for(i=0;i<s_num;i++){
		S[i].next_s[0]=(i<<1)%s_num;
		S[i].next_s[1]=((i<<1)+1)%s_num;
		S[i].next_out[0]=(mod_2((i<<1)&g1))*4+(mod_2((i<<1)&g2))*2+(mod_2((i<<1)&g3))*1;
		S[i].next_out[1]=(mod_2(((i<<1)+1)&g1))*4+(mod_2(((i<<1)+1)&g2))*2+(mod_2(((i<<1)+1)&g3))*1;
	}
	char u[100];
	gets(u);
	int next=0;
	
	// Length of input;
	int u_length;
	for(u_length=0;u[u_length]!='\0';u_length++){
	}
	int out_dec[u_length];
	int out_bin[3*u_length];  
	
	//Encoding
	for(i=0;u[i]!='\0';i++){
		if(u[i]=='0'){
			out_dec[i]=S[next].next_out[0];
			next=S[next].next_s[0];
			
		}
		else{
			out_dec[i]=S[next].next_out[1];
			next=S[next].next_s[1];
		}
	}
	
	
	int num;
	for(i=0;i<u_length;i++){
		num=out_dec[i];
		for(j=2;j>=0;j--){
			out_bin[3*i+j]=num%2;
			num=num/2;
		}
	}
	
	for(i=0;i<u_length;i++){
		printf("%d",out_bin[3*i]);
		printf("%d",out_bin[3*i+1]);
		printf("%d",out_bin[3*i+2]);
		printf(" ");	}
		
	printf("\n");
	system("pause");
	return 0;
}
