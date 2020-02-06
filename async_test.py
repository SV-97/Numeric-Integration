from termcolor import colored
import pathlib as pl
from contextlib import contextmanager
from asyncio.subprocess import PIPE, STDOUT
import asyncio
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
        self.compilation_failed = False


def approx_equal(a, b, tolerance=1e-10):
    return abs(a - b) <= tolerance


@contextmanager
def constant_context():
    """Context manager to remove compilation artifacts (objectfiles etc.)"""
    initial_files = [p for p in pl.Path("./").iterdir() if p.is_file()]
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
    Language("C", "gcc -O3 C.c -lm -o C.out", "./C.out"),
    Language("C++", "g++ -O3 Cpp.cpp -o CPP.out", "./CPP.out"),
    Language("C#", "csc -O -out:CS.exe CS.cs", "mono CS.exe"),
    Language("Clojure", None, "clojure Clojure.clj"),
    Language("Haskell", "ghc -O Haskell.hs", "./Haskell"),
    Language("Io", None, "io Io.io"),
    Language("Julia", None, "julia Julia.jl"),
    Language("Java", "javac Main.java", "java Main"),
    Language("Erlang", "erlc numi.erl", "escript numi.beam"),
    Language("F#", "fsharpc -O --standalone -o:FS.exe Program.fs", "./FS.exe"),
    Language("Factor", None, "~/Downloads/factor/factor numi.factor"),
    Language("PHP", None, "php PHP.php"),
    Language("Prolog", None, "swipl Prolog.pl"),
    Language("Python", None, "python Python.py"),  # uuuuh, meta
    Language("R", None, "Rscript R.r"),
    Language("Ruby", None, "ruby Ruby.rb"),
    Language("Rust", "rustc -C opt-level=3 Rust.rs", "./Rust"),
    Language("Scala", "scalac Scala.scala", "scala ScalaSimpson"),
    Language("SQLite3", None, "echo '.read SQLite.sql' | sqlite3 :memory:"),
    Language("Chez Scheme", "scheme -q Scheme-setup.scm",
             "scheme -q Scheme.scm"),
}


async def compile(lang):
    if lang.compilation is not None:
        proc = await asyncio.create_subprocess_shell(lang.compilation, stdout=PIPE, stderr=PIPE)
    else:
        proc = await asyncio.create_subprocess_shell(lang.execution, stdout=PIPE, stderr=PIPE)
    await proc.wait()
    return lang


async def execute(lang):
    proc = await asyncio.create_subprocess_shell(lang.execution, stdout=PIPE, stderr=STDOUT)
    stdout, _ = await proc.communicate()
    lang.out = stdout
    return lang


async def compile_and_verify():
    """Compile all the languages that need compilation and verify that they give the correct output"""
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
            lang.compilation_failed = True
            continue
        if approx_equal(parsed, 0):
            print(f"{TICK} {name}")
        else:
            print(f"{CROSS} {name}, got {parsed}")


async def benchmark():
    print()
    print("Benchmarking...")
    for _ in range(10):
        for lang in languages:
            if lang.compilation_failed:
                continue
            if len(lang.times) > 1:
                if lang.times[0] > 1:
                    continue
            t1 = time()
            proc = await asyncio.create_subprocess_shell(lang.execution, shell=True, stdout=PIPE, stderr=PIPE)
            await proc.wait()
            t2 = time()
            lang.times.append(t2 - t1)


def plot():
    axs = [plt.subplot(2, 2, cat) for cat in range(1, 5)]
    for lang in languages:
        if lang.compilation_failed:
            continue
        avg = mean(lang.times)
        if avg <= 0.02:
            category = 0
        elif avg <= 0.1:
            category = 1
        elif avg <= 0.3:
            category = 2
        else:
            category = 3
        plt.subplot(axs[category])
        xs = list(range(len(lang.times)))
        ys = lang.times
        plt.plot(xs, ys, label=lang.name)
        plt.ylabel("t in s")
        plt.xlabel("Iteration")
        plt.legend()


with constant_context():
    asyncio.run(compile_and_verify())
    asyncio.run(benchmark())
    plot()
    plt.show()
