#include <iostream>

extern "C" {
	extern unsigned char array1[4];
	extern int array2[4];

	void ReverseAndMultiplyByteArray(unsigned char* arr, int size);
	void ReverseAndDivideDwordArray(int* arr, int size);
}

//Affichage du tableau en byte
void ShowByteArray(const unsigned char* array, int size, const char* label)
{

	std::cout << label << ": ";
	for (int i = 0; i < size; i++)
	{
		std::cout << static_cast<int>(array[i]) << " ";
	}
	
	std::cout << std::endl;

}

// Affichage du tableau en dword
void ShowDwordArray(const int* array, int size, const char* label)
{
	std::cout << label << ": ";
	for (int i = 0; i < size; i++)
	{
		std::cout << array[i] << " ";
	}
	std::cout << std::endl;
}

int main()
{
	//Tableau #1
	ShowByteArray(array1, 4, "Tableau #1 (Avant)");
	ReverseAndMultiplyByteArray(array1, 4);
	ShowByteArray(array1, 4, "Tableau #1 (Apres)");

	//Tableau #2
	ShowDwordArray(array2, 4, "Tableau #2 (Avant)");
	ReverseAndDivideDwordArray(array2, 4);
	ShowDwordArray(array2, 4, "Tableau #2 (Apres)");

	//Afficher les tableau avant la transformation
	//ShowByteArray(array1, 4, "Tableau #1 (Avant)");
	//ShowDwordArray(array2, 4, "Tableau #2 (Avant)");

	//Appeler les procedures MASM
	//ReverseAndMultiplyByteArray(array1, 4);
	//ReverseAndDivideDwordArray(array2, 4);

	//Afficher les tableau après la transformation
	//ShowByteArray(array1, 4, "Tableau #1 (Apres)");
	//ShowDwordArray(array2, 4, "Tableau #2 (Apres)");

	return 0;
}
