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
import asyncio

TICK = colored("✓", "green", attrs=["bold"])
CROSS = colored("❌", "red", attrs=["bold"])


class Language():
    def __init__(self, compilation, execution):
        self.compilation = compilation
        self.execution = execution
    
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
    "C": Language("gcc -O3 C.c -lm", "./a.out"),
    "C++": Language("g++ -O3 Cpp.cpp", "./a.out"),
    "Clojure": Language(None, "clojure Clojure.clj"),
    "Haskell": Language("ghc -O Haskell.hs", "./Haskell"),
    "Io": Language(None, "io Io.io"),
    "Julia": Language(None, "julia Julia.jl"),
    "Java": Language("javac Main.java", "java Main"),
    "Erlang": Language("erlc numi.erl", "escript numi.beam"),
    "Factor": Language(None, "~/Downloads/factor/factor numi.factor"),
    "PHP": Language(None, "php PHP.php"),
    "Prolog": Language(None, "swipl Prolog.pl"),
    "Python": Language(None, "python Python.py"), #uuuuh, meta
    "R": Language(None, "Rscript R.r"),
    "Ruby": Language(None, "ruby Ruby.rb"),
    "Rust": Language("rustc -C opt-level=3 Rust.rs", "./Rust"),
    "Scala": Language("scalac Scala.scala", "scala ScalaSimpson"),
    "SQLite3": Language(None, "echo '.read SQLite.sql' | sqlite3 :memory:"),
}


with constant_context():
    for (name, lang) in languages.items():
        lang.compile()
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
