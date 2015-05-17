@echo off
for /f "delims=" %%A in ('hostname') do set "ux_hostname=%%A"
echo external_fact_hostname=%ux_hostname%
