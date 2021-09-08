%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pi-article.cls, v4.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{pi-article}[08/09/2021, v5.0]

%%%%%%%%%%%%%%%%%%%%%% Class options and conditionals

% Option for type of article
\newcommand{\arttype}{ARTICLE}
\DeclareOption{commun}{\renewcommand{\arttype}{COMMUNICATION}}
\DeclareOption{review}{\renewcommand{\arttype}{REVIEW}}
\DeclareOption{persp}{\renewcommand{\arttype}{PERSPECTIVE}}

% Option for switching to SI format
\newif\if@switchSI
\DeclareOption{SI}{\@switchSItrue}

% Option for two column format
\newif\if@switchtwocolumn
\DeclareOption{twocolumn}{
  \@switchtwocolumntrue
  \PassOptionsToClass{twocolumn}{extarticle}
}

% Option for line numbers
\newif\if@switchlineno
\DeclareOption{lineno}{\@switchlinenotrue}

% Option for affiliation location
\newif\if@switchaffil \@switchaffilfalse
\DeclareOption{affiltop}{\@switchaffiltrue}

% Option for toc image
\newif\if@switchtoc \@switchtocfalse
\DeclareOption{tocfig}{\@switchtoctrue}

% Option for debugging format
\newif\if@switchdebug
\DeclareOption{debug}{\@switchdebugtrue}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}  % pass other options to base class
\ProcessOptions*\relax                                            % finish options
\LoadClass{extarticle}

%% Options for individual element switching
\RequirePackage{etoolbox}         % general utilities
\newtoggle{shortintro}            % will not include abstract in the title page
\newtoggle{singlecolumn}          % text will be laid out in a single column
\newtoggle{toprule}               % large line at the top
\toggletrue{toprule}              % on by default

%%%%%%%%%%%%%%%%%%%%%% Global settings for SI format

