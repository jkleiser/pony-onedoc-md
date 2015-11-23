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

To convert this "one.md" into a HTML file, I suggest you use [marked](https://github.com/chjj/marked),
which you can install using [npm](https://www.npmjs.com).

When you've got the raw HTML file, you may insert its contents into a copy of the file src/doc-css.html
to get a complete HTML document, including CSS that more or less matches the online Pony tutorial.

If you want to directly produce a quick PDF of the "one.md", you may try this one:

http://www.markdowntopdf.com