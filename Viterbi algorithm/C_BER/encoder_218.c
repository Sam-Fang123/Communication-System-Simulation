#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#define length 2
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

int main(){
	
	
	int s_num=256;
	struct state{
		int next_s[2];
		int next_out[2];
		
	}S[s_num];
	
	//g1=561=1 0111 0001, g2=1 1110 1011
	int g1=0b100011101;
	int g2=0b110101111;
	int i,j;
	for(i=0;i<s_num;i++){
		S[i].next_s[0]=(i<<1)%s_num;
		S[i].next_s[1]=((i<<1)+1)%s_num;
		S[i].next_out[0]=(mod_2((i<<1)&g1))*2+(mod_2((i<<1)&g2))*1;
		S[i].next_out[1]=(mod_2(((i<<1)+1)&g1))*2+(mod_2(((i<<1)+1)&g2))*1;
	}
	
	FILE *fptr,*fptr2;
	char ch;
	int next=0;
	int first,second,out_dec;
	fptr=fopen("b.txt","r");
	fptr2=fopen("out.txt","w");
	if(fptr!=NULL){
		while((ch=getc(fptr))!=EOF)
		{
			if(ch=='0'){
				out_dec=S[next].next_out[0];
				next=S[next].next_s[0];
			}
			else{
				out_dec=S[next].next_out[1];
				next=S[next].next_s[1];
				}
			second=out_dec%2;
			out_dec=out_dec/2;
			first=out_dec%2;
			if(first==0)
				putc('0',fptr2);
			else
				putc('1',fptr2);
			if(second==0)
				putc('0',fptr2);
			else
				putc('1',fptr2);
		}
	}
	
	fclose(fptr);	
	fclose(fptr2);
	printf("\n");
	system("pause");
	return 0;
}
