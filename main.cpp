#include <iostream>
#include <cstdlib>
#include <sys/time.h>
#include <unistd.h>

using namespace std;

double timeval_diff(struct timeval *a, struct timeval *b)
{
  return
    (a->tv_sec + (double)a->tv_usec/1000000) -
    (b->tv_sec + (double)b->tv_usec/1000000);
}

int main()
{
    struct timeval t_ini, t_fin;
    int dormir;
    int intervalo = 2000;//milisegundos
    while(true){
        gettimeofday(&t_ini, NULL);
        system("php emergencia.php");
        gettimeofday(&t_fin, NULL);

        dormir = intervalo - (int)(timeval_diff(&t_fin, &t_ini) * 1000);
        if(dormir > 0) {
            cout << "A dormir: " << dormir << endl;
            usleep(dormir * 1000);
            }
        }
    return 0;
}
