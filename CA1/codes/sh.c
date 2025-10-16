// Shell.

#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"

// Parsed command representation
#define EXEC  1
#define REDIR 2
#define PIPE  3
#define LIST  4
#define BACK  5

#define MAXARGS 10

int  TAPPRESS = 0;
int  has_multiple_choice = 0;
int  done_printing = 0;
char *temp_buf;

struct cmd {
  int type;
};

struct execcmd {
  int type;
  char *argv[MAXARGS];
  char *eargv[MAXARGS];
};

struct redircmd {
  int type;
  struct cmd *cmd;
  char *file;
  char *efile;
  int mode;
  int fd;
};

struct pipecmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct listcmd {
  int type;
  struct cmd *left;
  struct cmd *right;
};

struct backcmd {
  int type;
  struct cmd *cmd;
};

int          fork1(void);
void         panic(char *);
struct cmd  *parsecmd(char *);
char       **get_matching_instructions(char *, int *);
void         auto_complete(char *, char *);
void         print_instructions(char **instructions, int count, const char *prefix);

// Execute cmd. Never returns.
void
runcmd(struct cmd *cmd)
{
  int p[2];
  struct backcmd  *bcmd;
  struct execcmd  *ecmd;
  struct listcmd  *lcmd;
  struct pipecmd  *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
    exit();

  switch (cmd->type) {
  default:
    panic("runcmd");

  case EXEC:
    ecmd = (struct execcmd *)cmd;
    if (ecmd->argv[0] == 0)
      exit();
    exec(ecmd->argv[0], ecmd->argv);
    printf(2, "exec %s failed\n", ecmd->argv[0]);
    break;

  case REDIR:
    rcmd = (struct redircmd *)cmd;
    close(rcmd->fd);
    if (open(rcmd->file, rcmd->mode) < 0) {
      printf(2, "open %s failed\n", rcmd->file);
      exit();
    }
    runcmd(rcmd->cmd);
    break;

  case LIST:
    lcmd = (struct listcmd *)cmd;
    if (fork1() == 0)
      runcmd(lcmd->left);
    wait();
    runcmd(lcmd->right);
    break;

  case PIPE:
    pcmd = (struct pipecmd *)cmd;
    if (pipe(p) < 0)
      panic("pipe");
    if (fork1() == 0) {
      close(1);
      dup(p[1]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->left);
    }
    if (fork1() == 0) {
      close(0);
      dup(p[0]);
      close(p[0]);
      close(p[1]);
      runcmd(pcmd->right);
    }
    close(p[0]);
    close(p[1]);
    wait();
    wait();
    break;

  case BACK:
    bcmd = (struct backcmd *)cmd;
    if (fork1() == 0)
      runcmd(bcmd->cmd);
    break;
  }
  exit();
}

void
auto_complete(char *instruction, char *buf)
{
  int buf_len   = strlen(buf);
  int instr_len = strlen(instruction);
  for (int i = buf_len; i <= instr_len; i++)
    buf[i] = instruction[i];
  printf(2, "%s\t", instruction + buf_len);
}

void
print_instructions(char **instructions, int count, const char *prefix)
{
  printf(2, "\n");
  for (int i = 0; i < count; i++) {
    if (instructions[i])
      printf(2, "%s\n", instructions[i]);
  }
  printf(2, "\t");
  printf(2, "$ %s", prefix);
}

