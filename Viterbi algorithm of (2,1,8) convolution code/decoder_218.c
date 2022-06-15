#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define length 8
#define SIZE 2


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
	
	
	printf("Enter the received sequence r: ");
	char r[10000];

	gets(r);
	printf("\n");
	int r_length;
	for(r_length=0;r[r_length]!='\0';r_length++){
	}
	printf("r length: %d \n\n",r_length);
	int path_length;
	path_length=r_length/2;
	int r_dec[path_length];
	
//	printf("1\n");
	for(i=0;i<path_length;i++)
		r_dec[i]=0;
	// Turn r_binary into r_decimal
	for(i=0;i<path_length;i++){
		
		if(r[2*i]=='1')
			r_dec[i]=r_dec[i]+2;
		if(r[2*i+1]=='1')
			r_dec[i]=r_dec[i]+1;
		//printf("%d ",r_dec[i]);
		}
//	printf("2\n");
	
	// Initialize the state used to store overall distance
	struct state{
		int prev;
		int d;
	};
	static struct state *S;
	S=malloc(s_num*path_length*sizeof(struct state));
	int index,index2,index3;
	for(i=0;i<s_num;i++){
		for(j=0;j<=path_length;j++){
			index=i*path_length+j;
			S[index].prev=10000000;
			S[index].d=10000000;
		}
	}
//	printf("3\n");
	S[0].d=0;
	int D1,D2;
	int r_d;
	//Decoding
	for(j=1;j<=path_length;j++){
		r_d=r_dec[j-1];
		for(i=0;i<s_num;i++){
			index=i*path_length+j;
			index2=S_b[i].prev_s[0]*path_length+j-1;
			index3=S_b[i].prev_s[1]*path_length+j-1;
			D1=dist(r_d,S_b[i].prev_out[0])+S[index2].d;
			D2=dist(r_d,S_b[i].prev_out[1])+S[index3].d;
			if(D1<D2){
				S[index].d=D1;
				S[index].prev=S_b[i].prev_s[0];
			}
			else{
				S[index].d=D2;
				S[index].prev=S_b[i].prev_s[1];
			}
		}
	}
	
	// Store the traveled state
	int pass_s[path_length+1];
	pass_s[path_length]=0;
	for(i=path_length-1;i>=0;i--){
		index=pass_s[i+1]*path_length+i+1;
		pass_s[i]=S[index].prev;
	}
//	printf("Traveled path: ");
//	for(i=0;i<=path_length;i++)
//		printf("%d ",pass_s[i]);
//	printf("\n");
	
	printf("Information sequence after decoding u: ");
	int u[path_length];
	int v_dec[path_length];
	int v[2*path_length];
	// Store the output u
	for(i=0;i<path_length;i++){
		if(pass_s[i+1]==S_f[pass_s[i]].next_s[0])
			u[i]=0;
		else
			u[i]=1;
		printf("%d",u[i]);
	}
	printf("\n \n");
	
	// Encoder
	int next=0;
	for(i=0;i<path_length;i++){
		v_dec[i]=S_f[next].next_out[u[i]];
		next=S_f[next].next_s[u[i]];	
	}
	int num;
	for(i=0;i<path_length;i++){
		num=v_dec[i];
		for(j=1;j>=0;j--){
			v[2*i+j]=num%2;
			num=num/2;
		}
	}
	printf("Original transmitted sequence v: ");
	for(i=0;i<path_length;i++){
		printf("%d",v[2*i]);
		printf("%d",v[2*i+1]);
		//printf(" ");	
		}
	printf("\n \n");
	
	printf("error position: ");
	int err_pos[2*path_length];
	int err_num=0;
	for(i=0;i<2*path_length;i++){
		if(r[i]=='1'&&v[i]==1)
			err_pos[i]=0;
		else if(r[i]=='0'&&v[i]==0)
			err_pos[i]=0;
		else{
			err_pos[i]=1; 
			printf("%d ",i+1);
			err_num=err_num+1;
			}

	}
	printf("\n\nThere are %d errors. \n\n",err_num);
///	for(i=0;i<2*path_length;i++){
//		printf("%d",err_pos[i]);
//	}
	
	free(S);
	system("pause");
	return 0;
}
