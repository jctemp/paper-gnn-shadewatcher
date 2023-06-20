FROM gcc:8.5.0 as parser
# 1. Install dependencies
RUN apt update -y && apt upgrade -y \
    && apt install -y pkg-config \
    libcrypto++-dev libssl-dev libjsoncpp-dev libconfig-dev libconfig++-dev \
    libpqxx-dev libpq-dev libjsoncpp-dev librdkafka-dev libneo4j-client-dev 

# 2. Copy source code
COPY ./parse /parse

# 3. Set environment variables
ENV CXXFLAGS -std=c++17
ENV PKG_CONFIG_PATH /usr/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH
ENV CPLUS_INCLUDE_PATH=/lib/include:$CPLUS_INCLUDE_PATH
ENV LD_LIBRARY_PATH=/lib/lib:/lib/lib64:$LD_LIBRARY_PATH
ENV PATH=/lib/bin:$PATH

# 4. Build
RUN cd /parse && make driverbeat && make driverdar && make driverkafka


FROM debian:buster-slim as python
# 1. Download dependencies
RUN apt update -y && apt install -y wget
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash ./miniconda.sh -b -p /opt/conda \
    && rm ./miniconda.sh

# 2. Copy source code
COPY ./conda.yml /conda.yml

# 3. Set environment variables
ENV PATH=/opt/conda/bin:$PATH
RUN conda init bash \
    && echo "conda activate shadewatcher" >> ~/.bashrc \
    && conda update -n base -c defaults conda -y \
    && conda env create -f /conda.yml


FROM debian:buster-slim as shadewatcher
# 1. Install dependencies
RUN apt update -y && apt install -y libneo4j-client-dev libconfig++-dev libpqxx-dev libjsoncpp-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 2. Copy dependencies
WORKDIR /ShadeWatcher
COPY --from=parser /parse/driverbeat /parse/driverdar /parse/driverkafka /ShadeWatcher/parse/
COPY --from=python /opt/conda /opt/conda
COPY ./py/encoding_parser.py /ShadeWatcher/parse/
VOLUME [ "/ShadeWatcher/config", "/ShadeWatcher/data", "/ShadeWatcher/recommend" ]

# 3. Set environment variables
ENV PATH=/opt/conda/bin:$PATH

# 4. Set conda environment
RUN conda init bash && echo "conda activate shadewatcher" >> ~/.bashrc

