#include <cstdlib>
#include <string>
#include <map>
#include <unistd.h>

extern char **environ;

namespace my {

typedef std::map<std::string, std::string> Env;

bool split2(std::string input, char separator, std::string &left, std::string &right) {
  bool found = false;
  for (int i=0; i<input.size(); i++) {
    if (input[i] == separator) {
      found = true;
    } else if (found) {
      right.append(&input[i]);
    } else {
      left.append(&input[i]);
    }
  }
  return found;
}

Env env() {
  std::map<std::string, std::string> ret;
  std::string key;
  std::string value;
  char **tmp;

  for (tmp = environ; tmp; tmp++) {
    std::string input = *tmp;
    if (split2(input, *"=", key, value)) {
      ret[key] = value;
    }
  }

  return ret;
}

}
