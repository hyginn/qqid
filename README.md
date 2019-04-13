# qqid

###### [Boris Steipe](https://orcid.org/0000-0002-1134-6758), Department of Biochemistry and Department of Molecular Genetics, University of Toronto, Canada. &lt;boris.steipe@utoronto.ca&gt;

----

**If any of this information is ambiguous, inaccurate, outdated, or incomplete, please check the [most recent version](https://github.com/hyginn/rpt) of the package on GitHub and [file an issue](https://github.com/hyginn/rpt/issues).**

----

# 1 Overview:

## 1.1 UUIDs

UUIDs (**U**niversally **U**nique **IDs**) are a solution wherever identifiers need to be created that are unique, but there is litttle or no control over theyr source. An application could be for contributions of observation by a loosely knit group of researchers to a common database. Identifiers they create locally should be preserved in the common database - but we don't know who they are so we can't provide them with ranges of identifiers to use, they might contribute, then leave the project, then come back again, so adminestring prefixes could be a nightmare, and we still need every single ID to be uiquely identified. UUIDs solve this problem by drawing IDs randomly from a very large space of numbers. This means: in theory, two UUIDs could be the same by chance. But in practice, a random UUID is drawn from 2<sup>122</sup> numbers, i.e. the chance of observing the same number twice is 1 / 5.3e36 - and that is less than winning the 6 of 49 lottery **five times in a row**.

```text
f81d4fae-7dec-11d0-a765-00a0c91e6bf6
```
(A canonical representation of a UUID (from [RFC 4122](https://tools.ietf.org/html/rfc4122)).)

There are many possible sources for UUIDs: Simon Urbanek's R-package [**UUID**](https://CRAN.R-project.org/package=uuid) provides pseudo-random UUIDs with the `UUIDgenerate()` function. This is convenient, but can be compromised by a poorly initialized random number generator in R. Siegfried Köstlmeier's [**qrandom**](https://CRAN.R-project.org/package=qrandom) package includes the `qUUID()` function that uses the [QRNG](https://qrng.anu.edu.au/API/api-demo.php) server in Canberra, Australia, which provides high-bandwidth true random numbers from measurements of quantum fluctuations of the vacuum, to generate true random UUIDs that conform to [RFC 4122](https://tools.ietf.org/html/rfc4122) - the authoritative UUID specification.

So, what's the problem that QQIDs address?

&nbsp;

## 1.2 The need for humane numbers ...

While UUIDs are an excellent technical solution for the internals of data management systems, they are not exactly easy to distinguish by eye. Practice shows that when we put them into spreadsheets during data entry, or need to tell them apart during testing and debugging of analysis code, it is surprisingly useful to be able to tell UUIDs apart by actually looking at them.

&nbsp;

## 1.3 The QQID concept ...

QQIDs are a formatted variant of UUIDs. A UUID can be uniquely reformatted to be represented as a QQID, and uniquely recovered from it. But the QQID converts the first five hexadecimal numbers of the UUID to two words from a table of English four-letter, monosyllabic words. Taken by themselves, there are only on the order of 1e6 possible combinations of these words. But we are not replacing the UUID, we are just representing its first five letters differently, and none of the randomness gets lost. IDs that begin with different words are necessarily different. IDs that begin with the same words could be different - one needs to consider the rest of the ID. However the likelihood of them being different is small enough for an use case in which we would reasonably not be looking at more than, say, 1,000 IDs, i.e. giving a collision probability of less than 0.4 .


**Create an empty project, linked to an empty GitHub repository. Then fill it with the files from `rpt`. Then start developing.**

This is all it takes, but the details take care. You will go through the following steps:

1. Define your package name and create a new GithHub project;
2. Make a new RStudio project on your local machine that is linked to your GitHub project;
3. Download a ZIP archive of `rpt` and copy all the files over to your project folder;
4. Customize your files;
5. Save, check, commit, and push to GitHub;
6. Start developing.

That's all. Each step is described in detail below.

----

# 2 Details ...

&nbsp;

**Go through these instructions carefully, step by step.**

&nbsp;

## 2.0 Prerequisites

You need a current installation of [**R**](https://www.r-project.org/) and [**RStudio**](https://www.rstudio.com/products/rstudio/download/), `git`, and a [**GitHub**](https://github.com/) account that **has been set up to connect to your RStudio projects**. If any of this is new to you (or if you wish to brush up on the details), head over to Jenny Bryan's superb tutorial [**Happy Git and GitHub with R**](http://happygitwithr.com/). You should also download the `devtools` and `testthat` packages from CRAN. In the RStudio console type:

```R
install.packages(c("devtools", "testthat"))
```

&nbsp;

## 2.1 A new GitHub project

Create a new, empty repository on GitHub and give it your package name.

- First you need to decide on a [**name**](http://r-pkgs.had.co.nz/package.html#naming) for your package. Take care to define it well. Short, memorable, lower-case, and not in conflict with current names on CRAN or Bioconductor. Head over to [the taskviews on CRAN](https://cran.r-project.org/web/views/) and browse to see good examples.
- Next, log into your GitHub account.
- Click on the **(+)** in the top menu bar and select _New repository_.
- Enter your package name as the repository name.
- _Check_ to **Initialize this repository with a README** (the README will be overwritten later, but you need at least one file as a placeholder in your repository.)
- Don't add a `.gitignore` file or a license (these will come from `rpt`).
- Click **Create repository**.
- Finally, copy the URL of your repository to your clipboard, it should look like `https://github.com/<your-GitHub-user-name>/<your-package-name>` <sup id="af2">[2](#f2)</sup>.

&nbsp;

## 2.2 A new RStudio project

Create a new RStudio project on your local machine that is linked to your GitHub repository and account.

- In RStudio, choose **File** ▷ **New Project...**, select **Version Control** ▷ **Git**. Enter the **Repository URL** you copied in the preceding step, hit your `tab` key to autofill the **Project directory name** (it should be the same as your package name), and **Browse...** to a parent directory in which you want to keep your RStudio project. Then click **Create Project**.

The project directory will be created, the repository file will be downloaded, a new RStudio session will open in your directory, and R's "working directory" should be set to here.

**Validate:**

1. In the console, type `getwd()`. This should print the correct directory.
2. Make a small change to the `README.md` file, commit it and push it back to the remote repository: 
    1. In the files pane, click on `README.md` to open the file in the editor. Make a small change (e.g. add the word "test"). Save the file.
    2. Click on the _Version control icon_ in the editor window menu and choose **Commit...**, or choose **Tools** ▷ **Version Control** ▷ **Commit...** from the menu.
    3. In the version control window, check the box next to `README.md` to "stage" the file, enter "test" as your "Commit message" and click **Commit**. This commits your edits to your local repository.
    4. Click the green **Push** up-arrow. This synchronizes your local repository with your remote repository on GitHub.
    5. Navigate to your GitHub repository, reload the page, and confirm that your edit has arrived in the `README.md` file in your GitHub repository.

Congratulate yourself if this has all worked. If not - don't continue. You need to fix whatever problem has arisen. In my experience, the most frequent issue is that someone has skipped a step that they thought was not important to them. Check carefully whether you have followed all the steps. In particular, if the problem is associated with `git` on your machine, or connecting RStudio to your GitHub repository, work through Jenny Bryan's [**Happy Git...**](http://happygitwithr.com/) first.

&nbsp;

## 2.3 Download the `rpt` files

Download a ZIP archive of `rpt` and copy all the files over to your project folder.

- Navigate to the GitHub repository for `rpt` at (<https://github.com/hyginn/rpt>).
- Click on the green **Clone or download** button and select **Download ZIP**. This will package the `rpt` folder into a ZIP archive which will contain all files, (without the actual repository database, you don't need that), and download it to your computer.
- Find the ZIP archive in your download folder and unpack it. This will create a folder called `rpt-master` which contains all of the `rpt` files. (Note:  the creation date of the folder is not today's date, so if your download folder lists files by date, the unzipped folder will not be at the top.)
- Move all of the files and folders within `rpt-master` into your project directory, overwriting any of the files that are already there. You can then delete `rpt-master` and the ZIP archive.

**Validate**

In RStudio, open the `./dev` directory. Open the file `rptTwee.R` and click on  **Source** to load the function. Then type `rptTwee()` into the console. You should get a directory tree that looks approximately like this.

```
 -- <your-package-name>/
   |__.gitignore
   |__.Rbuildignore
   |__DESCRIPTION
   |__dev/
      |__functionTemplate.R
      |__rptTwee.R
   |__inst/
      |__extdata/
         |__test_lseq.dat
      |__scripts/
         |__scriptTemplate.R
   |__LICENSE
   |__man/
      |__lseq.Rd
   |__NAMESPACE
   |__R/
      |__lseq.R
      |__zzz.R
   |__README.md
   |__<your-package-name>.Rproj
   |__rpt.Rproj
   |__tests/
      |__testthat.R
      |__testthat/
         |__helper-functions.R
         |__test_lseq.R
```

These are the files and directories for an RStudio project/R package that contains a sample function `lseq()` defined in `./R/lseq.R`, which is tested in `./test/testthat/test_lseq.R` using data in `./inst/extdata/test_lseq.dat`.

If directories or files are missing, figure out where you went wrong.

&nbsp;

## 2.4 Customize

Open the following `rpt` files in your script-editor, and edit/save them to customize them for your own package:

&nbsp;

#### `DESCRIPTION`

Modify the `DESCRIPTION` file as follows:

Replace `rpt` with your package name, change the version to 0.1.0 (a first development [version number](https://semver.org/)), change the date to today's date, remove the `cre` role from my `Authors@R` field, and change `aut` to `ctb`, add an author field for yourself, and write a description for your package.

```diff
-      Package: rpt
+      Package: <your-package-name>
Type: Package
-      Title: R Package Template
+      Title: <a title for your package>
-      Version: 1.4.0
+      Version: 0.1.0
-      Date: 2019-04-11
+      Date: <today-in-YYYY-MM-DD-format>
Authors@R: c(
-    person("Boris", "Steipe", email = "boris.steipe@utoronto.ca", role = c("aut", "cre"), comment = c(ORCID = "0000-0002-1134-6758"))
+     person("Boris", "Steipe", email = "boris.steipe@utoronto.ca", role = c("ctb"), comment = c(ORCID = "0000-0002-1134-6758")),
+     person("<your-given-name>", "<your-family-name>", email = "<your-email-address>", role = c("aut","cre"), comment = c(ORCID = "<your-ORCID-ID>"))
    )
-      Description: A template for an RStudio project of a basic R package ...
+      Description: {A short description of the purpose of your package}
License: file LICENSE
Encoding: UTF-8
LazyData: true
Suggests:
    testthat
RoxygenNote: 6.0.1

```
&nbsp;

### 2.4.1 Getting attribution right

Giving credit is the currency of the FOSS (Free and Open Source Software) world which makes all of our work possible, licensing keeps it free. Take the time to get your attributions and licenses right; even if you think you don't really need this immediately it's good practice for good habits. Don't think you don't have to care: you automatically have a copyright to everything you write, and if you don't license it, no one can legally re-use it. Unfortunately, the common practices for attributing R package authorship are not consistent wherever there is more than one author (which is usually the case in academia). `rpt` adopts a consistent approach that is backward compatible with earlier practice.

Attribution and licensing only appear to be related. They serve distinct requirements and require distinct and specific mechanisms.

Credible attribution needs to identify **who** authored **what** in a way that that information is conveniently accessible.

Credible licensing needs to identify **who** has a copyright to **what**, and under **which license** it is released, in a standard document.

- **Who**: all persons referenced in attributions or licenses - whether authors (`aut`), contributors (`ctb`), or other copyright holders (`cph`) - must be unambiguously identified. Since people's names are not unique, there is really only one good way to do this: associate everyone with their ORCID (Open Researcher and Contributor Identifier) ID. ORCID IDs are unique and stable. If you don't already have a (free!) [**ORCID ID**](https://orcid.org), now is a good time to get one - unless you don't identify as one who "participates in research, scholarship and innovation" at all. The common alternative of identifying persons by their e-mail is unique, but not stable. All authors and contributors are referenced in the `DESCRIPTION` file and the R packaging system uses standard methods to give credit. For details, in particular what the `aut` (author), `cre` (creator/maintainer), and `ctb` (contributor) roles mean, and which other fields might be important to you, see the [Package metadata chapter](http://r-pkgs.had.co.nz/description.html) in Hadley Wickham's book, and the [DESCRIPTION section](https://cran.r-project.org/doc/manuals/r-release/R-exts.html#The-DESCRIPTION-file) of the CRAN "Writing R Extensions" manual.


- **What**: in any multi-author situation you need to specify exactly which files have been authored by whom. For **attribution**, add an `@author` tag to the Roxygen header of every source code item. For **licensing**, both the copyright and the licensed contents needs to be identified in the `LICENSE` file, and it must include the date (year), since copyright eventually expires. Yes, this is wordy and duplicates information. No, there's no obvious way to avoid that and still be compliant.

- **Which license**: There are many reasons to favour the MIT license over other FOSS licenses, `rpt` uses MIT. If you wish to use a different license, or need to include a different license because you are incorporating code that is differently licensed, then add the license, the contents it applies to, and the licensors' details into a clearly separated section of your LICENSE file.   

- **In practice**: I am the author (`aut`) and maintainer (`cre`) of the `rpt` package and this is reflected in the `DESCRIPTION` file. I have licensed `rpt` under the MIT license, and the MIT license requires that this information remains associated with the package. Therefore my information is listed both in the `DESCRIPTION` file, which feeds various mechanisms to document authorship, and the `LICENSE` file, which defines how others may modify, distribute and use the code. My package is however only a template for your own, you normally would not actually be _using_ the code I wrote. Therefore, the first thing you do is to add yourself as a `person`, and give yourself the `aut` and `cre` roles as author and maintainer, respectively. I am not a co-author even though I have contributed code initially: therefore my role changes to `ctb`. Over time you remove and replace my contributions with your own work, and at some point you can remove my attributions and copyright claims, while possibly adding attributions for other authors of code you use in your package, and collaborators. During this process, both the `DESCRIPTION` and the `LICENSE` file may contain more than one author and/or licensor. A common case is that you want to use a single function from a large package, or functions from a package that are not on CRAN. If this code is published under one of the FOSS licenses, you can simply copy the code, include it in your package, add the author to `Authors@R` - typically in a `ctb` role - and add their copyright information to the LICENSE file. Check the `DESCRIPTION` file, the `LICENSE` file, and the function headers for examples.

Now, having that considered, continue customising your files.

&nbsp;

#### `rpt.Rproj`

You already have a `<your-package-name>.Rproj` configuration file for RStudio in the main directory. You can either overwrite that with the options defined in `rpt.Rproj`, or set the options individually under **Tools** ▷ **Project options...** and delete `rpt.Rproj`. `rpt.Rproj` sets the following (significant) project options:

- A We **don't** save or restore the Workspace and we don't save History.<sup id="af3">[3](#f3)</sup> 
- B We use **two spaces** for indentation, not tabs.<sup id="af4">[4](#f4)</sup>
- C We use **UTF-8** encoding, always. There is no excuse not to.
- D The "BuildType" of the project is a **Package**. Once this is defined in the project options, the _Environment_ pane will include a tab for **Build** tools.

To implement these options:
- In the _Files_ pane, select `<your-package-name>.Rproj` and click on **Delete**.
- Select `rpt.Rproj` and **Rename** it to `<your-package-name>.Rproj`.
- Choose **File** ▷ **Recent Projects...** ▷ **&lt;your-package-name&gt;** and reload your project.

**Validate**

The _Environment_ pane should now have a **Build** tab.

&nbsp;

## 2.5 Save, check, commit, and push

It's time to complete the first development cycle: save, check, commit, and push to the `master` branch on GitHub.

1. **Save** all modified documents.
2. **Check** your package. Click on the **Build** tab, then click on the **Check** icon. This runs package checking code that confirms that all required files are present and correctly formatted, and all tests pass. See below.
3. Once your package check has passed without any errors, warnings or notes, click on the _Version control icon_ in the editor window menu and choose **Commit...**, or choose **Tools** ▷ **Version Control** ▷ **Commit...** from the menu.
4. In the version control window, check the box next to all changed files to "stage" them, enter "Initial Commit" as your "Commit message" and click **Commit**. 5. Click the green **Push** up-arrow to synchronize your local repository with GitHub.
6. Navigate to your GitHub repository, reload the page, and confirm that your edited files have arrived.


**Your package check must pass without errors, warnings or notes.** `rpt` passes the checks, and nothing you have done above should have changed this, if it was done correctly. Therefore something is not quite right if the checking code finds anything to complain about. Fix it now. You need a "known-good-state" to revert to, for debugging, in case problems arise later on.

**Validate**

Install your package from github and confirm that it can be loaded. In the console, type:

```R
devtools::install_github("<your-user-name>/<your-package-name>")
library(<your-package-name>)
citation("<your-package-name>")
?lseq
```

This should install your package, and load the library. Attaching the library runs the `.onAttach()` function in `./R/zzz.R` and displays the updated package name and authors.<sup id="af5">[5](#f5)</sup> The `citation()` function creates a package citation from information it finds in `DESCRIPTION`. It should include all author's names and the current year. The final command accesses the help page for the `lseq()` sample function that came with `rpt`, via R's help system. By confirming that this works, you are exercising functionality that is specific to the way R loads and manages packages and package metadata, none of which would work from information that has merely been left behind in your Workspace during development.

&nbsp;

# 3 Develop

You are done with configuring your baseline. **Check** your package frequently during development, and fix all errors right away. Package check errors have a way of interacting with each other that makes them hard to debug, it is best to address each one immediately when it occurs. Also, commit frequently and use meaningful commit messages. Your sanity will thank you. If you want to keep template files for reference, move them to the `./dev` directory so they will not be included in the package build. Finally, whenever you add new contents, reference it in the `LICENSE` file. Whenever you remove one of the original files, remove it from the `LICENSE` file. And whenever you modify a function, add your name to any existing authors.

While developing package functions, NEVER use `source()` to load them. If you edit a function and then want to load it in the workspace, reload the library instead. That's necessary so that the script you are developing does not get out of sync with the library. If you change code: save, rebuild and re-install, this will make the functions from the `./R` directory available. Howev you **should** use `source()` for functions that are not built into the package - e.g. everything in the `./dev` folder.

&nbsp;

----
Some useful keyboard shortcuts for package authoring:

* Build and Reload Package:  `Cmd + Shift + B`
* Update Documentation:      `Cmd + Shift + D` or `devtools::document()`
* Test Package:              `Cmd + Shift + T`
* Check Package:             `Cmd + Shift + E` or `devtools::check()`

&nbsp;

# 4 What's in the box ...

Here is a list of assets provided with `rpt` and why they are included. You can delete everything you don't need, but note: you can't push empty directories to your repository. Make sure you keep at least one file in every directory that you want to keep during development.
 
```
.gitignore                     <- defines files that should not be committed to the repository
.Rbuildignore                  <- defines files that should not be included in the package
DESCRIPTION                    <- the metadata file for your package
dev                            <- optional: see (Note 1)
dev/functionTemplate.R         <- optional: see (Note 1)
dev/rptTwee.R                  <- optional: see (Note 1)
inst/                          <- optional: see (Note 2)
inst/extdata/                  <- optional: see (Note 3)
inst/extdata/test-lseq.dat     <- optional: see (Note 3)
inst/scripts/                  <- optional: see (Note 4)
inst/scripts/scriptTemplate.R  <- optional: see (Note 4)
LICENSE                        <- License(s)
man/                           <- help files, generated by Roxygen2: don't edit
NAMESPACE                      <- lists exported functions and data. Generated by Roxygen2: don't edit
R/                             <- Contains the code for exported functions
R/lseq.R                       <- a sample function
R/zzz.R                        <- three functions for package management
README.md                      <- see (Note 5)
rpt.Rproj                      <- project options. Rename to <your-package-name>.Rproj
tests                          <- see (Note 6)
tests/testthat                 <- contains scripts for tests to be run
tests/testthat/helper-functions.R  <- code runs to set up tests
tests/testthat/test_lseq.R     <- a test script for ./R/lseq.R
tests/testthat.R               <- the script that runs the tests
```

- **(Note 1)** The `./dev` directory. I use this directory to keep all files and assets that I need for development, but that should not be included and distributed in the final package. The directory is mentioned in `.Rbuildignore`. In `rpt` it contains `./dev/functionTemplate.R`, a template file for writing R functions with a Roxygen2 header, and `./dev/rptTwee.R`, which was discussed above.

- **(Note 2)** The `./inst` directory. Files in this directory are installed, and end up one level "higher" after installation. E.g. the contents of `./inst/extdata` is in the folder `./extdata/` of an installed package.

- **(Note 3)** The `./inst/extdata` directory. This directory commonly contains "extra" data that is used in tests and examples. (Actual package data would go into a top-level `./data` directory and needs to be "exported". See [the `rptPlus` package](https://github.com/hyginn/rptPlus) for an example.) Here it contains `inst/extdata/test-lseq.dat`, a sample data set used in the test for `lseq()`.

- **(Note 4)** The `./inst/scripts` directory. Many packages contain sample scripts in addition to the functions they share. Such  scripts go into this directory. `rpt` provides `./inst/scripts/scriptTemplate.R`, a template file to illustrate how to structure an R script.

- **(Note 5)** The file you are reading is the `README.md` file for the `rpt` package. `README` files explain what a package (or directory) contains, `.md` is the extension for [markdown](https://guides.github.com/features/mastering-markdown/) formatted text files. Replace the contents of this file with your own (you can keep using the [original on GitHub](https://github.com/hyginn/rpt/blob/master/README.md) as a reference); a nice template for structuring a markdown file is [here](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2).

- **(Note 6)** The `./tests` directory contains directories and assets for tests. For details see the [**Testing**](http://r-pkgs.had.co.nz/tests.html) chapter of Hadley Wickham's book. 

&nbsp;

----

# 5 FAQ

##### How can I import Bioconductor packages?
Work with Bioconductor packages is described in the [`rptPlus`](https://github.com/hyginn/rptPlus) package template.

&nbsp;

# 6 Notes
- Syntax for footnotes in markdown documents was suggested by _Matteo_ [on Stackoverflow](https://stackoverflow.com/questions/25579868/how-to-add-footnotes-to-github-flavoured-markdown). (Regrettably, the links between footnote references and text don't work on GitHub.)

----

<b id="af1">1</b> A good way to begin your devevlopment journey is to first browse through [Hadley Wickham's book](http://r-pkgs.had.co.nz) to get an idea of the general layout of packages, then build a minimal package yourself, and then use the book, and the CRAN policies to hone and refine what you have done. You need a bit of knowledge to get you started, but after that, learning is most effective if you learn what you need in the context of applying it.  [↩](#a1).

<b id="af2">2</b> Empty repositories by convention have a `.git` extension to the repository name, repositories with contents have no extension: the name indicates the repository directory and that directory contains the `.git` file. Therefore your package should **NOT** be named `<package>.git` although links to your repository on GitHub seem to be correctly processed with both versions. For more discussion, see [here](https://stackoverflow.com/questions/11068576/why-do-some-repository-urls-end-in-git-while-others-dont) [↩](#a2)

<b id="af3">3</b> Among the R development "dogmas" that have been proven again and again by experience are:  "_Don't work in the console, always work in a script._" and "_Never restore old Workspace. Recreate your Workspace from a script instead._" Therefore my projects don't save history, and don't save (or restore) Workspace either. You don't have to follow this advice, but trust me: it's better practice. [↩](#a3)

<b id="af4">4</b> A commonly agreed on coding style is to use 80 character lines or shorter. That's often a bit of a challenge when you use spaces around operators, expressive variable names, and 4-space indents. Of those three, the 4-space indents are the most dispensable; using 2-space indents works great and helps keep lines short enough. There seems to be a recent trend towards 2-spaces anyway. As for tabs vs. spaces: I write a lot of code that is meant to be read and studied, thus I need more control over what my users see. Therefore I use spaces, not tabs. YMMV, change your Project Options if you feel differently about this. [↩](#a4)

<b id="af5">5</b> Displaying the startup message (as of this writing) works only once per session due to a long-standing bug in RStudio. (cf. [here](https://github.com/r-lib/devtools/issues/1442)). To display the message, choose **File** ▷ **Recent Projects...** ▷ **&lt;your-package-name&gt;** to reload your project, then type `library(<your-package-name>)` into the cosole. For more details on the namespace functions, see [here](https://stat.ethz.ch/R-manual/R-devel/library/base/html/ns-hooks.html).[↩](#a5)

&nbsp;

# 7 Further reading

- The [**R Packages** book](http://r-pkgs.had.co.nz/) 
- The [**CRAN** manual on writing R-extensions](https://cran.r-project.org/doc/manuals/r-release/R-exts.html)
- Hornik, K., Murdoch D. and Zeileis, A. (2012) [Who Did What? The Roles of R Package Authors and How to Refer to Them](https://journal.r-project.org/archive/2012-1/RJournal_2012-1_Hornik~et~al.pdf). The R Journal 4:(1) 64-69.
- [**roxygen2** documentation](https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html)
- Cyril Chapellier's [**markdown cheatsheet**](https://github.com/tchapi/markdown-cheatsheet/blob/master/README.md) 
- The [**`rptPlus`** package template](https://github.com/hyginn/rptPlus) is built on `rpt` and covers more advanced topics.

&nbsp;

# 8 Acknowledgements

Thanks to my students, especially the BCB410 (Applied Bioinformatics) class of 2018, whose hard work on building their own R packages revealed the need for this template. [Yi Chen](https://orcid.org/0000-0003-1624-2760)'s careful proofreading helped make many points more specific. 

&nbsp;

&nbsp;

<!-- END -->
