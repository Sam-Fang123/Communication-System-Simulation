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
	
	// Initialize connecting condition and output of every forward path
	struct state_f{
		int next_s[2];
		int next_out[2];
		
	}S_f[s_num];
	
	// Initialize connecting condition and output of every forward path
	for(i=0;i<s_num;i++){
		S_f[i].next_s[0]=(i<<1)%s_num;
		S_f[i].next_s[1]=((i<<1)+1)%s_num;
		S_f[i].next_out[0]=(mod_2((i<<1)&g1))*4+(mod_2((i<<1)&g2))*2+(mod_2((i<<1)&g3))*1;
		S_f[i].next_out[1]=(mod_2(((i<<1)+1)&g1))*4+(mod_2(((i<<1)+1)&g2))*2+(mod_2(((i<<1)+1)&g3))*1;
	}
	
	struct state_b{
		int prev_s[2];
		int prev_out[2];
	}S_b[s_num];
	
	for(i=0;i<s_num;i++){
		S_b[i].prev_s[0]=(i>>1);
		S_b[i].prev_s[1]=(i>>1)+2;
		S_b[i].prev_out[0]=mod_2(S_b[i].prev_s[0]&g1)*4+mod_2(S_b[i].prev_s[0]&g2)*2+mod_2(S_b[i].prev_s[0]&g3)*1;
		S_b[i].prev_out[1]=mod_2(S_b[i].prev_s[1]&g1)*4+mod_2(S_b[i].prev_s[1]&g2)*2+mod_2(S_b[i].prev_s[1]&g3)*1;
	}
	
	for(i=0;i<s_num;i++){
		//show_binary(i);
		printf("%d",i);
		printf(" 的上一個stat分別為: ");
		//show_binary(S_b[i].prev_s[0]);
		printf("%d 和 %d  ",S_b[i].prev_s[0],S_b[i].prev_s[1]);
		//show_binary(S_b[i].prev_s[1]);
		printf(" 他們的path分別為: ");
		show_binary(S_b[i].prev_out[0]);
		printf(" 和 ");
		show_binary(S_b[i].prev_out[1]);
		printf("\n");
	}
	
	
	char r[100];
	gets(r);
	int next=0;
	int r_length;
	for(r_length=0;r[r_length]!='\0';r_length++){
	}
	int path_length;
	path_length=r_length/3;
	int r_dec[path_length];
	for(i=0;i<path_length;i++)
		r_dec[i]=0;
	// Turn r_binary into r_decimal
	for(i=0;i<path_length;i++){
		
		if(r[3*i]=='1')
			r_dec[i]=r_dec[i]+4;
		if(r[3*i+1]=='1')
			r_dec[i]=r_dec[i]+2;
		if(r[3*i+2]=='1')
			r_dec[i]=r_dec[i]+1;
		
		printf("%d ",r_dec[i]);
		
		}
	
	
	// Initialize the state used to store overall distance
	struct state{
		int prev;
		int d;
	}S[s_num][path_length+1];
	for(i=0;i<s_num;i++){
		for(j=0;j<=path_length;j++){
			S[i][j].prev=10000000;
			S[i][j].d=10000000;
		}
	}
	S[0][0].d=0;
	
	for(i=0;i<=path_length;i++){
		for(j=0;j<s_num;j++){
			
			
			
		}
	}
	
	
	int v_dec[r_length/3];
	int v_bin[r_length];  
	//Decoding
	
		
	printf("\n");
	system("pause");
	return 0;
}
