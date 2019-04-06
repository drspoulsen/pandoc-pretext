<h1 id="synopsis">Synopsis</h1>

<p>
	<c>pandoc</c> [<em>options</em>] [<em>input-file</em>]…
</p>

<h1 id="description">Description</h1>

<p>
	Pandoc is a <url href='https://www.haskell.org'>Haskell</url> library for converting from one markup format to
another, and a command-line tool that uses this library.
</p>

<p>
	Pandoc can convert between numerous markup and word processing formats,
including, but not limited to, various flavors of <url href='http://daringfireball.net/projects/markdown/'>Markdown</url>, <url href='http://www.w3.org/html/'>HTML</url>,
<url href='http://latex-project.org'>LaTeX</url> and <url href='https://en.wikipedia.org/wiki/Office_Open_XML'>Word docx</url>. For the full lists of input and output formats,
see the <c>--from</c> and <c>--to</c> <url href='#general-options'>options below</url>.
Pandoc can also produce <url href='https://www.adobe.com/pdf/'>PDF</url> output: see <url href='#creating-a-pdf'>creating a PDF</url>, below.
</p>

<p>
	Pandoc’s enhanced version of Markdown includes syntax for <url href='#tables'>tables</url>,
<url href='#definition-lists'>definition lists</url>, <url href='#metadata-blocks'>metadata blocks</url>, <url href='#footnotes'>footnotes</url>, <url href='#citations'>citations</url>, <url href='#math'>math</url>,
and much more. See below under <url href='#pandocs-markdown'>Pandoc’s Markdown</url>.
</p>

<p>
	Pandoc has a modular design: it consists of a set of readers, which parse
text in a given format and produce a native representation of the document
(an <em>abstract syntax tree</em> or AST), and a set of writers, which convert
this native representation into a target format. Thus, adding an input
or output format requires only adding a reader or writer. Users can also
run custom <url href='http://pandoc.org/filters.html'>pandoc filters</url> to modify the intermediate AST.
</p>

<p>
	Because pandoc’s intermediate representation of a document is less
expressive than many of the formats it converts between, one should
not expect perfect conversions between every format and every other.
Pandoc attempts to preserve the structural elements of a document, but
not formatting details such as margin size. And some document elements,
such as complex tables, may not fit into pandoc’s simple document
model. While conversions from pandoc’s Markdown to all formats aspire
to be perfect, conversions from formats more expressive than pandoc’s
Markdown can be expected to be lossy.
</p>

<h2 id="using-pandoc">Using pandoc</h2>

<p>
	If no <em>input-files</em> are specified, input is read from <em>stdin</em>.
Output goes to <em>stdout</em> by default. For output to a file,
use the <c>-o</c> option:
</p>

<pre>pandoc -o output.html input.txt</pre>

<p>
	By default, pandoc produces a document fragment. To produce a standalone
document (e.g. a valid HTML file including <c>&lt;head&gt;</c> and <c>&lt;body&gt;</c>),
use the <c>-s</c> or <c>--standalone</c> flag:
</p>

<pre>pandoc -s -o output.html input.txt</pre>

<p>
	For more information on how standalone documents are produced, see
<url href='#templates'>Templates</url> below.
</p>

<p>
	If multiple input files are given, <c>pandoc</c> will concatenate them all (with
blank lines between them) before parsing. (Use <c>--file-scope</c> to parse files
individually.)
</p>

<h2 id="specifying-formats">Specifying formats</h2>

<p>
	The format of the input and output can be specified explicitly using
command-line options. The input format can be specified using the
<c>-f/--from</c> option, the output format using the <c>-t/--to</c> option.
Thus, to convert <c>hello.txt</c> from Markdown to LaTeX, you could type:
</p>

<pre>pandoc -f markdown -t latex hello.txt</pre>

<p>
	To convert <c>hello.html</c> from HTML to Markdown:
</p>

<pre>pandoc -f html -t markdown hello.html</pre>

<p>
	Supported input and output formats are listed below under <url href='#options'>Options</url>
(see <c>-f</c> for input formats and <c>-t</c> for output formats). You
can also use <c>pandoc --list-input-formats</c> and
<c>pandoc --list-output-formats</c> to print lists of supported
formats.
</p>

<p>
	If the input or output format is not specified explicitly, <c>pandoc</c>
will attempt to guess it from the extensions of the filenames.
Thus, for example,
</p>

<pre>pandoc -o hello.tex hello.txt</pre>

<p>
	will convert <c>hello.txt</c> from Markdown to LaTeX. If no output file
is specified (so that output goes to <em>stdout</em>), or if the output file’s
extension is unknown, the output format will default to HTML.
If no input file is specified (so that input comes from <em>stdin</em>), or
if the input files’ extensions are unknown, the input format will
be assumed to be Markdown.
</p>

<h2 id="character-encoding">Character encoding</h2>

<p>
	Pandoc uses the UTF-8 character encoding for both input and output.
If your local character encoding is not UTF-8, you
should pipe input and output through <url href='http://www.gnu.org/software/libiconv/'><c>iconv</c></url>:
</p>

<pre>iconv -t utf-8 input.txt | pandoc | iconv -f utf-8</pre>

<p>
	Note that in some output formats (such as HTML, LaTeX, ConTeXt,
RTF, OPML, DocBook, and Texinfo), information about
the character encoding is included in the document header, which
will only be included if you use the <c>-s/--standalone</c> option.
</p>

<h2 id="creating-a-pdf">Creating a PDF</h2>

<p>
	To produce a PDF, specify an output file with a <c>.pdf</c> extension:
</p>

<pre>pandoc test.txt -o test.pdf</pre>

<p>
	By default, pandoc will use LaTeX to create the PDF, which requires
that a LaTeX engine be installed (see <c>--pdf-engine</c> below).
</p>

<p>
	Alternatively, pandoc can use <url href='http://www.contextgarden.net/'>ConTeXt</url>, <c>pdfroff</c>, or any of the
following HTML/CSS-to-PDF-engines, to create a PDF: <url href='https://wkhtmltopdf.org'><c>wkhtmltopdf</c></url>,
<url href='http://weasyprint.org'><c>weasyprint</c></url> or <url href='https://www.princexml.com/'><c>prince</c></url>.
To do this, specify an output file with a <c>.pdf</c> extension, as before,
but add the <c>--pdf-engine</c> option or <c>-t context</c>, <c>-t html</c>, or <c>-t ms</c>
to the command line (<c>-t html</c> defaults to <c>--pdf-engine=wkhtmltopdf</c>).
</p>

<p>
	PDF output uses <url href='#variables-for-latex'>variables for LaTeX</url> (with a LaTeX engine);
<url href='#variables-for-context'>variables for ConTeXt</url> (with ConTeXt); or <url href='#variables-for-wkhtmltopdf'>variables for <c>wkhtmltopdf</c></url>
(an HTML/CSS-to-PDF engine; <c>--css</c> also affects the output).
</p>

<p>
	To debug the PDF creation, it can be useful to look at the intermediate
representation: instead of <c>-o test.pdf</c>, use for example <c>-s -o test.tex</c>
to output the generated LaTeX. You can then test it with <c>pdflatex test.tex</c>.
</p>

<p>
	When using LaTeX, the following packages need to be available
(they are included with all recent versions of <url href='http://www.tug.org/texlive/'>TeX Live</url>):
<url href='https://ctan.org/pkg/amsfonts'><c>amsfonts</c></url>, <url href='https://ctan.org/pkg/amsmath'><c>amsmath</c></url>, <url href='https://ctan.org/pkg/lm'><c>lm</c></url>, <url href='https://ctan.org/pkg/unicode-math'><c>unicode-math</c></url>,
<url href='https://ctan.org/pkg/ifxetex'><c>ifxetex</c></url>, <url href='https://ctan.org/pkg/ifluatex'><c>ifluatex</c></url>, <url href='https://ctan.org/pkg/listings'><c>listings</c></url> (if the
<c>--listings</c> option is used), <url href='https://ctan.org/pkg/fancyvrb'><c>fancyvrb</c></url>, <url href='https://ctan.org/pkg/longtable'><c>longtable</c></url>,
<url href='https://ctan.org/pkg/booktabs'><c>booktabs</c></url>, <url href='https://ctan.org/pkg/graphicx'><c>graphicx</c></url> and <url href='https://ctan.org/pkg/grffile'><c>grffile</c></url> (if the document
contains images), <url href='https://ctan.org/pkg/hyperref'><c>hyperref</c></url>, <url href='https://ctan.org/pkg/xcolor'><c>xcolor</c></url>,
<url href='https://ctan.org/pkg/ulem'><c>ulem</c></url>, <url href='https://ctan.org/pkg/geometry'><c>geometry</c></url> (with the <c>geometry</c> variable set),
<url href='https://ctan.org/pkg/setspace'><c>setspace</c></url> (with <c>linestretch</c>), and
<url href='https://ctan.org/pkg/babel'><c>babel</c></url> (with <c>lang</c>). The use of <c>xelatex</c> or <c>lualatex</c> as
the PDF engine requires <url href='https://ctan.org/pkg/fontspec'><c>fontspec</c></url>. <c>xelatex</c> uses
<url href='https://ctan.org/pkg/polyglossia'><c>polyglossia</c></url> (with <c>lang</c>), <url href='https://ctan.org/pkg/xecjk'><c>xecjk</c></url>, and <url href='https://ctan.org/pkg/bidi'><c>bidi</c></url> (with the
<c>dir</c> variable set). If the <c>mathspec</c> variable is set,
<c>xelatex</c> will use <url href='https://ctan.org/pkg/mathspec'><c>mathspec</c></url> instead of <url href='https://ctan.org/pkg/unicode-math'><c>unicode-math</c></url>.
The <url href='https://ctan.org/pkg/upquote'><c>upquote</c></url> and <url href='https://ctan.org/pkg/microtype'><c>microtype</c></url> packages are used if
available, and <url href='https://ctan.org/pkg/csquotes'><c>csquotes</c></url> will be used for <url href='#typography'>typography</url>
if <c>\usepackage{csquotes}</c> is present in the template or
included via <c>/H/--include-in-header</c>. The <url href='https://ctan.org/pkg/natbib'><c>natbib</c></url>,
<url href='https://ctan.org/pkg/biblatex'><c>biblatex</c></url>, <url href='https://ctan.org/pkg/bibtex'><c>bibtex</c></url>, and <url href='https://ctan.org/pkg/biber'><c>biber</c></url> packages can optionally
be used for <url href='#citation-rendering'>citation rendering</url>. The following packages
will be used to improve output quality if present, but
pandoc does not require them to be present:
<url href='https://ctan.org/pkg/upquote'><c>upquote</c></url> (for straight quotes in verbatim environments),
<url href='https://ctan.org/pkg/microtype'><c>microtype</c></url> (for better spacing adjustments),
<url href='https://ctan.org/pkg/parskip'><c>parskip</c></url> (for better inter-paragraph spaces),
<url href='https://ctan.org/pkg/xurl'><c>xurl</c></url> (for better line breaks in URLs),
<url href='https://ctan.org/pkg/bookmark'><c>bookmark</c></url> (for better PDF bookmarks),
and <url href='https://ctan.org/pkg/footnotehyper'><c>footnotehyper</c></url> or <url href='https://ctan.org/pkg/footnote'><c>footnote</c></url> (to allow footnotes in tables).
</p>

<h2 id="reading-from-the-web">Reading from the Web</h2>

<p>
	Instead of an input file, an absolute URI may be given. In this case
pandoc will fetch the content using HTTP:
</p>

<pre>pandoc -f html -t markdown http://www.fsf.org</pre>

<p>
	It is possible to supply a custom User-Agent string or other
header when requesting a document from a URL:
</p>

<pre>pandoc -f html -t markdown --request-header User-Agent:&quot;Mozilla/5.0&quot; \
  http://www.fsf.org</pre>

<h1 id="options">Options</h1>

<h2 class="options" id="general-options">General options</h2>

<dl>
<dt><c>-f</c> <em>FORMAT</em>, <c>-r</c> <em>FORMAT</em>, <c>--from=</c><em>FORMAT</em>, <c>--read=</c><em>FORMAT</em></dt>
<dd><p>
	Specify input format. <em>FORMAT</em> can be:
</p>

<div id="input-formats">
<ul>
<li><c>commonmark</c> (<url href='http://commonmark.org'>CommonMark</url> Markdown)</li>
<li><c>creole</c> (<url href='http://www.wikicreole.org/wiki/Creole1.0'>Creole 1.0</url>)</li>
<li><c>docbook</c> (<url href='http://docbook.org'>DocBook</url>)</li>
<li><c>docx</c> (<url href='https://en.wikipedia.org/wiki/Office_Open_XML'>Word docx</url>)</li>
<li><c>dokuwiki</c> (<url href='https://www.dokuwiki.org/dokuwiki'>DokuWiki markup</url>)</li>
<li><c>epub</c> (<url href='http://idpf.org/epub'>EPUB</url>)</li>
<li><c>fb2</c> (<url href='http://www.fictionbook.org/index.php/Eng:XML_Schema_Fictionbook_2.1'>FictionBook2</url> e-book)</li>
<li><c>gfm</c> (<url href='https://help.github.com/articles/github-flavored-markdown/'>GitHub-Flavored Markdown</url>),
or the deprecated and less accurate <c>markdown_github</c>;
use <url href='#markdown-variants'><c>markdown_github</c></url> only
if you need extensions not supported in <url href='#markdown-variants'><c>gfm</c></url>.</li>
<li><c>haddock</c> (<url href='https://www.haskell.org/haddock/doc/html/ch03s08.html'>Haddock markup</url>)</li>
<li><c>html</c> (<url href='http://www.w3.org/html/'>HTML</url>)</li>
<li><c>ipynb</c> (<url href='https://nbformat.readthedocs.io/en/latest/'>Jupyter notebook</url>)</li>
<li><c>jats</c> (<url href='https://jats.nlm.nih.gov'>JATS</url> XML)</li>
<li><c>json</c> (JSON version of native AST)</li>
<li><c>latex</c> (<url href='http://latex-project.org'>LaTeX</url>)</li>
<li><c>markdown</c> (<url href='#pandocs-markdown'>Pandoc’s Markdown</url>)</li>
<li><c>markdown_mmd</c> (<url href='http://fletcherpenney.net/multimarkdown/'>MultiMarkdown</url>)</li>
<li><c>markdown_phpextra</c> (<url href='https://michelf.ca/projects/php-markdown/extra/'>PHP Markdown Extra</url>)</li>
<li><c>markdown_strict</c> (original unextended <url href='http://daringfireball.net/projects/markdown/'>Markdown</url>)</li>
<li><c>mediawiki</c> (<url href='https://www.mediawiki.org/wiki/Help:Formatting'>MediaWiki markup</url>)</li>
<li><c>man</c> (<url href='http://man7.org/linux/man-pages/man7/groff_man.7.html'>roff man</url>)</li>
<li><c>muse</c> (<url href='https://amusewiki.org/library/manual'>Muse</url>)</li>
<li><c>native</c> (native Haskell)</li>
<li><c>odt</c> (<url href='http://en.wikipedia.org/wiki/OpenDocument'>ODT</url>)</li>
<li><c>opml</c> (<url href='http://dev.opml.org/spec2.html'>OPML</url>)</li>
<li><c>org</c> (<url href='http://orgmode.org'>Emacs Org mode</url>)</li>
<li><c>rst</c> (<url href='http://docutils.sourceforge.net/docs/ref/rst/introduction.html'>reStructuredText</url>)</li>
<li><c>t2t</c> (<url href='http://txt2tags.org'>txt2tags</url>)</li>
<li><c>textile</c> (<url href='http://redcloth.org/textile'>Textile</url>)</li>
<li><c>tikiwiki</c> (<url href='https://doc.tiki.org/Wiki-Syntax-Text#The_Markup_Language_Wiki-Syntax'>TikiWiki markup</url>)</li>
<li><c>twiki</c> (<url href='http://twiki.org/cgi-bin/view/TWiki/TextFormattingRules'>TWiki markup</url>)</li>
<li><c>vimwiki</c> (<url href='https://vimwiki.github.io'>Vimwiki</url>)</li>
</ul></div>

<p>
	Extensions can be individually enabled or disabled by
appending <c>+EXTENSION</c> or <c>-EXTENSION</c> to the format name.
See <url href='#extensions'>Extensions</url> below, for a list of extensions and
their names. See <c>--list-input-formats</c> and <c>--list-extensions</c>,
below.
</p></dd>
<dt><c>-t</c> <em>FORMAT</em>, <c>-w</c> <em>FORMAT</em>, <c>--to=</c><em>FORMAT</em>, <c>--write=</c><em>FORMAT</em></dt>
<dd><p>
	Specify output format. <em>FORMAT</em> can be:
</p>

<div id="output-formats">
<ul>
<li><c>asciidoc</c> (<url href='http://www.methods.co.nz/asciidoc/'>AsciiDoc</url>) or <c>asciidoctor</c> (<url href='https://asciidoctor.org/'>AsciiDoctor</url>)</li>
<li><c>beamer</c> (<url href='https://ctan.org/pkg/beamer'>LaTeX beamer</url> slide show)</li>
<li><c>commonmark</c> (<url href='http://commonmark.org'>CommonMark</url> Markdown)</li>
<li><c>context</c> (<url href='http://www.contextgarden.net/'>ConTeXt</url>)</li>
<li><c>docbook</c> or <c>docbook4</c> (<url href='http://docbook.org'>DocBook</url> 4)</li>
<li><c>docbook5</c> (DocBook 5)</li>
<li><c>docx</c> (<url href='https://en.wikipedia.org/wiki/Office_Open_XML'>Word docx</url>)</li>
<li><c>dokuwiki</c> (<url href='https://www.dokuwiki.org/dokuwiki'>DokuWiki markup</url>)</li>
<li><c>epub</c> or <c>epub3</c> (<url href='http://idpf.org/epub'>EPUB</url> v3 book)</li>
<li><c>epub2</c> (EPUB v2)</li>
<li><c>fb2</c> (<url href='http://www.fictionbook.org/index.php/Eng:XML_Schema_Fictionbook_2.1'>FictionBook2</url> e-book)</li>
<li><c>gfm</c> (<url href='https://help.github.com/articles/github-flavored-markdown/'>GitHub-Flavored Markdown</url>),
or the deprecated and less accurate <c>markdown_github</c>;
use <url href='#markdown-variants'><c>markdown_github</c></url> only
if you need extensions not supported in <url href='#markdown-variants'><c>gfm</c></url>.</li>
<li><c>haddock</c> (<url href='https://www.haskell.org/haddock/doc/html/ch03s08.html'>Haddock markup</url>)</li>
<li><c>html</c> or <c>html5</c> (<url href='http://www.w3.org/html/'>HTML</url>, i.e. <url href='http://www.w3.org/TR/html5/'>HTML5</url>/XHTML <url href='https://www.w3.org/TR/html-polyglot/'>polyglot markup</url>)</li>
<li><c>html4</c> (<url href='http://www.w3.org/TR/xhtml1/'>XHTML</url> 1.0 Transitional)</li>
<li><c>icml</c> (<url href='http://wwwimages.adobe.com/www.adobe.com/content/dam/acom/en/devnet/indesign/sdk/cs6/idml/idml-cookbook.pdf'>InDesign ICML</url>)</li>
<li><c>ipynb</c> (<url href='https://nbformat.readthedocs.io/en/latest/'>Jupyter notebook</url>)</li>
<li><c>jats</c> (<url href='https://jats.nlm.nih.gov'>JATS</url> XML)</li>
<li><c>json</c> (JSON version of native AST)</li>
<li><c>latex</c> (<url href='http://latex-project.org'>LaTeX</url>)</li>
<li><c>man</c> (<url href='http://man7.org/linux/man-pages/man7/groff_man.7.html'>roff man</url>)</li>
<li><c>markdown</c> (<url href='#pandocs-markdown'>Pandoc’s Markdown</url>)</li>
<li><c>markdown_mmd</c> (<url href='http://fletcherpenney.net/multimarkdown/'>MultiMarkdown</url>)</li>
<li><c>markdown_phpextra</c> (<url href='https://michelf.ca/projects/php-markdown/extra/'>PHP Markdown Extra</url>)</li>
<li><c>markdown_strict</c> (original unextended <url href='http://daringfireball.net/projects/markdown/'>Markdown</url>)</li>
<li><c>mediawiki</c> (<url href='https://www.mediawiki.org/wiki/Help:Formatting'>MediaWiki markup</url>)</li>
<li><c>ms</c> (<url href='http://man7.org/linux/man-pages/man7/groff_ms.7.html'>roff ms</url>)</li>
<li><c>muse</c> (<url href='https://amusewiki.org/library/manual'>Muse</url>),</li>
<li><c>native</c> (native Haskell),</li>
<li><c>odt</c> (<url href='http://en.wikipedia.org/wiki/OpenDocument'>OpenOffice text document</url>)</li>
<li><c>opml</c> (<url href='http://dev.opml.org/spec2.html'>OPML</url>)</li>
<li><c>opendocument</c> (<url href='http://opendocument.xml.org'>OpenDocument</url>)</li>
<li><c>org</c> (<url href='http://orgmode.org'>Emacs Org mode</url>)</li>
<li><c>plain</c> (plain text),</li>
<li><c>pptx</c> (<url href='https://en.wikipedia.org/wiki/Microsoft_PowerPoint'>PowerPoint</url> slide show)</li>
<li><c>rst</c> (<url href='http://docutils.sourceforge.net/docs/ref/rst/introduction.html'>reStructuredText</url>)</li>
<li><c>rtf</c> (<url href='http://en.wikipedia.org/wiki/Rich_Text_Format'>Rich Text Format</url>)</li>
<li><c>texinfo</c> (<url href='http://www.gnu.org/software/texinfo/'>GNU Texinfo</url>)</li>
<li><c>textile</c> (<url href='http://redcloth.org/textile'>Textile</url>)</li>
<li><c>slideous</c> (<url href='http://goessner.net/articles/slideous/'>Slideous</url> HTML and JavaScript slide show)</li>
<li><c>slidy</c> (<url href='http://www.w3.org/Talks/Tools/Slidy/'>Slidy</url> HTML and JavaScript slide show)</li>
<li><c>dzslides</c> (<url href='http://paulrouget.com/dzslides/'>DZSlides</url> HTML5 + JavaScript slide show),</li>
<li><c>revealjs</c> (<url href='http://lab.hakim.se/reveal-js/'>reveal.js</url> HTML5 + JavaScript slide show)</li>
<li><c>s5</c> (<url href='http://meyerweb.com/eric/tools/s5/'>S5</url> HTML and JavaScript slide show)</li>
<li><c>tei</c> (<url href='https://github.com/TEIC/TEI-Simple'>TEI Simple</url>)</li>
<li><c>zimwiki</c> (<url href='http://zim-wiki.org/manual/Help/Wiki_Syntax.html'>ZimWiki markup</url>)</li>
<li>the path of a custom lua writer, see <url href='#custom-writers'>Custom writers</url> below</li>
</ul></div>

<p>
	Note that <c>odt</c>, <c>docx</c>, and <c>epub</c> output will not be directed
to <em>stdout</em> unless forced with <c>-o -</c>.
</p>

<p>
	Extensions can be individually enabled or
disabled by appending <c>+EXTENSION</c> or <c>-EXTENSION</c> to the format
name. See <url href='#extensions'>Extensions</url> below, for a list of extensions and their
names. See <c>--list-output-formats</c> and <c>--list-extensions</c>, below.
</p></dd>
<dt><c>-o</c> <em>FILE</em>, <c>--output=</c><em>FILE</em></dt>
<dd><p>
	Write output to <em>FILE</em> instead of <em>stdout</em>. If <em>FILE</em> is
<c>-</c>, output will go to <em>stdout</em>, even if a non-textual format
(<c>docx</c>, <c>odt</c>, <c>epub2</c>, <c>epub3</c>) is specified.
</p></dd>
<dt><c>--data-dir=</c><em>DIRECTORY</em></dt>
<dd><p>
	Specify the user data directory to search for pandoc data files.
If this option is not specified, the default user data directory
will be used. On *nix and macOS systems this will be the <c>pandoc</c>
subdirectory of the XDG data directory (by default,
<c>$HOME/.local/share</c>, overridable by setting the <c>XDG_DATA_HOME</c>
environment variable). If that directory does not exist,
<c>$HOME/.pandoc</c> will be used (for backwards compatibility).
In Windows the default user data directory is
<c>C:\Users\USERNAME\AppData\Roaming\pandoc</c>.
You can find the default user data directory on your system by
looking at the output of <c>pandoc --version</c>.
A <c>reference.odt</c>, <c>reference.docx</c>, <c>epub.css</c>, <c>templates</c>,
<c>slidy</c>, <c>slideous</c>, or <c>s5</c> directory
placed in this directory will override pandoc’s normal defaults.
</p></dd>
<dt><c>--bash-completion</c></dt>
<dd><p>
	Generate a bash completion script. To enable bash completion
with pandoc, add this to your <c>.bashrc</c>:
</p>

<pre>eval &quot;$(pandoc --bash-completion)&quot;</pre></dd>
<dt><c>--verbose</c></dt>
<dd><p>
	Give verbose debugging output. Currently this only has an effect
with PDF output.
</p></dd>
<dt><c>--quiet</c></dt>
<dd><p>
	Suppress warning messages.
</p></dd>
<dt><c>--fail-if-warnings</c></dt>
<dd><p>
	Exit with error status if there are any warnings.
</p></dd>
<dt><c>--log=</c><em>FILE</em></dt>
<dd><p>
	Write log messages in machine-readable JSON format to
<em>FILE</em>. All messages above DEBUG level will be written,
regardless of verbosity settings (<c>--verbose</c>, <c>--quiet</c>).
</p></dd>
<dt><c>--list-input-formats</c></dt>
<dd><p>
	List supported input formats, one per line.
</p></dd>
<dt><c>--list-output-formats</c></dt>
<dd><p>
	List supported output formats, one per line.
</p></dd>
<dt><c>--list-extensions</c>[<c>=</c><em>FORMAT</em>]</dt>
<dd><p>
	List supported extensions, one per line, preceded
by a <c>+</c> or <c>-</c> indicating whether it is enabled by default
in <em>FORMAT</em>. If <em>FORMAT</em> is not specified, defaults for
pandoc’s Markdown are given.
</p></dd>
<dt><c>--list-highlight-languages</c></dt>
<dd><p>
	List supported languages for syntax highlighting, one per
line.
</p></dd>
<dt><c>--list-highlight-styles</c></dt>
<dd><p>
	List supported styles for syntax highlighting, one per line.
See <c>--highlight-style</c>.
</p></dd>
<dt><c>-v</c>, <c>--version</c></dt>
<dd><p>
	Print version.
</p></dd>
<dt><c>-h</c>, <c>--help</c></dt>
<dd><p>
	Show usage message.
</p></dd>
</dl>

<h2 class="options" id="reader-options">Reader options</h2>

<dl>
<dt><c>--base-header-level=</c><em>NUMBER</em></dt>
<dd><p>
	Specify the base level for headers (defaults to 1).
</p></dd>
<dt><c>--strip-empty-paragraphs</c></dt>
<dd><p>
	<em>Deprecated. Use the <c>+empty_paragraphs</c> extension instead.</em>
Ignore paragraphs with no content. This option is useful
for converting word processing documents where users have
used empty paragraphs to create inter-paragraph space.
</p></dd>
<dt><c>--indented-code-classes=</c><em>CLASSES</em></dt>
<dd><p>
	Specify classes to use for indented code blocks–for example,
<c>perl,numberLines</c> or <c>haskell</c>. Multiple classes may be separated
by spaces or commas.
</p></dd>
<dt><c>--default-image-extension=</c><em>EXTENSION</em></dt>
<dd><p>
	Specify a default extension to use when image paths/URLs have no
