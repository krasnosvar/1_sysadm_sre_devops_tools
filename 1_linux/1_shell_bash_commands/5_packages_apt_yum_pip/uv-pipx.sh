#UV - fast replacement for pip/venv/pyenv/pipx (https://docs.astral.sh/uv/)
curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update

#project
uv init myproj && cd myproj
uv add requests 'pydantic>=2'
uv add --dev pytest ruff
uv remove requests
uv sync                    # create .venv from pyproject.toml + uv.lock
uv run python main.py      # run inside project env
uv lock --upgrade

#python versions
uv python install 3.13
uv python list
uv venv --python 3.13

#pip-compatible mode
uv pip install -r requirements.txt
uv pip compile requirements.in -o requirements.txt

#scripts and tools (instead of pipx)
uv run --with httpx script.py
uvx ruff check .           # run tool without installing
uv tool install ansible-core
uv tool list
uv tool upgrade --all

#PIPX - isolated CLI apps from PyPI
pipx install ansible-core
pipx inject ansible-core jmespath
pipx list
pipx upgrade-all
pipx run cowsay hi
