# Contributing to `ltertools`

Please follow the contributing instructions under the relevant subheading as you consider how best to contribute to `ltertools`. Thank you for your interest!

## Contributing a New Function

Adding a function you've written is the core of `ltertools`' reason for existing. If you have a function you'd like to contribute please do the following:

- [Open a GitHub issue](https://github.com/lter/ltertools/issues) and paste the entirety of your function in that issue

- Please also provide a **1-paragraph description** of what your function does and/or the contexts where your function should be invoked

    - This description should provide sufficient detail that an R expert can gain a fundamental understanding of your function's purpose such that we can do any necessary maintenance during integration
    - This will likely form the basis of the "Description" field of the function that `ltertools` users can access with `?function` so feel free to use an existing function's help file as a reference (e.g., `?dplyr::filter`, etc.)

Once you've provided this information we can work towards standardizing function formatting (casing, syntax, etc.) so that your function can be included in our suite of available tools!

### Function Credit

If you decide to contribute a function to `ltertools` we offer the following benefits:

- We will list your preferred name in the `DESCRIPTION` file as an author

- If you'd like, we can add any of: your email, professional website, or a link to your [ORCiD](https://orcid.org/)

By taking these steps we hope to ensure that your intellectual contributions will be appropriately credited and that `ltertools` users can find other facets of your professional work based on your links to this R package.

## Minor Edits / Suggestions

If you are either (1) calling attention to a bug/error or (2) making a small suggestion for improvement, we suggest that you [open a GitHub issue](https://github.com/lter/ltertools/issues).

- For bugs, please include a [minimal reproducible example](https://stackoverflow.com/help/minimal-reproducible-example) so that we can quickly reproduce and resolve the bug

- For suggestions, please be as precise as possible so that we know the scope of changes that would be needed to implement your idea(s)

## Major Changes

If you have a major change necessitating systemic/structural changes to `ltertools` we recommend the following:

1. [Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) the GitHub repository

2. Add your function script (and any necessary data files) to the `dev` folder in your fork

3. When finished with your edits, submit a pull request

## Style Guide

We are happy to tweak function/argument names as needed to maintain a consistent "feel" of functions in `ltertools`. That said, if you'd like to make those changes yourself you are more than welcome to though **such aesthetic changes are _optional_**. `ltertools` will adhere to the following stylistic elements:

- Use "snake case" (i.e., all lowercase separated by underscores) for functions and arguments (e.g., `my_function(argument_1 = ...)`, etc.)

- If your function prints informative messages, include a `quiet` argument that accepts a logical (i.e., `TRUE` or `FALSE`). Please suppress all of these messages when `quiet = TRUE`.

- Include errors / warnings for user inputs to arguments that are inappropriate class or structure (i.e., code defensively)
