"""
Convert the ShadeWatcher Parser output into one-hot encoded id mappings
which the ShadeWatcher recommendation GNN can use to train a model.
"""


import random
from os import makedirs
from os.path import join as pathjoin
from collections import defaultdict


def encode(edgefile_path, nodefile_path, output_path, randomize_edges):
    entityid_counter = 0
    entity2id = dict()
    inter2id = defaultdict(list)
    # relation2id - prexisting file
    train2id = []

    with open(nodefile_path) as nodefile:
        _, *lines = nodefile.readlines()

        for line in lines:
            split = line.split()
            if len(split) == 1:
                continue
            node_id, *_ = split

            if node_id not in entity2id:
                entity2id[node_id] = entityid_counter
                entityid_counter += 1

    with open(edgefile_path) as edgefile:
        _, *lines = edgefile.readlines()

        for line in lines:
            split = line.split()
            if len(split) == 1:
                continue
            _, node1_id, node2_id, relation_id, *_ = split

            if randomize_edges:
                # randomize the relation using one of the relation present
                # execve 2
                # recv 7
                # send 8
                # open 11
                # load 12
                # read 13
                # write 14
                # connect 15
                relation_id = random.choice([2, 7, 8, 11, 13, 14, 15])

            inter2id[entity2id[node1_id]].append(entity2id[node2_id])
            train2id.append(
                (
                    entity2id[node1_id],
                    entity2id[node2_id],
                    relation_id,
                )
            )

    makedirs(output_path, exist_ok=True)

    with open(pathjoin(output_path, "entity2id.txt"), "w+") as entity2id_file:
        entity2id_file.write(str(len(entity2id)) + "\n")
        entity2id_file.write("\n".join([f"{n} {i}" for n, i in entity2id.items()]))

    with open(pathjoin(output_path, "train2id.txt"), "w+") as train2id_file:
        train2id_file.write(str(len(train2id)) + "\n")
        train2id_file.write("\n".join([f"{n1} {n2} {r}" for n1, n2, r in train2id]))

    with open(pathjoin(output_path, "inter2id.txt"), "w+") as inter2id_file:
        inter2id_file.write(str(len(inter2id)) + "\n")
        inter2id_file.write(
            "\n".join([f'{n} {" ".join(map(str, ids))}' for n, ids in inter2id.items()])
        )

    with open(pathjoin(output_path, "relation2id.txt"), "w+") as relation2id_file:
        relation2id_file.write(
            r"""27
vfork 0
clone 1
execve 2
kill 3
pipe 4
delete 5
create 6
recv 7
send 8
mkdir 9
rmdir 10
open 11
load 12
read 13
write 14
connect 15
getpeername 16
filepath 17
mode 18
mtime 19
linknum 20
uid 21
count 22
nametype 23
version 24
dev 25
sizebyte 26"""
        )


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("edgefile_path")
    parser.add_argument("nodefile_path")

    parser.add_argument("-o", "--output-path", default=".")
    parser.add_argument("-r", "--randomize-edges", action="store_true")

    args = parser.parse_args()

    edgefile_path = args.edgefile_path
    nodefile_path = args.nodefile_path
    output_path = args.output_path
    randomize_edges = args.output_path

    encode(edgefile_path, nodefile_path, output_path, randomize_edges)