extension. This allows you to use the same source for formats that
require different kinds of images. Currently this option only affects
the Markdown and LaTeX readers.
</p></dd>
<dt><c>--file-scope</c></dt>
<dd><p>
	Parse each file individually before combining for multifile
documents. This will allow footnotes in different files with the
same identifiers to work as expected. If this option is set,
footnotes and links will not work across files. Reading binary
files (docx, odt, epub) implies <c>--file-scope</c>.
</p></dd>
<dt><c>-F</c> <em>PROGRAM</em>, <c>--filter=</c><em>PROGRAM</em></dt>
<dd><p>
	Specify an executable to be used as a filter transforming the
pandoc AST after the input is parsed and before the output is
written. The executable should read JSON from stdin and write
JSON to stdout. The JSON must be formatted like pandoc’s own
JSON input and output. The name of the output format will be
passed to the filter as the first argument. Hence,
</p>

<pre>pandoc --filter ./caps.py -t latex</pre>

<p>
	is equivalent to
</p>

<pre>pandoc -t json | ./caps.py latex | pandoc -f json -t latex</pre>

<p>
	The latter form may be useful for debugging filters.
</p>

<p>
	Filters may be written in any language. <c>Text.Pandoc.JSON</c>
exports <c>toJSONFilter</c> to facilitate writing filters in Haskell.
Those who would prefer to write filters in python can use the
module <url href='https://github.com/jgm/pandocfilters'><c>pandocfilters</c></url>, installable from PyPI. There are also
pandoc filter libraries in <url href='https://github.com/vinai/pandocfilters-php'>PHP</url>, <url href='https://metacpan.org/pod/Pandoc::Filter'>perl</url>, and
<url href='https://github.com/mvhenderson/pandoc-filter-node'>JavaScript/node.js</url>.
</p>

<p>
	In order of preference, pandoc will look for filters in
</p>

<ol>
<li><p>
	a specified full or relative path (executable or
non-executable)
</p></li>
<li><p>
	<c>$DATADIR/filters</c> (executable or non-executable)
where <c>$DATADIR</c> is the user data directory (see
<c>--data-dir</c>, above).
</p></li>
<li><p>
	<c>$PATH</c> (executable only)
</p></li>
</ol>

<p>
	Filters and lua-filters are applied in the order specified
on the command line.
</p></dd>
<dt><c>--lua-filter=</c><em>SCRIPT</em></dt>
<dd><p>
	Transform the document in a similar fashion as JSON filters (see
<c>--filter</c>), but use pandoc’s build-in lua filtering system. The given
lua script is expected to return a list of lua filters which will be
applied in order. Each lua filter must contain element-transforming
functions indexed by the name of the AST element on which the filter
function should be applied.
</p>

<p>
	The <c>pandoc</c> lua module provides helper functions for element
creation. It is always loaded into the script’s lua environment.
</p>

<p>
	The following is an example lua script for macro-expansion:
</p>

<pre>function expand_hello_world(inline)
  if inline.c == &#39;{{helloworld}}&#39; then
    return pandoc.Emph{ pandoc.Str &quot;Hello, World&quot; }
  else
    return inline
  end
end

return {{Str = expand_hello_world}}</pre>

<p>
	In order of preference, pandoc will look for lua filters in
</p>

<ol>
<li><p>
	a specified full or relative path (executable or
non-executable)
</p></li>
<li><p>
	<c>$DATADIR/filters</c> (executable or non-executable)
where <c>$DATADIR</c> is the user data directory (see
<c>--data-dir</c>, above).
</p></li>
</ol></dd>
<dt><c>-M</c> <em>KEY</em>[<c>=</c><em>VAL</em>], <c>--metadata=</c><em>KEY</em>[<c>:</c><em>VAL</em>]</dt>
<dd><p>
	Set the metadata field <em>KEY</em> to the value <em>VAL</em>. A value specified
on the command line overrides a value specified in the document
using <url href='#extension-yaml_metadata_block'>YAML metadata blocks</url>.
Values will be parsed as YAML boolean or string values. If no value is
specified, the value will be treated as Boolean true. Like
<c>--variable</c>, <c>--metadata</c> causes template variables to be set.
But unlike <c>--variable</c>, <c>--metadata</c> affects the metadata of the
underlying document (which is accessible from filters and may be
printed in some output formats) and metadata values will be escaped
when inserted into the template.
</p></dd>
<dt><c>--metadata-file=</c><em>FILE</em></dt>
<dd><p>
	Read metadata from the supplied YAML (or JSON) file.
This option can be used with every input format, but string
scalars in the YAML file will always be parsed as Markdown.
Generally, the input will be handled the same as in
<url href='#extension-yaml_metadata_block'>YAML metadata blocks</url>.
Metadata values specified inside the document, or by using <c>-M</c>,
overwrite values specified with this option.
</p></dd>
<dt><c>-p</c>, <c>--preserve-tabs</c></dt>
<dd><p>
	Preserve tabs instead of converting them to spaces (the default).
Note that this will only affect tabs in literal code spans and code
blocks; tabs in regular text will be treated as spaces.
</p></dd>
<dt><c>--tab-stop=</c><em>NUMBER</em></dt>
<dd><p>
	Specify the number of spaces per tab (default is 4).
</p></dd>
<dt><c>--track-changes=accept</c>|<c>reject</c>|<c>all</c></dt>
<dd><p>
	Specifies what to do with insertions, deletions, and comments
produced by the MS Word <q>Track Changes</q> feature. <c>accept</c> (the
default), inserts all insertions, and ignores all
deletions. <c>reject</c> inserts all deletions and ignores
insertions. Both <c>accept</c> and <c>reject</c> ignore comments. <c>all</c> puts
in insertions, deletions, and comments, wrapped in spans with
<c>insertion</c>, <c>deletion</c>, <c>comment-start</c>, and <c>comment-end</c>
classes, respectively. The author and time of change is
included. <c>all</c> is useful for scripting: only accepting changes
from a certain reviewer, say, or before a certain date. If a
paragraph is inserted or deleted, <c>track-changes=all</c> produces a
span with the class <c>paragraph-insertion</c>/<c>paragraph-deletion</c>
before the affected paragraph break. This option only affects the
docx reader.
</p></dd>
<dt><c>--extract-media=</c><em>DIR</em></dt>
<dd><p>
	Extract images and other media contained in or linked from
the source document to the path <em>DIR</em>, creating it if
necessary, and adjust the images references in the document
so they point to the extracted files. If the source format is
a binary container (docx, epub, or odt), the media is
extracted from the container and the original
filenames are used. Otherwise the media is read from the
file system or downloaded, and new filenames are constructed
based on SHA1 hashes of the contents.
</p></dd>
<dt><c>--abbreviations=</c><em>FILE</em></dt>
<dd><p>
	Specifies a custom abbreviations file, with abbreviations
one to a line. If this option is not specified, pandoc will
read the data file <c>abbreviations</c> from the user data
directory or fall back on a system default. To see the
system default, use
<c>pandoc --print-default-data-file=abbreviations</c>. The only
use pandoc makes of this list is in the Markdown reader.
Strings ending in a period that are found in this list will
be followed by a nonbreaking space, so that the period will
not produce sentence-ending space in formats like LaTeX.
</p></dd>
</dl>

<h2 class="options" id="general-writer-options">General writer options</h2>

<dl>
<dt><c>-s</c>, <c>--standalone</c></dt>
<dd><p>
	Produce output with an appropriate header and footer (e.g. a
standalone HTML, LaTeX, TEI, or RTF file, not a fragment). This option
is set automatically for <c>pdf</c>, <c>epub</c>, <c>epub3</c>, <c>fb2</c>, <c>docx</c>, and <c>odt</c>
output. For <c>native</c> output, this option causes metadata to
be included; otherwise, metadata is suppressed.
</p></dd>
<dt><c>--template=</c><em>FILE</em>|<em>URL</em></dt>
<dd><p>
	Use the specified file as a custom template for the generated document.
Implies <c>--standalone</c>. See <url href='#templates'>Templates</url>, below, for a description
of template syntax. If no extension is specified, an extension
corresponding to the writer will be added, so that <c>--template=special</c>
looks for <c>special.html</c> for HTML output. If the template is not
found, pandoc will search for it in the <c>templates</c> subdirectory of
the user data directory (see <c>--data-dir</c>). If this option is not used,
a default template appropriate for the output format will be used (see
<c>-D/--print-default-template</c>).
</p></dd>
<dt><c>-V</c> <em>KEY</em>[<c>=</c><em>VAL</em>], <c>--variable=</c><em>KEY</em>[<c>:</c><em>VAL</em>]</dt>
<dd><p>
	Set the template variable <em>KEY</em> to the value <em>VAL</em> when rendering the
document in standalone mode. This is generally only useful when the
<c>--template</c> option is used to specify a custom template, since
pandoc automatically sets the variables used in the default
templates. If no <em>VAL</em> is specified, the key will be given the
value <c>true</c>.
</p></dd>
<dt><c>-D</c> <em>FORMAT</em>, <c>--print-default-template=</c><em>FORMAT</em></dt>
<dd><p>
	Print the system default template for an output <em>FORMAT</em>. (See <c>-t</c>
for a list of possible <em>FORMAT</em>s.) Templates in the user data
directory are ignored. This option may be used with
<c>-o</c>/<c>--output</c> to redirect output to a file, but
<c>-o</c>/<c>--output</c> must come before <c>--print-default-template</c>
on the command line.
</p></dd>
<dt><c>--print-default-data-file=</c><em>FILE</em></dt>
<dd><p>
	Print a system default data file. Files in the user data directory
are ignored. This option may be used with <c>-o</c>/<c>--output</c> to
redirect output to a file, but <c>-o</c>/<c>--output</c> must come before
<c>--print-default-data-file</c> on the command line.
</p></dd>
<dt><c>--eol=crlf</c>|<c>lf</c>|<c>native</c></dt>
<dd><p>
	Manually specify line endings: <c>crlf</c> (Windows), <c>lf</c>
(macOS/Linux/UNIX), or <c>native</c> (line endings appropriate
to the OS on which pandoc is being run). The default is
<c>native</c>.
</p></dd>
<dt><c>--dpi</c>=<em>NUMBER</em></dt>
<dd><p>
	Specify the dpi (dots per inch) value for conversion from pixels
to inch/centimeters and vice versa. The default is 96dpi.
Technically, the correct term would be ppi (pixels per inch).
</p></dd>
<dt><c>--wrap=auto</c>|<c>none</c>|<c>preserve</c></dt>
<dd><p>
	Determine how text is wrapped in the output (the source
code, not the rendered version). With <c>auto</c> (the default),
pandoc will attempt to wrap lines to the column width specified by
<c>--columns</c> (default 72). With <c>none</c>, pandoc will not wrap
lines at all. With <c>preserve</c>, pandoc will attempt to
preserve the wrapping from the source document (that is,
where there are nonsemantic newlines in the source, there
will be nonsemantic newlines in the output as well).
Automatic wrapping does not currently work in HTML output.
In <c>ipynb</c> output, this option affects wrapping of the
contents of markdown cells.
</p></dd>
<dt><c>--columns=</c><em>NUMBER</em></dt>
<dd><p>
	Specify length of lines in characters. This affects text wrapping
in the generated source code (see <c>--wrap</c>). It also affects
calculation of column widths for plain text tables (see <url href='#tables'>Tables</url> below).
</p></dd>
<dt><c>--toc</c>, <c>--table-of-contents</c></dt>
<dd><p>
	Include an automatically generated table of contents (or, in
the case of <c>latex</c>, <c>context</c>, <c>docx</c>, <c>odt</c>,
<c>opendocument</c>, <c>rst</c>, or <c>ms</c>, an instruction to create
one) in the output document. This option has no effect
unless <c>-s/--standalone</c> is used, and it has no effect
on <c>man</c>, <c>docbook4</c>, <c>docbook5</c>, or <c>jats</c> output.
</p></dd>
<dt><c>--toc-depth=</c><em>NUMBER</em></dt>
<dd><p>
	Specify the number of section levels to include in the table
of contents. The default is 3 (which means that level 1, 2, and 3
headers will be listed in the contents).
</p></dd>
<dt><c>--strip-comments</c></dt>
<dd><p>
	Strip out HTML comments in the Markdown or Textile source,
rather than passing them on to Markdown, Textile or HTML
output as raw HTML. This does not apply to HTML comments
inside raw HTML blocks when the <c>markdown_in_html_blocks</c>
extension is not set.
</p></dd>
<dt><c>--no-highlight</c></dt>
<dd><p>
	Disables syntax highlighting for code blocks and inlines, even when
a language attribute is given.
</p></dd>
<dt><c>--highlight-style=</c><em>STYLE</em>|<em>FILE</em></dt>
<dd><p>
	Specifies the coloring style to be used in highlighted source code.
Options are <c>pygments</c> (the default), <c>kate</c>, <c>monochrome</c>,
<c>breezeDark</c>, <c>espresso</c>, <c>zenburn</c>, <c>haddock</c>, and <c>tango</c>.
For more information on syntax highlighting in pandoc, see
<url href='#syntax-highlighting'>Syntax highlighting</url>, below. See also
<c>--list-highlight-styles</c>.
</p>

<p>
	Instead of a <em>STYLE</em> name, a JSON file with extension
<c>.theme</c> may be supplied. This will be parsed as a KDE
syntax highlighting theme and (if valid) used as the
highlighting style.
</p>

<p>
	To generate the JSON version of an existing style,
use <c>--print-highlight-style</c>.
</p></dd>
<dt><c>--print-highlight-style=</c><em>STYLE</em>|<em>FILE</em></dt>
<dd><p>
	Prints a JSON version of a highlighting style, which can
be modified, saved with a <c>.theme</c> extension, and used
with <c>--highlight-style</c>. This option may be used with
<c>-o</c>/<c>--output</c> to redirect output to a file, but
<c>-o</c>/<c>--output</c> must come before <c>--print-highlight-style</c>
on the command line.
</p></dd>
<dt><c>--syntax-definition=</c><em>FILE</em></dt>
<dd><p>
	Instructs pandoc to load a KDE XML syntax definition file,
which will be used for syntax highlighting of appropriately
marked code blocks. This can be used to add support for
new languages or to use altered syntax definitions for
existing languages.
</p></dd>
<dt><c>-H</c> <em>FILE</em>, <c>--include-in-header=</c><em>FILE</em>|<em>URL</em></dt>
<dd><p>
	Include contents of <em>FILE</em>, verbatim, at the end of the header.
This can be used, for example, to include special
CSS or JavaScript in HTML documents. This option can be used
repeatedly to include multiple files in the header. They will be
included in the order specified. Implies <c>--standalone</c>.
</p></dd>
<dt><c>-B</c> <em>FILE</em>, <c>--include-before-body=</c><em>FILE</em>|<em>URL</em></dt>
<dd><p>
	Include contents of <em>FILE</em>, verbatim, at the beginning of the
document body (e.g. after the <c>&lt;body&gt;</c> tag in HTML, or the
<c>\begin{document}</c> command in LaTeX). This can be used to include
navigation bars or banners in HTML documents. This option can be
used repeatedly to include multiple files. They will be included in
the order specified. Implies <c>--standalone</c>.
</p></dd>
<dt><c>-A</c> <em>FILE</em>, <c>--include-after-body=</c><em>FILE</em>|<em>URL</em></dt>
<dd><p>
	Include contents of <em>FILE</em>, verbatim, at the end of the document
body (before the <c>&lt;/body&gt;</c> tag in HTML, or the
<c>\end{document}</c> command in LaTeX). This option can be used
repeatedly to include multiple files. They will be included in the
order specified. Implies <c>--standalone</c>.
</p></dd>
<dt><c>--resource-path=</c><em>SEARCHPATH</em></dt>
<dd><p>
	List of paths to search for images and other resources.
The paths should be separated by <c>:</c> on Linux, UNIX, and
macOS systems, and by <c>;</c> on Windows. If <c>--resource-path</c>
is not specified, the default resource path is the working
directory. Note that, if <c>--resource-path</c> is specified,
the working directory must be explicitly listed or it
will not be searched. For example:
<c>--resource-path=.:test</c> will search the working directory
and the <c>test</c> subdirectory, in that order.
</p>

<p>
	<c>--resource-path</c> only has an effect if (a) the output
format embeds images (for example, <c>docx</c>, <c>pdf</c>, or <c>html</c>
with <c>--self-contained</c>) or (b) it is used together with
<c>--extract-media</c>.
</p></dd>
<dt><c>--request-header=</c><em>NAME</em><c>:</c><em>VAL</em></dt>
<dd><p>
	Set the request header <em>NAME</em> to the value <em>VAL</em> when making
HTTP requests (for example, when a URL is given on the
command line, or when resources used in a document must be
downloaded). If you’re behind a proxy, you also need to set
the environment variable <c>http_proxy</c> to <c>http://...</c>.
</p></dd>
</dl>

<h2 class="options" id="options-affecting-specific-writers">Options affecting specific writers</h2>

<dl>
<dt><c>--self-contained</c></dt>
<dd><p>
	Produce a standalone HTML file with no external dependencies, using
<c>data:</c> URIs to incorporate the contents of linked scripts, stylesheets,
images, and videos. Implies <c>--standalone</c>. The resulting file should be
<q>self-contained,</q> in the sense that it needs no external files and no net
access to be displayed properly by a browser. This option works only with
HTML output formats, including <c>html4</c>, <c>html5</c>, <c>html+lhs</c>, <c>html5+lhs</c>,
<c>s5</c>, <c>slidy</c>, <c>slideous</c>, <c>dzslides</c>, and <c>revealjs</c>. Scripts, images,
and stylesheets at absolute URLs will be downloaded; those at relative
URLs will be sought relative to the working directory (if the first source
file is local) or relative to the base URL (if the first source
file is remote). Elements with the attribute
<c>data-external=&quot;1&quot;</c> will be left alone; the documents they
link to will not be incorporated in the document.
Limitation: resources that are loaded dynamically through
JavaScript cannot be incorporated; as a result,
<c>--self-contained</c> does not work with <c>--mathjax</c>, and some
advanced features (e.g. zoom or speaker notes) may not work
in an offline <q>self-contained</q> <c>reveal.js</c> slide show.
</p></dd>
<dt><c>--html-q-tags</c></dt>
<dd><p>
	Use <c>&lt;q&gt;</c> tags for quotes in HTML.
</p></dd>
<dt><c>--ascii</c></dt>
<dd><p>
	Use only ASCII characters in output. Currently supported for XML
and HTML formats (which use entities instead of UTF-8 when this
option is selected), CommonMark, gfm, and Markdown (which use
entities), roff ms (which use hexadecimal escapes), and to a
limited degree LaTeX (which uses standard commands for accented
characters when possible). roff man output uses ASCII by default.
</p></dd>
<dt><c>--reference-links</c></dt>
<dd><p>
	Use reference-style links, rather than inline links, in writing Markdown
or reStructuredText. By default inline links are used. The
placement of link references is affected by the
<c>--reference-location</c> option.
</p></dd>
<dt><c>--reference-location = block</c>|<c>section</c>|<c>document</c></dt>
<dd><p>
	Specify whether footnotes (and references, if <c>reference-links</c> is
set) are placed at the end of the current (top-level) block, the
current section, or the document. The default is
<c>document</c>. Currently only affects the markdown writer.
</p></dd>
<dt><c>--atx-headers</c></dt>
<dd><p>
	Use ATX-style headers in Markdown output. The default is
to use setext-style headers for levels 1-2, and then ATX headers.
(Note: for <c>gfm</c> output, ATX headers are always used.)
This option also affects markdown cells in <c>ipynb</c> output.
</p></dd>
<dt><c>--top-level-division=[default|section|chapter|part]</c></dt>
<dd><p>
	Treat top-level headers as the given division type in LaTeX, ConTeXt,
DocBook, and TEI output. The hierarchy order is part, chapter, then section;
all headers are shifted such that the top-level header becomes the specified
type. The default behavior is to determine the best division type via
heuristics: unless other conditions apply, <c>section</c> is chosen. When the
LaTeX document class is set to <c>report</c>, <c>book</c>, or <c>memoir</c> (unless the
<c>article</c> option is specified), <c>chapter</c> is implied as the setting for this
option. If <c>beamer</c> is the output format, specifying either <c>chapter</c> or
<c>part</c> will cause top-level headers to become <c>\part{..}</c>, while
second-level headers remain as their default type.
</p></dd>
<dt><c>-N</c>, <c>--number-sections</c></dt>
<dd><p>
	Number section headings in LaTeX, ConTeXt, HTML, or EPUB output.
By default, sections are not numbered. Sections with class
<c>unnumbered</c> will never be numbered, even if <c>--number-sections</c>
is specified.
</p></dd>
<dt><c>--number-offset=</c><em>NUMBER</em>[<c>,</c><em>NUMBER</em><c>,</c><em>…</em>]</dt>
<dd><p>
	Offset for section headings in HTML output (ignored in other
output formats). The first number is added to the section number for
top-level headers, the second for second-level headers, and so on.
So, for example, if you want the first top-level header in your
document to be numbered <q>6</q>, specify <c>--number-offset=5</c>.
If your document starts with a level-2 header which you want to
be numbered <q>1.5</q>, specify <c>--number-offset=1,4</c>.
Offsets are 0 by default. Implies <c>--number-sections</c>.
</p></dd>
<dt><c>--listings</c></dt>
<dd><p>
	Use the <url href='https://ctan.org/pkg/listings'><c>listings</c></url> package for LaTeX code blocks. The package
does not support multi-byte encoding for source code. To handle UTF-8
you would need to use a custom template. This issue is fully
documented here: <url href='https://en.wikibooks.org/wiki/LaTeX/Source_Code_Listings#Encoding_issue'>Encoding issue with the listings package</url>.
</p></dd>
<dt><c>-i</c>, <c>--incremental</c></dt>
<dd><p>
	Make list items in slide shows display incrementally (one by one).
The default is for lists to be displayed all at once.
</p></dd>
<dt><c>--slide-level=</c><em>NUMBER</em></dt>
<dd><p>
	Specifies that headers with the specified level create
slides (for <c>beamer</c>, <c>s5</c>, <c>slidy</c>, <c>slideous</c>, <c>dzslides</c>). Headers
above this level in the hierarchy are used to divide the
slide show into sections; headers below this level create
subheads within a slide. Note that content that is
not contained under slide-level headers will not appear in
the slide show. The default is to set the slide level based
on the contents of the document; see <url href='#structuring-the-slide-show'>Structuring the slide
show</url>.
</p></dd>
<dt><c>--section-divs</c></dt>
<dd><p>
	Wrap sections in <c>&lt;section&gt;</c> tags (or <c>&lt;div&gt;</c> tags for <c>html4</c>),
and attach identifiers to the enclosing <c>&lt;section&gt;</c> (or <c>&lt;div&gt;</c>)
rather than the header itself. See
<url href='#header-identifiers'>Header identifiers</url>, below.
</p></dd>
<dt><c>--email-obfuscation=none</c>|<c>javascript</c>|<c>references</c></dt>
<dd><p>
	Specify a method for obfuscating <c>mailto:</c> links in HTML documents.
<c>none</c> leaves <c>mailto:</c> links as they are. <c>javascript</c> obfuscates
them using JavaScript. <c>references</c> obfuscates them by printing their
letters as decimal or hexadecimal character references. The default
is <c>none</c>.
</p></dd>
<dt><c>--id-prefix=</c><em>STRING</em></dt>
<dd><p>
	Specify a prefix to be added to all identifiers and internal links
in HTML and DocBook output, and to footnote numbers in Markdown
and Haddock output. This is useful for preventing duplicate
identifiers when generating fragments to be included in other pages.
</p></dd>
<dt><c>-T</c> <em>STRING</em>, <c>--title-prefix=</c><em>STRING</em></dt>
<dd><p>
	Specify <em>STRING</em> as a prefix at the beginning of the title
that appears in the HTML header (but not in the title as it
appears at the beginning of the HTML body). Implies
<c>--standalone</c>.
</p></dd>
<dt><c>-c</c> <em>URL</em>, <c>--css=</c><em>URL</em></dt>
<dd><p>
	Link to a CSS style sheet. This option can be used repeatedly to
include multiple files. They will be included in the order specified.
</p>

<p>
	A stylesheet is required for generating EPUB. If none is
provided using this option (or the <c>css</c> or <c>stylesheet</c>
metadata fields), pandoc will look for a file <c>epub.css</c> in the
user data directory (see <c>--data-dir</c>). If it is not
found there, sensible defaults will be used.
</p></dd>
<dt><c>--reference-doc=</c><em>FILE</em></dt>
<dd><p>
	Use the specified file as a style reference in producing a
docx or ODT file.
</p>

<dl>
<dt>Docx</dt>
<dd><p>
	For best results, the reference docx should be a modified
version of a docx file produced using pandoc. The contents
of the reference docx are ignored, but its stylesheets and
document properties (including margins, page size, header,
and footer) are used in the new docx. If no reference docx
is specified on the command line, pandoc will look for a
file <c>reference.docx</c> in the user data directory (see
<c>--data-dir</c>). If this is not found either, sensible
defaults will be used.
</p>

<p>
	To produce a custom <c>reference.docx</c>, first get a copy of
the default <c>reference.docx</c>: <c>pandoc -o custom-reference.docx --print-default-data-file reference.docx</c>.
Then open <c>custom-reference.docx</c> in Word, modify the
styles as you wish, and save the file. For best
results, do not make changes to this file other than
modifying the styles used by pandoc:
</p>

<p>
	Paragraph styles:
</p>

<ul>
<li>Normal</li>
<li>Body Text</li>
<li>First Paragraph</li>
<li>Compact</li>
<li>Title</li>
<li>Subtitle</li>
<li>Author</li>
<li>Date</li>
<li>Abstract</li>
<li>Bibliography</li>
<li>Heading 1</li>
<li>Heading 2</li>
<li>Heading 3</li>
<li>Heading 4</li>
<li>Heading 5</li>
<li>Heading 6</li>
<li>Heading 7</li>
<li>Heading 8</li>
<li>Heading 9</li>
<li>Block Text</li>
<li>Footnote Text</li>
<li>Definition Term</li>
<li>Definition</li>
<li>Caption</li>
<li>Table Caption</li>
<li>Image Caption</li>
<li>Figure</li>
<li>Captioned Figure</li>
<li>TOC Heading</li>
</ul>

<p>
	Character styles:
</p>

<ul>
<li>Default Paragraph Font</li>
<li>Body Text Char</li>
<li>Verbatim Char</li>
<li>Footnote Reference</li>
<li>Hyperlink</li>
</ul>

<p>
	Table style:
</p>

<ul>
<li>Table</li>
</ul></dd>
<dt>ODT</dt>
<dd><p>
	For best results, the reference ODT should be a modified
version of an ODT produced using pandoc. The contents of
the reference ODT are ignored, but its stylesheets are used
in the new ODT. If no reference ODT is specified on the
command line, pandoc will look for a file <c>reference.odt</c> in
the user data directory (see <c>--data-dir</c>). If this is not
found either, sensible defaults will be used.
</p>

<p>
	To produce a custom <c>reference.odt</c>, first get a copy of
the default <c>reference.odt</c>: <c>pandoc -o custom-reference.odt --print-default-data-file reference.odt</c>.
Then open <c>custom-reference.odt</c> in LibreOffice, modify
the styles as you wish, and save the file.
</p></dd>
<dt>PowerPoint</dt>
<dd><p>
	Any template included with a recent install of Microsoft
PowerPoint (either with <c>.pptx</c> or <c>.potx</c> extension) should
work, as will most templates derived from these.
</p>

<p>
	The specific requirement is that the template should contain
the following four layouts as its first four layouts:
</p>

<ol>
<li>Title Slide</li>
<li>Title and Content</li>
<li>Section Header</li>
<li>Two Content</li>
</ol>

<p>
	All templates included with a recent version of MS PowerPoint
will fit these criteria. (You can click on <c>Layout</c> under the
<c>Home</c> menu to check.)
</p>

