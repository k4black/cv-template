%%%%%%%%%%%%%%%%%
% This is altacv.cls (v1.6.5, 3 Nov 2022) written by
% LianTze Lim (liantze@gmail.com).
%
%% It may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.3
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%    http://www.latex-project.org/lppl.txt
%% and version 1.3 or later is part of all distributions of LaTeX
%% version 2003/12/01 or later.
%%
%%
% Contributions:
% - https://github.com/akreuzer Added ragged2e option (5 Nov 2018)
% - https://github.com/stefanogermano Fixed bad boxes and undefined font shape (July 2018)
% - https://github.com/foohyfooh Fixed blank spaces in \cvevent and bad link in README.md (June 2018)
% - https://github.com/logological Remove redundant hyperref and typos (Apr 2021)

%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{altacv}[2022/11/03 AltaCV v1.6.5, yet another alternative class for a resume/curriculum vitae.]

%% v1.1: Optionally load academicons
%% v1.4: Nope, academicons is unnecessary; fontawesome5 has \faOrcid.
\DeclareOption{academicons}{\ClassWarning{altacv}{academicons option is now obsolete and unnecessary.}}
%% v1.1.3: Choice of round/square photo
\newif\if@normalphoto
\DeclareOption{normalphoto}{\@normalphototrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{extarticle}}
\newif\if@raggedtwoe
\DeclareOption{ragged2e}{\@raggedtwoetrue}
%% v1.3: load hyperref for clickable hyperlinks
\newif\if@withhyper
\DeclareOption{withhyper}{\@withhypertrue}
%% new: Optional debug mode
\newif\if@debug
\DeclareOption{debug}{\@debugtrue}
\ProcessOptions\relax

\LoadClass{extarticle}
%% v1.3.2 Hopefully this helps make the PDF
%% file more 'friendly' with copy-paste etc
\RequirePackage{etoolbox}
\RequirePackage[a-1b]{pdfx}
\RequirePackage{accsupp}
\RequirePackage[margin=2cm]{geometry}
\RequirePackage[fixed]{fontawesome5}  % http://mirrors.ibiblio.org/CTAN/fonts/fontawesome5/doc/fontawesome5.pdf
\RequirePackage{ifxetex,ifluatex}
\RequirePackage{scrlfile}
\RequirePackage{xparse}

%% new: for using \today
\RequirePackage[en-US]{datetime2}

%% new: Aux
\RequirePackage{calc} % http://ctan.org/pkg/calc
\RequirePackage{setspace}

%% new: Debug mode pkg
\if@debug
    \RequirePackage{showframe}
    \RequirePackage{longfbox}
    \fboxset{padding=0pt,margin=0pt,baseline-skip=false,border-style=dashed}
\else
    \RequirePackage[noframe]{showframe}
\fi%

