#include <iostream>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <vector>

bool is_prime(int v) {

   for (int i = 2 ; i <= sqrt(v) ; ++i) {
       if (v % i == 0)
           return false;
   }

   return true;
}

void print_prime_numbers(int n) {

   for (int i = 2; i <= n; ++i) {
       if (is_prime(i))
           std::cout << i << "\n";
   }
}


void print_prime_sieve(int n) {
	if (n < 2) {
		return;
	}

	std::vector<int> primes;
	primes.reserve((1.25506 * n) / log(n) + 1); // upper bound of primes in n (and 1 for flooring)
	primes.push_back(2);

	for (int i = 3; i < n ; i += 2) {
		bool isPrime(true);
		
		int s = sqrt(i);
		
		for (std::vector<int>::const_iterator p(primes.begin()); p != primes.end() ; ++p) {
			if (*p > s) break;

			if (i % *p == 0) {
				isPrime = false;
				break;
			}
		}
		if (isPrime)
			primes.push_back(i);
	}
	
	for (std::vector<int>::const_iterator p(primes.begin()); p != primes.end() ; ++p)
		std::cout << *p << "\n";
}



int main(int argc, char ** argv) {
	
	if (argc != 2) std::cout << "Need to enter n" << std::endl;

	print_prime_sieve(atoi(argv[1]));

}