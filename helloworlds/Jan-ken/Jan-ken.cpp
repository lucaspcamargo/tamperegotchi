#include <iostream>
#include <cstdlib>
#include <ctime>
#include <string>
using namespace std;

// Definitions to be used later for comparison.
string R = "Rock";
string P = "Paper";
string S = "Scissors";

string AI; // AI's choice.
int userChoice = NULL; // user's choice.


// This function will compare the possible combinations of the user and the computer and will decide who wins the match.
void compare(string choice1, string choice2){
	if (choice1 == R && choice2 == S)
		cout << choice1 << " wins!" << endl;
	else if (choice1 == P && choice2 == R)
		cout << choice1 << " wins!" << endl;
	else if (choice1 == S && choice2 == P)
		cout << choice1 << " wins!" << endl;
	else if ((choice1 == R && choice2 == R) || (choice1 == P && choice2 == P) || (choice1 == S && choice2 == S))
		cout << "It's a tie!" << endl;
};

string generateMove(){

	srand(time(0)); // To make as the random function produce a result that is as random as possible.

	int AIChoice = (1 + (rand() % 3));
	cout << endl << "TEST: Randomly generated number: " << AIChoice << endl << endl;

	if (AIChoice == 1) // We are checking the remainder after dividing by 3 so that we get 1, 2 or 3. Each of these numbers corresponds to either R, P or S. By default, %3 will give 0, 1 or 2 (since any remainder of 3 will just be a 1) so we add 1 to shift the answer for our purpose.
	{
		AI = "Rock"; cout << "Rock chosen by AI" << endl;
	} // In this case, if the random number generated and divided by 3 gives a remainder of 1, then the AI's choice is "Rock".
	else if (AIChoice == 2)
	{
		AI = "Paper"; cout << "Paper chosen by AI" << endl;
	}
	else if (AIChoice == 3)
	{
		AI = "Scissors"; cout << "Scissors chosen by AI" << endl;
	}

	return AI; // Return the AI's choice so that we can use this to compare with the user's choice.
};

int main()
{
	char answer; // Answer of user to continue playing game or not.

	do{
		do{
			cout << "=================== Jan-ken-gotchi! ===================" << endl;
			cout << "Please make your choice by pressing either 1 for Rock, 2 for Paper, or 3 for Scissors: ";
			cin >> userChoice;
			cout << endl;
			
			if (userChoice == 1)
				cout << "User chose: Rock" << endl;
			else if (userChoice == 2)
				cout << "User chose Paper" << endl;
			else if (userChoice == 3)
				cout << "User chose Scissors" << endl;

			if (userChoice < 1 || userChoice > 3) // Need to make sure user does not enter anything other than 1, 2 or 3.
				cout << endl << "Please enter one of the relevant choices of 1, 2 or 3: ";

		} while (userChoice < 1 || userChoice > 3); // Keep looping for input so long as input is incorrect.

		cout << endl;

		switch (userChoice){ // Each case corresponds to user choice. If choice is 1 (Rock), then case 1 will execute.
		case 1: compare("Rock", generateMove()); break; // Since 1 corresponds to Rock, Rock is passed as an argument to the function.
		case 2: compare("Paper", generateMove()); break;
		case 3: compare("Scissors", generateMove()); break;
		}

		cout << "=========================================" << endl;

		cout << endl << "Would you like to try again?" << endl;
		cout << "Answer: ";
		cin >> answer;

		cout << endl;

	} while (answer == 'Y' || answer == 'y');

	system("PAUSE");
}