<p>
	You can also modify the default <c>reference.pptx</c>: first run
<c>pandoc -o custom-reference.pptx --print-default-data-file reference.pptx</c>, and then modify <c>custom-reference.pptx</c>
in MS PowerPoint (pandoc will use the first four layout
slides, as mentioned above).
</p></dd>
</dl></dd>
<dt><c>--epub-cover-image=</c><em>FILE</em></dt>
<dd><p>
	Use the specified image as the EPUB cover. It is recommended
that the image be less than 1000px in width and height. Note that
in a Markdown source document you can also specify <c>cover-image</c>
in a YAML metadata block (see <url href='#epub-metadata'>EPUB Metadata</url>, below).
</p></dd>
<dt><c>--epub-metadata=</c><em>FILE</em></dt>
<dd><p>
	Look in the specified XML file for metadata for the EPUB.
The file should contain a series of <url href='http://dublincore.org/documents/dces/'>Dublin Core elements</url>.
For example:
</p>

<pre> &lt;dc:rights&gt;Creative Commons&lt;/dc:rights&gt;
 &lt;dc:language&gt;es-AR&lt;/dc:language&gt;</pre>

<p>
	By default, pandoc will include the following metadata elements:
<c>&lt;dc:title&gt;</c> (from the document title), <c>&lt;dc:creator&gt;</c> (from the
document authors), <c>&lt;dc:date&gt;</c> (from the document date, which should
be in <url href='http://www.w3.org/TR/NOTE-datetime'>ISO 8601 format</url>), <c>&lt;dc:language&gt;</c> (from the <c>lang</c>
variable, or, if is not set, the locale), and <c>&lt;dc:identifier id=&quot;BookId&quot;&gt;</c> (a randomly generated UUID). Any of these may be
overridden by elements in the metadata file.
</p>

<p>
	Note: if the source document is Markdown, a YAML metadata block
in the document can be used instead. See below under
<url href='#epub-metadata'>EPUB Metadata</url>.
</p></dd>
<dt><c>--epub-embed-font=</c><em>FILE</em></dt>
<dd><p>
	Embed the specified font in the EPUB. This option can be repeated
to embed multiple fonts. Wildcards can also be used: for example,
<c>DejaVuSans-*.ttf</c>. However, if you use wildcards on the command
line, be sure to escape them or put the whole filename in single quotes,
to prevent them from being interpreted by the shell. To use the
embedded fonts, you will need to add declarations like the following
to your CSS (see <c>--css</c>):
</p>

<pre>@font-face {
font-family: DejaVuSans;
font-style: normal;
font-weight: normal;
src:url(&quot;DejaVuSans-Regular.ttf&quot;);
}
@font-face {
font-family: DejaVuSans;
font-style: normal;
font-weight: bold;
src:url(&quot;DejaVuSans-Bold.ttf&quot;);
}
@font-face {
font-family: DejaVuSans;
font-style: italic;
font-weight: normal;
src:url(&quot;DejaVuSans-Oblique.ttf&quot;);
}
@font-face {
font-family: DejaVuSans;
font-style: italic;
font-weight: bold;
src:url(&quot;DejaVuSans-BoldOblique.ttf&quot;);
}
body { font-family: &quot;DejaVuSans&quot;; }</pre></dd>
<dt><c>--epub-chapter-level=</c><em>NUMBER</em></dt>
<dd><p>
	Specify the header level at which to split the EPUB into separate
<q>chapter</q> files. The default is to split into chapters at level 1
headers. This option only affects the internal composition of the
EPUB, not the way chapters and sections are displayed to users. Some
readers may be slow if the chapter files are too large, so for large
documents with few level 1 headers, one might want to use a chapter
level of 2 or 3.
</p></dd>
<dt><c>--epub-subdirectory=</c><em>DIRNAME</em></dt>
<dd><p>
	Specify the subdirectory in the OCF container that is to hold
the EPUB-specific contents. The default is <c>EPUB</c>. To put
the EPUB contents in the top level, use an empty string.
</p></dd>
<dt><c>--ipynb-output=all|none|best</c></dt>
<dd><p>
	Determines how ipynb output cells are treated. <c>all</c> means
that all of the data formats included in the original are
preserved. <c>none</c> means that the contents of data cells
are omitted. <c>best</c> causes pandoc to try to pick the
richest data block in each output cell that is compatible
with the output format. The default is <c>best</c>.
</p></dd>
<dt><c>--pdf-engine=</c><em>PROGRAM</em></dt>
<dd><p>
	Use the specified engine when producing PDF output.
Valid values are <c>pdflatex</c>, <c>lualatex</c>, <c>xelatex</c>, <c>latexmk</c>,
<c>tectonic</c>, <c>wkhtmltopdf</c>, <c>weasyprint</c>, <c>prince</c>, <c>context</c>,
and <c>pdfroff</c>. The default is <c>pdflatex</c>. If the engine is
not in your PATH, the full path of the engine may be specified here.
</p></dd>
<dt><c>--pdf-engine-opt=</c><em>STRING</em></dt>
<dd><p>
	Use the given string as a command-line argument to the <c>pdf-engine</c>.
For example, to use a persistent directory <c>foo</c> for <c>latexmk</c>’s
auxiliary files, use <c>--pdf-engine-opt=-outdir=foo</c>.
Note that no check for duplicate options is done.
</p></dd>
</dl>

<h2 class="options" id="citation-rendering">Citation rendering</h2>

<dl>
<dt><c>--bibliography=</c><em>FILE</em></dt>
<dd><p>
	Set the <c>bibliography</c> field in the document’s metadata to <em>FILE</em>,
overriding any value set in the metadata, and process citations
using <c>pandoc-citeproc</c>. (This is equivalent to
<c>--metadata bibliography=FILE --filter pandoc-citeproc</c>.)
If <c>--natbib</c> or <c>--biblatex</c> is also supplied, <c>pandoc-citeproc</c> is not
used, making this equivalent to <c>--metadata bibliography=FILE</c>.
If you supply this argument multiple times, each <em>FILE</em> will be added
to bibliography.
</p></dd>
<dt><c>--csl=</c><em>FILE</em></dt>
<dd><p>
	Set the <c>csl</c> field in the document’s metadata to <em>FILE</em>,
overriding any value set in the metadata. (This is equivalent to
<c>--metadata csl=FILE</c>.)
This option is only relevant with <c>pandoc-citeproc</c>.
</p></dd>
<dt><c>--citation-abbreviations=</c><em>FILE</em></dt>
<dd><p>
	Set the <c>citation-abbreviations</c> field in the document’s metadata to
<em>FILE</em>, overriding any value set in the metadata. (This is equivalent to
<c>--metadata citation-abbreviations=FILE</c>.)
This option is only relevant with <c>pandoc-citeproc</c>.
</p></dd>
<dt><c>--natbib</c></dt>
<dd><p>
	Use <url href='https://ctan.org/pkg/natbib'><c>natbib</c></url> for citations in LaTeX output. This option is not for use
with the <c>pandoc-citeproc</c> filter or with PDF output. It is intended for
use in producing a LaTeX file that can be processed with <url href='https://ctan.org/pkg/bibtex'><c>bibtex</c></url>.
</p></dd>
<dt><c>--biblatex</c></dt>
<dd><p>
	Use <url href='https://ctan.org/pkg/biblatex'><c>biblatex</c></url> for citations in LaTeX output. This option is not for use
with the <c>pandoc-citeproc</c> filter or with PDF output. It is intended for
use in producing a LaTeX file that can be processed with <url href='https://ctan.org/pkg/bibtex'><c>bibtex</c></url> or <url href='https://ctan.org/pkg/biber'><c>biber</c></url>.
</p></dd>
</dl>

<h2 class="options" id="math-rendering-in-html">Math rendering in HTML</h2>

<p>
	The default is to render TeX math as far as possible using Unicode characters.
Formulas are put inside a <c>span</c> with <c>class=&quot;math&quot;</c>, so that they may be styled
differently from the surrounding text if needed. However, this gives acceptable
results only for basic math, usually you will want to use <c>--mathjax</c> or another
of the following options.
</p>

<dl>
<dt><c>--mathjax</c>[<c>=</c><em>URL</em>]</dt>
<dd><p>
	Use <url href='https://www.mathjax.org'>MathJax</url> to display embedded TeX math in HTML output.
TeX math will be put between <c>\(...\)</c> (for inline math)
or <c>\[...\]</c> (for display math) and wrapped in <c>&lt;span&gt;</c> tags
with class <c>math</c>. Then the MathJax JavaScript will render it.
The <em>URL</em> should point to the <c>MathJax.js</c> load script.
If a <em>URL</em> is not provided, a link to the Cloudflare CDN will
be inserted.
</p></dd>
<dt><c>--mathml</c></dt>
<dd><p>
	Convert TeX math to <url href='http://www.w3.org/Math/'>MathML</url> (in <c>epub3</c>, <c>docbook4</c>, <c>docbook5</c>, <c>jats</c>,
<c>html4</c> and <c>html5</c>). This is the default in <c>odt</c> output. Note that
currently only Firefox and Safari (and select e-book readers) natively
support MathML.
</p></dd>
<dt><c>--webtex</c>[<c>=</c><em>URL</em>]</dt>
<dd><p>
	Convert TeX formulas to <c>&lt;img&gt;</c> tags that link to an external script