\if@switchSI
  \togglefalse{toprule}                               % no top rule
  \toggletrue{shortintro}                             % no abstract
  \toggletrue{singlecolumn}                           % single column
  \def\thepage{S\arabic{page}}                        % pages as S1-SX
  \renewcommand*\thefigure{S\arabic{figure}}          % Figures as Fig. S1
  \renewcommand*\thetable{S\arabic{table}}            % Tables as Table S1
  \renewcommand*\theequation{S\arabic{equation}}      % Equations as Eq. S1
  \AtBeginDocument{%                                  % Bibliographies as Ref. S1
      \renewcommand*\citenumfont[1]{S#1}%
      \renewcommand*\bibnumfmt[1]{(S#1)}%
  }
\fi

%%%%%%%%%%%%%%%%%%%%%% Fonts and language

% Fonts
\RequirePackage{lmodern}
\renewcommand*\familydefault{\sfdefault}

% Microtype
\AtEndOfClass{\RequirePackage{microtype}}

%% Set up main page fonts
\newcommand{\headerfont}{\fontfamily{lmss}\color{gray}\bfseries\sffamily\fontsize{16pt}{20pt}\selectfont}
\newcommand{\footerfont}{\normalfont\sffamily\fontsize{7pt}{9pt}\selectfont}
\newcommand{\titlefont}{\fontfamily{lmss}\bfseries\fontsize{22pt}{24pt}\selectfont}
\newcommand{\subtitlefont}{\fontfamily{lmss}\bfseries\fontsize{15pt}{20pt}\selectfont}
\newcommand{\contactfont}{\itshape\sffamily\fontsize{7pt}{9pt}\selectfont}
\newcommand{\absfont}{\normalfont\sffamily\bfseries\fontsize{8pt}{11pt}\selectfont}
\newcommand{\keywordsfont}{\normalfont\sffamily\fontsize{8pt}{11pt}\selectfont}
\newcommand{\footnotefont}{\normalfont\sffamily\fontsize{7}{9}\selectfont}

% AMS maths packages
\RequirePackage{
  amsmath,
  amsfonts,
  amsthm,
  amssymb
}

%% Add bolding to math where needed
\g@addto@macro\bfseries{\boldmath}

% Encodings
\RequirePackage{ifxetex,ifluatex}
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  \RequirePackage{cmap}
  \RequirePackage[TS1,T1]{fontenc}
  \RequirePackage[utf8]{inputenc}
\else % if luatex or xelatex
  \ifxetex
    \usepackage{mathspec}
    % undo the wrong changes made by mathspec
    \let\RequirePackage\original@RequirePackage
    \let\usepackage\RequirePackage
  \else
    \usepackage{fontspec}
  \fi
  \defaultfontfeatures{Ligatures=TeX,Scale=MatchLowercase}
\fi

% Language
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  \RequirePackage[english]{babel}
\else
  \usepackage{polyglossia}
  \setmainlanguage[]{english}
\fi

%%%%%%%%%%%%%%%%%%%%%% General pagination setup and tools

\RequirePackage[
  a4paper,includeheadfoot,                    % paper size, head/foot included in geometry
  top=35pt,bottom=50pt,                       % top/bottom
  left=75pt,right=75pt,                       % left/right
  marginparwidth=2cm,                         % margins (used for line numbers)
  marginparsep=5pt,                           % margin separation
  headheight=20pt,                            % header height
  headsep=0pt,                                % text distance from header
  footskip=25pt]{geometry}

\if@switchtwocolumn                           % smaller margins if two-column
\geometry{
  top=25pt,bottom=35pt,                       % top/bottom
  left=55pt,right=55pt,                       % left/right
}
\fi

\if@switchdebug
\geometry{
  showframe,showcrop,                       % for debugging
}
\fi


\RequirePackage{changepage}                   % change odd/even page at any point
\RequirePackage{lastpage}                     % Refer to last page of the document
\RequirePackage{afterpage}                    % execute a command on next page (useful for \clearpage flush)
\RequirePackage{enumitem}                     % For reducing bullet list item separation

\setlength{\columnsep}{13.5pt}                % Distance between the two columns of text
\setlength{\parindent}{12pt}                  % Paragraph indent

%%%%%%%%%%%%%%%%%%%%%% Figures, tables, equations and listings

% Figures
\RequirePackage{graphicx}                     % include pictures
\RequirePackage{tikz}                         % drawing pictures
\usetikzlibrary{svg.path}                     % TIKZ svg paths
\usetikzlibrary{calc}                         % TIKZ calculations
\RequirePackage[framemethod=tikz]{mdframed}   % breakable framed and coloured boxes

%% Set document color scheme
\RequirePackage{xcolor}                       % driver indepentent color extensions
\definecolor{black50}{gray}{0.5}              % 50% black for hrules
\definecolor{color0}{RGB}{0,0,0}              % Base
\definecolor{color1}{RGB}{59,90,198}          % author email, doi

% Tables 
\RequirePackage{
  booktabs,                                   % overall nice table quality
  array,                                      % better column and row definitions
  longtable,                                  % for tables spanning multiple pages
  makecell,                                   % multilined table cells
  tabularx,                                   % width-expanding column (with 'x')
  multirow,                                   % for multirow cells (with \\)
  colortbl                                    % to add colours to table cells
}
% booktabs provide nice spacing, but rule widths and distances need modifying
\setlength{\heavyrulewidth}{0.5pt}            % wide rule
\setlength{\lightrulewidth}{0.5pt}            % light rule
\setlength{\aboverulesep}{1.5pt}              % blank space above rules
\setlength{\belowrulesep}{1.5pt}              % blank space below rules
\setlength{\belowbottomsep}{5pt}              % blank space below whole table
\AtBeginEnvironment{tabular}{%                % font inside tables will be small
  \sffamily\fontsize{7.5}{10}\selectfont
}
%% command we can use to add some text e.g. below the table
\newcommand{\addtabletext}[1]{{\setlength{\leftskip}{9pt}\fontsize{7}{9}\selectfont#1}}

% Code snippets/listings
\RequirePackage{listings}

% Equations
% placed in square brackets
\renewcommand\tagform@[1]{\maketag@@@ {[\ignorespaces #1\unskip \@@italiccorr ]}}
% For numbering just one line of an equation
\newcommand\numberthis{\addtocounter{equation}{1}\tag{\theequation}}

%%%%%%%%%%%%%%%%%%%%%% Floats, subfloats and their captions

\RequirePackage{float}                        % improved interface for floating objects
\RequirePackage{dblfloatfix}                  % fixes for twocolumn floats
\RequirePackage{placeins}            % for the floatbarrier macro

% distance between floats and text
\setlength{\textfloatsep}{6pt \@plus 2.0pt \@minus 2.0pt}
% distance between two floats
\setlength{\floatsep}{8pt \@plus 2.0pt \@minus 2.0pt}

% Better captions 
\RequirePackage[
  skip=3pt,                                   % vertical space between caption and figure
  labelfont={bf,sf},                          % we bold the caption label
  labelsep=colon,                             % periods after label (Fig. 1:)
  figurename=Fig.,                            % figure will be abbreviated
  % tablename=Tbl.,                             % table will be abbreviated
]{caption}
% overall font types (excluding label)
\DeclareCaptionFormat{fmt}{\normalfont\sffamily\fontsize{7}{9}\selectfont#1#2#3}
\captionsetup*{format=fmt}                        % for figures
\captionsetup*[table]{format=fmt,position=above}  % for tables

% Subfigures
\RequirePackage{subcaption}

% Sidecaptions
\RequirePackage[rightcaption]{sidecap}

%%%%%%%%%%%%%%%%%%%%%% Utilities

% Filler text
\RequirePackage{lipsum}

% Todo notes
\RequirePackage{todonotes}

%%%%%%%%%%%%%%%%%%%%%% Science-related packages

% In-line fractions
\RequirePackage{xfrac}

% The SIunitx package enables the \SI{}{} command.
\RequirePackage{siunitx}
\sisetup{
  detect-weight=true,
  detect-family=true,
  per-mode=reciprocal,
  range-units=single,       % brief SIrange
  range-phrase=--           % and using lines
}

% The mchem package for formula subscripts using \ce{}
\RequirePackage[version=4]{mhchem}

%%%%%%%%%%%%%%%%%%%%%% Bibliography, footnotes and their settings

% Natbib package for text references
\RequirePackage[
    numbers,                % numbers as references
    merge,                  % merge multiple references in one
    super,                  % superscript
    sort&compress
]{natbib}

% Moves references after punctuation
\RequirePackage{natmove}
\renewcommand*{\natmovechars}{.}  % only after full stop

% Bibliography style
%% No separation between references
\setlength{\bibsep}{0.0pt}
%% Use pi-bib.bst as a styla (if available) else fall back to unsrtnat
\IfFileExists{templates/pi/pi-bib.bst}{
  \bibliographystyle{templates/pi/pi-bib}
}{
  \IfFileExists{pi-bib.bst}{
  \bibliographystyle{pi-bib}
  }{
    \PackageWarning{pi-bib}{templates/pi/pi-bib.bst not found; must specify manually}
    \bibliographystyle{unsrt}
}}
%% set Bibliography font
\renewcommand\bibfont{\normalfont\sffamily\fontsize{6}{8}\selectfont}
%% Use "References" as bibliography title
\renewcommand{\bibname}{References}
\renewcommand{\refname}{References}
\AtEndOfClass{
  \renewcommand{\tocbibname}{References}
}
%% Remove brackets from label
\renewcommand\@biblabel[1]{ #1.}

% Footnotes
\RequirePackage[flushmargin,ragged,symbol*]{footmisc}
\renewcommand*{\footnotelayout}{\footnotefont}
\renewcommand{\footnoterule}{% Set the footnote hrule style
  \kern -3pt
  {\color{black50} \hrule width 72pt height 0.25pt}
  \kern 2.5pt
}

%%%%%%%%%%%%%%%%%%%%%% References and bookmarks

% Xr:
% To reference another document, in this case the SI
\RequirePackage{xr, xr-hyper}

% Hyperlinking
\RequirePackage[
  colorlinks=true,
  allcolors=blue,
  pagebackref=false
]{hyperref}
%% Set URL link color & font
\renewcommand\UrlFont{\color{black}\sffamily}

% References
\RequirePackage[
  capitalise,
  nameinlink,
]{cleveref}

% Equation reference label has no brackets
\creflabelformat{equation}{#2\textup{#1}#3}

\RequirePackage{doi} % DOIs
\RequirePackage[nottoc]{tocbibind} % References section in TOC (for SI)

%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% Other Setup

%%%%%%%%%%%%%%%%%%%%%% Author and affiliation

% Keeps footnotes where they should be
\RequirePackage{titling}
\setlength\thanksmarkwidth{0em}
\setlength\thanksmargin{-\thanksmarkwidth}

% Typesetting for authors/affiliations
\RequirePackage{authblk}
\setlength{\affilsep}{8.5pt} % 16.5pts between base of author line and base of affil line
\renewcommand\Authfont{\color{color0}\normalfont\sffamily\bfseries\fontsize{9}{11}\selectfont}
\renewcommand\Affilfont{\color{color0}\footnotefont}
\renewcommand\AB@affilsepx{\newline\protect\Affilfont}
\renewcommand\Authands{, and }

%%%%%%%%%%%%%%%%%%%%%% Author and paper metadata

%% ORCID logo
\definecolor{orcidlogocol}{HTML}{A6CE39}
\tikzset{
  orcidlogo/.pic={
    \fill[orcidlogocol] svg{M256,128c0,70.7-57.3,128-128,128C57.3,256,0,198.7,0,128C0,57.3,57.3,0,128,0C198.7,0,256,57.3,256,128z};
    \fill[white] svg{M86.3,186.2H70.9V79.1h15.4v48.4V186.2z}
                 svg{M108.9,79.1h41.6c39.6,0,57,28.3,57,53.6c0,27.5-21.5,53.6-56.8,53.6h-41.8V79.1z M124.3,172.4h24.5c34.9,0,42.9-26.5,42.9-39.7c0-21.5-13.7-39.7-43.7-39.7h-23.7V172.4z}
                 svg{M88.7,56.8c0,5.5-4.5,10.1-10.1,10.1c-5.6,0-10.1-4.6-10.1-10.1c0-5.6,4.5-10.1,10.1-10.1C84.2,46.7,88.7,51.3,88.7,56.8z};
  }
x}

%% Article meta data additional fields
\newcommand{\pubdoi}[1]{\def\@pubdoi{#1}}                     % publication DOI
\newcommand{\keywords}[1]{\def\@keywords{#1}}                 % keywords
\newcommand{\sep}[0]{; }                                      % keyword separator
\newcommand{\contact}[1]{\def\@contact{#1}}                   % contact author
\newcommand{\leadauthor}[1]{\def\@leadauthor{#1}}             % lead (first) author
\newcommand{\equalcontrib}[1]{\def\@equalcontrib{#1}}         % equal contribution switch
\newcommand{\acknow}[1]{\def\@acknow{#1}}                     % ORCID
\newcommand{\orcid}[1]{                                       % ORCID
  \href{https://orcid.org/#1}{\mbox{
    \begin{tikzpicture}[overlay,remember picture]
      \coordinate (A);
      \coordinate (B) at ($(A)-(6pt,-8pt)$);
    \end{tikzpicture}
    \begin{tikzpicture}[overlay,remember picture,yscale=-0.04,xscale=0.04,transform shape]
      \pic at (B) {orcidlogo};
    \end{tikzpicture}
    }{}}}

%%%%%%%%%%%%%%%%%%%%%% Headers and footers

%% Fancyhdr styling
\RequirePackage{fancyhdr}  % custom headers/footers
\pagestyle{fancy}          % Set all pagestyle to fancy

% Clear everything
\fancyhf{}

% Headers
\renewcommand{\headrulewidth}{0pt}                                      % No header rule normally

% Footers
\renewcommand{\footrulewidth}{0pt}                                      % No footer rule normally
\fancyfoot[R]{%                                                         % footer right side
  \iftoggle{shortintro}{
    \footerfont\textit{Supplementary Information}\hspace{7pt}|%         % we add SI as text
  }{
    \footerfont\textit{Preprint}\hspace{7pt}|%                          % we add preprint
  }
  \hspace{7pt}\textbf{\today}\hspace{7pt}|%                             % add date
  \hspace{7pt}\textbf{\thepage}}                                        % add page number
\fancyfoot[L]{%                                                         % footer left side
  \footerfont\@ifundefined{@pubdoi}{}{%
      \href{https://dx.doi.org/\@pubdoi}{DOI: \@pubdoi}}                % add DOI + hyperlink
% \footerfont\@ifundefined{@leadauthor}{}{\@leadauthor}%                  % lead author name
% \ifnum \value{authors} > 1\textit{ et al.}\fi%                          % and et.al.
}

% Modifying the plain style (applied automatically with title page)
\fancypagestyle{plain}{%
    \fancyhf{}                                                          % clear everything
    \iftoggle{toprule}{%                                                % if SI, we add a top rule
        \fancyhead[L]{%                                                 % Add article type and rule
          \colorbox{black}{\parbox{18em}{\centering\color{white}\subtitlefont{\arttype}}}}
        \renewcommand{\headrulewidth}{3pt}%
    }{}
    \fancyfoot[R]{                                                      % footer right side
    \iftoggle{shortintro}{
      \footerfont\textit{Supplementary Information}\hspace{7pt}|%       % we add SI as text
    }{
      \footerfont\textit{Preprint}\hspace{7pt}|%       % we add preprint
    }
      \hspace{7pt}\textbf{\today}\hspace{7pt}|%                         % add date
      \hspace{7pt}\textbf{\thepage\textendash\pageref{LastPage}}}       % add page number
    \fancyfoot[L]{\footerfont\@ifundefined{@pubdoi}{}{%                 % footer left side
      \href{https://dx.doi.org/\@pubdoi}{DOI: \@pubdoi}}}               % add DOI + hyperlink
}

%%%%%%%%%%%%%%%%%%%%%% Line numbers

% Check switch for line numbers
\if@switchlineno
  \iftoggle{singlecolumn}{
    \RequirePackage{lineno}
  }{% use lineno in switch mode if doublecolumn
    \RequirePackage[switch]{lineno}
  }
  \renewcommand\linenumberfont{\normalfont\tiny\sffamily}
  \linenumbers
\fi

%%%%%%%%%%%%%%%%%%%%%% Typesetting

%% Section/subsection/paragraph set-up
\RequirePackage[explicit]{titlesec}
\setcounter{secnumdepth}{5}

\titleformat{\section}
  {\large\sffamily\bfseries}
  {\thesection.}
  {0.5em}
  {#1}
  []
\titleformat{name=\section,numberless}
  {\large\sffamily\bfseries}
  {}
  {0em}
  {#1}
  []  
\titleformat{\subsection}[runin]
  {\sffamily\bfseries}
  {\thesubsection.}
  {0.5em}
  {#1. }
  []
\titleformat{\subsubsection}[runin]
  {\sffamily\bfseries}
  {\thesubsubsection.}
  {0.5em}
  {#1. }
  []
\titleformat{\paragraph}[runin]
  {\sffamily\small\bfseries}
  {}
  {0em}
  {#1}
\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{5pt}
\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{2pt}
\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{2pt}
\titlespacing*{\paragraph}{0pc}{1.5ex \@plus2pt \@minus1pt}{12pt}

%% Abstract formatting
\def\xabstract{abstract}
\long\def\abstract#1\end#2{
  \def\two{#2}
  \ifx\two\xabstract
    \long\gdef\theabstract{\ignorespaces#1}
    \def\go{\end{abstract}}
  \else
    \typeout{^^J^^J PLEASE DO NOT USE ANY \string\begin\space \string\end^^J COMMANDS WITHIN ABSTRACT^^J^^J}#1\end{#2}
    \gdef\theabstract{%
      \vskip12pt BADLY FORMED ABSTRACT: PLEASE DO NOT USE {\tt\string\begin...\string\end} COMMANDS WITHIN THE ABSTRACT\vskip12pt%
    }\let\go\relax
  \fi
\go}

% Define an environment with abstract content and styling
\newcommand{\abscontent}{
  \noindent
  {%
    \vskip3pt%
    \if@switchtoc
      \begin{minipage}{0.59\linewidth}
        \absfont \theabstract
      \end{minipage}
      \begin{minipage}[L]{0.4\linewidth}
        \raggedleft
        \IfFileExists{figs/tocfig.png}{% no good way of checking for extension
        \includegraphics[width=0.9\linewidth]{figs/tocfig}}
        {\IfFileExists{figs/tocfig.bmp}{
        \includegraphics[width=0.9\linewidth]{figs/tocfig}}
        {\IfFileExists{figs/tocfig.pdf}{
        \includegraphics[width=0.9\linewidth]{figs/tocfig}}
        }{\includegraphics[width=0.9\linewidth]{example-image}}}
      \end{minipage}
    \else
      \begin{minipage}{\linewidth}
        \absfont \theabstract
      \end{minipage}
    \fi
  }%
  \vskip10pt%
  \noindent
  \@ifundefined{@abstractadd}{}{%
  {%
    \parbox{\linewidth}{%
    \abstractaddfont \@abstractadd}%
  }%
  \vskip10pt%
  }%
  \noindent
  \@ifundefined{@keywords}{}{%
  {%
    \parbox{\linewidth}{%
    \keywordsfont %
    \textbf{Keywords:} \@keywords}%
  }%
  \vskip10pt%
  }%
}

%% Manual adjustment of vertical distance, useful for overall formatting
\newlength\vert@adjust
\newcommand\verticaladjustment[1]{\setlength{\vert@adjust}{#1}}

%% Command to define an affiliation list in a footnote
\def\authaffil{%
  \if@switchaffil
    \@author\par%
    \vskip2pt
  \else
    \AB@authlist\par
    \protected@xdef\@thanks{\@thanks\protect\footnotetext[\the\c@footnote]{\AB@affillist\newline}}%
  \fi
}

%% Command to define a contact email switch
\def\contactswitch{%
  \contactfont\@ifundefined{@contact}{}{\textbf{\normalfont*}~E-Mail:~\@contact}\par%
  %
  \vskip3pt
}

%% Command to define an "equal contribution" switch
\def\equalcontribswitch{
  \footerfont\@ifundefined{@equalcontrib}{}{\textsuperscript{\textbf{\dag}}~These authors contributed equally}\par%
  %
  \vskip3pt
}

%%%% Custom title page
\renewcommand{\@maketitle}{%
\iftoggle{shortintro}
{% if short intro i.e. SI
  % patch author command to center section
  \patchcmd{\@author}{\raggedright}{\centering}{}{}
  %
  \topskip0pt
  \vspace*{\fill}%
  %
  {\centering\baselineskip=24pt\subtitlefont Supplementary Information for\par}%
  {\centering\baselineskip=24pt\titlefont \@title\par}%
  %
  \vskip10pt
  %
  % author names / addresses
  {\centering\authaffil{}}
  %
  \vskip8pt
  %
  % equal contribution
  {\centering\equalcontribswitch{}}
  % corresponding email
  {\centering\contactswitch{}}
  %
  \vspace*{\fill}%
}
{% else if complete paper
  %
  \vskip20pt%
  %
  {\raggedright\baselineskip=24pt\titlefont \@title\par}%
  %
  \vskip10pt
  %
  % author names / addresses
  \authaffil{}
  %
  \vskip3pt
  %
  % equal contribution
  \equalcontribswitch{}
  % corresponding email
  \contactswitch{}
  % abstract / TOC section
  {\abscontent{}}
  %
  \noindent\makebox[\linewidth]{\rule{\linewidth}{0.4pt}}%
  %
  \vskip15pt%
}%
\@ifundefined{vert@adjust}{}{\vskip\vert@adjust}%
}%
