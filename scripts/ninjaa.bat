@echo off

:: I hate that ninja overwrites the same line again and again.
:: You can loose important information.
:: Using -v is too verbose.
:: Others have the same opinion, but ninja team doesn't care:
:: https://groups.google.com/g/ninja-build/c/efudxpWrlTc

ninja %* | findstr "^"