that converts formulas to images. The formula will be URL-encoded
and concatenated with the URL provided. For SVG images you can for
example use <c>--webtex https://latex.codecogs.com/svg.latex?</c>.
If no URL is specified, the CodeCogs URL generating PNGs
will be used (<c>https://latex.codecogs.com/png.latex?</c>).
Note: the <c>--webtex</c> option will affect Markdown output
as well as HTML, which is useful if you’re targeting a
version of Markdown without native math support.
</p></dd>
<dt><c>--katex</c>[<c>=</c><em>URL</em>]</dt>
<dd><p>
	Use <url href='https://github.com/Khan/KaTeX'>KaTeX</url> to display embedded TeX math in HTML output.
The <em>URL</em> is the base URL for the KaTeX library. That directory
should contain a <c>katex.min.js</c> and a <c>katex.min.css</c> file.
If a <em>URL</em> is not provided, a link to the KaTeX CDN will be inserted.
</p></dd>
<dt><c>--gladtex</c></dt>
<dd><p>
	Enclose TeX math in <c>&lt;eq&gt;</c> tags in HTML output. The resulting HTML
can then be processed by <url href='http://humenda.github.io/GladTeX/'>GladTeX</url> to produce images of the typeset
formulas and an HTML file with links to these images.
So, the procedure is:
</p>

<pre>pandoc -s --gladtex input.md -o myfile.htex
gladtex -d myfile-images myfile.htex
# produces myfile.html and images in myfile-images</pre></dd>
</dl>

<h2 class="options" id="options-for-wrapper-scripts">Options for wrapper scripts</h2>

<dl>
<dt><c>--dump-args</c></dt>
<dd><p>
	Print information about command-line arguments to <em>stdout</em>, then exit.
This option is intended primarily for use in wrapper scripts.
The first line of output contains the name of the output file specified
with the <c>-o</c> option, or <c>-</c> (for <em>stdout</em>) if no output file was
specified. The remaining lines contain the command-line arguments,
one per line, in the order they appear. These do not include regular
pandoc options and their arguments, but do include any options appearing
after a <c>--</c> separator at the end of the line.
</p></dd>
<dt><c>--ignore-args</c></dt>
<dd><p>
	Ignore command-line arguments (for use in wrapper scripts).
Regular pandoc options are not ignored. Thus, for example,
</p>

<pre>pandoc --ignore-args -o foo.html -s foo.txt -- -e latin1</pre>

<p>
	is equivalent to
</p>

<pre>pandoc -o foo.html -s</pre></dd>
</dl>

<h1 id="templates">Templates</h1>

<p>
	When the <c>-s/--standalone</c> option is used, pandoc uses a template to
add header and footer material that is needed for a self-standing
document. To see the default template that is used, just type
</p>

<pre>pandoc -D *FORMAT*</pre>

<p>
	where <em>FORMAT</em> is the name of the output format. A custom template
can be specified using the <c>--template</c> option. You can also override
the system default templates for a given output format <em>FORMAT</em>
by putting a file <c>templates/default.*FORMAT*</c> in the user data
directory (see <c>--data-dir</c>, above). <em>Exceptions:</em>
</p>

<ul>
<li>For <c>odt</c> output, customize the <c>default.opendocument</c>
template.</li>
<li>For <c>pdf</c> output, customize the <c>default.latex</c> template
(or the <c>default.context</c> template, if you use <c>-t context</c>,
or the <c>default.ms</c> template, if you use <c>-t ms</c>, or the
<c>default.html</c> template, if you use <c>-t html</c>).</li>
<li><c>docx</c> and <c>pptx</c> have no template (however, you can use
<c>--reference-doc</c> to customize the output).</li>
</ul>

<p>
	Templates contain <em>variables</em>, which allow for the inclusion of
arbitrary information at any point in the file. They may be set at the
command line using the <c>-V/--variable</c> option. If a variable is not set,
pandoc will look for the key in the document’s metadata – which can be set
using either <url href='#extension-yaml_metadata_block'>YAML metadata blocks</url>
or with the <c>-M/--metadata</c> option.
</p>

<h2 id="metadata-variables">Metadata variables</h2>

<dl>
<dt><c>title</c>, <c>author</c>, <c>date</c></dt>
<dd><p>
	allow identification of basic aspects of the document. Included
in PDF metadata through LaTeX and ConTeXt. These can be set
through a <url href='#extension-pandoc_title_block'>pandoc title block</url>,
which allows for multiple authors, or through a YAML metadata block:
</p>

<pre>---
author:
- Aristotle
- Peter Abelard
...</pre></dd>
<dt><c>subtitle</c></dt>
<dd>document subtitle, included in HTML, EPUB, LaTeX, ConTeXt, and docx
documents</dd>
<dt><c>abstract</c></dt>
<dd>document summary, included in LaTeX, ConTeXt, AsciiDoc, and docx
documents</dd>
<dt><c>keywords</c></dt>
<dd>list of keywords to be included in HTML, PDF, ODT, pptx, docx
and AsciiDoc metadata; repeat as for <c>author</c>, above</dd>
<dt><c>subject</c></dt>
<dd>document subject, included in ODT, PDF, docx and pptx metadata</dd>
<dt><c>description</c></dt>
<dd>document description, included in ODT, docx and pptx metadata. Some
applications show this as <c>Comments</c> metadata.</dd>
<dt><c>category</c></dt>
<dd>document category, included in docx and pptx metadata</dd>
</dl>

<p>
	Additionally,
any root-level string metadata, not included in ODT, docx
or pptx metadata is added as a <em>custom property</em>.
The following YAML metadata block for instance:
</p>

<pre>---
title:  &#39;This is the title&#39;
subtitle: &quot;This is the subtitle&quot;
author:
- Author One
- Author Two
description: |
    This is a long
    description.

    It consists of two paragraphs
...</pre>

<p>
	will include <c>title</c>, <c>author</c> and <c>description</c> as standard document
properties and <c>subtitle</c> as a custom property when converting to docx,
ODT or pptx.
</p>

<h2 id="language-variables">Language variables</h2>

<dl>
<dt><c>lang</c></dt>
<dd><p>
	identifies the main language of the document using IETF language
tags (following the <url href='https://tools.ietf.org/html/bcp47'>BCP 47</url> standard), such as <c>en</c> or <c>en-GB</c>.
The <url href='https://r12a.github.io/app-subtags/'>Language subtag lookup</url> tool can look up or verify these tags.
This affects most formats, and controls hyphenation in PDF output
when using LaTeX (through <url href='https://ctan.org/pkg/babel'><c>babel</c></url> and <url href='https://ctan.org/pkg/polyglossia'><c>polyglossia</c></url>) or ConTeXt.
</p>

<p>
	Use native pandoc <url href='#divs-and-spans'>Divs and Spans</url> with the <c>lang</c> attribute to
switch the language:
</p>

<pre>---
lang: en-GB
...

Text in the main document language (British English).

::: {lang=fr-CA}
&gt; Cette citation est écrite en français canadien.
:::

More text in English. [&#39;Zitat auf Deutsch.&#39;]{lang=de}</pre></dd>
<dt><c>dir</c></dt>
<dd><p>
	the base script direction, either <c>rtl</c> (right-to-left)
or <c>ltr</c> (left-to-right).
</p>

<p>
	For bidirectional documents, native pandoc <c>span</c>s and <c>div</c>s
with the <c>dir</c> attribute (value <c>rtl</c> or <c>ltr</c>) can be used to
override the base direction in some output formats.
This may not always be necessary if the final renderer
(e.g. the browser, when generating HTML) supports the
<url href='http://www.w3.org/International/articles/inline-bidi-markup/uba-basics'>Unicode Bidirectional Algorithm</url>.
</p>

<p>
	When using LaTeX for bidirectional documents, only the <c>xelatex</c> engine
is fully supported (use <c>--pdf-engine=xelatex</c>).
</p></dd>
</dl>

<h2 id="variables-for-html-slides">Variables for HTML slides</h2>

<p>
	These affect HTML output when <url href='#producing-slide-shows-with-pandoc'>producing slide shows with pandoc</url>.
All <url href='https://github.com/hakimel/reveal.js#configuration'>reveal.js configuration options</url> are available as variables.
</p>

<dl>
<dt><c>revealjs-url</c></dt>
<dd>base URL for reveal.js documents (defaults to <c>reveal.js</c>)</dd>
<dt><c>s5-url</c></dt>
<dd>base URL for S5 documents (defaults to <c>s5/default</c>)</dd>
<dt><c>slidy-url</c></dt>
<dd>base URL for Slidy documents (defaults to
<c>https://www.w3.org/Talks/Tools/Slidy2</c>)</dd>
<dt><c>slideous-url</c></dt>
<dd>base URL for Slideous documents (defaults to <c>slideous</c>)</dd>
</dl>

<h2 id="variables-for-beamer-slides">Variables for Beamer slides</h2>

<p>
	These variables change the appearance of PDF slides using <url href='https://ctan.org/pkg/beamer'><c>beamer</c></url>.
</p>

<dl>
<dt><c>aspectratio</c></dt>
<dd>slide aspect ratio (<c>43</c> for 4:3 [default], <c>169</c> for 16:9,
<c>1610</c> for 16:10, <c>149</c> for 14:9, <c>141</c> for 1.41:1, <c>54</c> for 5:4,
<c>32</c> for 3:2)</dd>
<dt><c>beamerarticle</c></dt>
<dd>produce an article from Beamer slides</dd>
<dt><c>beameroption</c></dt>
<dd>add extra beamer option with <c>\setbeameroption{}</c></dd>
<dt><c>institute</c></dt>
<dd>author affiliations: can be a list when there are multiple authors</dd>
<dt><c>logo</c></dt>
<dd>logo image for slides</dd>
<dt><c>navigation</c></dt>
<dd>controls navigation symbols (default is <c>empty</c> for no navigation
symbols; other valid values are <c>frame</c>, <c>vertical</c>, and <c>horizontal</c>)</dd>
<dt><c>section-titles</c></dt>
<dd>enables <q>title pages</q> for new sections (default is true)</dd>
<dt><c>theme</c>, <c>colortheme</c>, <c>fonttheme</c>, <c>innertheme</c>, <c>outertheme</c></dt>
<dd>beamer themes:</dd>
<dt><c>themeoptions</c></dt>
<dd>options for LaTeX beamer themes (a list).</dd>
<dt><c>titlegraphic</c></dt>
<dd>image for title slide</dd>
</dl>

<h2 id="variables-for-latex">Variables for LaTeX</h2>

<p>
	Pandoc uses these variables when <url href='#creating-a-pdf'>creating a PDF</url> with a LaTeX engine.
</p>

<h3 id="layout">Layout</h3>

<dl>
<dt><c>classoption</c></dt>
<dd>option for document class, e.g. <c>oneside</c>; repeat for multiple options</dd>
<dt><c>documentclass</c></dt>
<dd>document class: usually one of the standard classes, <url href='https://ctan.org/pkg/article'><c>article</c></url>, <url href='https://ctan.org/pkg/report'><c>report</c></url>,
and <url href='https://ctan.org/pkg/book'><c>book</c></url>; the <url href='https://ctan.org/pkg/koma-script'>KOMA-Script</url> equivalents, <c>scrartcl</c>, <c>scrreprt</c>,
and <c>scrbook</c>, which default to smaller margins; or <url href='https://ctan.org/pkg/memoir'><c>memoir</c></url></dd>
<dt><c>geometry</c></dt>
<dd>option for <url href='https://ctan.org/pkg/geometry'><c>geometry</c></url> package, e.g. <c>margin=1in</c>;
repeat for multiple options</dd>
<dt><c>indent</c></dt>
<dd>uses document class settings for indentation (the default LaTeX template
otherwise removes indentation and adds space between paragraphs)</dd>
<dt><c>linestretch</c></dt>
<dd>adjusts line spacing using the <url href='https://ctan.org/pkg/setspace'><c>setspace</c></url>
package, e.g. <c>1.25</c>, <c>1.5</c></dd>
<dt><c>margin-left</c>, <c>margin-right</c>, <c>margin-top</c>, <c>margin-bottom</c></dt>
<dd>sets margins if <c>geometry</c> is not used (otherwise <c>geometry</c>
overrides these)</dd>
<dt><c>pagestyle</c></dt>
<dd>control <c>\pagestyle{}</c>: the default article class
supports <c>plain</c> (default), <c>empty</c> (no running heads or page numbers),
and <c>headings</c> (section titles in running heads)</dd>
<dt><c>papersize</c></dt>
<dd>paper size, e.g. <c>letter</c>, <c>a4</c></dd>
<dt><c>secnumdepth</c></dt>
<dd>numbering depth for sections (with <c>--number-sections</c> option
or <c>numbersections</c> variable)</dd>
<dt><c>subparagraph</c></dt>
<dd>disables default behavior of LaTeX template that redefines (sub)paragraphs
as sections, changing the appearance of nested headings in some classes</dd>
</dl>

<h3 id="fonts">Fonts</h3>

<dl>
<dt><c>fontenc</c></dt>
<dd>allows font encoding to be specified through <c>fontenc</c> package (with <c>pdflatex</c>);
default is <c>T1</c> (see <url href='https://ctan.org/pkg/encguide'>LaTeX font encodings guide</url>)</dd>
<dt><c>fontfamily</c></dt>
<dd>font package for use with <c>pdflatex</c>:
<url href='http://www.tug.org/texlive/'>TeX Live</url> includes many options, documented in the <url href='http://www.tug.dk/FontCatalogue/'>LaTeX Font Catalogue</url>.
The default is <url href='https://ctan.org/pkg/lm'>Latin Modern</url>.</dd>
<dt><c>fontfamilyoptions</c></dt>
<dd><p>
	options for package used as <c>fontfamily</c>; repeat for multiple options.
For example, to use the Libertine font with proportional lowercase
(old-style) figures through the <url href='https://ctan.org/pkg/libertinus'><c>libertinus</c></url> package:
</p>

<pre>---
fontfamily: libertinus
fontfamilyoptions:
- osf
- p
...</pre></dd>
<dt><c>fontsize</c></dt>
<dd>font size for body text. The standard classes allow 10pt, 11pt, and 12pt.
To use another size, set <c>documentclass</c> to one of the <url href='https://ctan.org/pkg/koma-script'>KOMA-Script</url> classes,
such as <c>scrartcl</c> or <c>scrbook</c>.</dd>
<dt><c>mainfont</c>, <c>sansfont</c>, <c>monofont</c>, <c>mathfont</c>, <c>CJKmainfont</c></dt>
<dd>font families for use with <c>xelatex</c> or
<c>lualatex</c>: take the name of any system font, using the
<url href='https://ctan.org/pkg/fontspec'><c>fontspec</c></url> package. <c>CJKmainfont</c> uses the <url href='https://ctan.org/pkg/xecjk'><c>xecjk</c></url> package.</dd>
<dt><c>mainfontoptions</c>, <c>sansfontoptions</c>, <c>monofontoptions</c>, <c>mathfontoptions</c>, <c>CJKoptions</c></dt>
<dd><p>
	options to use with <c>mainfont</c>, <c>sansfont</c>, <c>monofont</c>, <c>mathfont</c>,
<c>CJKmainfont</c> in <c>xelatex</c> and <c>lualatex</c>. Allow for any choices
available through <url href='https://ctan.org/pkg/fontspec'><c>fontspec</c></url>; repeat for multiple options. For example,
to use the <url href='http://www.gust.org.pl/projects/e-foundry/tex-gyre'>TeX Gyre</url> version of Palatino with lowercase figures:
</p>

<pre>---
mainfont: TeX Gyre Pagella
mainfontoptions:
- Numbers=Lowercase
- Numbers=Proportional
...</pre></dd>
<dt><c>microtypeoptions</c></dt>
<dd>options to pass to the microtype package</dd>
</dl>

<h3 id="links">Links</h3>

<dl>
<dt><c>colorlinks</c></dt>
<dd>add color to link text; automatically enabled if any of
<c>linkcolor</c>, <c>filecolor</c>, <c>citecolor</c>, <c>urlcolor</c>, or <c>toccolor</c> are set</dd>
<dt><c>linkcolor</c>, <c>filecolor</c>, <c>citecolor</c>, <c>urlcolor</c>, <c>toccolor</c></dt>
<dd>color for internal links, external links, citation links, linked
URLs, and links in table of contents, respectively: uses options
allowed by <url href='https://ctan.org/pkg/xcolor'><c>xcolor</c></url>, including the <c>dvipsnames</c>, <c>svgnames</c>, and
<c>x11names</c> lists</dd>
<dt><c>links-as-notes</c></dt>
<dd>causes links to be printed as footnotes</dd>
</dl>

<h3 id="front-matter">Front matter</h3>

<dl>
<dt><c>lof</c>, <c>lot</c></dt>
<dd>include list of figures, list of tables</dd>
<dt><c>thanks</c></dt>
<dd>contents of acknowledgments footnote after document title</dd>
<dt><c>toc</c></dt>
<dd>include table of contents (can also be set using <c>--toc/--table-of-contents</c>)</dd>
<dt><c>toc-depth</c></dt>
<dd>level of section to include in table of contents</dd>
</dl>

<h3 id="biblatex-bibliographies">BibLaTeX Bibliographies</h3>

<p>
	These variables function when using BibLaTeX for <url href='#citation-rendering'>citation rendering</url>.
</p>

<dl>
<dt><c>biblatexoptions</c></dt>
<dd>list of options for biblatex</dd>
<dt><c>biblio-style</c></dt>
<dd>bibliography style, when used with <c>--natbib</c> and <c>--biblatex</c>.</dd>
<dt><c>biblio-title</c></dt>
<dd>bibliography title, when used with <c>--natbib</c> and <c>--biblatex</c>.</dd>
<dt><c>bibliography</c></dt>
<dd>bibliography to use for resolving references</dd>
<dt><c>natbiboptions</c></dt>
<dd>list of options for natbib</dd>
</dl>

<h2 id="variables-for-context">Variables for ConTeXt</h2>

<p>
	Pandoc uses these variables when <url href='#creating-a-pdf'>creating a PDF</url> with ConTeXt.
</p>

<dl>
<dt><c>fontsize</c></dt>
<dd>font size for body text (e.g. <c>10pt</c>, <c>12pt</c>)</dd>
<dt><c>headertext</c>, <c>footertext</c></dt>
<dd>text to be placed in running header or footer (see <url href='https://wiki.contextgarden.net/Headers_and_Footers'>ConTeXt Headers and Footers</url>);
repeat up to four times for different placement</dd>
<dt><c>indenting</c></dt>
<dd>controls indentation of paragraphs, e.g. <c>yes,small,next</c> (see <url href='https://wiki.contextgarden.net/Indentation'>ConTeXt Indentation</url>);
repeat for multiple options</dd>
<dt><c>interlinespace</c></dt>
<dd>adjusts line spacing, e.g. <c>4ex</c> (using <url href='https://wiki.contextgarden.net/Command/setupinterlinespace'><c>setupinterlinespace</c></url>);
repeat for multiple options</dd>
<dt><c>layout</c></dt>
<dd>options for page margins and text arrangement (see <url href='https://wiki.contextgarden.net/Layout'>ConTeXt Layout</url>);
repeat for multiple options</dd>
<dt><c>linkcolor</c>, <c>contrastcolor</c></dt>
<dd>color for links outside and inside a page, e.g. <c>red</c>, <c>blue</c> (see <url href='https://wiki.contextgarden.net/Color'>ConTeXt Color</url>)</dd>
<dt><c>linkstyle</c></dt>
<dd>typeface style for links, e.g. <c>normal</c>, <c>bold</c>, <c>slanted</c>, <c>boldslanted</c>, <c>type</c>, <c>cap</c>, <c>small</c></dd>
<dt><c>lof</c>, <c>lot</c></dt>
<dd>include list of figures, list of tables</dd>
<dt><c>mainfont</c>, <c>sansfont</c>, <c>monofont</c>, <c>mathfont</c></dt>
<dd>font families: take the name of any system font (see <url href='https://wiki.contextgarden.net/Font_Switching'>ConTeXt Font Switching</url>)</dd>
<dt><c>margin-left</c>, <c>margin-right</c>, <c>margin-top</c>, <c>margin-bottom</c></dt>
<dd>sets margins, if <c>layout</c> is not used (otherwise <c>layout</c>
overrides these)</dd>
<dt><c>pagenumbering</c></dt>
<dd>page number style and location (using <url href='https://wiki.contextgarden.net/Command/setuppagenumbering'><c>setuppagenumbering</c></url>);
repeat for multiple options</dd>
<dt><c>papersize</c></dt>
<dd>paper size, e.g. <c>letter</c>, <c>A4</c>, <c>landscape</c> (see <url href='https://wiki.contextgarden.net/PaperSetup'>ConTeXt Paper Setup</url>);
repeat for multiple options</dd>
<dt><c>pdfa</c></dt>
<dd>adds to the preamble the setup necessary to generate PDF/A-1b:2005.
To successfully generate PDF/A the required ICC color profiles have to
be available and the content and all included files (such as images)
have to be standard conforming. The ICC profiles can be obtained
from <url href='https://wiki.contextgarden.net/PDFX#ICC_profiles'>ConTeXt ICC Profiles</url>. See also <url href='https://wiki.contextgarden.net/PDF/A'>ConTeXt PDFA</url> for more
details.</dd>
<dt><c>toc</c></dt>
<dd>include table of contents (can also be set using <c>--toc/--table-of-contents</c>)</dd>
<dt><c>whitespace</c></dt>
<dd>spacing between paragraphs, e.g. <c>none</c>, <c>small</c> (using <url href='https://wiki.contextgarden.net/Command/setupwhitespace'><c>setupwhitespace</c></url>)</dd>
</dl>

<h2 id="variables-for-wkhtmltopdf">Variables for <c>wkhtmltopdf</c></h2>

<p>
	Pandoc uses these variables when <url href='#creating-a-pdf'>creating a PDF</url> with <url href='https://wkhtmltopdf.org'><c>wkhtmltopdf</c></url>.
The <c>--css</c> option also affects the output.
</p>

<dl>
<dt><c>footer-html</c>, <c>header-html</c></dt>
<dd>add information to the header and footer</dd>
<dt><c>margin-left</c>, <c>margin-right</c>, <c>margin-top</c>, <c>margin-bottom</c></dt>
<dd>set the page margins</dd>
<dt><c>papersize</c></dt>
<dd>sets the PDF paper size</dd>
</dl>

<h2 id="variables-for-man-pages">Variables for man pages</h2>

<dl>
<dt><c>adjusting</c></dt>
<dd>adjusts text to left (<c>l</c>), right (<c>r</c>), center (<c>c</c>),
or both (<c>b</c>) margins</dd>
<dt><c>footer</c></dt>
<dd>footer in man pages</dd>
<dt><c>header</c></dt>
<dd>header in man pages</dd>
<dt><c>hyphenate</c></dt>
<dd>if <c>true</c> (the default), hyphenation will be used</dd>
<dt><c>section</c></dt>
<dd>section number in man pages</dd>
</dl>

<h2 id="variables-for-ms">Variables for ms</h2>

<dl>
<dt><c>fontfamily</c></dt>
<dd>font family (e.g. <c>T</c> or <c>P</c>)</dd>
<dt><c>indent</c></dt>
<dd>paragraph indent (e.g. <c>2m</c>)</dd>
<dt><c>lineheight</c></dt>
<dd>line height (e.g. <c>12p</c>)</dd>
<dt><c>pointsize</c></dt>
<dd>point size (e.g. <c>10p</c>)</dd>
</dl>

<h2 id="structural-variables">Structural variables</h2>

<p>
	Pandoc sets these variables automatically in response to <url href='#options'>options</url> or
document contents; users can also modify them. These vary depending
on the output format, and include the following:
</p>

<dl>
<dt><c>body</c></dt>
<dd>body of document</dd>
<dt><c>date-meta</c></dt>
<dd>the <c>date</c> variable converted to ISO 8601 YYYY-MM-DD,
included in all HTML based formats (dzslides, epub,
html, html4, html5, revealjs, s5, slideous, slidy).
The recognized formats for <c>date</c> are: <c>mm/dd/yyyy</c>,
<c>mm/dd/yy</c>, <c>yyyy-mm-dd</c> (ISO 8601), <c>dd MM yyyy</c>
(e.g. either <c>02 Apr 2018</c> or <c>02 April 2018</c>),
<c>MM dd, yyyy</c> (e.g. <c>Apr. 02, 2018</c> or <c>April 02, 2018),</c>yyyy[mm[dd]]]<c>(e.g.</c>20180402, <c>201804</c> or <c>2018</c>).</dd>
<dt><c>header-includes</c></dt>
<dd>contents specified by <c>-H/--include-in-header</c> (may have multiple
values)</dd>
<dt><c>include-before</c></dt>
<dd>contents specified by <c>-B/--include-before-body</c> (may have
multiple values)</dd>
<dt><c>include-after</c></dt>
<dd>contents specified by <c>-A/--include-after-body</c> (may have
multiple values)</dd>
<dt><c>meta-json</c></dt>
<dd>JSON representation of all of the document’s metadata. Field
values are transformed to the selected output format.</dd>
<dt><c>numbersections</c></dt>
<dd>non-null value if <c>-N/--number-sections</c> was specified</dd>
<dt><c>sourcefile</c>, <c>outputfile</c></dt>
<dd><p>
	source and destination filenames, as given on the command line.
<c>sourcefile</c> can also be a list if input comes from multiple files, or empty
if input is from stdin. You can use the following snippet in your template
to distinguish them:
</p>

<pre>$if(sourcefile)$
$for(sourcefile)$
$sourcefile$
$endfor$
$else$
(stdin)
$endif$</pre>

<p>
	Similarly, <c>outputfile</c> can be <c>-</c> if output goes to the terminal.
</p></dd>
<dt><c>toc</c></dt>
<dd>non-null value if <c>--toc/--table-of-contents</c> was specified</dd>
<dt><c>toc-title</c></dt>
<dd>title of table of contents (works only with EPUB,
opendocument, odt, docx, pptx, beamer, LaTeX)</dd>
</dl>

<h2 id="using-variables-in-templates">Using variables in templates</h2>

<p>
	Variable names are sequences of alphanumerics, <c>-</c>, and <c>_</c>,
starting with a letter. A variable name surrounded by <c>$</c> signs
will be replaced by its value. For example, the string <c>$title$</c> in
</p>

<pre>&lt;title&gt;$title$&lt;/title&gt;</pre>

<p>
	will be replaced by the document title.
</p>

<p>
	To write a literal <c>$</c> in a template, use <c>$$</c>.
</p>

<p>
	Templates may contain conditionals. The syntax is as follows:
</p>

<pre>$if(variable)$
X
$else$
Y
$endif$</pre>

<p>
	This will include <c>X</c> in the template if <c>variable</c> has a truthy
value; otherwise it will include <c>Y</c>. Here a truthy value is any
of the following:
</p>

<ul>
<li>a string that is not entirely white space,</li>
<li>a non-empty array where the first value is truthy,</li>
<li>any number (including zero),</li>
<li>any object,</li>
<li>the boolean <c>true</c> (to specify the boolean <c>true</c>
value using YAML metadata or the <c>--metadata</c> flag,
use <c>true</c>, <c>True</c>, or <c>TRUE</c>; with the <c>--variable</c>
flag, simply omit a value for the variable, e.g.
<c>--variable draft</c>).</li>
</ul>

<p>
	<c>X</c> and <c>Y</c> are placeholders for any valid template text,
and may include interpolated variables or other conditionals.
The <c>$else$</c> section may be omitted.
</p>

<p>
	When variables can have multiple values (for example, <c>author</c> in
a multi-author document), you can use the <c>$for$</c> keyword:
</p>

<pre>$for(author)$
&lt;meta name=&quot;author&quot; content=&quot;$author$&quot; /&gt;
$endfor$</pre>

<p>
	You can optionally specify a separator to be used between
consecutive items:
</p>

<pre>$for(author)$$author$$sep$, $endfor$</pre>

<p>
	Note that the separator needs to be specified immediately before the <c>$endfor</c>
keyword.
</p>

<p>
	A dot can be used to select a field of a variable that takes
an object as its value. So, for example:
</p>

<pre>$author.name$ ($author.affiliation$)</pre>

<p>
	The value of a variable will be indented to the same level as the variable.
</p>

<p>
	If you use custom templates, you may need to revise them as pandoc
changes. We recommend tracking the changes in the default templates,
and modifying your custom templates accordingly. An easy way to do this
is to fork the <url href='https://github.com/jgm/pandoc-templates'>pandoc-templates</url> repository and merge in changes after each
pandoc release.
</p>

<p>
	Templates may contain comments: anything on a line after <c>$--</c>
will be treated as a comment and ignored.
</p>

<h1 id="extensions">Extensions</h1>

<p>
	The behavior of some of the readers and writers can be adjusted by
enabling or disabling various extensions.
</p>

<p>
	An extension can be enabled by adding <c>+EXTENSION</c>
to the format name and disabled by adding <c>-EXTENSION</c>. For example,
<c>--from markdown_strict+footnotes</c> is strict Markdown with footnotes
enabled, while <c>--from markdown-footnotes-pipe_tables</c> is pandoc’s
Markdown without footnotes or pipe tables.
</p>

<p>
	The markdown reader and writer make by far the most use of extensions.
Extensions only used by them are therefore covered in the
section <url href='#pandocs-markdown'>Pandoc’s Markdown</url> below (See <url href='#markdown-variants'>Markdown variants</url> for
<c>commonmark</c> and <c>gfm</c>.) In the following, extensions that also work
for other formats are covered.
</p>

<p>
	Note that markdown extensions added to the <c>ipynb</c> format
affect Markdown cells in Jupyter notebooks (as do command-line
options like <c>--atx-headers</c>).
</p>

<h2 id="typography">Typography</h2>

<h4 id="extension-smart">Extension: <c>smart</c></h4>

<p>
	Interpret straight quotes as curly quotes, <c>---</c> as em-dashes,
<c>--</c> as en-dashes, and <c>...</c> as ellipses. Nonbreaking spaces are
inserted after certain abbreviations, such as <q>Mr.</q>
</p>

<p>
	This extension can be enabled/disabled for the following formats:
</p>

<dl>
<dt>input formats</dt>
<dd><c>markdown</c>, <c>commonmark</c>, <c>latex</c>, <c>mediawiki</c>, <c>org</c>, <c>rst</c>, <c>twiki</c></dd>
<dt>output formats</dt>
<dd><c>markdown</c>, <c>latex</c>, <c>context</c>, <c>rst</c></dd>
<dt>enabled by default in</dt>
<dd><c>markdown</c>, <c>latex</c>, <c>context</c> (both input and output)</dd>
</dl>

<p>
	Note: If you are <em>writing</em> Markdown, then the <c>smart</c> extension
has the reverse effect: what would have been curly quotes comes
out straight.
</p>

<p>
	In LaTeX, <c>smart</c> means to use the standard TeX ligatures
for quotation marks (<c>``</c> and <c>&#39;&#39;</c> for double quotes,
<c>`</c> and <c>&#39;</c> for single quotes) and dashes (<c>--</c> for
en-dash and <c>---</c> for em-dash). If <c>smart</c> is disabled,
then in reading LaTeX pandoc will parse these characters
literally. In writing LaTeX, enabling <c>smart</c> tells pandoc
to use the ligatures when possible; if <c>smart</c> is disabled
pandoc will use unicode quotation mark and dash characters.
</p>

<h2 id="headers-and-sections">Headers and sections</h2>

<h4 id="extension-auto_identifiers">Extension: <c>auto_identifiers</c></h4>

<p>
	A header without an explicitly specified identifier will be
automatically assigned a unique identifier based on the header text.
</p>

<p>
	This extension can be enabled/disabled for the following formats:
</p>

<dl>
<dt>input formats</dt>
<dd><c>markdown</c>, <c>latex</c>, <c>rst</c>, <c>mediawiki</c>, <c>textile</c></dd>
<dt>output formats</dt>
<dd><c>markdown</c>, <c>muse</c></dd>
<dt>enabled by default in</dt>
<dd><c>markdown</c>, <c>muse</c></dd>
</dl>

<p>
	The default algorithm used to derive the identifier from the
header text is:
</p>

<ul>
<li>Remove all formatting, links, etc.</li>
<li>Remove all footnotes.</li>
<li>Remove all non-alphanumeric characters,
except underscores, hyphens, and periods.</li>
<li>Replace all spaces and newlines with hyphens.</li>
<li>Convert all alphabetic characters to lowercase.</li>
<li>Remove everything up to the first letter (identifiers may
not begin with a number or punctuation mark).</li>
<li>If nothing is left after this, use the identifier <c>section</c>.</li>
</ul>

<p>
	Thus, for example,
</p>

<table>
<tr class="header">
<th align="left">Header</th>
<th align="left">Identifier</th>
</tr>
<tr class="odd">
<td align="left"><c>Header identifiers in HTML</c></td>
<td align="left"><c>header-identifiers-in-html</c></td>
</tr>
<tr class="even">
<td align="left"><c>Maître d&#39;hôtel</c></td>
<td align="left"><c>maître-dhôtel</c></td>
</tr>
<tr class="odd">
<td align="left"><c>*Dogs*?--in *my* house?</c></td>
<td align="left"><c>dogs--in-my-house</c></td>
</tr>
<tr class="even">
<td align="left"><c>[HTML], [S5], or [RTF]?</c></td>
<td align="left"><c>html-s5-or-rtf</c></td>
</tr>
<tr class="odd">
<td align="left"><c>3. Applications</c></td>
<td align="left"><c>applications</c></td>
</tr>
<tr class="even">
<td align="left"><c>33</c></td>
<td align="left"><c>section</c></td>
</tr>
</table>

<p>
	These rules should, in most cases, allow one to determine the identifier
from the header text. The exception is when several headers have the
same text; in this case, the first will get an identifier as described
above; the second will get the same identifier with <c>-1</c> appended; the
third with <c>-2</c>; and so on.
</p>

<p>
	(However, a different algorithm is used if
<c>gfm_auto_identifiers</c> is enabled; see below.)
</p>

<p>
	These identifiers are used to provide link targets in the table of
contents generated by the <c>--toc|--table-of-contents</c> option. They
also make it easy to provide links from one section of a document to
another. A link to this section, for example, might look like this:
</p>

<pre>See the section on
[header identifiers](#header-identifiers-in-html-latex-and-context).</pre>

<p>
	Note, however, that this method of providing links to sections works
only in HTML, LaTeX, and ConTeXt formats.
</p>

<p>
	If the <c>--section-divs</c> option is specified, then each section will
be wrapped in a <c>section</c> (or a <c>div</c>, if <c>html4</c> was specified),
and the identifier will be attached to the enclosing <c>&lt;section&gt;</c>
(or <c>&lt;div&gt;</c>) tag rather than the header itself. This allows entire
sections to be manipulated using JavaScript or treated differently in
CSS.
</p>

<h4 id="extension-ascii_identifiers">Extension: <c>ascii_identifiers</c></h4>

<p>
	Causes the identifiers produced by <c>auto_identifiers</c> to be pure ASCII.
Accents are stripped off of accented Latin letters, and non-Latin
letters are omitted.
</p>

<h4 id="extension-gfm_auto_identifiers">Extension: <c>gfm_auto_identifiers</c></h4>

<p>
	Changes the algorithm used by <c>auto_identifiers</c> to conform to
GitHub’s method. Spaces are converted to dashes (<c>-</c>),
uppercase characters to lowercase characters, and punctuation
characters other than <c>-</c> and <c>_</c> are removed.
</p>

<h2 id="math-input">Math Input</h2>

<p>
	The extensions <url href='#extension-tex_math_dollars'><c>tex_math_dollars</c></url>,
<url href='#extension-tex_math_single_backslash'><c>tex_math_single_backslash</c></url>, and
<url href='#extension-tex_math_double_backslash'><c>tex_math_double_backslash</c></url>
are described in the section about Pandoc’s Markdown.
</p>

<p>
	However, they can also be used with HTML input. This is handy for
reading web pages formatted using MathJax, for example.
</p>

<h2 id="raw-htmltex">Raw HTML/TeX</h2>

<p>
	The following extensions (especially how they affect Markdown
input/output) are also described in more detail in their respective
sections of <url href='#pandocs-markdown'>Pandoc’s Markdown</url>.
</p>

<h4 id="raw_html">Extension: <c>raw_html</c></h4>

<p>
	When converting from HTML, parse elements to raw HTML which are not
representable in pandoc’s AST.
By default, this is disabled for HTML input.
</p>

<h4 id="raw_tex">Extension: <c>raw_tex</c></h4>

<p>
	Allows raw LaTeX, TeX, and ConTeXt to be included in a document.
</p>

<p>
	This extension can be enabled/disabled for the following formats
(in addition to <c>markdown</c>):
</p>

<dl>
<dt>input formats</dt>
<dd><c>latex</c>, <c>org</c>, <c>textile</c>, <c>html</c> (environments, <c>\ref</c>, and
<c>\eqref</c> only), <c>ipynb</c></dd>
<dt>output formats</dt>
<dd><c>textile</c>, <c>commonmark</c></dd>
</dl>

<p>
	Note: as applied to <c>ipynb</c>, <c>raw_html</c> and <c>raw_tex</c> affect not
only raw TeX in markdown cells, but data with mime type
<c>text/html</c> in output cells. Since the <c>ipynb</c> reader attempts
to preserve the richest possible outputs when several options
are given, you will get best results if you disable <c>raw_html</c>
and <c>raw_tex</c> when converting to formats like <c>docx</c> which don’t
allow raw <c>html</c> or <c>tex</c>.
</p>

<h4 id="native_divs">Extension: <c>native_divs</c></h4>

<p>
	This extension is enabled by default for HTML input. This means that
<c>div</c>s are parsed to pandoc native elements. (Alternatively, you
can parse them to raw HTML using <c>-f html-native_divs+raw_html</c>.)
</p>

<p>
	When converting HTML to Markdown, for example, you may want to drop all
<c>div</c>s and <c>span</c>s:
</p>

<pre>pandoc -f html-native_divs-native_spans -t markdown</pre>

<h4 id="native_spans">Extension: <c>native_spans</c></h4>

<p>
	Analogous to <c>native_divs</c> above.
</p>

<h2 id="literate-haskell-support">Literate Haskell support</h2>

<h4 id="extension-literate_haskell">Extension: <c>literate_haskell</c></h4>

<p>
	Treat the document as literate Haskell source.
</p>

<p>
	This extension can be enabled/disabled for the following formats:
</p>

<dl>
<dt>input formats</dt>
<dd><c>markdown</c>, <c>rst</c>, <c>latex</c></dd>
<dt>output formats</dt>
<dd><c>markdown</c>, <c>rst</c>, <c>latex</c>, <c>html</c></dd>
</dl>

<p>
	If you append <c>+lhs</c> (or <c>+literate_haskell</c>) to one of the formats
above, pandoc will treat the document as literate Haskell source.
This means that
</p>

<ul>
<li><p>
	In Markdown input, <q>bird track</q> sections will be parsed as Haskell
code rather than block quotations. Text between <c>\begin{code}</c>
and <c>\end{code}</c> will also be treated as Haskell code. For
ATX-style headers the character <sq>=</sq> will be used instead of <sq>#</sq>.
</p></li>
<li><p>
	In Markdown output, code blocks with classes <c>haskell</c> and <c>literate</c>
will be rendered using bird tracks, and block quotations will be
indented one space, so they will not be treated as Haskell code.
In addition, headers will be rendered setext-style (with underlines)
rather than ATX-style (with <sq>#</sq> characters). (This is because ghc
treats <sq>#</sq> characters in column 1 as introducing line numbers.)
</p></li>
<li><p>
	In restructured text input, <q>bird track</q> sections will be parsed
as Haskell code.
</p></li>
<li><p>
	In restructured text output, code blocks with class <c>haskell</c> will
be rendered using bird tracks.
</p></li>
<li><p>
	In LaTeX input, text in <c>code</c> environments will be parsed as
Haskell code.
</p></li>
<li><p>
	In LaTeX output, code blocks with class <c>haskell</c> will be rendered
inside <c>code</c> environments.
</p></li>
<li><p>
	In HTML output, code blocks with class <c>haskell</c> will be rendered
with class <c>literatehaskell</c> and bird tracks.
</p></li>
</ul>

<p>
	Examples:
</p>

<pre>pandoc -f markdown+lhs -t html</pre>

<p>
	reads literate Haskell source formatted with Markdown conventions and writes
ordinary HTML (without bird tracks).
</p>

<pre>pandoc -f markdown+lhs -t html+lhs</pre>

<p>
	writes HTML with the Haskell code in bird tracks, so it can be copied
and pasted as literate Haskell source.
</p>

<p>
	Note that GHC expects the bird tracks in the first column, so indented
literate code blocks (e.g. inside an itemized environment) will not be
picked up by the Haskell compiler.
</p>

<h2 id="other-extensions">Other extensions</h2>

<h4 id="extension-empty_paragraphs">Extension: <c>empty_paragraphs</c></h4>

<p>
	Allows empty paragraphs. By default empty paragraphs are
omitted.
</p>

<p>
	This extension can be enabled/disabled for the following formats:
</p>

<dl>
<dt>input formats</dt>
<dd><c>docx</c>, <c>html</c></dd>
<dt>output formats</dt>
<dd><c>docx</c>, <c>odt</c>, <c>opendocument</c>, <c>html</c></dd>
</dl>

<h4 id="ext-styles">Extension: <c>styles</c></h4>

<p>
	When converting from docx, read all docx styles as divs (for
paragraph styles) and spans (for character styles) regardless
of whether pandoc understands the meaning of these styles.
This can be used with <url href='#custom-styles'>docx custom styles</url>.
Disabled by default.
</p>

<dl>
<dt>input formats</dt>
<dd><c>docx</c></dd>
</dl>

<h4 id="extension-amuse">Extension: <c>amuse</c></h4>

<p>
	In the <c>muse</c> input format, this enables Text::Amuse
extensions to Emacs Muse markup.
</p>

<h4 id="org-citations">Extension: <c>citations</c></h4>

<p>
	Some aspects of <url href='#citations'>Pandoc’s Markdown citation syntax</url> are also accepted
in <c>org</c> input.
</p>

<h4 id="extension-ntb">Extension: <c>ntb</c></h4>

<p>
	In the <c>context</c> output format this enables the use of <url href='http://wiki.contextgarden.net/TABLE'>Natural Tables
(TABLE)</url> instead of the default
<url href='http://wiki.contextgarden.net/xtables'>Extreme Tables (xtables)</url>.
Natural tables allow more fine-grained global customization but come
at a performance penalty compared to extreme tables.
</p>

<h1 id="pandocs-markdown">Pandoc’s Markdown</h1>

<p>
	Pandoc understands an extended and slightly revised version of
John Gruber’s <url href='http://daringfireball.net/projects/markdown/'>Markdown</url> syntax. This document explains the syntax,
noting differences from standard Markdown. Except where noted, these
differences can be suppressed by using the <c>markdown_strict</c> format instead
of <c>markdown</c>. Extensions can be enabled or disabled to specify the
behavior more granularly. They are described in the following. See also
<url href='#extensions'>Extensions</url> above, for extensions that work also on other formats.
</p>

<h2 id="philosophy">Philosophy</h2>

<p>
	Markdown is designed to be easy to write, and, even more importantly,
easy to read:
</p>

<blockquote>
<p>
	A Markdown-formatted document should be publishable as-is, as plain
text, without looking like it’s been marked up with tags or formatting
instructions.
– <url href='http://daringfireball.net/projects/markdown/syntax#philosophy'>John Gruber</url>
</p>
</blockquote>

<p>
	This principle has guided pandoc’s decisions in finding syntax for
tables, footnotes, and other extensions.
</p>

<p>
	There is, however, one respect in which pandoc’s aims are different
from the original aims of Markdown. Whereas Markdown was originally
designed with HTML generation in mind, pandoc is designed for multiple
output formats. Thus, while pandoc allows the embedding of raw HTML,
it discourages it, and provides other, non-HTMLish ways of representing
important document elements like definition lists, tables, mathematics, and
footnotes.
</p>

<h2 id="paragraphs">Paragraphs</h2>

<p>
	A paragraph is one or more lines of text followed by one or more blank lines.
Newlines are treated as spaces, so you can reflow your paragraphs as you like.
If you need a hard line break, put two or more spaces at the end of a line.
</p>

<h4 id="extension-escaped_line_breaks">Extension: <c>escaped_line_breaks</c></h4>

<p>
	A backslash followed by a newline is also a hard line break.
Note: in multiline and grid table cells, this is the only way
to create a hard line break, since trailing spaces in the cells
are ignored.
</p>

<h2 id="headers">Headers</h2>

<p>
	There are two kinds of headers: Setext and ATX.
</p>

<h3 id="setext-style-headers">Setext-style headers</h3>

<p>
	A setext-style header is a line of text <q>underlined</q> with a row of <c>=</c> signs
(for a level one header) or <c>-</c> signs (for a level two header):
</p>

<pre>A level-one header
==================

A level-two header
------------------</pre>

<p>
	The header text can contain inline formatting, such as emphasis (see
<url href='#inline-formatting'>Inline formatting</url>, below).
</p>

<h3 id="atx-style-headers">ATX-style headers</h3>

<p>
	An ATX-style header consists of one to six <c>#</c> signs and a line of
text, optionally followed by any number of <c>#</c> signs. The number of
<c>#</c> signs at the beginning of the line is the header level:
</p>

<pre>## A level-two header

### A level-three header ###</pre>

<p>
	As with setext-style headers, the header text can contain formatting:
</p>

<pre># A level-one header with a [link](/url) and *emphasis*</pre>

<h4 id="extension-blank_before_header">Extension: <c>blank_before_header</c></h4>

<p>
	Standard Markdown syntax does not require a blank line before a header.
Pandoc does require this (except, of course, at the beginning of the
document). The reason for the requirement is that it is all too easy for a
<c>#</c> to end up at the beginning of a line by accident (perhaps through line
wrapping). Consider, for example:
</p>

<pre>I like several of their flavors of ice cream:
#22, for example, and #5.</pre>

<h4 id="extension-space_in_atx_header">Extension: <c>space_in_atx_header</c></h4>

<p>
	Many Markdown implementations do not require a space between the
opening <c>#</c>s of an ATX header and the header text, so that
<c>#5 bolt</c> and <c>#hashtag</c> count as headers. With this extension,
pandoc does require the space.
</p>

<h3 id="header-identifiers">Header identifiers</h3>

<p>
	See also the <url href='#extension-auto_identifiers'><c>auto_identifiers</c> extension</url> above.
</p>

<h4 id="extension-header_attributes">Extension: <c>header_attributes</c></h4>

<p>
	Headers can be assigned attributes using this syntax at the end
of the line containing the header text:
</p>

<pre>{#identifier .class .class key=value key=value}</pre>

<p>
	Thus, for example, the following headers will all be assigned the identifier
<c>foo</c>:
</p>

<pre># My header {#foo}

## My header ##    {#foo}

My other header   {#foo}
---------------</pre>

<p>
	(This syntax is compatible with <url href='https://michelf.ca/projects/php-markdown/extra/'>PHP Markdown Extra</url>.)
</p>

<p>
	Note that although this syntax allows assignment of classes and key/value
attributes, writers generally don’t use all of this information. Identifiers,
classes, and key/value attributes are used in HTML and HTML-based formats such
as EPUB and slidy. Identifiers are used for labels and link anchors in the
LaTeX, ConTeXt, Textile, and AsciiDoc writers.
</p>

<p>
	Headers with the class <c>unnumbered</c> will not be numbered, even if
<c>--number-sections</c> is specified. A single hyphen (<c>-</c>) in an attribute
context is equivalent to <c>.unnumbered</c>, and preferable in non-English
documents. So,
</p>

<pre># My header {-}</pre>

<p>
	is just the same as
</p>

<pre># My header {.unnumbered}</pre>

<h4 id="extension-implicit_header_references">Extension: <c>implicit_header_references</c></h4>

<p>
	Pandoc behaves as if reference links have been defined for each header.
So, to link to a header
</p>

<pre># Header identifiers in HTML</pre>

<p>
	you can simply write
</p>

<pre>[Header identifiers in HTML]</pre>

<p>
	or
</p>

<pre>[Header identifiers in HTML][]</pre>

<p>
	or
</p>

<pre>[the section on header identifiers][header identifiers in
HTML]</pre>

<p>
	instead of giving the identifier explicitly:
</p>

<pre>[Header identifiers in HTML](#header-identifiers-in-html)</pre>

<p>
	If there are multiple headers with identical text, the corresponding
reference will link to the first one only, and you will need to use explicit
links to link to the others, as described above.
</p>

<p>
	Like regular reference links, these references are case-insensitive.
</p>

<p>
	Explicit link reference definitions always take priority over
implicit header references. So, in the following example, the
link will point to <c>bar</c>, not to <c>#foo</c>:
</p>

<pre># Foo

[foo]: bar

See [foo]</pre>

<h2 id="block-quotations">Block quotations</h2>

<p>
	Markdown uses email conventions for quoting blocks of text.
A block quotation is one or more paragraphs or other block elements
(such as lists or headers), with each line preceded by a <c>&gt;</c> character
and an optional space. (The <c>&gt;</c> need not start at the left margin, but
it should not be indented more than three spaces.)
</p>

<pre>&gt; This is a block quote. This
&gt; paragraph has two lines.
&gt;
&gt; 1. This is a list inside a block quote.
&gt; 2. Second item.</pre>

<p>
	A <q>lazy</q> form, which requires the <c>&gt;</c> character only on the first
line of each block, is also allowed:
</p>

<pre>&gt; This is a block quote. This
paragraph has two lines.

&gt; 1. This is a list inside a block quote.
2. Second item.</pre>

<p>
	Among the block elements that can be contained in a block quote are
other block quotes. That is, block quotes can be nested:
</p>

<pre>&gt; This is a block quote.
&gt;
&gt; &gt; A block quote within a block quote.</pre>

<p>
	If the <c>&gt;</c> character is followed by an optional space, that space
will be considered part of the block quote marker and not part of
the indentation of the contents. Thus, to put an indented code
block in a block quote, you need five spaces after the <c>&gt;</c>:
</p>

<pre>&gt;     code</pre>

<h4 id="extension-blank_before_blockquote">Extension: <c>blank_before_blockquote</c></h4>

<p>
	Standard Markdown syntax does not require a blank line before a block
quote. Pandoc does require this (except, of course, at the beginning of the
document). The reason for the requirement is that it is all too easy for a
<c>&gt;</c> to end up at the beginning of a line by accident (perhaps through line
wrapping). So, unless the <c>markdown_strict</c> format is used, the following does
not produce a nested block quote in pandoc:
</p>

<pre>&gt; This is a block quote.
&gt;&gt; Nested.</pre>

<h2 id="verbatim-code-blocks">Verbatim (code) blocks</h2>

<h3 id="indented-code-blocks">Indented code blocks</h3>

<p>
	A block of text indented four spaces (or one tab) is treated as verbatim
text: that is, special characters do not trigger special formatting,
and all spaces and line breaks are preserved. For example,
</p>

<pre>    if (a &gt; 3) {
      moveShip(5 * gravity, DOWN);
    }</pre>

<p>
	The initial (four space or one tab) indentation is not considered part
of the verbatim text, and is removed in the output.
</p>

<p>
	Note: blank lines in the verbatim text need not begin with four spaces.
</p>

<h3 id="fenced-code-blocks">Fenced code blocks</h3>

<h4 id="extension-fenced_code_blocks">Extension: <c>fenced_code_blocks</c></h4>

<p>
	In addition to standard indented code blocks, pandoc supports
<em>fenced</em> code blocks. These begin with a row of three or more
tildes (<c>~</c>) and end with a row of tildes that must be at least as long as
the starting row. Everything between these lines is treated as code. No
indentation is necessary:
</p>

<pre>~~~~~~~
if (a &gt; 3) {
  moveShip(5 * gravity, DOWN);
}
~~~~~~~</pre>

<p>
	Like regular code blocks, fenced code blocks must be separated
from surrounding text by blank lines.
</p>

<p>
	If the code itself contains a row of tildes or backticks, just use a longer
row of tildes or backticks at the start and end:
</p>

<pre>~~~~~~~~~~~~~~~~
~~~~~~~~~~
code including tildes
~~~~~~~~~~
~~~~~~~~~~~~~~~~</pre>

<h4 id="extension-backtick_code_blocks">Extension: <c>backtick_code_blocks</c></h4>

<p>
	Same as <c>fenced_code_blocks</c>, but uses backticks (<c>`</c>) instead of tildes
(<c>~</c>).
</p>

<h4 id="extension-fenced_code_attributes">Extension: <c>fenced_code_attributes</c></h4>

<p>
	Optionally, you may attach attributes to fenced or backtick code block using
this syntax:
</p>

<pre>~~~~ {#mycode .haskell .numberLines startFrom=&quot;100&quot;}
qsort []     = []
qsort (x:xs) = qsort (filter (&lt; x) xs) ++ [x] ++
               qsort (filter (&gt;= x) xs)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~</pre>

<p>
	Here <c>mycode</c> is an identifier, <c>haskell</c> and <c>numberLines</c> are classes, and
<c>startFrom</c> is an attribute with value <c>100</c>. Some output formats can use this
information to do syntax highlighting. Currently, the only output formats
that uses this information are HTML, LaTeX, Docx, Ms, and PowerPoint. If
highlighting is supported for your output format and language, then the code
block above will appear highlighted, with numbered lines. (To see which
languages are supported, type <c>pandoc --list-highlight-languages</c>.) Otherwise,
the code block above will appear as follows:
</p>

<pre>&lt;pre id=&quot;mycode&quot; class=&quot;haskell numberLines&quot; startFrom=&quot;100&quot;&gt;
  &lt;code&gt;
  ...
  &lt;/code&gt;
&lt;/pre&gt;</pre>

<p>
	The <c>numberLines</c> (or <c>number-lines</c>) class will cause the lines
of the code block to be numbered, starting with <c>1</c> or the value
of the <c>startFrom</c> attribute. The <c>lineAnchors</c> (or
<c>line-anchors</c>) class will cause the lines to be clickable
anchors in HTML output.
</p>

<p>
	A shortcut form can also be used for specifying the language of
the code block:
</p>

<pre>```haskell
qsort [] = []
```</pre>

<p>
	This is equivalent to:
</p>

<pre>``` {.haskell}
qsort [] = []
```</pre>

<p>
	If the <c>fenced_code_attributes</c> extension is disabled, but
input contains class attribute(s) for the code block, the first
class attribute will be printed after the opening fence as a bare
word.
</p>

<p>
	To prevent all highlighting, use the <c>--no-highlight</c> flag.
To set the highlighting style, use <c>--highlight-style</c>.
For more information on highlighting, see <url href='#syntax-highlighting'>Syntax highlighting</url>,
below.
</p>

<h2 id="line-blocks">Line blocks</h2>

<h4 id="extension-line_blocks">Extension: <c>line_blocks</c></h4>

<p>
	A line block is a sequence of lines beginning with a vertical bar (<c>|</c>)
followed by a space. The division into lines will be preserved in
the output, as will any leading spaces; otherwise, the lines will
be formatted as Markdown. This is useful for verse and addresses:
</p>

<pre>| The limerick packs laughs anatomical
| In space that is quite economical.
|    But the good ones I&#39;ve seen
|    So seldom are clean
| And the clean ones so seldom are comical

| 200 Main St.
| Berkeley, CA 94718</pre>

<p>
	The lines can be hard-wrapped if needed, but the continuation
line must begin with a space.
</p>

<pre>| The Right Honorable Most Venerable and Righteous Samuel L.
  Constable, Jr.
| 200 Main St.
| Berkeley, CA 94718</pre>

<p>
	This syntax is borrowed from <url href='http://docutils.sourceforge.net/docs/ref/rst/introduction.html'>reStructuredText</url>.
</p>

<h2 id="lists">Lists</h2>

<h3 id="bullet-lists">Bullet lists</h3>

<p>
	A bullet list is a list of bulleted list items. A bulleted list
item begins with a bullet (<c>*</c>, <c>+</c>, or <c>-</c>). Here is a simple
example:
</p>

<pre>* one
* two
* three</pre>

<p>
	This will produce a <q>compact</q> list. If you want a <q>loose</q> list, in which
each item is formatted as a paragraph, put spaces between the items:
</p>

<pre>* one

* two

* three</pre>

<p>
	The bullets need not be flush with the left margin; they may be
indented one, two, or three spaces. The bullet must be followed
by whitespace.
</p>

<p>
	List items look best if subsequent lines are flush with the first
line (after the bullet):
</p>

<pre>* here is my first
  list item.
* and my second.</pre>

<p>
	But Markdown also allows a <q>lazy</q> format:
</p>

<pre>* here is my first
list item.
* and my second.</pre>

<h3 id="block-content-in-list-items">Block content in list items</h3>

<p>
	A list item may contain multiple paragraphs and other block-level
content. However, subsequent paragraphs must be preceded by a blank line
and indented to line up with the first non-space content after
the list marker.
</p>

<pre>  * First paragraph.

    Continued.

  * Second paragraph. With a code block, which must be indented
    eight spaces:

        { code }</pre>

<p>
	Exception: if the list marker is followed by an indented code
block, which must begin 5 spaces after the list marker, then
subsequent paragraphs must begin two columns after the last
character of the list marker:
</p>

<pre>*     code

  continuation paragraph</pre>

<p>
	List items may include other lists. In this case the preceding blank
line is optional. The nested list must be indented to line up with
the first non-space character after the list marker of the
containing list item.
</p>

<pre>* fruits
  + apples
    - macintosh
    - red delicious
  + pears
  + peaches
* vegetables
  + broccoli
  + chard</pre>

<p>
	As noted above, Markdown allows you to write list items <q>lazily,</q> instead of
indenting continuation lines. However, if there are multiple paragraphs or
other blocks in a list item, the first line of each must be indented.
</p>

<pre>+ A lazy, lazy, list
item.

+ Another one; this looks
bad but is legal.

    Second paragraph of second
list item.</pre>

<h3 id="ordered-lists">Ordered lists</h3>

<p>
	Ordered lists work just like bulleted lists, except that the items
begin with enumerators rather than bullets.
</p>

<p>
	In standard Markdown, enumerators are decimal numbers followed
by a period and a space. The numbers themselves are ignored, so
there is no difference between this list:
</p>

<pre>1.  one
2.  two
3.  three</pre>

<p>
	and this one:
</p>

<pre>5.  one
7.  two
1.  three</pre>

<h4 id="extension-fancy_lists">Extension: <c>fancy_lists</c></h4>

<p>
	Unlike standard Markdown, pandoc allows ordered list items to be marked
with uppercase and lowercase letters and roman numerals, in addition to
Arabic numerals. List markers may be enclosed in parentheses or followed by a
single right-parentheses or period. They must be separated from the
text that follows by at least one space, and, if the list marker is a
capital letter with a period, by at least two spaces.<a id="fnref1" href="#fn1"><sup>1</sup></a>
</p>

<p>
	The <c>fancy_lists</c> extension also allows <sq><c>#</c></sq> to be used as an
ordered list marker in place of a numeral:
</p>

<pre>#. one
#. two</pre>

<h4 id="extension-startnum">Extension: <c>startnum</c></h4>

<p>
	Pandoc also pays attention to the type of list marker used, and to the
starting number, and both of these are preserved where possible in the
output format. Thus, the following yields a list with numbers followed
by a single parenthesis, starting with 9, and a sublist with lowercase
roman numerals:
</p>

<pre> 9)  Ninth
10)  Tenth
11)  Eleventh
       i. subone
      ii. subtwo
     iii. subthree</pre>

