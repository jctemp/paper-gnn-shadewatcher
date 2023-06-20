#!/usr/bin/env nu
# DEPS
if (echo "ShadeWatcher" | path exists) {
    rm -r ShadeWatcher
}

git clone -q https://github.com/jun-zeng/ShadeWatcher.git
cd ShadeWatcher

["data", "parse", "recommend", "config"] | each { |src| 
    let dest = "../" + $src
    if (echo $dest | path exists) { 
        rm -r $dest
    }
    mv $src ../
    $"Moved ($src | path expand) to ($dest | path expand)."
}

cd ../
rm -r ShadeWatcher

# DATASET
if (echo "darpa-trace.tar.gz" | path exists) != true {
    pip install gdown
    python ./py/dataset.py
} else {
    $"Dataset already exists."
}

mkdir data/e3/trace
tar -xzf darpa-trace.tar.gz -C data/e3/trace

