# pony-onedoc-md
## Concatenate all Pony tutorial markdown files into one file

Start by cloning this repo, or just grab a copy of the file makeone.pony,
and compile it using ponyc.

Then get your local clone of the Pony tutorial, in a suitable folder:
```
git clone https://github.com/CausalityLtd/pony-tutorial.git
```

Then, assuming your compiled program is named "onedoc-md", you should be able to do something like this:
```
./onedoc-md /PATH/TO/pony-tutorial /PATH/TO/one.md
```
The file "one.md" now contains the entire Pony tutorial.

If you want to produce a quite nice PDF of this "one.md", you may e.g. use this one:

http://www.markdowntopdf.com