<p>
	Pandoc will start a new list each time a different type of list
marker is used. So, the following will create three lists:
</p>

<pre>(2) Two
(5) Three
1.  Four
*   Five</pre>

<p>
	If default list markers are desired, use <c>#.</c>:
</p>

<pre>#.  one
#.  two
#.  three</pre>

<h4 id="extension-task_lists">Extension: <c>task_lists</c></h4>

<p>
	Pandoc supports task lists, using the syntax of GitHub-Flavored Markdown.
</p>

<pre>- [ ] an unchecked task list item
- [x] checked item</pre>

<h3 id="definition-lists">Definition lists</h3>

<h4 id="extension-definition_lists">Extension: <c>definition_lists</c></h4>

<p>
	Pandoc supports definition lists, using the syntax of
<url href='https://michelf.ca/projects/php-markdown/extra/'>PHP Markdown Extra</url> with some extensions.<a id="fnref2" href="#fn2"><sup>2</sup></a>
</p>

<pre>Term 1

:   Definition 1

Term 2 with *inline markup*

:   Definition 2

        { some code, part of Definition 2 }

    Third paragraph of definition 2.</pre>

<p>
	Each term must fit on one line, which may optionally be followed by
a blank line, and must be followed by one or more definitions.
A definition begins with a colon or tilde, which may be indented one
or two spaces.
</p>

<p>
	A term may have multiple definitions, and each definition may consist of one or
more block elements (paragraph, code block, list, etc.), each indented four
spaces or one tab stop. The body of the definition (including the first line,
aside from the colon or tilde) should be indented four spaces. However,
as with other Markdown lists, you can <q>lazily</q> omit indentation except
at the beginning of a paragraph or other block element:
</p>

<pre>Term 1

:   Definition
with lazy continuation.

    Second paragraph of the definition.</pre>

<p>
	If you leave space before the definition (as in the example above),
the text of the definition will be treated as a paragraph. In some
output formats, this will mean greater spacing between term/definition
pairs. For a more compact definition list, omit the space before the
definition:
</p>

<pre>Term 1
  ~ Definition 1

Term 2
  ~ Definition 2a
  ~ Definition 2b</pre>

<p>
	Note that space between items in a definition list is required.
(A variant that loosens this requirement, but disallows <q>lazy</q>
hard wrapping, can be activated with <c>compact_definition_lists</c>: see
<url href='#non-pandoc-extensions'>Non-pandoc extensions</url>, below.)
</p>

<h3 id="numbered-example-lists">Numbered example lists</h3>

<h4 id="extension-example_lists">Extension: <c>example_lists</c></h4>

<p>
	The special list marker <c>@</c> can be used for sequentially numbered
examples. The first list item with a <c>@</c> marker will be numbered <sq>1</sq>,
the next <sq>2</sq>, and so on, throughout the document. The numbered examples
need not occur in a single list; each new list using <c>@</c> will take up
where the last stopped. So, for example:
</p>

<pre>(@)  My first example will be numbered (1).
(@)  My second example will be numbered (2).

Explanation of examples.

(@)  My third example will be numbered (3).</pre>

<p>
	Numbered examples can be labeled and referred to elsewhere in the
document:
</p>

<pre>(@good)  This is a good example.

As (@good) illustrates, ...</pre>

<p>
	The label can be any string of alphanumeric characters, underscores,
or hyphens.
</p>

<p>
	Note: continuation paragraphs in example lists must always
be indented four spaces, regardless of the length of the
list marker. That is, example lists always behave as if the
<c>four_space_rule</c> extension is set. This is because example
labels tend to be long, and indenting content to the
first non-space character after the label would be awkward.
</p>

<h3 id="compact-and-loose-lists">Compact and loose lists</h3>

<p>
	Pandoc behaves differently from <c>Markdown.pl</c> on some <q>edge
cases</q> involving lists. Consider this source:
</p>

<pre>+   First
+   Second:
    -   Fee
    -   Fie
    -   Foe

+   Third</pre>

<p>
	Pandoc transforms this into a <q>compact list</q> (with no <c>&lt;p&gt;</c> tags around
<q>First</q>, <q>Second</q>, or <q>Third</q>), while Markdown puts <c>&lt;p&gt;</c> tags around
<q>Second</q> and <q>Third</q> (but not <q>First</q>), because of the blank space
around <q>Third</q>. Pandoc follows a simple rule: if the text is followed by
a blank line, it is treated as a paragraph. Since <q>Second</q> is followed
by a list, and not a blank line, it isn’t treated as a paragraph. The
fact that the list is followed by a blank line is irrelevant. (Note:
Pandoc works this way even when the <c>markdown_strict</c> format is specified. This
behavior is consistent with the official Markdown syntax description,
even though it is different from that of <c>Markdown.pl</c>.)
</p>

<h3 id="ending-a-list">Ending a list</h3>

<p>
	What if you want to put an indented code block after a list?
</p>

<pre>-   item one
-   item two

    { my code block }</pre>

<p>
	Trouble! Here pandoc (like other Markdown implementations) will treat
<c>{ my code block }</c> as the second paragraph of item two, and not as
a code block.
</p>

<p>
	To <q>cut off</q> the list after item two, you can insert some non-indented
content, like an HTML comment, which won’t produce visible output in
any format:
</p>

<pre>-   item one
-   item two

&lt;!-- end of list --&gt;

    { my code block }</pre>

<p>
	You can use the same trick if you want two consecutive lists instead
of one big list:
</p>

<pre>1.  one
2.  two
3.  three

&lt;!-- --&gt;

1.  uno
2.  dos
3.  tres</pre>

<h2 id="horizontal-rules">Horizontal rules</h2>

<p>
	A line containing a row of three or more <c>*</c>, <c>-</c>, or <c>_</c> characters
(optionally separated by spaces) produces a horizontal rule:
</p>

<pre>*  *  *  *

---------------</pre>

<h2 id="tables">Tables</h2>

<p>
	Four kinds of tables may be used. The first three kinds presuppose the use of
a fixed-width font, such as Courier. The fourth kind can be used with
proportionally spaced fonts, as it does not require lining up columns.
</p>

<h4 id="extension-table_captions">Extension: <c>table_captions</c></h4>

<p>
	A caption may optionally be provided with all 4 kinds of tables (as
illustrated in the examples below). A caption is a paragraph beginning
with the string <c>Table:</c> (or just <c>:</c>), which will be stripped off.
It may appear either before or after the table.
</p>

<h4 id="extension-simple_tables">Extension: <c>simple_tables</c></h4>

<p>
	Simple tables look like this:
</p>

<pre>  Right     Left     Center     Default
-------     ------ ----------   -------
     12     12        12            12
    123     123       123          123
      1     1          1             1

Table:  Demonstration of simple table syntax.</pre>

<p>
	The headers and table rows must each fit on one line. Column
alignments are determined by the position of the header text relative
to the dashed line below it:<a id="fnref3" href="#fn3"><sup>3</sup></a>
</p>

<ul>
<li>If the dashed line is flush with the header text on the right side
but extends beyond it on the left, the column is right-aligned.</li>
<li>If the dashed line is flush with the header text on the left side
but extends beyond it on the right, the column is left-aligned.</li>
<li>If the dashed line extends beyond the header text on both sides,
the column is centered.</li>
<li>If the dashed line is flush with the header text on both sides,
the default alignment is used (in most cases, this will be left).</li>
</ul>

<p>
	The table must end with a blank line, or a line of dashes followed by
a blank line.
</p>

<p>
	The column headers may be omitted, provided a dashed line is used
to end the table. For example:
</p>

<pre>-------     ------ ----------   -------
     12     12        12             12
    123     123       123           123
      1     1          1              1
-------     ------ ----------   -------</pre>

<p>
	When headers are omitted, column alignments are determined on the basis
of the first line of the table body. So, in the tables above, the columns
would be right, left, center, and right aligned, respectively.
</p>

<h4 id="extension-multiline_tables">Extension: <c>multiline_tables</c></h4>

<p>
	Multiline tables allow headers and table rows to span multiple lines
of text (but cells that span multiple columns or rows of the table are
not supported). Here is an example:
</p>

<pre>-------------------------------------------------------------
 Centered   Default           Right Left
  Header    Aligned         Aligned Aligned
----------- ------- --------------- -------------------------
   First    row                12.0 Example of a row that
                                    spans multiple lines.

  Second    row                 5.0 Here&#39;s another one. Note
                                    the blank line between
                                    rows.
-------------------------------------------------------------

Table: Here&#39;s the caption. It, too, may span
multiple lines.</pre>

<p>
	These work like simple tables, but with the following differences:
</p>

<ul>
<li>They must begin with a row of dashes, before the header text
(unless the headers are omitted).</li>
<li>They must end with a row of dashes, then a blank line.</li>
<li>The rows must be separated by blank lines.</li>
</ul>

<p>
	In multiline tables, the table parser pays attention to the widths of
the columns, and the writers try to reproduce these relative widths in
the output. So, if you find that one of the columns is too narrow in the
output, try widening it in the Markdown source.
</p>

<p>
	Headers may be omitted in multiline tables as well as simple tables:
</p>

<pre>----------- ------- --------------- -------------------------
   First    row                12.0 Example of a row that
                                    spans multiple lines.

  Second    row                 5.0 Here&#39;s another one. Note
                                    the blank line between
                                    rows.
----------- ------- --------------- -------------------------

: Here&#39;s a multiline table without headers.</pre>

<p>
	It is possible for a multiline table to have just one row, but the row
should be followed by a blank line (and then the row of dashes that ends
the table), or the table may be interpreted as a simple table.
</p>

<h4 id="extension-grid_tables">Extension: <c>grid_tables</c></h4>

<p>
	Grid tables look like this:
</p>

<pre>: Sample grid table.

+---------------+---------------+--------------------+
| Fruit         | Price         | Advantages         |
+===============+===============+====================+
| Bananas       | $1.34         | - built-in wrapper |
|               |               | - bright color     |
+---------------+---------------+--------------------+
| Oranges       | $2.10         | - cures scurvy     |
|               |               | - tasty            |
+---------------+---------------+--------------------+</pre>

<p>
	The row of <c>=</c>s separates the header from the table body, and can be
omitted for a headerless table. The cells of grid tables may contain
arbitrary block elements (multiple paragraphs, code blocks, lists,
etc.). Cells that span multiple columns or rows are not
supported. Grid tables can be created easily using <url href='http://table.sourceforge.net/'>Emacs table mode</url>.
</p>

<p>
	Alignments can be specified as with pipe tables, by putting
colons at the boundaries of the separator line after the
header:
</p>

<pre>+---------------+---------------+--------------------+
| Right         | Left          | Centered           |
+==============:+:==============+:==================:+
| Bananas       | $1.34         | built-in wrapper   |
+---------------+---------------+--------------------+</pre>

<p>
	For headerless tables, the colons go on the top line instead:
</p>

<pre>+--------------:+:--------------+:------------------:+
| Right         | Left          | Centered           |
+---------------+---------------+--------------------+</pre>

<h5 id="grid-table-limitations">Grid Table Limitations</h5>

<p>
	Pandoc does not support grid tables with row spans or column spans.
This means that neither variable numbers of columns across rows nor
variable numbers of rows across columns are supported by Pandoc.
All grid tables must have the same number of columns in each row,
and the same number of rows in each column. For example, the
Docutils <url href='http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#grid-tables'>sample grid tables</url> will not render as expected with
Pandoc.
</p>

<h4 id="extension-pipe_tables">Extension: <c>pipe_tables</c></h4>

<p>
	Pipe tables look like this:
</p>

<pre>| Right | Left | Default | Center |
|------:|:-----|---------|:------:|
|   12  |  12  |    12   |    12  |
|  123  |  123 |   123   |   123  |
|    1  |    1 |     1   |     1  |

  : Demonstration of pipe table syntax.</pre>

<p>
	The syntax is identical to <url href='https://michelf.ca/projects/php-markdown/extra/#table'>PHP Markdown Extra tables</url>. The beginning and
ending pipe characters are optional, but pipes are required between all
columns. The colons indicate column alignment as shown. The header
cannot be omitted. To simulate a headerless table, include a header
with blank cells.
</p>

<p>
	Since the pipes indicate column boundaries, columns need not be vertically
aligned, as they are in the above example. So, this is a perfectly
legal (though ugly) pipe table:
</p>

<pre>fruit| price
-----|-----:
apple|2.05
pear|1.37
orange|3.09</pre>

<p>
	The cells of pipe tables cannot contain block elements like paragraphs
and lists, and cannot span multiple lines. If a pipe table contains a
row whose printable content is wider than the column width (see
<c>--columns</c>), then the table will take up the full text width and
the cell contents will wrap, with the relative cell widths determined
by the number of dashes in the line separating the table header from
the table body. (For example <c>---|-</c> would make the first column 3/4
and the second column 1/4 of the full text width.)
On the other hand, if no lines are wider than column width, then
cell contents will not be wrapped, and the cells will be sized
to their contents.
</p>

<p>
	Note: pandoc also recognizes pipe tables of the following
form, as can be produced by Emacs’ orgtbl-mode:
</p>

<pre>| One | Two   |
|-----+-------|
| my  | table |
| is  | nice  |</pre>

<p>
	The difference is that <c>+</c> is used instead of <c>|</c>. Other orgtbl features
are not supported. In particular, to get non-default column alignment,
you’ll need to add colons as above.
</p>

<h2 id="metadata-blocks">Metadata blocks</h2>

<h4 id="extension-pandoc_title_block">Extension: <c>pandoc_title_block</c></h4>

<p>
	If the file begins with a title block
</p>

<pre>% title
% author(s) (separated by semicolons)
% date</pre>

<p>
	it will be parsed as bibliographic information, not regular text. (It
will be used, for example, in the title of standalone LaTeX or HTML
output.) The block may contain just a title, a title and an author,
or all three elements. If you want to include an author but no
title, or a title and a date but no author, you need a blank line:
</p>

<pre>%
% Author

% My title
%
% June 15, 2006</pre>

<p>
	The title may occupy multiple lines, but continuation lines must
begin with leading space, thus:
</p>

<pre>% My title
  on multiple lines</pre>

<p>
	If a document has multiple authors, the authors may be put on
separate lines with leading space, or separated by semicolons, or
both. So, all of the following are equivalent:
</p>

<pre>% Author One
  Author Two

% Author One; Author Two

% Author One;
  Author Two</pre>

<p>
	The date must fit on one line.
</p>

<p>
	All three metadata fields may contain standard inline formatting
(italics, links, footnotes, etc.).
</p>

<p>
	Title blocks will always be parsed, but they will affect the output only
