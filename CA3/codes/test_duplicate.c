#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf(1, "usage: test_duplicate <filename>\n");
        exit();
    }


    if (make_duplicate_file(argv[1]) < 0) {
        printf(1, "Error duplicating file\n");
    } else {
        printf(1, "File duplicated successfully\n");
    }

    exit();
}
