from termcolor import colored
import pathlib as pl
from contextlib import contextmanager
from asyncio import create_subprocess_exec as run, create_subprocess_shell as check_output
from asyncio.subprocess import PIPE, STDOUT
import asyncio

TICK = colored("✓", "green", attrs=["bold"])
CROSS = colored("❌", "red", attrs=["bold"])


async def compile(self):
    if self.compilation is not None:
        a = await asyncio.create_subprocess_shell(self.compilation, stdout=PIPE, stderr=PIPE)
    else:
        # because some languages like python compile on first execution
        a = await asyncio.create_subprocess_shell(self.execution, stdout=PIPE, stderr=PIPE)


class Language():
    def __init__(self, name, compilation, execution):
        self.name = name
        self.compilation = compilation
        self.execution = execution


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


async def compile(lang):
    if lang.compilation is not None:
        await asyncio.create_subprocess_shell(lang.compilation, stdout=PIPE, stderr=PIPE)
    else:
        await asyncio.create_subprocess_shell(lang.execution, stdout=PIPE, stderr=PIPE)
    return lang


async def execute(lang):
    proc = await asyncio.create_subprocess_shell(lang.execution, stdout=PIPE, stderr=STDOUT)
    stdout, _ = await proc.communicate()
    lang.out = stdout
    return lang


async def main():
    compilations = [compile(lang) for lang in languages]
    compilations = asyncio.as_completed(compilations)
    for compilation in compilations:
        lang = await compilation
        lang = await execute(lang)
        proc = lang.out
        name = lang.name
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

with constant_context():
    asyncio.run(main())