int
getcmd(char *buf, int nbuf)
{
  if (!temp_buf) {
    temp_buf = malloc(nbuf);
    if (temp_buf)
      temp_buf[0] = 0;
  }

  if ((!TAPPRESS && !has_multiple_choice)) {
    printf(2, "$ ");
    memset(buf, 0, nbuf);
  }

  gets(buf, nbuf);

  int pressed_tab = 0;
  int len = strlen(buf);
  if (len > 0 && buf[len - 1] == '\t') {
    pressed_tab = 1;
    buf[len - 1] = 0; // strip the tab for prefix logic
  }

  if (temp_buf && strcmp(buf, temp_buf) != 0) {
    has_multiple_choice = 0;
    TAPPRESS = 0;
  }

  if (pressed_tab) {
    int instruction_num = 0;
    char **instructions = get_matching_instructions(buf, &instruction_num);

    if (instruction_num == 0) {
      TAPPRESS = 1;

      if (temp_buf)
        memmove(temp_buf, buf, nbuf);
      return 3;
    } 
    else if (instruction_num == 1) {

      auto_complete(instructions[0], buf);
      TAPPRESS = 1;
      if (temp_buf)
        memmove(temp_buf, buf, nbuf); 
      return 3;

    } 
    else {

      if (has_multiple_choice) {

        print_instructions(instructions, instruction_num, buf);
        done_printing = 1;

        if (temp_buf)
          memmove(temp_buf, buf, nbuf);

        return 3;
      } 
      else {

        has_multiple_choice = 1; 

        if (temp_buf)
          memmove(temp_buf, buf, nbuf);

        return 3;
      }
    }
  } else {
    TAPPRESS = 0;
    has_multiple_choice = 0;
  }

  if (buf[0] == 0)
    return -1; // EOF

  if (temp_buf)
    memmove(temp_buf, buf, nbuf); // snapshot current prefix
  return 0;
}

char *
scratchـstrncpy(char *dst, const char *src, int n)
{
  int i;
  for (i = 0; i < n && src[i]; i++)
    dst[i] = src[i];
  for (; i < n; i++)
    dst[i] = 0;
  return dst;
}

char **
get_matching_instructions(char *prefix, int *num_of_instructions)
{
  int fd;
  struct dirent de;
  char *path = ".";
  fd = open(path, 0);
  char **instructions = malloc(sizeof(char *) * 16);
  int counter = 0;
  int prefix_len = strlen(prefix);

  
  int match_cd = 1;
  for (int i = 0; i < prefix_len; i++) {
    if (prefix[i] != 'c' && i == 0) { match_cd = 0; break; }
    if (i == 1 && prefix[i] != 'd') { match_cd = 0; break; }
    if (i > 1) { match_cd = 0; break; } 
  }
  if (match_cd) {
    instructions[counter] = malloc(3);
    scratchـstrncpy(instructions[counter], "cd", 3);
    instructions[counter][2] = 0;
    counter++;
    *num_of_instructions = counter;
  }


  
  while (read(fd, &de, sizeof(de)) == sizeof(de)) {
    if (de.inum == 0)
      continue;

    int pre_flag = 1;
    for (int i = 0; i < prefix_len; i++) {
      if (prefix[i] != de.name[i]) {
        pre_flag = 0;
        break;
      }
    }

    if (pre_flag) {
      instructions[counter] = malloc(DIRSIZ + 1);
      scratchـstrncpy(instructions[counter], de.name, DIRSIZ);
      instructions[counter][DIRSIZ] = 0;
      counter++;
      *num_of_instructions = counter;
    }
  }

  close(fd);
  return instructions;
}


int
main(void)
{
  static char buf[100];
  int fd;
  int completion_flag;

  // Ensure that three file descriptors are open.
  while ((fd = open("console", O_RDWR)) >= 0) {
    if (fd >= 3) {
      close(fd);
      break;
    }
  }

  // Read and run input commands.
  while ((completion_flag = getcmd(buf, sizeof(buf))) >= 0) {
    if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ') {
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf) - 1] = 0; // chop \n
      if (chdir(buf + 3) < 0)
        printf(2, "cannot cd %s\n", buf + 3);
      continue;
    }
    if (completion_flag == 3) {
      // completion path; do nothing
    } else {
      if (fork1() == 0)
        runcmd(parsecmd(buf));
      wait();
    }
  }
  exit();
}

void
panic(char *s)
{
  printf(2, "%s\n", s);
  exit();
}

int
fork1(void)
{
  int pid = fork();
  if (pid == -1)
    panic("fork");
  return pid;
}

// PAGEBREAK!
// Constructors

