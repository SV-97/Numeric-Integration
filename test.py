"""Small automated test suite
Doesn't cover:
    * C# & F# ( couldn't get mono running )
    * Matlab ( don't have matlab on my PC and couldn't test it )
    
Factor is a bit wonky because I don't have it properly installed
(couldn't be bothered to do so).

"""
from termcolor import colored
from subprocess import check_output, run, PIPE, STDOUT
import pathlib as pl
from contextlib import contextmanager
from time import time
import matplotlib.pyplot as plt
from statistics import mean

TICK = colored("✓", "green", attrs=["bold"])
CROSS = colored("❌", "red", attrs=["bold"])


class Language():
    def __init__(self, name, compilation, execution):
        self.name = name
        self.compilation = compilation
        self.execution = execution
        self.times = []
    
    def compile(self):
        if self.compilation is not None:
            run(self.compilation, stdout=PIPE, stderr=STDOUT, shell=True)
        else:
            # because some languages like python compile on first execution
            run(self.execution, stdout=PIPE, stderr=STDOUT, shell=True)


def approx_equal(a, b, tolerance=1e-10):
    return abs(a - b) <= tolerance


@contextmanager
def constant_context():
    """Context manager to remove compilation artifacts (objectfiles etc.)"""
    initial_files = [ p for p in pl.Path("./").iterdir() if p.is_file()]
    try:
        yield
    finally:
        print("Cleaning up...")
        # remove compilation artifacts
        for p in filter(lambda p: p.is_file(), pl.Path("./").iterdir()):
            if p not in initial_files:
                print(f"Removing: {p}")
                p.unlink()

languages = {
    Language("C", "gcc -O3 C.c -lm", "./a.out"),
    Language("C++", "g++ -O3 Cpp.cpp", "./a.out"),
    Language("Clojure", None, "clojure Clojure.clj"),
    Language("Haskell", "ghc -O Haskell.hs", "./Haskell"),
    Language("Io", None, "io Io.io"),
    Language("Julia", None, "julia Julia.jl"),
    Language("Java", "javac Main.java", "java Main"),
    Language("Erlang", "erlc numi.erl", "escript numi.beam"),
    Language("Factor", None, "~/Downloads/factor/factor numi.factor"),
    Language("PHP", None, "php PHP.php"),
    Language("Prolog", None, "swipl Prolog.pl"),
    Language("Python", None, "python Python.py"), #uuuuh, meta
    Language("R", None, "Rscript R.r"),
    Language("Ruby", None, "ruby Ruby.rb"),
    Language("Rust", "rustc -C opt-level=3 Rust.rs", "./Rust"),
    Language("Scala", "scalac Scala.scala", "scala ScalaSimpson"),
    Language("SQLite3", None, "echo '.read SQLite.sql' | sqlite3 :memory:"),
}

with constant_context():
    for lang in languages:
        lang.compile()
        name = lang.name
        try:
            proc = check_output(lang.execution, shell=True, stderr=STDOUT)
        except FileNotFoundError:
            print(f"{CROSS} {name}, failed to execute")
            continue

        val = proc.decode()
        try:
            parsed = float(val)
        except ValueError:
            print(f"{CROSS} {name}, failed to parse output: {val}")
            continue
        if approx_equal(parsed, 0):
            print(f"{TICK} {name}")
        else:
            print(f"{CROSS} {name}, got {parsed}")
    
    print()
    print("Benchmarking...")
    for i in range(10):
        for lang in languages:
            if len(lang.times) > 1:
                if lang.times[0] > 1:
                    continue
            t1 = time()
            check_output(lang.execution, shell=True, stderr=STDOUT)
            t2 = time()
            lang.times.append(t2 - t1)

for lang in languages:
    avg = mean(lang.times)
    if avg <= 0.02: category = 1
    elif avg <= 0.1: category = 2
    elif avg <= 0.3: category = 3
    else: category = 4
    plt.legend()
    plt.subplot(2, 2, category) # uses behaviour that's deprecated in 3.1.0 and may break on an update
    xs = list(range(len(lang.times)))
    ys = lang.times
    plt.plot(xs, ys, label=lang.name)
    plt.ylabel("t in s")
    plt.xlabel("Iteration")

plt.legend()
plt.show()