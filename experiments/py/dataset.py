# !/usr/bin/env python3

import gdown
url = 'https://drive.google.com/uc?id=1GG1aUnPjjzzdbxznVTN8X6oVfA-K4oIV'
output = 'darpa-trace.tar.gz'
gdown.download(url, output, quiet=False)