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
	// Initialize connecting condition and output of every backward path
	struct state_b{
		int prev_s[2];
		int prev_out[2];
	}S_b[s_num];
	
	for(i=0;i<s_num;i++){
		S_b[i].prev_s[0]=(i>>1);
		S_b[i].prev_s[1]=(i>>1)+2;
		S_b[i].prev_out[0]=S_f[S_b[i].prev_s[0]].next_out[i%2];
		S_b[i].prev_out[1]=S_f[S_b[i].prev_s[1]].next_out[i%2];
	}	
	
	char r[100];
	gets(r);
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
		//printf("%d ",r_dec[i]);
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
	int D1,D2;
	int r_d;
	//Decoding
	for(j=1;j<=path_length;j++){
		r_d=r_dec[j-1];
		for(i=0;i<s_num;i++){
			D1=dist(r_d,S_b[i].prev_out[0])+S[S_b[i].prev_s[0]][j-1].d;
			D2=dist(r_d,S_b[i].prev_out[1])+S[S_b[i].prev_s[1]][j-1].d;
			if(D1<D2){
				S[i][j].d=D1;
				S[i][j].prev=S_b[i].prev_s[0];
			}
			else{
				S[i][j].d=D2;
				S[i][j].prev=S_b[i].prev_s[1];
			}
		}
	}
	
	for(i=0;i<path_length;i++)
		printf("%d ",r_dec[i]);
	printf("\n");
	
	for(j=0;j<s_num;j++){
		printf("%dªº:",j);
		for(i=0;i<=path_length;i++){
			if(S[j][i].d>1000)
				printf("n  ");
			else
			printf("%d  ",S[j][i].d);}
		printf("\n");
	}
	printf("\n");
	for(j=0;j<s_num;j++){
		printf("%dªº:",j);
		for(i=0;i<=path_length;i++){
			if(S[j][i].prev>1000)
				printf("n  ");
			else
			printf("%d  ",S[j][i].prev);}
		printf("\n");
	}
	
	// Store the traveled state
	int pass_s[path_length+1];
	pass_s[path_length]=0;
	for(i=path_length-1;i>=0;i--){
		pass_s[i]=S[pass_s[i+1]][i+1].prev;
	}
	printf("Traveled path: ");
	for(i=0;i<=path_length;i++)
		printf("%d ",pass_s[i]);
	printf("\n");
	
	int u[path_length];
	int v_dec[path_length];
	int v[3*path_length];
	// Store the output u
	printf("u: ");
	for(i=0;i<path_length;i++){
		if(pass_s[i+1]==S_f[pass_s[i]].next_s[0])
			u[i]=0;
		else
			u[i]=1;
		printf(" %d  ",u[i]);
	}
	printf("\n");
	
	// Encoder
	int next=0;
	for(i=0;i<path_length;i++){
		
		v_dec[i]=S_f[next].next_out[u[i]];
		next=S_f[next].next_s[u[i]];	
	}
	int num;
	for(i=0;i<path_length;i++){
		num=v_dec[i];
		for(j=2;j>=0;j--){
			v[3*i+j]=num%2;
			num=num/2;
		}
	}
	printf("v: ");
	for(i=0;i<path_length;i++){
		printf("%d",v[3*i]);
		printf("%d",v[3*i+1]);
		printf("%d",v[3*i+2]);
		printf(" ");	}
	printf("\n");
	
	system("pause");
	return 0;
}
