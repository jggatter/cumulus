FROM debian:buster-slim
SHELL ["/bin/bash", "-c"]

RUN apt-get -qq update && \
    apt-get -qq -y install --no-install-recommends \
        curl \
        gnupg \
        python3 \
        build-essential \
        python3-dev \
        python3-pip

RUN pip3 install setuptools==46.1.3 --no-cache-dir && \
    pip3 install numpy==1.18.2 --no-cache-dir && \
    pip3 install scipy==1.4.1 --no-cache-dir && \
    pip3 install pandas==1.0.3 --no-cache-dir && \
    pip3 install Cython==0.29.16 --no-cache-dir && \
    pip3 install docopt==0.6.2 --no-cache-dir && \
    pip3 install h5py==2.10.0 --no-cache-dir && \
    pip3 install joblib==0.14.1 --no-cache-dir && \
    pip3 install loompy==3.0.6 --no-cache-dir && \
    pip3 install matplotlib==3.2.1 --no-cache-dir && \
    pip3 install natsort==7.0.1 --no-cache-dir && \
    pip3 install numba==0.48.0  --no-cache-dir && \
    pip3 install numcodecs==0.6.4 --no-cache-dir && \
    pip3 install seaborn==0.10.0 --no-cache-dir && \
    pip3 install zarr==2.4.0 --no-cache-dir && \
    pip3 install pegasusio==0.1.3 --no-cache-dir && \
    pip3 install demuxEM==0.1.1 --no-cache-dir

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \ 
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && apt-get install -y google-cloud-sdk=290.0.0-0

RUN apt-get -qq -y remove curl gnupg python3-pip && \
    apt-get -qq -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /var/log/dpkg.log && \
    rm /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python

RUN mkdir /software
ADD https://raw.githubusercontent.com/klarman-cell-observatory/cumulus/master/docker/monitor_script.sh /software
RUN chmod a+rx /software/monitor_script.sh

ENV PATH=/software:$PATH