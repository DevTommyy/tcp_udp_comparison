Comparison between `TCP` and `UDP` packet loss.

# Usage

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
cat comparison.txt
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

## Requirements

Having Rust installed

To install it in a Unix based sysem:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

```
