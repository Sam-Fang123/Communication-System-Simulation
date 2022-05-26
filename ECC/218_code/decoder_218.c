#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define length 8
#define SIZE 2

// Used to show binary representation of a decimal number
void show_binary(int num){
	
	int i,b[length]={0};

	for(i=1;i<=length;i++){
		b[length-i]=num%2;
		num=num/2;
	}
	for(i=0;i<length;i++)
		printf("%d",b[i]);
	/*printf("\n");*/
	
}

void show_binary2(int num){
	
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
	
	
	int s_num=256;
	// Initialize connecting condition and output of every forward path
	struct state_f{
		int next_s[2];
		int next_out[2];
		
	}S_f[s_num];
	
	//g1=561=1 0111 0001, g2=1 1110 1011
	int g1=0b100011101;
	int g2=0b110101111;
	int i,j;
	// Initialize connecting condition and output of every forward path
	for(i=0;i<s_num;i++){
		S_f[i].next_s[0]=(i<<1)%s_num;
		S_f[i].next_s[1]=((i<<1)+1)%s_num;
		S_f[i].next_out[0]=(mod_2((i<<1)&g1))*2+(mod_2((i<<1)&g2))*1;
		S_f[i].next_out[1]=(mod_2(((i<<1)+1)&g1))*2+(mod_2(((i<<1)+1)&g2))*1;
	}
	
	for(i=0;i<s_num;i++){
		printf("state:");
		show_binary(i);
		printf(" 輸入0到: ");
		show_binary(S_f[i].next_s[0]);
		printf(", 且輸出: ");
		show_binary2(S_f[i].next_out[0]); 
		printf(", 輸入1到: ");
		show_binary(S_f[i].next_s[1]);
		printf(", 且輸出: ");
		show_binary2(S_f[i].next_out[1]);
		printf("\n"); 
	} 
	
	// Initialize connecting condition and output of every backward path
	struct state_b{
		int prev_s[2];
		int prev_out[2];
	}S_b[s_num];
	
	for(i=0;i<s_num;i++){
		S_b[i].prev_s[0]=(i>>1);
		S_b[i].prev_s[1]=(i>>1)+128;
		S_b[i].prev_out[0]=S_f[S_b[i].prev_s[0]].next_out[i%2];
		S_b[i].prev_out[1]=S_f[S_b[i].prev_s[1]].next_out[i%2];
	}
	
	for(i=0;i<s_num;i++){
		show_binary(i);
		printf(" 的上一個stat分別為: ");
		show_binary(S_b[i].prev_s[0]);
		printf(" 和 "); 
		show_binary(S_b[i].prev_s[1]);
		printf(" 他們的path分別為: ");
		show_binary2(S_b[i].prev_out[0]);
		printf(" 和 ");
		show_binary2(S_b[i].prev_out[1]);
		printf("\n");
	}
	
	
	
	system("pause");
	return 0;
}
