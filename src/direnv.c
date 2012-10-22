#include <stdio.h>
#include <direnv.h>
#include <direnv_version.h>

const char builtin_commands[] =
  "--version"
  "--help";

void print_version() {
  printf("direnv v%d.%d.%d", direnv_VERSION_MAX, direnv_VERSION_MIN, direnv_VERSION_TINY);
}

void print_usage() {
  printf("direnv [--version] [--help] <command> [<args]\n");
}

int main(int argc, char * argv) {
  if (argc == 1) {
    print_usage();
    return 1;
  }

  printf("Hello world: %d\n", argc);

}
