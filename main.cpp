//
//  main.cpp
//  Project VAriables Example2
//
//  Created by Чагаева Елена on 03.07.2023.
//

#include <iostream>
using namespace std;

int main() {
    //declar one double variable to contain the money you have let's say 379.93
    
    //find how many $100 bills, $50, $20, $10 and $5 dollars bills to make up your amount
    //as well as quarters, dimes, nickels and cents
    //Hint:389.93/100 = 3.8993
    
    double amount = 389.93;
    int number100 = amount / 100;
    cout <<"there are: " << number100 << " - $100 bills \n";
    amount = amount - (number100 * 100);
    
    int number50 = amount / 50;
    cout << "there are: " << number50 << " - $50 bills \n";
    amount = amount - (number50 * 50);
    
    int number20 = amount / 20;
    cout << "there are: " << number20 << " - $20 bills \n";
    amount = amount - (number20 * 20);
    
    int number10 = amount / 10;
    cout << "there are: " << number10 << " - $10 bills \n";
    amount = amount - (number10 * 10);
    
    int number5 = amount / 5;
    cout << "there are: " << number5 << " - $5 bills \n";
    amount = amount - (number5 * 5);
    
    int number1 = amount / 1;
    cout << "there are: " << number1 << " - $1 bills \n";
    amount = amount - (number1 * 1);
    
    int Quoters = amount / .25;
    cout << "there are: " << Quoters << " - Quoters \n";
    amount = amount - (Quoters * .25);
    
    int dimes = amount / .1;
    cout << "there are: " << dimes << " - dimes \n";
    amount = amount - (dimes * .1);
    
    int nickles = amount / .05;
    cout << "there are: " << nickles << " - nickles \n";
    amount = amount - (dimes * .05);
    
    int cents = amount / .01;
    cout << "there are: " << cents << " - cents \n\n";
    amount = amount - (cents * .01);
    
    system ("pause");
    return 0;
}
/*
 #include <iostream>
 using namespace std;


 int main() {
     double Totalamount;
     std::cout << "Enter the total amount: $";
     std::cin >> Totalamount;

     int amount = static_cast<int>(Totalamount);
     int numCents = static_cast<int>((Totalamount - amount) * 100);

     std::cout << "Amount: $" << amount << std::endl;
     std::cout << "Cents : " << numCents << std::endl;

     int bills[] = {100, 50, 20, 10, 5, 1};
     int numBills[6];

     for (int i = 0; i < 6; ++i) {
         numBills[i] = amount / bills[i];
         amount %= bills[i];
     }

     int coins[] = {25, 10, 5, 1};
     int numCoins[4];

     for (int i = 0; i < 4; ++i) {
         numCoins[i] = numCents / coins[i];
         numCents %= coins[i];
     }

     for (int i = 0; i < 6; ++i) {
         if (bills[i] >= 5) {
             std::cout << "$" << bills[i] << " bills: " << numBills[i] << std::endl;
         } else {
             std::cout << " " << bills[i] << " bills: " << numBills[i] << std::endl;
         }
     }

     for (int i = 0; i < 4; ++i) {
         std::cout << " " << coins[i];
         if (coins[i] >= 10) {
             std::cout << " coins: " << numCoins[i] << std::endl;
         } else {
             std::cout << "    coins: " << numCoins[i] << std::endl;
         }
     }

     return 0;
 }
 */
