# No need to run this unless you want to recreate "bigrams.tsv"
# Expects do find the [aligned Bach chorales dataset](https://github.com/johentsch/aligned_bach_chorales/)
# in a directory called "bach"

import pandas as pd
import numpy as np
import pitchtypes as pty

# load Bach chorales:
names = [f"chor{i:03}" for i in range(1,101)]
piece_dfs = [pd.read_csv(f"bach/data/craigsapp_krn/notes/{name}.tsv", sep='\t') for name in names]
df = pd.concat(piece_dfs, keys=names, names=["piece", "note"])

def note_bigrams(piece_df):
    """
    Takes a piece dataframe and returns a dataframe of note bigrams.
    This is very rough and doesn't take into account rests nor any houses or other jumps in the score.
    """
    # helper function
    def make_bigrams(subdf):
        return pd.DataFrame({
            #"staff": subdf.staff.to_numpy()[1:],
            "n0_tpc": subdf.tpc.to_numpy()[:-1],
            "n0_octave": subdf.octave.to_numpy()[:-1],
            "n1_tpc": subdf.tpc.to_numpy()[1:],
            "n1_octave": subdf.octave.to_numpy()[1:],
        }).rename_axis(index="bigram_id")
        
    return piece_df.groupby(["piece", "staff"]).apply(make_bigrams)

bg = note_bigrams(df)

def bigrams_to_distance(df):
    n0s = pty.SpelledPitchArray.from_independent(df.n0_tpc, df.n0_octave)
    n1s = pty.SpelledPitchArray.from_independent(df.n1_tpc, df.n1_octave)
    intervals = n1s - n0s
    df = df.copy()

    fifths = intervals.fifths()
    octs = intervals.internal_octaves()
    df["n0_midi"] = n0s.fifths() * 7 + (n0s.internal_octaves() + 1) * 12
    df["int_fifths"] = fifths
    df["int_octaves"] = octs
    df["int_semitones"] = fifths * 7 + octs * 12
    return df

dists = bigrams_to_distance(bg)

dists.to_csv("bigrams.tsv", sep="\t")