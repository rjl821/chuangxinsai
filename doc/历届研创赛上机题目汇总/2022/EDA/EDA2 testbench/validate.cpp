#include <cstdio>
#include <cstring>

#define Max_Num 1000
char ineq[Max_Num][Max_Num];
int var[Max_Num];
int var_num = 0;
int max_val = 0;

void gen_ineq(const char * dat_file_path)
{
    memset(ineq, 0, Max_Num * Max_Num);
    var_num = 0;
    max_val = 0;

    FILE *fp = fopen(dat_file_path, "r");
    int i, j;
    
    if (!fp) {
        fprintf(stderr, "can't open dat file\n");
    }
    fscanf(fp, "%d\n", &var_num);
    fscanf(fp, "%d\n", &max_val);
    while(2 == fscanf(fp, "%d,%d\n", &i, &j)) {
        ineq[i][j] = 1;
    }

    fclose(fp);
}

bool validate(const char * result_file_path)
{
    memset(var, 0, Max_Num * sizeof(int));
    FILE *fp = fopen(result_file_path, "r");
    int val = 0;
    int i = 0;

    if (!fp) {
        fprintf(stderr, "can't open result file\n");
    }
    while(1==fscanf(fp, "%d\n", &val)) {
        var[i++] = val;
        if (val < 1 || val > max_val) {
            printf("%s, %d illegal value \n", result_file_path, i);
            return false;
        }
    }

    for (i=0; i < Max_Num; i++) {
        for (int j = 0; j < Max_Num; j++) {
            if (ineq[i][j] && var[i] == var[j]) {
                printf("%s, %d, %d failed\n", result_file_path, i, j);
                return false;
            }
        }
    }

    fclose(fp);
    return true;
}

int main()
{
	gen_ineq("./test0.dat");
    validate("./result0");
    gen_ineq("./test1.dat");
    validate("./result1");
    gen_ineq("./test2.dat");
    validate("./result2");
    gen_ineq("./test3.dat");
    validate("./result3");
    gen_ineq("./test4.dat");
    validate("./result4");
    gen_ineq("./test5.dat");
    validate("./result5");
}
