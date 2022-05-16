FROM ubuntu

# Install Erlang
RUN apt-get update
RUN apt-get install -y erlang zlib1g-dev

#Atom VM
RUN apt-get update
RUN apt-get install -y git cmake gperf build-essential
RUN git clone https://github.com/atomvm/AtomVM --branch release-0.5
WORKDIR /AtomVM
RuN mkdir build
WORKDIR /AtomVM/build
RUN cmake ..
RUN make


# Atomix
WORKDIR /
RUN git clone https://github.com/taguniversalmachine/atomix

