#include <iostream>
#include <algorithm>
#include <intrin.h> 


int FindMinIndex(const int* array, int start, int end) {
	int minIndex = start;
	for (int i = start + 1; i <= end; i++) {
		if (array[i] < array[minIndex]) {
			minIndex = i;
		}
	}

	return minIndex;
}

void SortSelection(int* array, int size) {
	for (int i = 0; i < size - 1; i++) {
		int minIndex = FindMinIndex(array, i, size - 1);
		std::swap(array[i], array[minIndex]);
	}
}

void ShowArray(const int* array, int size) {
	std::cout << "[";
	for (int i = 0; i < size; ++i) {
		std::cout << array[i];
		if (i < size - 1) std::cout << ", ";
	}

	std::cout << "]" << std::endl;
		
}

int main() {
	int array[] = { 64, 25, 12, 22, 11, 8, 45, 33, 18, 7 };
	int size = sizeof(array) / sizeof(array[0]);

	//Mesure le nombre de cycles avant l'éxécution
	unsigned long long startCycle = __rdtsc();

	//Trouver l'index minimum et sa valeur
	std::cout << "===TROUVER INDEX MINIMUM ET SA VALEUR===" << std::endl;
	int minIndex = FindMinIndex(array, 0, size - 1);
	std::cout << "Tableau : ";
	ShowArray(array, size);
	std::cout << "Minimum trouve a l'index " << minIndex << " (Valeur : " << array[minIndex] << ")" << std::endl;

	//Application du tri par selection
	std::cout << "\n===Tri par selection===" << std::endl;
	SortSelection(array, size);

	//Mesure le nombre de cycle après l'exécution
	unsigned long long endCycle = __rdtsc();

	std::cout << "Tableau trie : ";
	ShowArray(array, size);

	std::cout << "Cycle CPU utilises : " << (endCycle - startCycle) << std::endl;

	return 0;
}