struct cmd *
execcmd(void)
{
  struct execcmd *cmd;
  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = EXEC;
  return (struct cmd *)cmd;
}

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
  struct redircmd *cmd;
  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = REDIR;
  cmd->cmd  = subcmd;
  cmd->file = file;
  cmd->efile = efile;
  cmd->mode = mode;
  cmd->fd   = fd;
  return (struct cmd *)cmd;
}

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
  struct pipecmd *cmd;
  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type  = PIPE;
  cmd->left  = left;
  cmd->right = right;
  return (struct cmd *)cmd;
}

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
  struct listcmd *cmd;
  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type  = LIST;
  cmd->left  = left;
  cmd->right = right;
  return (struct cmd *)cmd;
}

struct cmd *
backcmd(struct cmd *subcmd)
{
  struct backcmd *cmd;
  cmd = malloc(sizeof(*cmd));
  memset(cmd, 0, sizeof(*cmd));
  cmd->type = BACK;
  cmd->cmd  = subcmd;
  return (struct cmd *)cmd;
}

// PAGEBREAK!
// Parsing

char whitespace[] = " \t\r\n\v";
char symbols[]    = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
  char *s;
  int ret;

  s = *ps;
  while (s < es && strchr(whitespace, *s))
    s++;
  if (q)
    *q = s;
  ret = *s;
  switch (*s) {
  case 0:
    break;
  case '|':
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    break;
  case '>':
    s++;
    if (*s == '>') {
      ret = '+';
      s++;
    }
    break;
  default:
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
    *eq = s;

  while (s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return ret;
}

int
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while (s < es && strchr(whitespace, *s))
    s++;
  *ps = s;
  return *s && strchr(toks, *s);
}

struct cmd *parseline(char **, char *);
struct cmd *parsepipe(char **, char *);
struct cmd *parseexec(char **, char *);
struct cmd *nulterminate(struct cmd *);

struct cmd *
parsecmd(char *s)
{
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
  cmd = parseline(&s, es);
  peek(&s, es, "");
  if (s != es) {
    printf(2, "leftovers: %s\n", s);
    panic("syntax");
  }
  nulterminate(cmd);
  return cmd;
}

struct cmd *
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while (peek(ps, es, "&")) {
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if (peek(ps, es, ";")) {
    gettoken(ps, es, 0, 0);
    cmd = listcmd(cmd, parseline(ps, es));
  }
  return cmd;
}

struct cmd *
parsepipe(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parseexec(ps, es);
  if (peek(ps, es, "|")) {
    gettoken(ps, es, 0, 0);
    cmd = pipecmd(cmd, parsepipe(ps, es));
  }
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>")) {
    tok = gettoken(ps, es, 0, 0);
    if (gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
    switch (tok) {
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
      break;
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
      break;
    }
  }
  return cmd;
}

struct cmd *
parseblock(char **ps, char *es)
{
  struct cmd *cmd;

  if (!peek(ps, es, "("))
    panic("parseblock");
  gettoken(ps, es, 0, 0);
  cmd = parseline(ps, es);
  if (!peek(ps, es, ")"))
    panic("syntax - missing )");
  gettoken(ps, es, 0, 0);
  cmd = parseredirs(cmd, ps, es);
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
    return parseblock(ps, es);

  ret = execcmd();
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while (!peek(ps, es, "|)&;")) {
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
      break;
    if (tok != 'a')
      panic("syntax");
    cmd->argv[argc]  = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc]  = 0;
  cmd->eargv[argc] = 0;
  return ret;
}

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
  int i;
  struct backcmd *bcmd;
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
    return 0;

  switch (cmd->type) {
  case EXEC:
    ecmd = (struct execcmd *)cmd;
    for (i = 0; ecmd->argv[i]; i++)
      *ecmd->eargv[i] = 0;
    break;

  case REDIR:
    rcmd = (struct redircmd *)cmd;
    nulterminate(rcmd->cmd);
    *rcmd->efile = 0;
    break;

  case PIPE:
    pcmd = (struct pipecmd *)cmd;
    nulterminate(pcmd->left);
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd *)cmd;
    nulterminate(lcmd->left);
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
