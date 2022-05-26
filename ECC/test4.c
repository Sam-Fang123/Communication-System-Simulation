#include <stdio.h>
#include <math.h>
#include <stdlib.h>

int mod_2(int num){
	int i;
	int sum=0;
	for(i=1;i<=10;i++){
		sum=sum+num%2;
		num=num/2;
	}
	return sum%2;
}

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
	
	int i=7;
	int j=0;
	printf("%d\n",dist(i,j));
	//int c=INT_MAX;
	//printf("%d",c);
		
	system("pause");
	return 0;
}