%% new: update links style, keep color add iconed href command
% use \href{<url>}{<text>} or \ihref[<icon>]{<url>}{<text>}
\PassOptionsToPackage{hidelinks}{hyperref}
\RequirePackage[hidelinks]{hyperref}
\newcommand{\ihref}[3][\raisebox{0.08em}{\scriptsize{\faLink[regular]}}\normalsize]{\href{#2}{#1\hspace{-0.1em}#3}}
\pagenumbering{arabic}

%% new: Footer with meta-info, setup footer to cover the full width
\RequirePackage{fancyhdr}
\setlength{\headwidth}{\textwidth}
\addtolength{\headwidth}{0.73\marginparwidth}
\pagestyle{fancy}
\fancyhf{}
%\fancyhfoffset{0em}
\renewcommand{\headrulewidth}{0pt}  % Remove head rule
\renewcommand{\footruleskip}{0.5cm}  % shift footer down

%% v1.1.5: added for convenience
\newif\ifxetexorluatex
\ifxetex
  \xetexorluatextrue
\else
  \ifluatex
    \xetexorluatextrue
  \else
    \xetexorluatexfalse
  \fi
\fi

\ifxetexorluatex
  \RequirePackage{fontspec}
\else
  %% v1.3.2 attempts to make ligatures
  %% copy-paste as normal characters
  \RequirePackage{cmap}
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[T1]{fontenc}
  \input{glyphtounicode}
  \pdfglyphtounicode{f_f}{FB00}
  \pdfglyphtounicode{f_f_i}{FB03}
  \pdfglyphtounicode{f_f_l}{FB04}
  \pdfglyphtounicode{f_i}{FB01}
  \pdfgentounicode=1
\fi

\if@raggedtwoe
  \RequirePackage[newcommands]{ragged2e}
\fi

\if@withhyper
  \AtBeginDocument{%
    \hypersetup{hidelinks}
    \urlstyle{same}
  }
\fi

\RequirePackage{xcolor}

\colorlet{accent}{blue!70!black}
\colorlet{emphasis}{black}
\colorlet{heading}{black}
\colorlet{headingrule}{black}
\colorlet{subheading}{emphasis}
\colorlet{body}{black!80!white}
\colorlet{name}{heading}
\colorlet{tagline}{accent}
\colorlet{light}{lightgray}  %% new: for tags and footer
\newcommand{\itemmarker}{{\small\textbullet}}
\newcommand{\ratingmarker}{\faCircle}

\RequirePackage{tikz}
\usetikzlibrary{arrows}
\RequirePackage[skins]{tcolorbox}
\RequirePackage[inline]{enumitem}
\setlist{leftmargin=*,labelsep=0.5em,nosep,itemsep=0.2\baselineskip,after=\vskip0.25\baselineskip}
\setlist[itemize]{label=\itemmarker}
\RequirePackage{graphicx}
\RequirePackage{trimclip}
\RequirePackage{dashrule}
\RequirePackage{multirow,tabularx}
\RequirePackage{changepage}
% \RequirePackage{marginfix}

\setlength{\parindent}{0pt}
\newcommand{\divider}{\textcolor{body!30}{\hdashrule{\linewidth}{0.6pt}{0.5ex}}\medskip}

\newenvironment{fullwidth}{%
  \begin{adjustwidth}{}{\dimexpr-\marginparwidth-\marginparsep\relax}}
  {\end{adjustwidth}}

%% v1.3.1 \detokenize will break UTF-8 in pdflatex
%% Using alternative from https://tex.stackexchange.com/a/530911/226
\newcommand{\utffriendlydetokenize}[1]{%
\scantokens{%
  \catcode`\_=12%
%   \catcode`\^=12%
%   \catcode`\{=12%
%   \catcode`\}=12%
  \catcode`\&=12%
  \catcode`\$=12%
  \catcode`\#=12%
  \catcode`\~=12%
%   \catcode`\\=12%
  {#1}%
}%
}
%% v1.3: Incorporating hyperlinks
%% v1.3.1: using \unfriendlydetokenize to avoid breaking unicode
%% v1.6: Use accsupp so that when copying/pasting the icon from PDF to a text
%%       file, the icon name is pasted
\ExplSyntaxOn
\NewDocumentCommand{\printinfo}{m m o}{%
  \BeginAccSupp{method=escape,ActualText={#1:~#2}}
  \IfNoValueTF{#3}{%
    \mbox{\textcolor{accent}{\normalfont #1}~\utffriendlydetokenize{#2}\hspace{2em}}%
  }{%
     \if@withhyper%
      \mbox{\textcolor{accent}{\normalfont #1}~
      \href{#3}{\utffriendlydetokenize{#2}}\hspace{2em}}
     \else%
       \ClassWarning{Please specify [withhyper] option to enable hyperlinks. Printing out full hyperlink prefix #1 for now.}%
      \mbox{\textcolor{accent}{\normalfont #1}~{\utffriendlydetokenize{#3#2}}\hspace{2em}}%
     \fi%
  }%
  \EndAccSupp{}
}%


%% v1.3: Exploring convenient creation of fields
%% v1.6: Add starred mode to create \printinfo with full URL
\NewDocumentCommand{\NewInfoField}{s m m o}{%
  \IfBooleanF{#1}{
    \IfNoValueF{#4}{\csdef{#2 hyperprefix}{#4}}%
  }
  \csdef{#2 symbol}{#3}%
  \IfBooleanTF{#1}
    { \csdef{#2}##1##2{%
        \if@withhyper
          \IfNoValueTF {##2}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[##2]}%
        \else
          \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
      }%
    }
    { \csdef{#2}##1{%
        \if@withhyper
          \IfNoValueTF {#4}
            {\printinfo{\csuse{#2 symbol}}{##1}}%
            {\printinfo{\csuse{#2 symbol}}{##1}[\csuse{#2 hyperprefix}##1]}%
        \else
          \printinfo{\csuse{#2 symbol}}{##1}%
        \fi%
      }%
    }
}
\ExplSyntaxOff

\newcommand{\name}[1]{\def\@name{#1}}
\newcommand{\tagline}[1]{\def\@tagline{#1}}
\newcommand{\personalinfo}[1]{\def\@personalinfo{#1}}
\NewInfoField{email}{\faAt}[mailto:]
\NewInfoField{mailaddress}{\faEnvelope}
\NewInfoField{phone}{\faPhone}[tel:]
\NewInfoField{homepage}{\faGlobe}[https://]
\NewInfoField{twitter}{\faTwitter}[https://twitter.com/]
\NewInfoField{linkedin}{\faLinkedinIn}[https://linkedin.com/in/]
\NewInfoField{github}{\faGithub}[https://github.com/]
% v1.?? Use fontawesome5 for Orcid symbol
\NewInfoField{orcid}{\faOrcid}[https://orcid.org/]
\NewInfoField{location}{\faMapMarker*}

% v1.2: Support for multiple photos
\newlength{\altacv@photos@width}
\newlength{\altacv@photo@diam@left}
\newlength{\altacv@photo@diam@right}
\def\altacv@left@photos{}
\def\altacv@right@photos{}

\newcommand{\@makeaphoto}[2]{%
  \begin{minipage}{#1}%
    \if@normalphoto
      \includegraphics[width=\linewidth]{#2}
    \else
      \tikz\path[fill overzoom image={#2}]circle[radius=0.5\linewidth];
    \fi%
  \end{minipage}%
}

\newcommand{\altacv@add@photo@left}[1]{%
  \appto{\altacv@left@photos}{%
    \@makeaphoto{\altacv@photo@diam@left}{#1}\hspace{1ex}%
  }%
  \addtolength{\altacv@photos@width}{\altacv@photo@diam@left}%
  \addtolength{\altacv@photos@width}{1ex}%
}
\newcommand{\altacv@add@photo@right}[1]{%
  \appto{\altacv@right@photos}{%
    \@makeaphoto{\altacv@photo@diam@right}{#1}\hspace{1ex}%
  }%
  \addtolength{\altacv@photos@width}{\altacv@photo@diam@right}%
  \addtolength{\altacv@photos@width}{1ex}%
}
\newcommand{\photoL}[2]{%
  \setlength{\altacv@photo@diam@left}{#1}%
  \forcsvlist{\altacv@add@photo@left}{#2}%
}
\newcommand{\photoR}[2]{%
  \setlength{\altacv@photo@diam@right}{#1}%
  \forcsvlist{\altacv@add@photo@right}{#2}%
}
\let\photo\photoR

\newcommand{\namefont}{\Huge\bfseries}
\newcommand{\taglinefont}{\large\bfseries}
\newcommand{\personalinfofont}{\footnotesize\bfseries}
\newcommand{\cvsectionfont}{\LARGE\bfseries}
\newcommand{\cvsubsectionfont}{\large\bfseries}

\newcommand{\makecvheader}{%
  \begingroup
    \altacv@left@photos\hfill%
    \begin{minipage}{\dimexpr\linewidth-\altacv@photos@width}%
    \raggedright%
    {\namefont\color{name}\MakeUppercase{\@name}\par}
    \medskip
    {\taglinefont\color{tagline}\@tagline\par}
    \medskip
    {\personalinfofont\@personalinfo\par}
    \end{minipage}\hfill%
    \altacv@right@photos\par%
  \endgroup\medskip
}
%% new: Define a footer for CV
% Usage \makecvfooter{<left>}{<center>}{<right>}
\newcommand*{\makecvfooter}[3]{%
  \fancyfoot{}  % clear all footer fields
  \fancyfoot[L]{\small\color{light}\textit{#1}}
  \fancyfoot[C]{\small\color{light}\textit{#2}}
  \fancyfoot[R]{\small\color{light}\textit{#3}}
}

\renewenvironment{quote}{\color{accent}\itshape\large}{\par}

\newcommand{\cvsection}[2][]{%
  \nointerlineskip\bigskip%  %% bugfix in v1.6.2
  \ifstrequal{#1}{}{}{\marginpar{\vspace*{\dimexpr1pt-\baselineskip}\raggedright\input{#1}}}%
  {\color{heading}\cvsectionfont\MakeUppercase{#2}}\\[-1ex]%
  {\color{headingrule}\rule{\linewidth}{2pt}\par}%\medskip
}

\newcommand{\cvsubsection}[1]{%
  \smallskip%
  {\color{subheading}\cvsubsectionfont{#1}\par}\medskip
}

%% new: minipage box to limit width
% usage \cvbox{<width percent>}{<content>}
\newcommand{\cvbox}[2][\linewidth]{%
\lfbox{\begin{minipage}[t]{#1}%
    \vspace{0pt}% anchor for [t]
    #2%
\end{minipage}}%
}

%% new: split into 2 columns right and left aligned
% usage \cvsplit[0.8]{left column content}{right column}
\newcommand{\cvsplit}[4][0.8]{%
    \noindent%
    \cvbox[#1 \linewidth - 0.015 \linewidth]{\raggedright#2}%
    \hspace{0.01 \linewidth}
    \hfill
    \cvbox[1\linewidth - #1\linewidth - 0.015\linewidth]{\raggedleft#3}%
    \par%
}


% v1.1.4: fixes inconsistent font size
%% new: update the layout of the cventry
% \newcommand{\cvevent}[4]{%
%   {\large\color{emphasis}#1\par}
%   \smallskip\normalsize
%   \ifstrequal{#2}{}{}{
%   \textbf{\color{accent}#2}\par
%   \smallskip}
%   \ifstrequal{#3}{}{}{{\small\makebox[0.5\linewidth][l]{\faCalendar~#3}}}%
%   \ifstrequal{#4}{}{}{{\small\makebox[0.5\linewidth][l]{\faMapMarker~#4}}}\par
%   \medskip\normalsize
% }
\newcommand{\cvevent}[4]{%
    \cvsplit{%
        \large\color{emphasis}#1\par %Title
        \normalsize
        \ifstrequal{#2}{}{\smallskip}{
            \textbf{\color{accent}#2}\ifstrequal{#4}{}{}{\color{accent}\hspace{-0.45em},\hspace{0.3em}#4}% company + location line
            \par % accent subtitle
        \smallskip}%
    }{%
        \ifstrequal{#3}{}{}{\small\faCalendar[regular]\hspace{0.5em}#3}% date line
    }%
    \smallskip\normalsize
}

\newcommand{\cvachievement}[3]{%
  \begin{tabularx}{\linewidth}{@{}p{2em} @{\hspace{1ex}} >{\raggedright\arraybackslash}X@{}}
  \multirow{2}{*}{\Large\color{accent}#1} & \bfseries\textcolor{emphasis}{#2}\\
  & #3
  \end{tabularx}%
  \smallskip
}

%% new: Tag command e.g. [Python] (colored with experience level)
% usage: \cvtag[50]{tag-content} (0, 10, 20 ,30 ,40)
% TODO: 0-5 score convert to gradient
\newcommand{\cvsmalltagraw}[2][0]{%
    \tikz[baseline]\node[anchor=base,draw=body!30,fill=accent!#1,rounded corners=1.2ex,inner xsep=0.6ex,inner ysep=0.6ex,text height=1.2ex,text depth=0.0ex,minimum height=1.2ex]{#2};
}
\newcommand{\cvsmalltag}[2][0]{%
    \small\cvsmalltagraw[#1]{#2}\normalsize%
}
\newcommand{\cvsmalltagline}[1]{%
%    \footnotesize{\foreach \n in {#1}{\cvsmalltagraw{\color{body!50}\n}}}\par
    \footnotesize{\foreach \n in {#1}{\cvsmalltagraw{\color{light}\n}}}\par
    % \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners=0.8ex,inner xsep=0.1ex,inner ysep =0.4ex,text height=1.0ex,text depth=0.05ex,minimum height=1.20x]{\scriptsize#1};
}

\newcommand{\cvtag}[1]{%
  \tikz[baseline]\node[anchor=base,draw=body!30,rounded corners,inner xsep=1ex,inner ysep =0.75ex,text height=1.5ex,text depth=.25ex]{#1};
}

% v1.6: Use accsupp so that the actual numeric value is copied/pasted
%       and also support 0.5, 1.5, 2.5, 3.5, 4.5
\newcommand{\cvskill}[2]{%
  \textcolor{emphasis}{\textbf{#1}}\hfill
  \BeginAccSupp{method=plain,ActualText={#2}}
  \foreach \x in {1,...,5}{%
    \ifdimequal{\x pt - #2 pt}{0.5pt}%
    {\clipbox*{0pt -0.25ex {.5\width} {\totalheight}}{\color{accent}\ratingmarker}%
     \clipbox*{{.5\width} -0.25ex {\width} {\totalheight}}{\color{body!30}\ratingmarker}}
    {\ifdimgreater{\x bp}{#2 bp}{\color{body!30}}{\color{accent}}\ratingmarker}%
  }\EndAccSupp{}\par%
}

% Adapted from @Jake's answer at http://tex.stackexchange.com/a/82729/226
\newcommand{\wheelchart}[4][0]{%
    \begingroup\centering
    \def\innerradius{#3}%
    \def\outerradius{#2}%
    % Calculate total
    \pgfmathsetmacro{\totalnum}{0}%
    \foreach \value/\colour/\name in {#4} {%
        \pgfmathparse{\value+\totalnum}%
        \global\let\totalnum=\pgfmathresult%
    }%
    \begin{tikzpicture}

      % Calculate the thickness and the middle line of the wheel
      \pgfmathsetmacro{\wheelwidth}{\outerradius-\innerradius}
      \pgfmathsetmacro{\midradius}{(\outerradius+\innerradius)/2}
      \pgfmathsetmacro{\totalrot}{-90 + #1}

      % Rotate so we start from the top
      \begin{scope}[rotate=\totalrot]

      % Loop through each value set. \cumnum keeps track of where we are in the wheel
      \pgfmathsetmacro{\cumnum}{0}
      \foreach \value/\width/\colour/\name in {#4} {
            \pgfmathsetmacro{\newcumnum}{\cumnum + \value/\totalnum*360}

            % Calculate the percent value
            \pgfmathsetmacro{\percentage}{\value/\totalnum*100}
            % Calculate the mid angle of the colour segments to place the labels
            \pgfmathsetmacro{\midangle}{-(\cumnum+\newcumnum)/2}

            % This is necessary for the labels to align nicely
            \pgfmathparse{
               (-\midangle>180?"west":"east")
            } \edef\textanchor{\pgfmathresult}
            \pgfmathparse{
               (-\midangle>180?"flush left":"flush right")
            } \edef\textalign{\pgfmathresult}
            \pgfmathsetmacro\labelshiftdir{1-2*(-\midangle<180)}

            % Draw the color segments. Somehow, the \midrow units got lost, so we add 'pt' at the end. Not nice...
            \filldraw[draw=white,fill=\colour] (-\cumnum:\outerradius) arc (-\cumnum:-(\newcumnum):\outerradius) --
            (-\newcumnum:\innerradius) arc (-\newcumnum:-(\cumnum):\innerradius) -- cycle;

            % Draw the data labels
            % v1.6: Use accsupp so that the numeric number is copied/pasted too
            \draw  [*-,thin,emphasis] node [append after command={(\midangle:\midradius pt) -- (\midangle:\outerradius + 1ex) -- (\tikzlastnode)}] at (\midangle:\outerradius + 1ex) [xshift=\labelshiftdir*0.5cm,inner sep=1ex, outer sep=0pt, text width=\width,anchor=\textanchor,align=\textalign,font=\small,text=body]{\BeginAccSupp{method=pdfstringdef,ActualText={\name: \value}}\name\EndAccSupp{}};
            % Set the old cumulated angle to the new value
            \global\let\cumnum=\newcumnum
        }
      \end{scope}
%      \draw[gray] (0,0) circle (\outerradius) circle (\innerradius);
    \end{tikzpicture}\par
    \endgroup
}

\newcommand{\cvref}[3]{%
  \smallskip
  \textcolor{emphasis}{\textbf{#1}}\par
  \begin{description}[font=\color{accent},style=multiline,leftmargin=1.35em,align=left]
  \item[\small\normalfont\emailsymbol] #2
  \item[\small\normalfont\mailaddresssymbol] #3
  \end{description}
%   \medskip
}

\newenvironment{cvcolumn}[1]{\begin{minipage}[t]{#1}\raggedright}{\end{minipage}}

% v1.5 Move biblatex-related code to separate .cfg file
% so that it's easier to change and customise the style for
% publication lists

% v1.1.2: make it easier to add a sidebar aligned with top of next page
\RequirePackage{afterpage}
\newcommand{\addsidebar}[2][]{\marginpar{%
  \ifstrequal{#1}{}{}{\vspace*{#1}}%
  \input{#2}}%
}
\newcommand{\addnextpagesidebar}[2][]{\afterpage{\addsidebar[#1]{#2}}}

% v1.6.5 But provide for ability to highlight names in publication list
\RequirePackage{pgffor}
\def\my@namelist{}
\newcommand{\mynames}[1]{\def\my@namelist{#1}}
\newtoggle{boldname}
\AddToHook{package/biblatex/after}{
\renewcommand*{\mkbibnamefamily}[1]{%
  \global\togglefalse{boldname}%
  \foreach \my@fname / \my@gname in \my@namelist {%
    \ifboolexpr{ test {\ifdefstrequal{\namepartfamily}{\my@fname}}
                 and
                 test {\ifdefstrequal{\namepartgiven}{\my@gname}}}
      {\global\toggletrue{boldname}}{}%
  }%
  \iftoggle{boldname}{\textbf{#1}}{#1}%
}

\renewcommand*{\mkbibnamegiven}[1]{%
  \global\togglefalse{boldname}%
  \foreach \my@fname / \my@gname in \my@namelist{%
    \ifboolexpr{ test {\ifdefstrequal{\namepartfamily}{\my@fname}}
                 and
                 test {\ifdefstrequal{\namepartgiven}{\my@gname}}}
      {\global\toggletrue{boldname}\breakforeach}{}%
  }%
  \iftoggle{boldname}{\textbf{#1}}{#1}%
}
}

\AddToHook{begindocument/before}{%
  \pagestyle{empty}
  \color{body}
  \raggedright
}