#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"

static void run_one(const char *key, const char *path){
  char out[512];
  int ret = grep_syscall(key, path, out, sizeof(out));

  if(ret < 0){
    printf(1, "grep(\"%s\", \"%s\"): not found or error (ret=%d)\n", key, path, ret);
  }

  else{
    int truncated = (ret >= (int)sizeof(out));
    printf(1, "grep(\"%s\", \"%s\"): match len=%d%s\n", key, path, ret, truncated ? " (truncated)" : "");
    printf(1, "=> \"%s\"\n", out);
  }
}
static void self_tests(void){
  const char *fname = "tg.txt";
  int fd = open(fname, O_CREATE | O_WRONLY);

  if(fd < 0){
    printf(2, "cannot create %s\n", fname);
    exit();
  }

  const char *body =
    "first line without key\n"
    "second line with KEYWORD here\n"
    "the last line.\n";
  write(fd, body, strlen(body));
  close(fd);

  printf(1, "== self-tests ==\n");

  run_one("KEYWORD", fname);

  run_one("NOPE", fname);

  run_one("anything", "no_such_file.txt");
}

int main(int argc, char **argv)
{
  if(argc == 3){
    run_one(argv[1], argv[2]);
    exit();
  }

  self_tests();
  exit();
}
