#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <string.h>

int main(int argc, char **argv) {

	int rank, size;
	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Status status;

	char string[size];
	if (rank == 0) {
		printf("enter the word: ");
		scanf("%s", string);
	}
	char c;
	MPI_Scatter(string, 1, MPI_CHAR, &c, 1, MPI_CHAR, 0, MPI_COMM_WORLD);

	if (rank != 0) {
		char new_string[rank+1];
		for (int t = 0; t <= rank; ++t) {
			new_string[t] = c;
		}
		MPI_Send(new_string, rank+1, MPI_CHAR, 0, 1, MPI_COMM_WORLD);
	}

	if (rank == 0) {
		char ans[size * (size + 1) / 2];
		ans[0] = c;
		int ptr = 1;
		for (int t = 2; t <= size; ++t) {
			char temp[t];
			MPI_Recv(temp, t, MPI_CHAR, t-1, 1, MPI_COMM_WORLD, &status);
			for (int r = 0; r < t; ++r) 
				ans[ptr++] = temp[r];
		}
		printf("final stirng: %s\n", ans);
	}

	MPI_Finalize();

	return 0;
}
