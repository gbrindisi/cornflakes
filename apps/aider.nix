{ pkgs, lib }:

# Derivation for Aider
let
  python3 = pkgs.python311.override {
    self = python3;
    packageOverrides = _: super: { tree-sitter = super.tree-sitter_0_21; };
  };

  version = "0.59.0";

in python3.pkgs.buildPythonApplication {
  pname = "aider-chat";
  inherit version;
  pyproject = true;

  src = pkgs.fetchFromGitHub {
    owner = "aider-ai";
    repo = "aider";
    rev = "refs/tags/v${version}";
    # nix hash to-sri --type sha256 $(nix-prefetch-url --unpack https://github.com/Aider-AI/aider/archive/refs/tags/v0.59.0.tar.gz)
    hash = "sha256-20LicYj1j5gGzhF+SxPUKu858nHZgwDF1JxXeHRtYe0=";
  };

  pythonRelaxDeps = true;

  buildInputs = [ pkgs.portaudio ];

  nativeCheckInputs = [ python3.pkgs.pytestCheckHook ];

  build-system = [ python3.pkgs.setuptools-scm ];

  dependencies = with python3.pkgs; [
    aiohappyeyeballs
    backoff
    beautifulsoup4
    configargparse
    diff-match-patch
    diskcache
    flake8
    gitpython
    grep-ast
    importlib-resources
    json5
    jsonschema
    jiter
    litellm
    networkx
    numpy
    packaging
    pathspec
    pexpect
    pillow
    playwright
    prompt-toolkit
    ptyprocess
    pydub
    pypager
    pypandoc
    pyperclip
    pyyaml
    psutil
    rich
    scipy
    sounddevice
    soundfile
    streamlit
    tokenizers
    watchdog
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/scrape/test_scrape.py"
    # Expected 'mock' to have been called once
    "tests/help/test_help.py"
  ];

  disabledTests = [
        # Tests require network
        "test_urls"
        "test_get_commit_message_with_custom_prompt"
        # FileNotFoundError
        "test_get_commit_message"
        # Expected 'launch_gui' to have been called once
        "test_browser_flag_imports_streamlit"
        # AttributeError
        "test_simple_send_with_retries"
        # Expected 'check_version' to have been called once
        "test_main_exit_calls_version_check"
        "test_cmd_git"
        "test_main_with_empty_git_dir_new_subdir_file"
    ] ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
        # Tests fails on darwin
        "test_dark_mode_sets_code_theme"
        "test_default_env_file_sets_automatic_variable"
    ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export AIDER_CHECK_UPDATE=false
  '';

}
