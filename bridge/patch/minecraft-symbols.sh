sed -i 's/hybris_dlsym/dlsym/;s/hybris\///' tools/process_headers.py
pushd tools
python process_headers.py &> /dev/null
popd
touch .target