when the <c>--standalone</c> (<c>-s</c>) option is chosen. In HTML output, titles
will appear twice: once in the document head – this is the title that
will appear at the top of the window in a browser – and once at the
beginning of the document body. The title in the document head can have
an optional prefix attached (<c>--title-prefix</c> or <c>-T</c> option). The title
in the body appears as an H1 element with class <q>title</q>, so it can be
suppressed or reformatted with CSS. If a title prefix is specified with
<c>-T</c> and no title block appears in the document, the title prefix will
be used by itself as the HTML title.
</p>

<p>
	The man page writer extracts a title, man page section number, and
other header and footer information from the title line. The title
is assumed to be the first word on the title line, which may optionally
end with a (single-digit) section number in parentheses. (There should
be no space between the title and the parentheses.) Anything after
this is assumed to be additional footer and header text. A single pipe
character (<c>|</c>) should be used to separate the footer text from the header
text. Thus,
</p>

<pre>% PANDOC(1)</pre>

<p>
	will yield a man page with the title <c>PANDOC</c> and section 1.
</p>

<pre>% PANDOC(1) Pandoc User Manuals</pre>

<p>
	will also have <q>Pandoc User Manuals</q> in the footer.
</p>

<pre>% PANDOC(1) Pandoc User Manuals | Version 4.0</pre>

<p>
	will also have <q>Version 4.0</q> in the header.
</p>

<h4 id="extension-yaml_metadata_block">Extension: <c>yaml_metadata_block</c></h4>

<p>
	A YAML metadata block is a valid YAML object, delimited by a line of three
hyphens (<c>---</c>) at the top and a line of three hyphens (<c>---</c>) or three dots
(<c>...</c>) at the bottom. A YAML metadata block may occur anywhere in the
document, but if it is not at the beginning, it must be preceded by a blank
line. (Note that, because of the way pandoc concatenates input files when
several are provided, you may also keep the metadata in a separate YAML file
and pass it to pandoc as an argument, along with your Markdown files:
</p>

<pre>pandoc chap1.md chap2.md chap3.md metadata.yaml -s -o book.html</pre>

<p>
	Just be sure that the YAML file begins with <c>---</c> and ends with <c>---</c> or
<c>...</c>.) Alternatively, you can use the <c>--metadata-file</c> option. Using
that approach however, you cannot reference content (like footnotes)
from the main markdown input document.
</p>

<p>
	Metadata will be taken from the fields of the YAML object and added to any
existing document metadata. Metadata can contain lists and objects (nested
arbitrarily), but all string scalars will be interpreted as Markdown. Fields
with names ending in an underscore will be ignored by pandoc. (They may be
given a role by external processors.) Field names must not be
interpretable as YAML numbers or boolean values (so, for
example, <c>yes</c>, <c>True</c>, and <c>15</c> cannot be used as field names).
</p>

<p>
	A document may contain multiple metadata blocks. The metadata fields will
be combined through a <em>left-biased union</em>: if two metadata blocks attempt
to set the same field, the value from the first block will be taken.
</p>

<p>
	When pandoc is used with <c>-t markdown</c> to create a Markdown document,
a YAML metadata block will be produced only if the <c>-s/--standalone</c>
option is used. All of the metadata will appear in a single block
at the beginning of the document.
</p>

<p>
	Note that YAML escaping rules must be followed. Thus, for example,
if a title contains a colon, it must be quoted. The pipe character
(<c>|</c>) can be used to begin an indented block that will be interpreted
literally, without need for escaping. This form is necessary
when the field contains blank lines or block-level formatting:
</p>

<pre>---
title:  &#39;This is the title: it contains a colon&#39;
author:
- Author One
- Author Two
keywords: [nothing, nothingness]
abstract: |
  This is the abstract.

  It consists of two paragraphs.
...</pre>

<p>
	Template variables will be set automatically from the metadata. Thus, for
example, in writing HTML, the variable <c>abstract</c> will be set to the HTML
equivalent of the Markdown in the <c>abstract</c> field:
</p>

<pre>&lt;p&gt;This is the abstract.&lt;/p&gt;
&lt;p&gt;It consists of two paragraphs.&lt;/p&gt;</pre>

<p>
	Variables can contain arbitrary YAML structures, but the template must match
this structure. The <c>author</c> variable in the default templates expects a
simple list or string, but can be changed to support more complicated
structures. The following combination, for example, would add an affiliation
to the author if one is given:
</p>

<pre>---
title: The document title
author:
- name: Author One
  affiliation: University of Somewhere
- name: Author Two
  affiliation: University of Nowhere
...</pre>

<p>
	To use the structured authors in the example above, you would need a custom
template:
</p>

<pre>$for(author)$
$if(author.name)$
$author.name$$if(author.affiliation)$ ($author.affiliation$)$endif$
$else$
$author$
$endif$
$endfor$</pre>

<p>
	Raw content to include in the document’s header may be specified
using <c>header-includes</c>; however, it is important to mark up
this content as raw code for a particular output format, using
the <url href='#extension-raw_attribute'><c>raw_attribute</c> extension</url>), or it
will be interpreted as markdown. For example:
</p>

<pre>header-includes:
- |
  ```{=latex}
  \let\oldsection\section
  \renewcommand{\section}[1]{\clearpage\oldsection{#1}}
  ```</pre>

<h2 id="backslash-escapes">Backslash escapes</h2>

<h4 id="extension-all_symbols_escapable">Extension: <c>all_symbols_escapable</c></h4>

<p>
	Except inside a code block or inline code, any punctuation or space
character preceded by a backslash will be treated literally, even if it
would normally indicate formatting. Thus, for example, if one writes
</p>

<pre>*\*hello\**</pre>

<p>
	one will get
</p>

<pre>&lt;em&gt;*hello*&lt;/em&gt;</pre>

<p>
	instead of
</p>

<pre>&lt;strong&gt;hello&lt;/strong&gt;</pre>

<p>
	This rule is easier to remember than standard Markdown’s rule,
which allows only the following characters to be backslash-escaped:
</p>

<pre>\`*_{}[]()&gt;#+-.!</pre>

<p>
	(However, if the <c>markdown_strict</c> format is used, the standard Markdown rule
will be used.)
</p>

<p>
	A backslash-escaped space is parsed as a nonbreaking space. It will
appear in TeX output as <c>~</c> and in HTML and XML as <c>\&amp;#160;</c> or
<c>\&amp;nbsp;</c>.
</p>

<p>
	A backslash-escaped newline (i.e. a backslash occurring at the end of
a line) is parsed as a hard line break. It will appear in TeX output as
<c>\\</c> and in HTML as <c>&lt;br /&gt;</c>. This is a nice alternative to
Markdown’s <q>invisible</q> way of indicating hard line breaks using
two trailing spaces on a line.
</p>

<p>
	Backslash escapes do not work in verbatim contexts.
</p>

<h2 id="inline-formatting">Inline formatting</h2>

<h3 id="emphasis">Emphasis</h3>

<p>
	To <em>emphasize</em> some text, surround it with <c>*</c>s or <c>_</c>, like this:
</p>

<pre>This text is _emphasized with underscores_, and this
is *emphasized with asterisks*.</pre>

<p>
	Double <c>*</c> or <c>_</c> produces <alert>strong emphasis</alert>:
</p>

<pre>This is **strong emphasis** and __with underscores__.</pre>

<p>
	A <c>*</c> or <c>_</c> character surrounded by spaces, or backslash-escaped,
will not trigger emphasis:
</p>

<pre>This is * not emphasized *, and \*neither is this\*.</pre>

<h4 id="extension-intraword_underscores">Extension: <c>intraword_underscores</c></h4>

<p>
	Because <c>_</c> is sometimes used inside words and identifiers,
pandoc does not interpret a <c>_</c> surrounded by alphanumeric
characters as an emphasis marker. If you want to emphasize
just part of a word, use <c>*</c>:
</p>

<pre>feas*ible*, not feas*able*.</pre>

<h3 id="strikeout">Strikeout</h3>

<h4 id="extension-strikeout">Extension: <c>strikeout</c></h4>

<p>
	To strikeout a section of text with a horizontal line, begin and end it
with <c>~~</c>. Thus, for example,
</p>

<pre>This ~~is deleted text.~~</pre>

<h3 id="superscripts-and-subscripts">Superscripts and subscripts</h3>

<h4 id="extension-superscript-subscript">Extension: <c>superscript</c>, <c>subscript</c></h4>

<p>
	Superscripts may be written by surrounding the superscripted text by <c>^</c>
characters; subscripts may be written by surrounding the subscripted
text by <c>~</c> characters. Thus, for example,
</p>

<pre>H~2~O is a liquid.  2^10^ is 1024.</pre>

<p>
	If the superscripted or subscripted text contains spaces, these spaces
must be escaped with backslashes. (This is to prevent accidental
superscripting and subscripting through the ordinary use of <c>~</c> and <c>^</c>.)
Thus, if you want the letter P with <sq>a cat</sq> in subscripts, use
<c>P~a\ cat~</c>, not <c>P~a cat~</c>.
</p>

<h3 id="verbatim">Verbatim</h3>

<p>
	To make a short span of text verbatim, put it inside backticks:
</p>

<pre>What is the difference between `&gt;&gt;=` and `&gt;&gt;`?</pre>

<p>
	If the verbatim text includes a backtick, use double backticks:
</p>

<pre>Here is a literal backtick `` ` ``.</pre>

<p>
	(The spaces after the opening backticks and before the closing
backticks will be ignored.)
</p>

<p>
	The general rule is that a verbatim span starts with a string
of consecutive backticks (optionally followed by a space)
and ends with a string of the same number of backticks (optionally
preceded by a space).
</p>

<p>
	Note that backslash-escapes (and other Markdown constructs) do not
work in verbatim contexts:
</p>

<pre>This is a backslash followed by an asterisk: `\*`.</pre>

<h4 id="extension-inline_code_attributes">Extension: <c>inline_code_attributes</c></h4>

<p>
	Attributes can be attached to verbatim text, just as with
<url href='#fenced-code-blocks'>fenced code blocks</url>:
</p>

<pre>`&lt;$&gt;`{.haskell}</pre>

<h3 id="small-caps">Small caps</h3>

<p>
	To write small caps, use the <c>smallcaps</c> class:
</p>

<pre>[Small caps]{.smallcaps}</pre>

<p>
	Or, without the <c>bracketed_spans</c> extension:
</p>

<pre>&lt;span class=&quot;smallcaps&quot;&gt;Small caps&lt;/span&gt;</pre>

<p>
	For compatibility with other Markdown flavors, CSS is also supported:
</p>

<pre>&lt;span style=&quot;font-variant:small-caps;&quot;&gt;Small caps&lt;/span&gt;</pre>

<p>
	This will work in all output formats that support small caps.
</p>

<h2 id="math">Math</h2>

<h4 id="extension-tex_math_dollars">Extension: <c>tex_math_dollars</c></h4>

<p>
	Anything between two <c>$</c> characters will be treated as TeX math. The
opening <c>$</c> must have a non-space character immediately to its right,
while the closing <c>$</c> must have a non-space character immediately to its
left, and must not be followed immediately by a digit. Thus,
<c>$20,000 and $30,000</c> won’t parse as math. If for some reason
you need to enclose text in literal <c>$</c> characters, backslash-escape
them and they won’t be treated as math delimiters.
</p>

<p>
	TeX math will be printed in all output formats. How it is rendered
depends on the output format:
</p>

<dl>
<dt>LaTeX</dt>
<dd>It will appear verbatim surrounded by <c>\(...\)</c> (for inline
math) or <c>\[...\]</c> (for display math).</dd>
<dt>Markdown, Emacs Org mode, ConTeXt, ZimWiki</dt>
<dd>It will appear verbatim surrounded by <c>$...$</c> (for inline
math) or <c>$$...$$</c> (for display math).</dd>
<dt>reStructuredText</dt>
<dd>It will be rendered using an <url href='http://docutils.sourceforge.net/docs/ref/rst/roles.html#math'>interpreted text role <c>:math:</c></url>.</dd>
<dt>AsciiDoc</dt>
<dd>For AsciiDoc output format (<c>-t asciidoc</c>) it will appear verbatim
surrounded by <c>latexmath:[$...$]</c> (for inline math) or
<c>[latexmath]++++\[...\]+++</c> (for display math).
For AsciiDoctor output format (<c>-t asciidoctor</c>) the LaTex delimiters
(<c>$..$</c> and <c>\[..\]</c>) are omitted.</dd>
<dt>Texinfo</dt>
<dd>It will be rendered inside a <c>@math</c> command.</dd>
<dt>roff man</dt>
<dd>It will be rendered verbatim without <c>$</c>’s.</dd>
<dt>MediaWiki, DokuWiki</dt>
<dd>It will be rendered inside <c>&lt;math&gt;</c> tags.</dd>
<dt>Textile</dt>
<dd>It will be rendered inside <c>&lt;span class=&quot;math&quot;&gt;</c> tags.</dd>
<dt>RTF, OpenDocument</dt>
<dd>It will be rendered, if possible, using Unicode characters,
and will otherwise appear verbatim.</dd>
<dt>ODT</dt>
<dd>It will be rendered, if possible, using MathML.</dd>
<dt>DocBook</dt>
<dd>If the <c>--mathml</c> flag is used, it will be rendered using MathML
in an <c>inlineequation</c> or <c>informalequation</c> tag. Otherwise it
will be rendered, if possible, using Unicode characters.</dd>
<dt>Docx</dt>
<dd>It will be rendered using OMML math markup.</dd>
<dt>FictionBook2</dt>
<dd>If the <c>--webtex</c> option is used, formulas are rendered as images
using CodeCogs or other compatible web service, downloaded
and embedded in the e-book. Otherwise, they will appear verbatim.</dd>
<dt>HTML, Slidy, DZSlides, S5, EPUB</dt>
<dd>The way math is rendered in HTML will depend on the
command-line options selected. Therefore see <url href='#math-rendering-in-html'>Math rendering in HTML</url>
above.</dd>
</dl>

<h2 id="raw-html">Raw HTML</h2>

<h4 id="extension-raw_html">Extension: <c>raw_html</c></h4>

<p>
	Markdown allows you to insert raw HTML (or DocBook) anywhere in a document
(except verbatim contexts, where <c>&lt;</c>, <c>&gt;</c>, and <c>&amp;</c> are interpreted
literally). (Technically this is not an extension, since standard
Markdown allows it, but it has been made an extension so that it can
be disabled if desired.)
</p>

<p>
	The raw HTML is passed through unchanged in HTML, S5, Slidy, Slideous,
DZSlides, EPUB, Markdown, CommonMark, Emacs Org mode, and Textile
output, and suppressed in other formats.
</p>

<p>
	For a more explicit way of including raw HTML in a Markdown
document, see the <url href='#extension-raw_attribute'><c>raw_attribute</c> extension</url>.
</p>

<p>
	In the CommonMark format, if <c>raw_html</c> is enabled, superscripts,
subscripts, strikeouts and small capitals will be represented as HTML.
Otherwise, plain-text fallbacks will be used. Note that even if
<c>raw_html</c> is disabled, tables will be rendered with HTML syntax if
they cannot use pipe syntax.
</p>

<h4 id="extension-markdown_in_html_blocks">Extension: <c>markdown_in_html_blocks</c></h4>

<p>
	Standard Markdown allows you to include HTML <q>blocks</q>: blocks
of HTML between balanced tags that are separated from the surrounding text
with blank lines, and start and end at the left margin. Within
these blocks, everything is interpreted as HTML, not Markdown;
so (for example), <c>*</c> does not signify emphasis.
</p>

<p>
	Pandoc behaves this way when the <c>markdown_strict</c> format is used; but
by default, pandoc interprets material between HTML block tags as Markdown.
Thus, for example, pandoc will turn
</p>

