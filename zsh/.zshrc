kill-port() {
  if [ -z "$1" ]; then
    echo "Usage: kill-port <port>"
    return 1
  fi

  PIDS=$(lsof -ti tcp:"$1")

  if [ -z "$PIDS" ]; then
    echo "No process is using port $1"
    return 0
  fi

  echo "Killing the following processes using port $1:"
  echo "$PIDS"

  echo "$PIDS" | xargs kill -9
}

git-kalpak44() {
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Not inside a git repository."
    return 1
  fi

  git config user.name "Pavel Usanli"
  git config user.email "pavel.usanli@gmail.com"

  echo "✅ Local git config set:"
  git config --local --list | grep user.
}
