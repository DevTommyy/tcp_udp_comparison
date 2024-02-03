Comparison between `TCP` and `UDP` packet loss.

# Usage

### Installation

To run everything in a Unix based system open the shell and do:

```bash
# clone the repository
git clone https://github.com/DevTommyy/udp_test.git
cd udp_test

# make the script runnable
chmod +x run.sh

# run everything
./run.sh
```

You'll see something like

```txt
`some cargo things...`
Comparison completed and saved to comparison.txt
```

then you can just open the file with a text editor or cat it:

```bash
less comparison.txt
```

### Sample output

if there is no packet loss:

```txt
The files are identical
```

or, if there is packet loss:

```txt
The files are different
Here are the differences:
1197a1198,1199
> abdicai
> abdicammo
1267a1270,1297
> abiliterai
> abiliteremmo
...

```

### Cleanup

There is a script for the cleanup, if you want to run it, again give it the permission and then run it, it will `cargo clean` both directories

```bash
# make the script runnable
chmod +x cleanup.sh

# run everything

./cleanup.sh

```

# Note

The test only occurs for one protocol out of time (either `TCP` or `UDP`), so to test the other open the project in your editor of choice
e.g.

```bash
# if you have visual studio code cli utility installed
code .
```

then go to `receiver/src/main.rs` and `sender/src/main.rs` and in the `main` function uncomment the wanted protocol and comment the other (it's just commenting and uncommenting a line).
Finally run the run script, then see the results:

```bash
# run everything
./run.sh

# see the output
less comparison.txt
```

## Requirements

Having Rust installed

To install it in a Unix based sysem:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

```
