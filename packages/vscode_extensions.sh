#!/bin/bash
set -e

vscodeExecutable="code"
if [ -n "$(command -v code-oss)" ]; then
    vscodeExecutable="code-oss"
fi

"$vscodeExecutable" --install-extension alefragnani.project-manager
"$vscodeExecutable" --install-extension bungcip.better-toml
"$vscodeExecutable" --install-extension hollowtree.vue-snippets
"$vscodeExecutable" --install-extension MS-CEINTL.vscode-language-pack-de
"$vscodeExecutable" --install-extension ms-vscode.cpptools
"$vscodeExecutable" --install-extension msjsdiag.debugger-for-chrome
"$vscodeExecutable" --install-extension rust-lang.rust
"$vscodeExecutable" --install-extension vadimcn.vscode-lldb
"$vscodeExecutable" --install-extension webfreak.debug
"$vscodeExecutable" --install-extension zhuangtongfa.Material-theme

exit 0
