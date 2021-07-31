#include <iostream>

using namespace std;
int possible[10];
int counter = 0;
int control = 0;
int CheckSumPossibility(int num, int arr[], int size) 
{ 
    if (num == 0) {
		control = 1; 
		for (int i = 0; i<counter; i++) 
			cout << possible[i] << " "; 
		cout << endl;
		return control; 
	}
	else if (size == 0)
		return control;
	else if (num < 0) 
		return control; 
	CheckSumPossibility(num, arr, size - 1); 
	possible[counter] = arr[size-1];
	counter++;
	CheckSumPossibility(num - arr[size - 1], arr, size - 1);
	counter--;
	return control;
} 

int main() 
{ 
	int arraySize;
	int arr[20];
	int num;
	int returnVal;
    
    cin >> arraySize;
    cin >> num;
	
	for(int i=0; i < arraySize; i++)
		cin >> arr[i];
	
	returnVal = CheckSumPossibility(num, arr, arraySize);
	 
	if(returnVal == 1)
		cout << "Possible!\n";
	else
		cout << "Not Possible!\n";
		
	return 0; 
} 

