#include <iostream>
#include <string>
#include <cstring>

extern "C" {
	//Déclaration des fonctions assembleur
	int FindFirstChar(const char* chaine, const char* caracteres, char* caractereTrouve, int* indexTrouve);
	void ReplaceChars(char* chaine, const char* caracteres);
}

int main() {
	char buffer[100];
	char chars[4];

	//Demander la chaine de caractères
	std::cout << "Entrez une chaine de caracteres (tout en minuscule) : ";
	std::cin.getline(buffer, sizeof(buffer));

	//Demande les 3 caractères
	std::cout << "Entrez les 3 caracteres a rechercher et remplacer : ";
	std::cin.getline(chars, sizeof(chars));

	//Vérifier qu'il y a bien 3 caractères
	if (strlen(chars) < 3) {
		std::cout << "Erreur : Vous devez entrer exactement 3 caractères!" << std::endl;

		return 1;
	}

	// === PARTIE 1 : Recherche de caracteres ===
	char caractereTrouve;
	int indexTrouve;

	int resultat = FindFirstChar(buffer, chars, &caractereTrouve, &indexTrouve);

	if (resultat == 1) {
		std::cout << "Premier caractere trouve : " << caractereTrouve << " a la position " << (indexTrouve + 1) << std::endl;
	}

	else {
		std::cout << "Aucun caractere trouve (-1)" << std::endl;
	}

	// === PARTIE 2 : Remplacement cyclique ===
	std::cout << "Chaine avant remplacement : " << buffer << std::endl;

	ReplaceChars(buffer, chars);

	std::cout << "Chaine apres le remplacement : " << buffer << std::endl;

	return 0;
}