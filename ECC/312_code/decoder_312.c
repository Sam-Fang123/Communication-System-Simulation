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
//Used to calaulate Hamming distance
int dist(int num1,int num2){
	int num3,i;
	num3=num1^num2;
	int sum=0;
	for(i=1;i<=10;i++){
		sum=sum+num3%2;
		num3=num3/2;
	}
	return sum;
	
}

int main(){
	
	int memory=2;
	int s_num=4;
	int i,j;
	int g1=0b011;
	int g2=0b101;
	int g3=0b111;
	
	// Initialize connecting condition and output of every path
	struct state{
		int next_s[2];
		int next_out[2];
		
	}S[s_num];
	
	// Initialize connecting condition and output of every path
	for(i=0;i<s_num;i++){
		S[i].next_s[0]=(i<<1)%s_num;
		S[i].next_s[1]=((i<<1)+1)%s_num;
		S[i].next_out[0]=(mod_2((i<<1)&g1))*4+(mod_2((i<<1)&g2))*2+(mod_2((i<<1)&g3))*1;
		S[i].next_out[1]=(mod_2(((i<<1)+1)&g1))*4+(mod_2(((i<<1)+1)&g2))*2+(mod_2(((i<<1)+1)&g3))*1;
	}
	
	char r[100];
	gets(r);
	int next=0;
	int r_length;
	for(r_length=0;r[r_length]!='\0';r_length++){
	}
	
	// Initialize the state used to store overall distance
	struct state2{
		int prev;
		int d;
	}SS[s_num][r_length/3];
	for(i=0;i<s_sum;i++){
		S[i][0].d=0;
		S[i][0].prev=INT_MAX;
	}
	for(i=0;i<s_num;i++){
		for(j=1;j<r_length/3;j++){
			SS[i][j].prev=INT_MAX;
			SS[i][j].d=INT_MAX;
		}
	}
	
	for(i=0;i<r_length/3;i++){
		for(j=0;j<s_sum;j++){
			if(i<2){
				
			}
			
			
			
		}
	}
	
	
	int v_dec[r_length/3];
	int v_bin[r_length];  
	printf("%d\n",r_length);
	//Decoding
	
		
	printf("\n");
	system("pause");
	return 0;
}
