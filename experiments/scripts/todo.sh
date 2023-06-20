./driverdar -dataset e3/trace/other -trace ../data/e3/trace/ta1-trace-e3-official-1.json.6 -storefile -storeentity -multithread
./driverbeat -trace ../data/examples/nano_scp_1 -storeentity -storefile -multithread

target=../data/encoding/e3/trace
python ./encoding_parser.py "$target/edgefact_0.txt" "$target/nodefact.txt" -o $target

python driver.py --dataset e3/trace --epoch 20 --show_val --show_test --save_model
python driver.py --dataset e3/trace --save_embedding