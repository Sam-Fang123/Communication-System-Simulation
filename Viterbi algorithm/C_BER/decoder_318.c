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
	
	//g1=575=1 0111 1101, g2=623=1 1001 0011 g3=727=1 1101 0111
	int g1=0b101111101;
	int g2=0b110010011;
	int g3=0b111010111;
	int i,j;
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
		S_b[i].prev_s[1]=(i>>1)+128;
		S_b[i].prev_out[0]=S_f[S_b[i].prev_s[0]].next_out[i%2];
		S_b[i].prev_out[1]=S_f[S_b[i].prev_s[1]].next_out[i%2];
	}
	
	FILE *fptr_u,*fptr;
	fptr=fopen("r_318.txt","r");
	fptr_u=fopen("u_318.txt","w");
	struct state{
			int prev;
			int d;
	};
	int r_dec[1009];
	int r[3027];
	int k=0;
	char ch;
	if(fptr!=NULL){
		while((ch=getc(fptr))!=EOF){
			r[k]=ch;
			k=k+1;
			if(k==3027){
				k=0;
				for(i=0;i<1009;i++)
					r_dec[i]=0;
				for(i=0;i<1009;i++){
					if(r[3*i]=='1')
					r_dec[i]=r_dec[i]+4;
					if(r[3*i+1]=='1')
						r_dec[i]=r_dec[i]+2;
					if(r[3*i+2]=='1')
						r_dec[i]=r_dec[i]+1;
					}
				static struct state *S;
				S=malloc(s_num*1009*sizeof(struct state));
				int index,index2,index3;
				for(i=0;i<s_num;i++){
					for(j=0;j<=1009;j++){
						index=i*1009+j;
						S[index].prev=10000000;
						S[index].d=10000000;
					}
				}
				S[0].d=0;
				int D1,D2;
				int r_d;
				for(j=1;j<=1009;j++){
					r_d=r_dec[j-1];
					for(i=0;i<s_num;i++){
						index=i*1009+j;
						index2=S_b[i].prev_s[0]*1009+j-1;
						index3=S_b[i].prev_s[1]*1009+j-1;
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
				int pass_s[1010];
				pass_s[1009]=0;
				for(i=1009-1;i>=0;i--){
					index=pass_s[i+1]*1009+i+1;
					pass_s[i]=S[index].prev;
				}
				for(i=0;i<1000;i++){
					if(pass_s[i+1]==S_f[pass_s[i]].next_s[0])
						putc('0',fptr_u);
					else
						putc('1',fptr_u);
				}
				free(S);	
					
			}
		}
		
	}
	fclose(fptr);	
	fclose(fptr_u);
	printf("finish!");
	system("pause");
	return 0;
}