<pre>&lt;table&gt;
&lt;tr&gt;
&lt;td&gt;*one*&lt;/td&gt;
&lt;td&gt;[a link](http://google.com)&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;</pre>

<p>
	into
</p>

<pre>&lt;table&gt;
&lt;tr&gt;
&lt;td&gt;&lt;em&gt;one&lt;/em&gt;&lt;/td&gt;
&lt;td&gt;&lt;a href=&quot;http://google.com&quot;&gt;a link&lt;/a&gt;&lt;/td&gt;
&lt;/tr&gt;
&lt;/table&gt;</pre>

<p>
	whereas <c>Markdown.pl</c> will preserve it as is.
</p>

<p>
	There is one exception to this rule: text between <c>&lt;script&gt;</c> and
<c>&lt;style&gt;</c> tags is not interpreted as Markdown.
</p>

<p>
	This departure from standard Markdown should make it easier to mix
Markdown with HTML block elements. For example, one can surround
a block of Markdown text with <c>&lt;div&gt;</c> tags without preventing it
from being interpreted as Markdown.
</p>

<h4 id="extension-native_divs">Extension: <c>native_divs</c></h4>

<p>
	Use native pandoc <c>Div</c> blocks for content inside <c>&lt;div&gt;</c> tags.
For the most part this should give the same output as
<c>markdown_in_html_blocks</c>, but it makes it easier to write pandoc
filters to manipulate groups of blocks.
</p>

<h4 id="extension-native_spans">Extension: <c>native_spans</c></h4>

<p>
	Use native pandoc <c>Span</c> blocks for content inside <c>&lt;span&gt;</c> tags.
For the most part this should give the same output as <c>raw_html</c>,
but it makes it easier to write pandoc filters to manipulate groups
of inlines.
</p>

<h4 id="extension-raw_tex">Extension: <c>raw_tex</c></h4>

<p>
	In addition to raw HTML, pandoc allows raw LaTeX, TeX, and ConTeXt to be
included in a document. Inline TeX commands will be preserved and passed
unchanged to the LaTeX and ConTeXt writers. Thus, for example, you can use
LaTeX to include BibTeX citations:
</p>

<pre>This result was proved in \cite{jones.1967}.</pre>

<p>
	Note that in LaTeX environments, like
</p>

<pre>\begin{tabular}{|l|l|}\hline
Age &amp; Frequency \\ \hline
18--25  &amp; 15 \\
26--35  &amp; 33 \\
36--45  &amp; 22 \\ \hline
\end{tabular}</pre>

<p>
	the material between the begin and end tags will be interpreted as raw
LaTeX, not as Markdown.
</p>

<p>
	For a more explicit and flexible way of including raw TeX in a
Markdown document, see the <url href='#extension-raw_attribute'><c>raw_attribute</c>
extension</url>.
</p>

<p>
	Inline LaTeX is ignored in output formats other than Markdown, LaTeX,
Emacs Org mode, and ConTeXt.
</p>

<h3 id="generic-raw-attribute">Generic raw attribute</h3>

<h4 id="extension-raw_attribute">Extension: <c>raw_attribute</c></h4>

<p>
	Inline spans and fenced code blocks with a special
kind of attribute will be parsed as raw content with the
designated format. For example, the following produces a raw
roff <c>ms</c> block:
</p>

<pre>```{=ms}
.MYMACRO
blah blah
```</pre>

<p>
	And the following produces a raw <c>html</c> inline element:
</p>

<pre>This is `&lt;a&gt;html&lt;/a&gt;`{=html}</pre>

<p>
	This can be useful to insert raw xml into <c>docx</c> documents, e.g.
a pagebreak:
</p>

<pre>```{=openxml}
&lt;w:p&gt;
  &lt;w:r&gt;
    &lt;w:br w:type=&quot;page&quot;/&gt;
  &lt;/w:r&gt;
&lt;/w:p&gt;
```</pre>

<p>
	The format name should match the target format name (see
<c>-t/--to</c>, above, for a list, or use <c>pandoc --list-output-formats</c>). Use <c>openxml</c> for <c>docx</c> output,
<c>opendocument</c> for <c>odt</c> output, <c>html5</c> for <c>epub3</c> output,
<c>html4</c> for <c>epub2</c> output, and <c>latex</c>, <c>beamer</c>,
<c>ms</c>, or <c>html5</c> for <c>pdf</c> output (depending on what you
use for <c>--pdf-engine</c>).
</p>

<p>
	This extension presupposes that the relevant kind of
inline code or fenced code block is enabled. Thus, for
example, to use a raw attribute with a backtick code block,
<c>backtick_code_blocks</c> must be enabled.
</p>

<p>
	The raw attribute cannot be combined with regular attributes.
</p>

<h2 id="latex-macros">LaTeX macros</h2>

<h4 id="extension-latex_macros">Extension: <c>latex_macros</c></h4>

<p>
	When this extension is enabled, pandoc will parse LaTeX
macro definitions and apply the resulting macros to all LaTeX
math and raw LaTeX. So, for example, the following will work in
all output formats, not just LaTeX:
</p>

<pre>\newcommand{\tuple}[1]{\langle #1 \rangle}

$\tuple{a, b, c}$</pre>

<p>
	Note that LaTeX macros will not be applied if they occur
inside inside a raw span or block marked with the
<url href='#extension-raw_attribute'><c>raw_attribute</c> extension</url>.
</p>

<p>
	When <c>latex_macros</c> is disabled, the raw LaTeX and math will
not have macros applied. This is usually a better approach when
you are targeting LaTeX or PDF.
</p>

<p>
	Whether or not <c>latex_macros</c> is enabled, the macro definitions
will still be passed through as raw LaTeX.
</p>

<h2 id="links-1">Links</h2>

<p>
	Markdown allows links to be specified in several ways.
</p>

<h3 id="automatic-links">Automatic links</h3>

<p>
	If you enclose a URL or email address in pointy brackets, it
will become a link:
</p>

<pre>&lt;http://google.com&gt;
&lt;sam@green.eggs.ham&gt;</pre>

<h3 id="inline-links">Inline links</h3>

<p>
	An inline link consists of the link text in square brackets,
followed by the URL in parentheses. (Optionally, the URL can
be followed by a link title, in quotes.)
</p>

<pre>This is an [inline link](/url), and here&#39;s [one with
a title](http://fsf.org &quot;click here for a good time!&quot;).</pre>

<p>
	There can be no space between the bracketed part and the parenthesized part.
The link text can contain formatting (such as emphasis), but the title cannot.
</p>

<p>
	Email addresses in inline links are not autodetected, so they have to be
prefixed with <c>mailto</c>:
</p>

<pre>[Write me!](mailto:sam@green.eggs.ham)</pre>

<h3 id="reference-links">Reference links</h3>

<p>
	An <em>explicit</em> reference link has two parts, the link itself and the link
definition, which may occur elsewhere in the document (either
before or after the link).
</p>

<p>
	The link consists of link text in square brackets, followed by a label in
square brackets. (There cannot be space between the two unless the
<c>spaced_reference_links</c> extension is enabled.) The link definition
consists of the bracketed label, followed by a colon and a space, followed by
the URL, and optionally (after a space) a link title either in quotes or in
parentheses. The label must not be parseable as a citation (assuming
the <c>citations</c> extension is enabled): citations take precedence over
link labels.
</p>

<p>
	Here are some examples:
</p>

<pre>[my label 1]: /foo/bar.html  &quot;My title, optional&quot;
[my label 2]: /foo
[my label 3]: http://fsf.org (The free software foundation)
[my label 4]: /bar#special  &#39;A title in single quotes&#39;</pre>

<p>
	The URL may optionally be surrounded by angle brackets:
</p>

<pre>[my label 5]: &lt;http://foo.bar.baz&gt;</pre>

<p>
	The title may go on the next line:
</p>

<pre>[my label 3]: http://fsf.org
  &quot;The free software foundation&quot;</pre>

<p>
	Note that link labels are not case sensitive. So, this will work:
</p>

<pre>Here is [my link][FOO]

[Foo]: /bar/baz</pre>

<p>
	In an <em>implicit</em> reference link, the second pair of brackets is
empty:
</p>

<pre>See [my website][].

[my website]: http://foo.bar.baz</pre>

<p>
	Note: In <c>Markdown.pl</c> and most other Markdown implementations,
reference link definitions cannot occur in nested constructions
such as list items or block quotes. Pandoc lifts this arbitrary
seeming restriction. So the following is fine in pandoc, though
not in most other implementations:
</p>

<pre>&gt; My block [quote].
&gt;
&gt; [quote]: /foo</pre>

<h4 id="extension-shortcut_reference_links">Extension: <c>shortcut_reference_links</c></h4>

<p>
	In a <em>shortcut</em> reference link, the second pair of brackets may
be omitted entirely:
</p>

<pre>See [my website].

[my website]: http://foo.bar.baz</pre>

<h3 id="internal-links">Internal links</h3>

<p>
	To link to another section of the same document, use the automatically
generated identifier (see <url href='#header-identifiers'>Header identifiers</url>). For example:
</p>

<pre>See the [Introduction](#introduction).</pre>

<p>
	or
</p>

<pre>See the [Introduction].

[Introduction]: #introduction</pre>

<p>
	Internal links are currently supported for HTML formats (including
HTML slide shows and EPUB), LaTeX, and ConTeXt.
</p>

<h2 id="images">Images</h2>

<p>
	A link immediately preceded by a <c>!</c> will be treated as an image.
The link text will be used as the image’s alt text:
</p>

<pre>![la lune](lalune.jpg &quot;Voyage to the moon&quot;)

![movie reel]

[movie reel]: movie.gif</pre>

<h4 id="extension-implicit_figures">Extension: <c>implicit_figures</c></h4>

<p>
	An image with nonempty alt text, occurring by itself in a
paragraph, will be rendered as a figure with a caption. The
image’s alt text will be used as the caption.
</p>

<pre>![This is the caption](/url/of/image.png)</pre>

<p>
	How this is rendered depends on the output format. Some output
formats (e.g. RTF) do not yet support figures. In those
formats, you’ll just get an image in a paragraph by itself, with
no caption.
</p>

<p>
	If you just want a regular inline image, just make sure it is not
the only thing in the paragraph. One way to do this is to insert a
nonbreaking space after the image:
</p>

<pre>![This image won&#39;t be a figure](/url/of/image.png)\</pre>

<p>
	Note that in reveal.js slide shows, an image in a paragraph
by itself that has the <c>stretch</c> class will fill the screen,
and the caption and figure tags will be omitted.
</p>

<h4 id="extension-link_attributes">Extension: <c>link_attributes</c></h4>

<p>
	Attributes can be set on links and images:
</p>

<pre>An inline ![image](foo.jpg){#id .class width=30 height=20px}
and a reference ![image][ref] with attributes.

[ref]: foo.jpg &quot;optional title&quot; {#id .class key=val key2=&quot;val 2&quot;}</pre>

<p>
	(This syntax is compatible with <url href='https://michelf.ca/projects/php-markdown/extra/'>PHP Markdown Extra</url> when only <c>#id</c>
and <c>.class</c> are used.)
</p>

<p>
	For HTML and EPUB, all attributes except <c>width</c> and <c>height</c> (but
including <c>srcset</c> and <c>sizes</c>) are passed through as is. The other
writers ignore attributes that are not supported by their output
format.
</p>

<p>
	The <c>width</c> and <c>height</c> attributes on images are treated specially. When
used without a unit, the unit is assumed to be pixels. However, any of
the following unit identifiers can be used: <c>px</c>, <c>cm</c>, <c>mm</c>, <c>in</c>, <c>inch</c>
and <c>%</c>. There must not be any spaces between the number and the unit.
For example:
</p>

<pre>![](file.jpg){ width=50% }</pre>

<ul>
<li>Dimensions are converted to inches for output in page-based formats like
LaTeX. Dimensions are converted to pixels for output in HTML-like
formats. Use the <c>--dpi</c> option to specify the number of pixels per
inch. The default is 96dpi.</li>
<li>The <c>%</c> unit is generally relative to some available space.
For example the above example will render to the following.

<ul>
<li>HTML: <c>&lt;img href=&quot;file.jpg&quot; style=&quot;width: 50%;&quot; /&gt;</c></li>
<li>LaTeX: <c>\includegraphics[width=0.5\textwidth,height=\textheight]{file.jpg}</c>
(If you’re using a custom template, you need to configure <c>graphicx</c>
as in the default template.)</li>
<li>ConTeXt: <c>\externalfigure[file.jpg][width=0.5\textwidth]</c></li>
</ul></li>
<li>Some output formats have a notion of a class
(<url href='http://wiki.contextgarden.net/Using_Graphics#Multiple_Image_Settings'>ConTeXt</url>)
or a unique identifier (LaTeX <c>\caption</c>), or both (HTML).</li>
<li>When no <c>width</c> or <c>height</c> attributes are specified, the fallback
is to look at the image resolution and the dpi metadata embedded in
the image file.</li>
</ul>

<h2 id="divs-and-spans">Divs and Spans</h2>

<p>
	Using the <c>native_divs</c> and <c>native_spans</c> extensions
(see <url href='#extension-native_divs'>above</url>), HTML syntax can
be used as part of markdown to create native <c>Div</c> and <c>Span</c>
elements in the pandoc AST (as opposed to raw HTML).
However, there is also nicer syntax available:
</p>

<h4 id="extension-fenced_divs">Extension: <c>fenced_divs</c></h4>

<p>
	Allow special fenced syntax for native <c>Div</c> blocks. A Div
starts with a fence containing at least three consecutive
colons plus some attributes. The attributes may optionally
be followed by another string of consecutive colons.
The attribute syntax is exactly as in fenced code blocks (see
<url href='#extension-fenced_code_attributes'>Extension: <c>fenced_code_attributes</c></url>). As with fenced
code blocks, one can use either attributes in curly braces
or a single unbraced word, which will be treated as a class
name. The Div ends with another line containing a string of at
least three consecutive colons. The fenced Div should be
separated by blank lines from preceding and following blocks.
</p>

<p>
	Example:
</p>

<pre>::::: {#special .sidebar}
Here is a paragraph.

And another.
:::::</pre>

<p>
	Fenced divs can be nested. Opening fences are distinguished
because they <em>must</em> have attributes:
</p>

<pre>::: Warning ::::::
This is a warning.

::: Danger
This is a warning within a warning.
:::
::::::::::::::::::</pre>

<p>
	Fences without attributes are always closing fences. Unlike
with fenced code blocks, the number of colons in the closing
fence need not match the number in the opening fence. However,
it can be helpful for visual clarity to use fences of different
lengths to distinguish nested divs from their parents.
</p>

<h4 id="extension-bracketed_spans">Extension: <c>bracketed_spans</c></h4>

<p>
	A bracketed sequence of inlines, as one would use to begin
a link, will be treated as a <c>Span</c> with attributes if it is
followed immediately by attributes:
</p>

<pre>[This is *some text*]{.class key=&quot;val&quot;}</pre>

<h2 id="footnotes">Footnotes</h2>

<h4 id="extension-footnotes">Extension: <c>footnotes</c></h4>

<p>
	Pandoc’s Markdown allows footnotes, using the following syntax:
</p>

<pre>Here is a footnote reference,[^1] and another.[^longnote]

[^1]: Here is the footnote.

[^longnote]: Here&#39;s one with multiple blocks.

    Subsequent paragraphs are indented to show that they
belong to the previous footnote.

        { some.code }

    The whole paragraph can be indented, or just the first
    line.  In this way, multi-paragraph footnotes work like
    multi-paragraph list items.

This paragraph won&#39;t be part of the note, because it
isn&#39;t indented.</pre>

<p>
	The identifiers in footnote references may not contain spaces, tabs,
or newlines. These identifiers are used only to correlate the
footnote reference with the note itself; in the output, footnotes
will be numbered sequentially.
</p>

<p>
	The footnotes themselves need not be placed at the end of the
document. They may appear anywhere except inside other block elements
(lists, block quotes, tables, etc.). Each footnote should be
separated from surrounding content (including other footnotes)
by blank lines.
</p>

<h4 id="extension-inline_notes">Extension: <c>inline_notes</c></h4>

<p>
	Inline footnotes are also allowed (though, unlike regular notes,
they cannot contain multiple paragraphs). The syntax is as follows:
</p>

<pre>Here is an inline note.^[Inlines notes are easier to write, since
you don&#39;t have to pick an identifier and move down to type the
note.]</pre>

<p>
	Inline and regular footnotes may be mixed freely.
</p>

<h2 id="citations">Citations</h2>

<h4 id="extension-citations">Extension: <c>citations</c></h4>

<p>
	Using an external filter, <c>pandoc-citeproc</c>, pandoc can automatically generate
citations and a bibliography in a number of styles. Basic usage is
</p>

<pre>pandoc --filter pandoc-citeproc myinput.txt</pre>

<p>
	In order to use this feature, you will need to specify a bibliography file
using the <c>bibliography</c> metadata field in a YAML metadata section, or
<c>--bibliography</c> command line argument. You can supply multiple <c>--bibliography</c>
arguments or set <c>bibliography</c> metadata field to YAML array, if you want to
use multiple bibliography files. The bibliography may have any of these
formats:
</p>

<table>
<tr class="header">
<th align="left">Format</th>
<th align="left">File extension</th>
</tr>
<tr class="odd">
<td align="left">BibLaTeX</td>
<td align="left">.bib</td>
</tr>
<tr class="even">
<td align="left">BibTeX</td>
<td align="left">.bibtex</td>
</tr>
<tr class="odd">
<td align="left">Copac</td>
<td align="left">.copac</td>
</tr>
<tr class="even">
<td align="left">CSL JSON</td>
<td align="left">.json</td>
</tr>
<tr class="odd">
<td align="left">CSL YAML</td>
<td align="left">.yaml</td>
</tr>
<tr class="even">
<td align="left">EndNote</td>
<td align="left">.enl</td>
</tr>
<tr class="odd">
<td align="left">EndNote XML</td>
<td align="left">.xml</td>
</tr>
<tr class="even">
<td align="left">ISI</td>
<td align="left">.wos</td>
</tr>
<tr class="odd">
<td align="left">MEDLINE</td>
<td align="left">.medline</td>
</tr>
<tr class="even">
<td align="left">MODS</td>
<td align="left">.mods</td>
</tr>
<tr class="odd">
<td align="left">RIS</td>
<td align="left">.ris</td>
</tr>
</table>

<p>
	Note that <c>.bib</c> can be used with both BibTeX and BibLaTeX files;
use <c>.bibtex</c> to force BibTeX.
</p>

<p>
	Note that <c>pandoc-citeproc --bib2json</c> and <c>pandoc-citeproc --bib2yaml</c>
can produce <c>.json</c> and <c>.yaml</c> files from any of the supported formats.
</p>

<p>
	In-field markup: In BibTeX and BibLaTeX databases,
pandoc-citeproc parses a subset of LaTeX markup; in CSL YAML
databases, pandoc Markdown; and in CSL JSON databases, an
<url href='http://docs.citationstyles.org/en/1.0/release-notes.html#rich-text-markup-within-fields'>HTML-like markup</url>:
</p>

<dl>
<dt><c>&lt;i&gt;...&lt;/i&gt;</c></dt>
<dd>italics</dd>
<dt><c>&lt;b&gt;...&lt;/b&gt;</c></dt>
<dd>bold</dd>
<dt><c>&lt;span style=&quot;font-variant:small-caps;&quot;&gt;...&lt;/span&gt;</c> or <c>&lt;sc&gt;...&lt;/sc&gt;</c></dt>
<dd>small capitals</dd>
<dt><c>&lt;sub&gt;...&lt;/sub&gt;</c></dt>
<dd>subscript</dd>
<dt><c>&lt;sup&gt;...&lt;/sup&gt;</c></dt>
<dd>superscript</dd>
<dt><c>&lt;span class=&quot;nocase&quot;&gt;...&lt;/span&gt;</c></dt>
<dd>prevent a phrase from being capitalized as title case</dd>
</dl>

<p>
	<c>pandoc-citeproc -j</c> and <c>-y</c> interconvert the CSL JSON
and CSL YAML formats as far as possible.
</p>

<p>
	As an alternative to specifying a bibliography file using <c>--bibliography</c>
or the YAML metadata field <c>bibliography</c>, you can include
the citation data directly in the <c>references</c> field of the
document’s YAML metadata. The field should contain an array of
YAML-encoded references, for example:
</p>

<pre>---
references:
- type: article-journal
  id: WatsonCrick1953
  author:
  - family: Watson
    given: J. D.
  - family: Crick
    given: F. H. C.
  issued:
    date-parts:
    - - 1953
      - 4
      - 25
  title: &#39;Molecular structure of nucleic acids: a structure for deoxyribose
    nucleic acid&#39;
  title-short: Molecular structure of nucleic acids
  container-title: Nature
  volume: 171
  issue: 4356
  page: 737-738
  DOI: 10.1038/171737a0
  URL: http://www.nature.com/nature/journal/v171/n4356/abs/171737a0.html
  language: en-GB
...</pre>

<p>
	(<c>pandoc-citeproc --bib2yaml</c> can produce these from a bibliography file in one
of the supported formats.)
</p>

<p>
	Citations and references can be formatted using any style supported by the
<url href='http://citationstyles.org'>Citation Style Language</url>, listed in the <url href='https://www.zotero.org/styles'>Zotero Style Repository</url>.
These files are specified using the <c>--csl</c> option or the <c>csl</c> metadata field.
By default, <c>pandoc-citeproc</c> will use the <url href='http://chicagomanualofstyle.org'>Chicago Manual of Style</url> author-date
format. The CSL project provides further information on <url href='https://citationstyles.org/authors/'>finding and editing styles</url>.
</p>

<p>
	To make your citations hyperlinks to the corresponding bibliography
entries, add <c>link-citations: true</c> to your YAML metadata.
</p>

<p>
	Citations go inside square brackets and are separated by semicolons.
Each citation must have a key, composed of <sq>@</sq> + the citation
identifier from the database, and may optionally have a prefix,
a locator, and a suffix. The citation key must begin with a letter, digit,
or <c>_</c>, and may contain alphanumerics, <c>_</c>, and internal punctuation
characters (<c>:.#$%&amp;-+?&lt;&gt;~/</c>). Here are some examples:
</p>

<pre>Blah blah [see @doe99, pp. 33-35; also @smith04, chap. 1].

Blah blah [@doe99, pp. 33-35, 38-39 and *passim*].

Blah blah [@smith04; @doe99].</pre>

<p>
	<c>pandoc-citeproc</c> detects locator terms in the <url href='https://github.com/citation-style-language/locales'>CSL locale files</url>.
Either abbreviated or unabbreviated forms are accepted. In the <c>en-US</c>
locale, locator terms can be written in either singular or plural forms,
as <c>book</c>, <c>bk.</c>/<c>bks.</c>; <c>chapter</c>, <c>chap.</c>/<c>chaps.</c>; <c>column</c>,
<c>col.</c>/<c>cols.</c>; <c>figure</c>, <c>fig.</c>/<c>figs.</c>; <c>folio</c>, <c>fol.</c>/<c>fols.</c>;
<c>number</c>, <c>no.</c>/<c>nos.</c>; <c>line</c>, <c>l.</c>/<c>ll.</c>; <c>note</c>, <c>n.</c>/<c>nn.</c>; <c>opus</c>,
<c>op.</c>/<c>opp.</c>; <c>page</c>, <c>p.</c>/<c>pp.</c>; <c>paragraph</c>, <c>para.</c>/<c>paras.</c>; <c>part</c>,
<c>pt.</c>/<c>pts.</c>; <c>section</c>, <c>sec.</c>/<c>secs.</c>; <c>sub verbo</c>, <c>s.v.</c>/<c>s.vv.</c>;
<c>verse</c>, <c>v.</c>/<c>vv.</c>; <c>volume</c>, <c>vol.</c>/<c>vols.</c>; <c>¶</c>/<c>¶¶</c>; <c>§</c>/<c>§§</c>. If no
locator term is used, <q>page</q> is assumed.
</p>

<p>
	<c>pandoc-citeproc</c> will use heuristics to distinguish the locator
from the suffix. In complex cases, the locator can be enclosed
in curly braces (using <c>pandoc-citeproc</c> 0.15 and higher only):
</p>

<pre>[@smith{ii, A, D-Z}, with a suffix]
[@smith, {pp. iv, vi-xi, (xv)-(xvii)} with suffix here]</pre>

<p>
	A minus sign (<c>-</c>) before the <c>@</c> will suppress mention of
the author in the citation. This can be useful when the
author is already mentioned in the text:
</p>

<pre>Smith says blah [-@smith04].</pre>

<p>
	You can also write an in-text citation, as follows:
</p>

<pre>@smith04 says blah.

@smith04 [p. 33] says blah.</pre>

<p>
	If the style calls for a list of works cited, it will be placed
in a div with id <c>refs</c>, if one exists:
</p>

<pre>::: {#refs}
:::</pre>

<p>
	Otherwise, it will be placed at the end of the document.
Generation of the bibliography can be suppressed by setting
<c>suppress-bibliography: true</c> in the YAML metadata.
</p>

<p>
	If you wish the bibliography to have a section header, you can
set <c>reference-section-title</c> in the metadata, or put the header
at the beginning of the div with id <c>refs</c> (if you are using it)
or at the end of your document:
</p>

<pre>last paragraph...

# References</pre>

<p>
	The bibliography will be inserted after this header. Note that
the <c>unnumbered</c> class will be added to this header, so that the
section will not be numbered.
</p>

<p>
	If you want to include items in the bibliography without actually
citing them in the body text, you can define a dummy <c>nocite</c> metadata
field and put the citations there:
</p>

<pre>---
nocite: |
  @item1, @item2
...

@item3</pre>

<p>
	In this example, the document will contain a citation for <c>item3</c>
only, but the bibliography will contain entries for <c>item1</c>, <c>item2</c>, and
<c>item3</c>.
</p>

<p>
	It is possible to create a bibliography with all the citations,
whether or not they appear in the document, by using a wildcard:
</p>

<pre>---
nocite: |
  @*
...</pre>

<p>
	For LaTeX output, you can also use <url href='https://ctan.org/pkg/natbib'><c>natbib</c></url> or <url href='https://ctan.org/pkg/biblatex'><c>biblatex</c></url> to
render the bibliography. In order to do so, specify bibliography
files as outlined above, and add <c>--natbib</c> or <c>--biblatex</c>
argument to <c>pandoc</c> invocation. Bear in mind that bibliography
files have to be in respective format (either BibTeX or
BibLaTeX).
</p>

<p>
	For more information, see the <url href='https://github.com/jgm/pandoc-citeproc/blob/master/man/pandoc-citeproc.1.md'>pandoc-citeproc man page</url>.
</p>

<h2 id="non-pandoc-extensions">Non-pandoc extensions</h2>

<p>
	The following Markdown syntax extensions are not enabled by default
in pandoc, but may be enabled by adding <c>+EXTENSION</c> to the format
name, where <c>EXTENSION</c> is the name of the extension. Thus, for
example, <c>markdown+hard_line_breaks</c> is Markdown with hard line breaks.
</p>

<h4 id="extension-old_dashes">Extension: <c>old_dashes</c></h4>

<p>
	Selects the pandoc &lt;= 1.8.2.1 behavior for parsing smart dashes:
<c>-</c> before a numeral is an en-dash, and <c>--</c> is an em-dash.
This option only has an effect if <c>smart</c> is enabled. It is
selected automatically for <c>textile</c> input.
</p>

<h4 id="extension-angle_brackets_escapable">Extension: <c>angle_brackets_escapable</c></h4>

<p>
	Allow <c>&lt;</c> and <c>&gt;</c> to be backslash-escaped, as they can be in
GitHub flavored Markdown but not original Markdown. This is
implied by pandoc’s default <c>all_symbols_escapable</c>.
</p>

<h4 id="extension-lists_without_preceding_blankline">Extension: <c>lists_without_preceding_blankline</c></h4>

<p>
	Allow a list to occur right after a paragraph, with no intervening
blank space.
</p>

<h4 id="extension-four_space_rule">Extension: <c>four_space_rule</c></h4>

<p>
	Selects the pandoc &lt;= 2.0 behavior for parsing lists, so that
four spaces indent are needed for list item continuation
paragraphs.
</p>

<h4 id="extension-spaced_reference_links">Extension: <c>spaced_reference_links</c></h4>

<p>
	Allow whitespace between the two components of a reference link,
for example,
</p>

<pre>[foo] [bar].</pre>

<h4 id="extension-hard_line_breaks">Extension: <c>hard_line_breaks</c></h4>

<p>
	Causes all newlines within a paragraph to be interpreted as hard line
breaks instead of spaces.
</p>

<h4 id="extension-ignore_line_breaks">Extension: <c>ignore_line_breaks</c></h4>

<p>
	Causes newlines within a paragraph to be ignored, rather than being
treated as spaces or as hard line breaks. This option is intended for
use with East Asian languages where spaces are not used between words,
but text is divided into lines for readability.
</p>

<h4 id="extension-east_asian_line_breaks">Extension: <c>east_asian_line_breaks</c></h4>

<p>
	Causes newlines within a paragraph to be ignored, rather than
being treated as spaces or as hard line breaks, when they occur
between two East Asian wide characters. This is a better choice
than <c>ignore_line_breaks</c> for texts that include a mix of East
Asian wide characters and other characters.
</p>

<h4 id="extension-emoji">Extension: <c>emoji</c></h4>

<p>
	Parses textual emojis like <c>:smile:</c> as Unicode emoticons.
</p>

<h4 id="extension-tex_math_single_backslash">Extension: <c>tex_math_single_backslash</c></h4>

<p>
	Causes anything between <c>\(</c> and <c>\)</c> to be interpreted as inline
TeX math, and anything between <c>\[</c> and <c>\]</c> to be interpreted
as display TeX math. Note: a drawback of this extension is that
it precludes escaping <c>(</c> and <c>[</c>.
</p>

<h4 id="extension-tex_math_double_backslash">Extension: <c>tex_math_double_backslash</c></h4>

<p>
	Causes anything between <c>\\(</c> and <c>\\)</c> to be interpreted as inline
TeX math, and anything between <c>\\[</c> and <c>\\]</c> to be interpreted
as display TeX math.
</p>

<h4 id="extension-markdown_attribute">Extension: <c>markdown_attribute</c></h4>

<p>
	By default, pandoc interprets material inside block-level tags as Markdown.
This extension changes the behavior so that Markdown is only parsed
inside block-level tags if the tags have the attribute <c>markdown=1</c>.
</p>

<h4 id="extension-mmd_title_block">Extension: <c>mmd_title_block</c></h4>

<p>
	Enables a <url href='http://fletcherpenney.net/multimarkdown/'>MultiMarkdown</url> style title block at the top of
the document, for example:
</p>

<pre>Title:   My title
Author:  John Doe
Date:    September 1, 2008
Comment: This is a sample mmd title block, with
         a field spanning multiple lines.</pre>

<p>
	See the MultiMarkdown documentation for details. If <c>pandoc_title_block</c> or
<c>yaml_metadata_block</c> is enabled, it will take precedence over
<c>mmd_title_block</c>.
</p>

<h4 id="extension-abbreviations">Extension: <c>abbreviations</c></h4>

<p>
	Parses PHP Markdown Extra abbreviation keys, like
</p>

<pre>*[HTML]: Hypertext Markup Language</pre>

<p>
	Note that the pandoc document model does not support
abbreviations, so if this extension is enabled, abbreviation keys are
simply skipped (as opposed to being parsed as paragraphs).
</p>

<h4 id="extension-autolink_bare_uris">Extension: <c>autolink_bare_uris</c></h4>

<p>
	Makes all absolute URIs into links, even when not surrounded by
pointy braces <c>&lt;...&gt;</c>.
</p>

<h4 id="extension-mmd_link_attributes">Extension: <c>mmd_link_attributes</c></h4>

<p>
	Parses multimarkdown style key-value attributes on link
and image references. This extension should not be confused with the
<url href='#extension-link_attributes'><c>link_attributes</c></url> extension.
</p>

<pre>This is a reference ![image][ref] with multimarkdown attributes.

[ref]: http://path.to/image &quot;Image title&quot; width=20px height=30px
       id=myId class=&quot;myClass1 myClass2&quot;</pre>

<h4 id="extension-mmd_header_identifiers">Extension: <c>mmd_header_identifiers</c></h4>

<p>
	Parses multimarkdown style header identifiers (in square brackets,
after the header but before any trailing <c>#</c>s in an ATX header).
</p>

<h4 id="extension-compact_definition_lists">Extension: <c>compact_definition_lists</c></h4>

<p>
	Activates the definition list syntax of pandoc 1.12.x and earlier.
This syntax differs from the one described above under <url href='#definition-lists'>Definition lists</url>
in several respects:
</p>

<ul>
<li>No blank line is required between consecutive items of the
definition list.</li>
<li>To get a <q>tight</q> or <q>compact</q> list, omit space between consecutive
items; the space between a term and its definition does not affect
anything.</li>
<li>Lazy wrapping of paragraphs is not allowed: the entire definition must
be indented four spaces.<a id="fnref4" href="#fn4"><sup>4</sup></a></li>
</ul>

<h2 id="markdown-variants">Markdown variants</h2>

<p>
	In addition to pandoc’s extended Markdown, the following Markdown
variants are supported:
</p>

<dl>
<dt><c>markdown_phpextra</c> (PHP Markdown Extra)</dt>
<dd><c>footnotes</c>, <c>pipe_tables</c>, <c>raw_html</c>, <c>markdown_attribute</c>,
<c>fenced_code_blocks</c>, <c>definition_lists</c>, <c>intraword_underscores</c>,
<c>header_attributes</c>, <c>link_attributes</c>, <c>abbreviations</c>,
<c>shortcut_reference_links</c>, <c>spaced_reference_links</c>.</dd>
<dt><c>markdown_github</c> (deprecated GitHub-Flavored Markdown)</dt>
<dd><c>pipe_tables</c>, <c>raw_html</c>, <c>fenced_code_blocks</c>, <c>auto_identifiers</c>,
<c>gfm_auto_identifiers</c>, <c>backtick_code_blocks</c>,
<c>autolink_bare_uris</c>, <c>space_in_atx_header</c>,
<c>intraword_underscores</c>, <c>strikeout</c>, <c>task_lists</c>, <c>emoji</c>,
<c>shortcut_reference_links</c>, <c>angle_brackets_escapable</c>,
<c>lists_without_preceding_blankline</c>.</dd>
<dt><c>markdown_mmd</c> (MultiMarkdown)</dt>
<dd><c>pipe_tables</c>, <c>raw_html</c>, <c>markdown_attribute</c>, <c>mmd_link_attributes</c>,
<c>tex_math_double_backslash</c>, <c>intraword_underscores</c>,
<c>mmd_title_block</c>, <c>footnotes</c>, <c>definition_lists</c>,
<c>all_symbols_escapable</c>, <c>implicit_header_references</c>,
<c>auto_identifiers</c>, <c>mmd_header_identifiers</c>,
<c>shortcut_reference_links</c>, <c>implicit_figures</c>,
<c>superscript</c>, <c>subscript</c>, <c>backtick_code_blocks</c>,
<c>spaced_reference_links</c>, <c>raw_attribute</c>.</dd>
<dt><c>markdown_strict</c> (Markdown.pl)</dt>
<dd><c>raw_html</c>, <c>shortcut_reference_links</c>,
<c>spaced_reference_links</c>.</dd>
</dl>

<p>
	We also support <c>commonmark</c> and <c>gfm</c> (GitHub-Flavored Markdown,
which is implemented as a set of extensions on <c>commonmark</c>).
</p>

<p>
	Note, however, that <c>commonmark</c> and <c>gfm</c> have limited support
for extensions. Only those listed below (and <c>smart</c>,
<c>raw_tex</c>, and <c>hard_line_breaks</c>) will work. The extensions
can, however, all be individually disabled. Also, <c>raw_tex</c>
only affects <c>gfm</c> output, not input.
</p>

<dl>
<dt><c>gfm</c> (GitHub-Flavored Markdown)</dt>
<dd><c>pipe_tables</c>, <c>raw_html</c>, <c>fenced_code_blocks</c>, <c>auto_identifiers</c>,
<c>gfm_auto_identifiers</c>, <c>backtick_code_blocks</c>,
<c>autolink_bare_uris</c>, <c>space_in_atx_header</c>,
<c>intraword_underscores</c>, <c>strikeout</c>, <c>task_lists</c>, <c>emoji</c>,
<c>shortcut_reference_links</c>, <c>angle_brackets_escapable</c>,
<c>lists_without_preceding_blankline</c>.</dd>
</dl>

<h1 id="producing-slide-shows-with-pandoc">Producing slide shows with pandoc</h1>

<p>
	You can use pandoc to produce an HTML + JavaScript slide presentation
that can be viewed via a web browser. There are five ways to do this,
using <url href='http://meyerweb.com/eric/tools/s5/'>S5</url>, <url href='http://paulrouget.com/dzslides/'>DZSlides</url>, <url href='http://www.w3.org/Talks/Tools/Slidy/'>Slidy</url>, <url href='http://goessner.net/articles/slideous/'>Slideous</url>, or <url href='http://lab.hakim.se/reveal-js/'>reveal.js</url>.
You can also produce a PDF slide show using LaTeX <url href='https://ctan.org/pkg/beamer'><c>beamer</c></url>, or
slides shows in Microsoft <url href='https://en.wikipedia.org/wiki/Microsoft_PowerPoint'>PowerPoint</url> format.
</p>

<p>
	Here’s the Markdown source for a simple slide show, <c>habits.txt</c>:
</p>

<pre>% Habits
% John Doe
% March 22, 2005

# In the morning

## Getting up

- Turn off alarm
- Get out of bed

## Breakfast

- Eat eggs
- Drink coffee

# In the evening

## Dinner

- Eat spaghetti
- Drink wine

------------------

![picture of spaghetti](images/spaghetti.jpg)

## Going to sleep

- Get in bed
- Count sheep</pre>

<p>
	To produce an HTML/JavaScript slide show, simply type
</p>

<pre>pandoc -t FORMAT -s habits.txt -o habits.html</pre>

<p>
	where <c>FORMAT</c> is either <c>s5</c>, <c>slidy</c>, <c>slideous</c>, <c>dzslides</c>, or <c>revealjs</c>.
</p>

<p>
	For Slidy, Slideous, reveal.js, and S5, the file produced by pandoc with the
<c>-s/--standalone</c> option embeds a link to JavaScript and CSS files, which are
assumed to be available at the relative path <c>s5/default</c> (for S5), <c>slideous</c>
(for Slideous), <c>reveal.js</c> (for reveal.js), or at the Slidy website at
<c>w3.org</c> (for Slidy). (These paths can be changed by setting the <c>slidy-url</c>,
<c>slideous-url</c>, <c>revealjs-url</c>, or <c>s5-url</c> variables; see <url href='#variables-for-html-slides'>Variables for HTML slides</url>,
above.) For DZSlides, the (relatively short) JavaScript and CSS are included in
the file by default.
</p>

<p>
	With all HTML slide formats, the <c>--self-contained</c> option can be used to
produce a single file that contains all of the data necessary to display the
slide show, including linked scripts, stylesheets, images, and videos.
</p>

<p>
	To produce a PDF slide show using beamer, type
</p>

<pre>pandoc -t beamer habits.txt -o habits.pdf</pre>

<p>
	Note that a reveal.js slide show can also be converted to a PDF
by printing it to a file from the browser.
</p>

<p>
	To produce a Powerpoint slide show, type
</p>

<pre>pandoc habits.txt -o habits.pptx</pre>

<h2 id="structuring-the-slide-show">Structuring the slide show</h2>

<p>
	By default, the <em>slide level</em> is the highest header level in
the hierarchy that is followed immediately by content, and not another
header, somewhere in the document. In the example above, level 1 headers
are always followed by level 2 headers, which are followed by content,
so 2 is the slide level. This default can be overridden using
the <c>--slide-level</c> option.
</p>

<p>
	The document is carved up into slides according to the following
rules:
</p>

<ul>
<li><p>
	A horizontal rule always starts a new slide.
</p></li>
<li><p>
	A header at the slide level always starts a new slide.
</p></li>
<li><p>
	Headers <em>below</em> the slide level in the hierarchy create
headers <em>within</em> a slide.
</p></li>
<li><p>
	Headers <em>above</em> the slide level in the hierarchy create
<q>title slides,</q> which just contain the section title
and help to break the slide show into sections.
Non-slide content under these headers will be included
on the title slide (for HTML slide shows) or in a
subsequent slide with the same title (for beamer).
</p></li>
<li><p>
	A title page is constructed automatically from the document’s title
block, if present. (In the case of beamer, this can be disabled
by commenting out some lines in the default template.)
</p></li>
</ul>

<p>
	These rules are designed to support many different styles of slide show. If
you don’t care about structuring your slides into sections and subsections,
you can just use level 1 headers for all each slide. (In that case, level 1
will be the slide level.) But you can also structure the slide show into
sections, as in the example above.
</p>

<p>
	Note: in reveal.js slide shows, if slide level is 2, a two-dimensional
layout will be produced, with level 1 headers building horizontally
and level 2 headers building vertically. It is not recommended that
you use deeper nesting of section levels with reveal.js.
</p>

<h2 id="incremental-lists">Incremental lists</h2>

<p>
	By default, these writers produce lists that display <q>all at once.</q>
If you want your lists to display incrementally (one item at a time),
use the <c>-i</c> option. If you want a particular list to depart from the
default, put it in a <c>div</c> block with class <c>incremental</c> or
<c>nonincremental</c>. So, for example, using the <c>fenced div</c> syntax, the
following would be incremental regardless of the document default:
</p>

<pre>::: incremental

- Eat spaghetti
- Drink wine

:::</pre>

<p>
	or
</p>

<pre>::: nonincremental

- Eat spaghetti
- Drink wine

:::</pre>

<p>
	While using <c>incremental</c> and <c>nonincremental</c> divs are the
recommended method of setting incremental lists on a per-case basis,
an older method is also supported: putting lists inside a blockquote
will depart from the document default (that is, it will display
incrementally without the <c>-i</c> option and all at once with the <c>-i</c>
option):
</p>

<pre>&gt; - Eat spaghetti
&gt; - Drink wine</pre>

<p>
	Both methods allow incremental and nonincremental lists to be mixed
in a single document.
</p>

<h2 id="inserting-pauses">Inserting pauses</h2>

<p>
	You can add <q>pauses</q> within a slide by including a paragraph containing
three dots, separated by spaces:
</p>

<pre># Slide with a pause

content before the pause

. . .

content after the pause</pre>

<h2 id="styling-the-slides">Styling the slides</h2>

<p>
	You can change the style of HTML slides by putting customized CSS files
in <c>$DATADIR/s5/default</c> (for S5), <c>$DATADIR/slidy</c> (for Slidy),
or <c>$DATADIR/slideous</c> (for Slideous),
where <c>$DATADIR</c> is the user data directory (see <c>--data-dir</c>, above).
The originals may be found in pandoc’s system data directory (generally
<c>$CABALDIR/pandoc-VERSION/s5/default</c>). Pandoc will look there for any
files it does not find in the user data directory.
</p>

<p>
	For dzslides, the CSS is included in the HTML file itself, and may
be modified there.
</p>

<p>
	All <url href='https://github.com/hakimel/reveal.js#configuration'>reveal.js configuration options</url> can be set through variables.
For example, themes can be used by setting the <c>theme</c> variable:
</p>

<pre>-V theme=moon</pre>

<p>
	Or you can specify a custom stylesheet using the <c>--css</c> option.
</p>

<p>
	To style beamer slides, you can specify a <c>theme</c>, <c>colortheme</c>,
<c>fonttheme</c>, <c>innertheme</c>, and <c>outertheme</c>, using the <c>-V</c> option:
</p>

<pre>pandoc -t beamer habits.txt -V theme:Warsaw -o habits.pdf</pre>

<p>
	Note that header attributes will turn into slide attributes
(on a <c>&lt;div&gt;</c> or <c>&lt;section&gt;</c>) in HTML slide formats, allowing you
to style individual slides. In beamer, the only header attribute
that affects slides is the <c>allowframebreaks</c> class, which sets the
<c>allowframebreaks</c> option, causing multiple slides to be created
if the content overfills the frame. This is recommended especially for
bibliographies:
</p>

<pre># References {.allowframebreaks}</pre>

<h2 id="speaker-notes">Speaker notes</h2>

<p>
	Speaker notes are supported in reveal.js and PowerPoint (pptx)
output. You can add notes to your Markdown document thus:
</p>

<pre>::: notes

This is my note.

- It can contain Markdown
- like this list

:::</pre>

<p>
	To show the notes window in reveal.js, press <c>s</c> while viewing the
presentation. Speaker notes in PowerPoint will be available, as usual,
in handouts and presenter view.
</p>

<p>
	Notes are not yet supported for other slide formats, but the notes
will not appear on the slides themselves.
</p>

<h2 id="columns">Columns</h2>

<p>
	To put material in side by side columns, you can use a native
div container with class <c>columns</c>, containing two or more div
containers with class <c>column</c> and a <c>width</c> attribute:
</p>

<pre>:::::::::::::: {.columns}
::: {.column width=&quot;40%&quot;}
contents...
:::
::: {.column width=&quot;60%&quot;}
contents...
:::
::::::::::::::</pre>

<h2 id="frame-attributes-in-beamer">Frame attributes in beamer</h2>

<p>
	Sometimes it is necessary to add the LaTeX <c>[fragile]</c> option to
a frame in beamer (for example, when using the <c>minted</c> environment).
This can be forced by adding the <c>fragile</c> class to the header
introducing the slide:
</p>

<pre># Fragile slide {.fragile}</pre>

<p>
	All of the other frame attributes described in Section 8.1 of
the <url href='http://ctan.math.utah.edu/ctan/tex-archive/macros/latex/contrib/beamer/doc/beameruserguide.pdf'>Beamer User’s Guide</url> may also be used: <c>allowdisplaybreaks</c>,
<c>allowframebreaks</c>, <c>b</c>, <c>c</c>, <c>t</c>, <c>environment</c>, <c>label</c>, <c>plain</c>,
<c>shrink</c>, <c>standout</c>, <c>noframenumbering</c>.
</p>

<h2 id="background-in-reveal.js-and-beamer">Background in reveal.js and beamer</h2>

<p>
	Background images can be added to self-contained reveal.js slideshows and
to beamer slideshows.
</p>

<p>
	For the same image on every slide, use the configuration
option <c>background-image</c> either in the YAML metadata block
or as a command-line variable. (There are no other options in
beamer and the rest of this section concerns reveal.js slideshows.)
</p>

<p>
	For reveal.js, you can instead use the reveal.js-native option
<c>parallaxBackgroundImage</c>. You can also set <c>parallaxBackgroundHorizontal</c>
and <c>parallaxBackgroundVertical</c> the same way and must also set
<c>parallaxBackgroundSize</c> to have your values take effect.
</p>

<p>
	To set an image for a particular reveal.js slide, add
<c>{data-background-image=&quot;/path/to/image&quot;}</c>
to the first slide-level header on the slide (which may even be empty).
</p>

<p>
	In reveal.js’s overview mode, the parallaxBackgroundImage will show up
only on the first slide.
</p>

<p>
	Other reveal.js background settings also work on individual slides, including
<c>data-background-size</c>, <c>data-background-repeat</c>, <c>data-background-color</c>,
<c>data-transition</c>, and <c>data-transition-speed</c>.
</p>

<p>
	See the <url href='https://github.com/hakimel/reveal.js#slide-backgrounds'>reveal.js
documentation</url>
for more details.
</p>

<p>
	For example in reveal.js:
</p>

<pre>---
title: My Slideshow
parallaxBackgroundImage: /path/to/my/background_image.png
---

## Slide One

Slide 1 has background_image.png as its background.

## {data-background-image=&quot;/path/to/special_image.jpg&quot;}

Slide 2 has a special image for its background, even though the header has no content.</pre>

<h1 id="creating-epubs-with-pandoc">Creating EPUBs with pandoc</h1>

<h2 id="epub-metadata">EPUB Metadata</h2>

<p>
	EPUB metadata may be specified using the <c>--epub-metadata</c> option, but
if the source document is Markdown, it is better to use a <url href='#extension-yaml_metadata_block'>YAML metadata
block</url>. Here is an example:
</p>

<pre>---
title:
- type: main
  text: My Book
- type: subtitle
  text: An investigation of metadata
creator:
- role: author
  text: John Smith
- role: editor
  text: Sarah Jones
identifier:
- scheme: DOI
  text: doi:10.234234.234/33
publisher:  My Press
rights: © 2007 John Smith, CC BY-NC
ibooks:
  version: 1.3.4
...</pre>

<p>
	The following fields are recognized:
</p>

<dl>
<dt><c>identifier</c></dt>
<dd>Either a string value or an object with fields <c>text</c> and
<c>scheme</c>. Valid values for <c>scheme</c> are <c>ISBN-10</c>,
<c>GTIN-13</c>, <c>UPC</c>, <c>ISMN-10</c>, <c>DOI</c>, <c>LCCN</c>, <c>GTIN-14</c>,
<c>ISBN-13</c>, <c>Legal deposit number</c>, <c>URN</c>, <c>OCLC</c>,
<c>ISMN-13</c>, <c>ISBN-A</c>, <c>JP</c>, <c>OLCC</c>.</dd>
<dt><c>title</c></dt>
<dd>Either a string value, or an object with fields <c>file-as</c> and
<c>type</c>, or a list of such objects. Valid values for <c>type</c> are
<c>main</c>, <c>subtitle</c>, <c>short</c>, <c>collection</c>, <c>edition</c>, <c>extended</c>.</dd>
<dt><c>creator</c></dt>
<dd>Either a string value, or an object with fields <c>role</c>, <c>file-as</c>,
and <c>text</c>, or a list of such objects. Valid values for <c>role</c> are
<url href='http://loc.gov/marc/relators/relaterm.html'>MARC relators</url>, but
pandoc will attempt to translate the human-readable versions
(like <q>author</q> and <q>editor</q>) to the appropriate marc relators.</dd>
<dt><c>contributor</c></dt>
<dd>Same format as <c>creator</c>.</dd>
<dt><c>date</c></dt>
<dd>A string value in <c>YYYY-MM-DD</c> format. (Only the year is necessary.)
Pandoc will attempt to convert other common date formats.</dd>
<dt><c>lang</c> (or legacy: <c>language</c>)</dt>
<dd>A string value in <url href='https://tools.ietf.org/html/bcp47'>BCP 47</url> format. Pandoc will default to the local
language if nothing is specified.</dd>
<dt><c>subject</c></dt>
<dd>A string value or a list of such values.</dd>
<dt><c>description</c></dt>
<dd>A string value.</dd>
<dt><c>type</c></dt>
<dd>A string value.</dd>
<dt><c>format</c></dt>
<dd>A string value.</dd>
<dt><c>relation</c></dt>
<dd>A string value.</dd>
<dt><c>coverage</c></dt>
<dd>A string value.</dd>
<dt><c>rights</c></dt>
<dd>A string value.</dd>
<dt><c>cover-image</c></dt>
<dd>A string value (path to cover image).</dd>
<dt><c>css</c> (or legacy: <c>stylesheet</c>)</dt>
<dd>A string value (path to CSS stylesheet).</dd>
<dt><c>page-progression-direction</c></dt>
<dd>Either <c>ltr</c> or <c>rtl</c>. Specifies the <c>page-progression-direction</c>
attribute for the <url href='http://idpf.org/epub/301/spec/epub-publications.html#sec-spine-elem'><c>spine</c> element</url>.</dd>
<dt><c>ibooks</c></dt>
<dd><p>
	iBooks-specific metadata, with the following fields:
</p>

<ul>
<li><c>version</c>: (string)</li>
<li><c>specified-fonts</c>: <c>true</c>|<c>false</c> (default <c>false</c>)</li>
<li><c>ipad-orientation-lock</c>: <c>portrait-only</c>|<c>landscape-only</c></li>
<li><c>iphone-orientation-lock</c>: <c>portrait-only</c>|<c>landscape-only</c></li>
<li><c>binding</c>: <c>true</c>|<c>false</c> (default <c>true</c>)</li>
<li><c>scroll-axis</c>: <c>vertical</c>|<c>horizontal</c>|<c>default</c></li>
</ul></dd>
</dl>

<h2 id="the-epubtype-attribute">The <c>epub:type</c> attribute</h2>

<p>
	For <c>epub3</c> output, you can mark up the header that corresponds to an EPUB
chapter using the <url href='http://www.idpf.org/epub/31/spec/epub-contentdocs.html#sec-epub-type-attribute'><c>epub:type</c> attribute</url>. For example, to set
the attribute to the value <c>prologue</c>, use this markdown:
</p>

<pre># My chapter {epub:type=prologue}</pre>

<p>
	Which will result in:
</p>

<pre>&lt;body epub:type=&quot;frontmatter&quot;&gt;
  &lt;section epub:type=&quot;prologue&quot;&gt;
    &lt;h1&gt;My chapter&lt;/h1&gt;</pre>

<p>
	Pandoc will output <c>&lt;body epub:type=&quot;bodymatter&quot;&gt;</c>, unless
you use one of the following values, in which case either
<c>frontmatter</c> or <c>backmatter</c> will be output.
</p>

<table>
<tr class="header">
<th align="left"><c>epub:type</c> of first section</th>
<th align="left"><c>epub:type</c> of body</th>
</tr>
<tr class="odd">
<td align="left">prologue</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">abstract</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">acknowledgments</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">copyright-page</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">dedication</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">foreword</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">halftitle,</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">introduction</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">preface</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">seriespage</td>
<td align="left">frontmatter</td>
</tr>
<tr class="odd">
<td align="left">titlepage</td>
<td align="left">frontmatter</td>
</tr>
<tr class="even">
<td align="left">afterword</td>
<td align="left">backmatter</td>
</tr>
<tr class="odd">
<td align="left">appendix</td>
<td align="left">backmatter</td>
</tr>
<tr class="even">
<td align="left">colophon</td>
<td align="left">backmatter</td>
</tr>
<tr class="odd">
<td align="left">conclusion</td>
<td align="left">backmatter</td>
</tr>
<tr class="even">
<td align="left">epigraph</td>
<td align="left">backmatter</td>
</tr>
</table>

<h2 id="linked-media">Linked media</h2>

<p>
	By default, pandoc will download media referenced from any <c>&lt;img&gt;</c>, <c>&lt;audio&gt;</c>,
<c>&lt;video&gt;</c> or <c>&lt;source&gt;</c> element present in the generated EPUB,
and include it in the EPUB container, yielding a completely
self-contained EPUB. If you want to link to external media resources
instead, use raw HTML in your source and add <c>data-external=&quot;1&quot;</c> to the tag
with the <c>src</c> attribute. For example:
</p>

<pre>&lt;audio controls=&quot;1&quot;&gt;
  &lt;source src=&quot;http://example.com/music/toccata.mp3&quot;
          data-external=&quot;1&quot; type=&quot;audio/mpeg&quot;&gt;
  &lt;/source&gt;
&lt;/audio&gt;</pre>

<h1 id="creating-jupyter-notebooks-with-pandoc">Creating Jupyter notebooks with pandoc</h1>

<p>
	When creating a <url href='https://nbformat.readthedocs.io/en/latest/'>Jupyter notebook</url>, pandoc will try to infer the
notebook structure. Code blocks with the class <c>code</c> will be
taken as code cells, and intervening content will be taken as
Markdown cells. Attachments will automatically be created for
images in Markdown cells. Metadata will be taken from the
<c>jupyter</c> metadata field. For example:
</p>

<pre>---
title: My notebook
jupyter:
  nbformat: 4
  nbformat_minor: 5
  kernelspec:
     display_name: Python 2
     language: python
     name: python2
  language_info:
     codemirror_mode:
       name: ipython
       version: 2
     file_extension: &quot;.py&quot;
     mimetype: &quot;text/x-python&quot;
     name: &quot;python&quot;
     nbconvert_exporter: &quot;python&quot;
     pygments_lexer: &quot;ipython2&quot;
     version: &quot;2.7.15&quot;
---

# Lorem ipsum

**Lorem ipsum** dolor sit amet, consectetur adipiscing elit. Nunc luctus
bibendum felis dictum sodales.

``` code
print(&quot;hello&quot;)
```

## Pyout

``` code
from IPython.display import HTML
HTML(&quot;&quot;&quot;
&lt;script&gt;
console.log(&quot;hello&quot;);
&lt;/script&gt;
&lt;b&gt;HTML&lt;/b&gt;
&quot;&quot;&quot;)
```

## Image

This image ![image](myimage.png) will be
included as a cell attachment.</pre>

<p>
	If you want to add cell attributes, group cells differently, or
add output to code cells, then you need to include divs to
indicate the structure. You can use either <url href='#extension-fenced_divs'>fenced
divs</url> or <url href='#extension-native_divs'>native divs</url> for this. Here is an example:
</p>

<pre>:::::: {.cell .markdown}
# Lorem

**Lorem ipsum** dolor sit amet, consectetur adipiscing elit. Nunc luctus
bibendum felis dictum sodales.
::::::

:::::: {.cell .code execution_count=1}
``` {.python}
print(&quot;hello&quot;)
```

::: {.output .stream .stdout}
```
hello
```
:::
::::::

:::::: {.cell .code execution_count=2}
``` {.python}
from IPython.display import HTML
HTML(&quot;&quot;&quot;
&lt;script&gt;
console.log(&quot;hello&quot;);
&lt;/script&gt;
&lt;b&gt;HTML&lt;/b&gt;
&quot;&quot;&quot;)
```

::: {.output .execute_result execution_count=2}
```{=html}
&lt;script&gt;
console.log(&quot;hello&quot;);
&lt;/script&gt;
&lt;b&gt;HTML&lt;/b&gt;
hello
```
:::
::::::</pre>

<p>
	If you include raw HTML or TeX in an output cell, use the
[raw attribute][Extension: <c>fenced_attribute</c>], as shown
in the last cell of the example above. Although pandoc can
process <q>bare</q> raw HTML and TeX, the result is often
interspersed raw elements and normal textual elements, and
in an output cell pandoc expects a single, connected raw
block. To avoid using raw HTML or TeX except when
marked explicitly using raw attributes, we recommend
specifying the extensions <c>-raw_html-raw_tex+raw_attribute</c> when
translating between Markdown and ipynb notebooks.
</p>

<h1 id="syntax-highlighting">Syntax highlighting</h1>

<p>
	Pandoc will automatically highlight syntax in <url href='#fenced-code-blocks'>fenced code blocks</url> that
are marked with a language name. The Haskell library <url href='https://github.com/jgm/skylighting'>skylighting</url> is
used for highlighting. Currently highlighting is supported only for
HTML, EPUB, Docx, Ms, and LaTeX/PDF output. To see a list of language names
that pandoc will recognize, type <c>pandoc --list-highlight-languages</c>.
</p>

<p>
	The color scheme can be selected using the <c>--highlight-style</c> option.
The default color scheme is <c>pygments</c>, which imitates the default color
scheme used by the Python library pygments (though pygments is not actually
used to do the highlighting). To see a list of highlight styles,
type <c>pandoc --list-highlight-styles</c>.
</p>

<p>
	If you are not satisfied with the predefined styles, you can
use <c>--print-highlight-style</c> to generate a JSON <c>.theme</c> file which
can be modified and used as the argument to <c>--highlight-style</c>. To
get a JSON version of the <c>pygments</c> style, for example:
</p>

<pre>pandoc --print-highlight-style pygments &gt; my.theme</pre>

<p>
	Then edit <c>my.theme</c> and use it like this:
</p>

<pre>pandoc --highlight-style my.theme</pre>

<p>
	If you are not satisfied with the built-in highlighting, or you
want highlight a language that isn’t supported, you can use the
<c>--syntax-definition</c> option to load a <url href='https://docs.kde.org/stable5/en/applications/katepart/highlight.html'>KDE-style XML syntax definition
file</url>.
Before writing your own, have a look at KDE’s <url href='https://github.com/KDE/syntax-highlighting/tree/master/data/syntax'>repository of syntax
definitions</url>.
</p>

<p>
	To disable highlighting, use the <c>--no-highlight</c> option.
</p>

<h1 id="custom-styles">Custom Styles</h1>

<p>
	Custom styles can be used in the docx and ICML formats.
</p>

<h2 id="output">Output</h2>

<p>
	By default, pandoc’s docx and ICML output applies a predefined set of styles
for blocks such as paragraphs and block quotes, and uses largely default
formatting (italics, bold) for inlines. This will work for most
purposes, especially alongside a <c>reference.docx</c> file. However, if you
need to apply your own styles to blocks, or match a preexisting set of
styles, pandoc allows you to define custom styles for blocks and text
using <c>div</c>s and <c>span</c>s, respectively.
</p>

<p>
	If you define a <c>div</c> or <c>span</c> with the attribute <c>custom-style</c>,
pandoc will apply your specified style to the contained elements. So,
for example using the <c>bracketed_spans</c> syntax,
</p>

<pre>[Get out]{custom-style=&quot;Emphatically&quot;}, he said.</pre>

<p>
	would produce a docx file with <q>Get out</q> styled with character
style <c>Emphatically</c>. Similarly, using the <c>fenced_divs</c> syntax,
</p>

<pre>Dickinson starts the poem simply:

::: {custom-style=&quot;Poetry&quot;}
| A Bird came down the Walk---
| He did not know I saw---
:::</pre>

<p>
	would style the two contained lines with the <c>Poetry</c> paragraph style.
</p>

<p>
	For docx output, styles will be defined in the output file as inheriting
from normal text, if the styles are not yet in your reference.docx.
If they are already defined, pandoc will not alter the definition.
</p>

<p>
	This feature allows for greatest customization in conjunction with
<url href='http://pandoc.org/filters.html'>pandoc filters</url>. If you want all paragraphs after block quotes to be
indented, you can write a filter to apply the styles necessary. If you
want all italics to be transformed to the <c>Emphasis</c> character style
(perhaps to change their color), you can write a filter which will
transform all italicized inlines to inlines within an <c>Emphasis</c>
custom-style <c>span</c>.
</p>

<p>
	For docx output, you don’t need to enable any extensions for
custom styles to work.
</p>

<h2 id="input">Input</h2>

<p>
	The docx reader, by default, only reads those styles that it can
convert into pandoc elements, either by direct conversion or
interpreting the derivation of the input document’s styles.
</p>

<p>
	By enabling the <url href='#ext-styles'><c>styles</c> extension</url> in the docx reader
(<c>-f docx+styles</c>), you can produce output that maintains the styles
of the input document, using the <c>custom-style</c> class. Paragraph
styles are interpreted as divs, while character styles are interpreted
as spans.
</p>

<p>
	For example, using the <c>custom-style-reference.docx</c> file in the test
directory, we have the following different outputs:
</p>

<p>
	Without the <c>+styles</c> extension:
</p>

<pre>$ pandoc test/docx/custom-style-reference.docx -f docx -t markdown
This is some text.

This is text with an *emphasized* text style. And this is text with a
**strengthened** text style.

&gt; Here is a styled paragraph that inherits from Block Text.</pre>

<p>
	And with the extension:
</p>

<pre>$ pandoc test/docx/custom-style-reference.docx -f docx+styles -t markdown

::: {custom-style=&quot;FirstParagraph&quot;}
This is some text.
:::

::: {custom-style=&quot;BodyText&quot;}
This is text with an [emphasized]{custom-style=&quot;Emphatic&quot;} text style.
And this is text with a [strengthened]{custom-style=&quot;Strengthened&quot;}
text style.
:::

::: {custom-style=&quot;MyBlockStyle&quot;}
&gt; Here is a styled paragraph that inherits from Block Text.
:::</pre>

<p>
	With these custom styles, you can use your input document as a
reference-doc while creating docx output (see below), and maintain the
same styles in your input and output files.
</p>

<h1 id="custom-writers">Custom writers</h1>

<p>
	Pandoc can be extended with custom writers written in <url href='http://www.lua.org'>lua</url>. (Pandoc
includes a lua interpreter, so lua need not be installed separately.)
</p>

<p>
	To use a custom writer, simply specify the path to the lua script
in place of the output format. For example:
</p>

<pre>pandoc -t data/sample.lua</pre>

<p>
	Creating a custom writer requires writing a lua function for each
possible element in a pandoc document. To get a documented example
which you can modify according to your needs, do
</p>

<pre>pandoc --print-default-data-file sample.lua</pre>

<h1 id="a-note-on-security">A note on security</h1>

<p>
	If you use pandoc to convert user-contributed content in a web
application, here are some things to keep in mind:
</p>

<ol>
<li><p>
	Although pandoc itself will not create or modify any files other
than those you explicitly ask it create (with the exception
of temporary files used in producing PDFs), a filter or custom
writer could in principle do anything on your file system. Please
audit filters and custom writers very carefully before using them.
</p></li>
<li><p>
	If your application uses pandoc as a Haskell library (rather than
shelling out to the executable), it is possible to use it in a mode
that fully isolates pandoc from your file system, by running the
pandoc operations in the <c>PandocPure</c> monad. See the document
<url href='http://pandoc.org/using-the-pandoc-api.html'>Using the pandoc API</url>
for more details.
</p></li>
<li><p>
	Pandoc’s parsers can exhibit pathological performance on some
corner cases. It is wise to put any pandoc operations under
a timeout, to avoid DOS attacks that exploit these issues.
If you are using the pandoc executable, you can add the
command line options <c>+RTS -M512M -RTS</c> (for example) to limit
the heap size to 512MB.
</p></li>
<li><p>
	The HTML generated by pandoc is not guaranteed to be safe.
If <c>raw_html</c> is enabled for the Markdown input, users can
inject arbitrary HTML. Even if <c>raw_html</c> is disabled,
users can include dangerous content in attributes for
headers, spans, and code blocks. To be safe, you should
run all the generated HTML through an HTML sanitizer.
</p></li>
</ol>

<h1 id="authors">Authors</h1>

<p>
	Copyright 2006–2019 John MacFarlane (jgm@berkeley.edu). Released
under the <url href='http://www.gnu.org/copyleft/gpl.html'>GPL</url>, version 2 or greater. This software carries no
warranty of any kind. (See COPYRIGHT for full copyright and
warranty notices.) For a full list of contributors, see the file
AUTHORS.md in the pandoc source code.
</p>
<ol class="footnotes">
<li id="fn1"><p>
	The point of this rule is to ensure that normal paragraphs
starting with people’s initials, like
</p>

<pre>B. Russell was an English philosopher.</pre>

<p>
	do not get treated as list items.
</p>

<p>
	This rule will not prevent
</p>

<pre>(C) 2007 Joe Smith</pre>

<p>
	from being interpreted as a list item. In this case, a backslash
escape can be used:
</p>

<pre>(C\) 2007 Joe Smith <a href="#fnref1">&#8617;</a></pre></li>
<li id="fn2"><p>
	I have been influenced by the suggestions of <url href='http://www.justatheory.com/computers/markup/modest-markdown-proposal.html'>David Wheeler</url>.
 <a href="#fnref2">&#8617;</a></p></li>
<li id="fn3"><p>
	This scheme is due to Michel Fortin, who proposed it on the
<url href='http://six.pairlist.net/pipermail/markdown-discuss/2005-March/001097.html'>Markdown discussion list</url>.
 <a href="#fnref3">&#8617;</a></p></li>
<li id="fn4"><p>
	To see why laziness is incompatible with relaxing the requirement
of a blank line between items, consider the following example:
</p>

<pre>bar
:    definition
foo
:    definition</pre>

<p>
	Is this a single list item with two definitions of <q>bar,</q> the first of
which is lazily wrapped, or two list items? To remove the ambiguity
we must either disallow lazy wrapping or require a blank line between
list items.
 <a href="#fnref4">&#8617;</a></p></li>
</ol>
